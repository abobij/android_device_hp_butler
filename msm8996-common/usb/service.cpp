#define LOG_TAG "android.hardware.usb@1.0-service.hp"

#include <hidl/HidlTransportSupport.h>
#include "Usb.h"

using android::OK;
using android::sp;
using android::status_t;
using android::hardware::configureRpcThreadpool;
using android::hardware::joinRpcThreadpool;
using android::hardware::usb::V1_0::IUsb;
using android::hardware::usb::V1_0::implementation::Usb;

int main() {
    sp<IUsb> service = new Usb();
    configureRpcThreadpool(1, true /* callerWillJoin */);
    status_t status = service->registerAsService();
    if (status == OK) {
        ALOGI("HP USB HAL Ready.");
        joinRpcThreadpool();
    }
    ALOGE("Cannot register HP USB HAL service");
    return 1;
}
