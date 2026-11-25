#ifndef ANDROID_HARDWARE_USB_V1_0_HP_USB_H
#define ANDROID_HARDWARE_USB_V1_0_HP_USB_H

#include <android/hardware/usb/1.0/IUsb.h>
#include <hidl/Status.h>
#include <log/log.h>
#include <pthread.h>

#ifdef LOG_TAG
#undef LOG_TAG
#endif
#define LOG_TAG "android.hardware.usb@1.0-service.hp"

namespace android {
namespace hardware {
namespace usb {
namespace V1_0 {
namespace implementation {

struct Usb : public IUsb {
    Usb();
    Return<void> switchRole(const hidl_string& portName, const PortRole& role) override;
    Return<void> setCallback(const sp<IUsbCallback>& callback) override;
    Return<void> queryPortStatus() override;

    sp<IUsbCallback> mCallback;
    pthread_mutex_t mLock = PTHREAD_MUTEX_INITIALIZER;

  private:
    pthread_t mPoll = 0;
    bool mThreadRunning = false;
};

}  // namespace implementation
}  // namespace V1_0
}  // namespace usb
}  // namespace hardware
}  // namespace android

#endif  // ANDROID_HARDWARE_USB_V1_0_HP_USB_H
