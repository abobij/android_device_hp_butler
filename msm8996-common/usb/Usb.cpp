#include "Usb.h"

#include <cutils/uevent.h>
#include <errno.h>
#include <fcntl.h>
#include <fstream>
#include <signal.h>
#include <string.h>
#include <sys/epoll.h>
#include <unistd.h>

namespace android {
namespace hardware {
namespace usb {
namespace V1_0 {
namespace implementation {

namespace {

constexpr const char* kSsusbModePath = "/sys/devices/soc/6a00000.ssusb/mode";
constexpr const char* kUsbPresentPath = "/sys/devices/soc/6a00000.ssusb/power_supply/usb/present";
constexpr const char* kAndroidStatePath = "/sys/class/android_usb/android0/state";
constexpr int kUeventMsgLen = 2048;

volatile sig_atomic_t gDestroyThread = 0;

bool readTrimmedFile(const char* path, std::string& out) {
    std::ifstream file(path);
    if (!file.is_open()) {
        return false;
    }
    std::getline(file, out);
    while (!out.empty() && (out.back() == '\r' || out.back() == '\n' || out.back() == ' ')) {
        out.pop_back();
    }
    return true;
}

Status buildPortStatus(hidl_vec<PortStatus>& statusList) {
    std::string mode;
    std::string state;
    std::string present;
    readTrimmedFile(kSsusbModePath, mode);
    readTrimmedFile(kAndroidStatePath, state);
    readTrimmedFile(kUsbPresentPath, present);

    PortStatus port = {};
    port.portName = "usb0";
    port.canChangeMode = false;
    port.canChangeDataRole = false;
    port.canChangePowerRole = false;

    if (mode == "host") {
        port.supportedModes = PortMode::DFP;
        port.currentMode = PortMode::DFP;
        port.currentPowerRole = PortPowerRole::SOURCE;
        port.currentDataRole = PortDataRole::HOST;
    } else if (state == "CONFIGURED" || state == "CONNECTED" || present == "1" ||
               mode == "peripheral") {
        port.supportedModes = PortMode::UFP;
        port.currentMode = PortMode::UFP;
        port.currentPowerRole = PortPowerRole::SINK;
        port.currentDataRole = PortDataRole::DEVICE;
    } else {
        port.supportedModes = PortMode::UFP;
        port.currentMode = PortMode::NONE;
        port.currentPowerRole = PortPowerRole::NONE;
        port.currentDataRole = PortDataRole::NONE;
    }

    statusList.resize(1);
    statusList[0] = port;
    return Status::SUCCESS;
}

void notifyCallback(Usb* usb) {
    pthread_mutex_lock(&usb->mLock);
    sp<IUsbCallback> cb = usb->mCallback;
    pthread_mutex_unlock(&usb->mLock);
    if (cb == nullptr) {
        return;
    }
    hidl_vec<PortStatus> ports;
    Status status = buildPortStatus(ports);
    Return<void> ret = cb->notifyPortStatusChange(ports, status);
    if (!ret.isOk()) {
        ALOGE("notifyPortStatusChange error: %s", ret.description().c_str());
    }
}

void* ueventWorker(void* param) {
    auto* usb = static_cast<Usb*>(param);
    int ueventFd = uevent_open_socket(64 * 1024, true);
    if (ueventFd < 0) {
        ALOGE("uevent_open_socket failed");
        return nullptr;
    }
    fcntl(ueventFd, F_SETFL, O_NONBLOCK);

    int epollFd = epoll_create(16);
    if (epollFd < 0) {
        ALOGE("epoll_create failed: %d", errno);
        close(ueventFd);
        return nullptr;
    }

    struct epoll_event ev = {};
    ev.events = EPOLLIN;
    ev.data.fd = ueventFd;
    if (epoll_ctl(epollFd, EPOLL_CTL_ADD, ueventFd, &ev) < 0) {
        ALOGE("epoll_ctl failed: %d", errno);
        close(epollFd);
        close(ueventFd);
        return nullptr;
    }

    char msg[kUeventMsgLen + 2];
    while (!gDestroyThread) {
        struct epoll_event events[16];
        int nevents = epoll_wait(epollFd, events, 16, -1);
        if (nevents < 0) {
            if (errno == EINTR) {
                continue;
            }
            break;
        }
        for (int i = 0; i < nevents; ++i) {
            int n = uevent_kernel_multicast_recv(ueventFd, msg, kUeventMsgLen);
            if (n <= 0 || n >= kUeventMsgLen) {
                continue;
            }
            msg[n] = '\0';
            msg[n + 1] = '\0';
            bool relevant = false;
            for (char* cp = msg; *cp; cp += strlen(cp) + 1) {
                if (strcmp(cp, "SUBSYSTEM=android_usb") == 0 ||
                    strcmp(cp, "SUBSYSTEM=power_supply") == 0) {
                    relevant = true;
                    break;
                }
            }
            if (relevant) {
                notifyCallback(usb);
            }
        }
    }

    close(epollFd);
    close(ueventFd);
    return nullptr;
}

void stopSignalHandler(int sig) {
    if (sig == SIGUSR1) {
        gDestroyThread = 1;
    }
}

}  // namespace

Usb::Usb() {}

Return<void> Usb::switchRole(const hidl_string& portName, const PortRole& newRole) {
    pthread_mutex_lock(&mLock);
    sp<IUsbCallback> cb = mCallback;
    pthread_mutex_unlock(&mLock);
    if (cb != nullptr) {
        Return<void> ret = cb->notifyRoleSwitchStatus(portName, newRole, Status::ERROR);
        if (!ret.isOk()) {
            ALOGE("notifyRoleSwitchStatus error: %s", ret.description().c_str());
        }
    }
    return Void();
}

Return<void> Usb::queryPortStatus() {
    notifyCallback(this);
    return Void();
}

Return<void> Usb::setCallback(const sp<IUsbCallback>& callback) {
    pthread_mutex_lock(&mLock);
    if ((mCallback == nullptr && callback == nullptr) ||
        (mCallback != nullptr && callback != nullptr)) {
        mCallback = callback;
        pthread_mutex_unlock(&mLock);
        return Void();
    }
    mCallback = callback;
    if (mCallback == nullptr) {
        if (mThreadRunning) {
            pthread_kill(mPoll, SIGUSR1);
            pthread_mutex_unlock(&mLock);
            pthread_join(mPoll, nullptr);
            pthread_mutex_lock(&mLock);
            mThreadRunning = false;
        }
        pthread_mutex_unlock(&mLock);
        return Void();
    }

    gDestroyThread = 0;
    signal(SIGUSR1, stopSignalHandler);
    if (pthread_create(&mPoll, nullptr, ueventWorker, this) == 0) {
        mThreadRunning = true;
    } else {
        ALOGE("pthread_create failed: %d", errno);
        mCallback = nullptr;
    }
    pthread_mutex_unlock(&mLock);
    return Void();
}

}  // namespace implementation
}  // namespace V1_0
}  // namespace usb
}  // namespace hardware
}  // namespace android
