#define LOG_TAG "android.hardware.gnss@1.0-service.hp"

#include <android/hardware/gnss/1.0/IGnss.h>
#include <dlfcn.h>
#include <hidl/HidlTransportSupport.h>
#include <log/log.h>

using android::OK;
using android::sp;
using android::status_t;
using android::hardware::configureRpcThreadpool;
using android::hardware::joinRpcThreadpool;
using android::hardware::gnss::V1_0::IGnss;

namespace {
constexpr const char* kGnssImplPath = "/vendor/lib64/hw/android.hardware.gnss@1.0-impl-qti.so";
using FetchGnssFn = IGnss* (*)(const char*);
}  // namespace

int main() {
    void* handle = dlopen(kGnssImplPath, RTLD_NOW);
    if (handle == nullptr) {
        ALOGE("Failed to load %s: %s", kGnssImplPath, dlerror());
        return 1;
    }

    auto fetch = reinterpret_cast<FetchGnssFn>(dlsym(handle, "HIDL_FETCH_IGnss"));
    if (fetch == nullptr) {
        ALOGE("Failed to resolve HIDL_FETCH_IGnss: %s", dlerror());
        return 1;
    }

    sp<IGnss> service(fetch("default"));
    if (service == nullptr) {
        ALOGE("HIDL_FETCH_IGnss returned null");
        return 1;
    }

    configureRpcThreadpool(1, true /* callerWillJoin */);
    status_t status = service->registerAsService();
    if (status == OK) {
        ALOGI("HP GNSS HAL Ready.");
        joinRpcThreadpool();
    }

    ALOGE("Cannot register HP GNSS HAL service (%d)", status);
    return 1;
}
