$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)
$(call inherit-product, vendor/lineage/config/common_mini.mk)

PRODUCT_SHIPPING_API_LEVEL := 25
DEVICE_PACKAGE_OVERLAYS += device/hp/msm8996-common/overlay

PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.composer@2.1-impl \
    android.hardware.graphics.composer@2.1-service \
    android.hardware.graphics.mapper@2.0-impl \
    gralloc.msm8996 \
    hwcomposer.msm8996

# The Butler 8.1 EGL subdriver supports the shared CAF gralloc1 HAL.
hp_egl_blob_paths := \
    lib/egl/eglSubDriverAndroid.so \
    lib/egl/libEGL_adreno.so \
    lib/egl/libGLESv1_CM_adreno.so \
    lib/egl/libGLESv2_adreno.so \
    lib/libadreno_utils.so \
    lib/libgsl.so \
    lib/libllvm-glnext.so \
    lib64/egl/eglSubDriverAndroid.so \
    lib64/egl/libEGL_adreno.so \
    lib64/egl/libGLESv1_CM_adreno.so \
    lib64/egl/libGLESv2_adreno.so \
    lib64/libadreno_utils.so \
    lib64/libgsl.so \
    lib64/libllvm-glnext.so

PRODUCT_COPY_FILES += $(foreach blob,$(hp_egl_blob_paths),\
    vendor/hp/msm8996-common/proprietary/8.1-graphics/$(blob):$(TARGET_COPY_OUT_VENDOR)/$(blob))

PRODUCT_PACKAGES += LatinIME

PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0-impl \
    android.hardware.gatekeeper@1.0-service \
    android.hardware.keymaster@3.0-impl \
    android.hardware.keymaster@3.0-service

PRODUCT_PACKAGES += \
    android.hardware.light@2.0-impl \
    android.hardware.light@2.0-service \
    lights.msm8996

PRODUCT_COPY_FILES += frameworks/native/data/etc/android.software.app_widgets.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.app_widgets.xml

PRODUCT_COPY_FILES += frameworks/native/data/etc/android.software.secure_lock_screen.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.secure_lock_screen.xml

PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml

PRODUCT_PROPERTY_OVERRIDES += ro.hardware.egl=adreno
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += persist.sys.usb.config=adb

PRODUCT_PACKAGES += \
    android.hardware.bluetooth@1.0-impl \
    android.hardware.bluetooth@1.0-service

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml

# The Nougat vendor library selects the QCA6174 UART transport.
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    qcom.bluetooth.soc=rome \
    ro.bt.bdaddr_path=/data/vendor/bluetooth/bdaddr \
    persist.bluetooth.bluetooth_audio_hal.disabled=true

PRODUCT_PACKAGES += \
    android.hardware.wifi@1.0-service \
    wpa_supplicant \
    wpa_supplicant.conf
