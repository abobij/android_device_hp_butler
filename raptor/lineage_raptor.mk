$(call inherit-product, device/hp/msm8996-common/msm8996.mk)
$(call inherit-product, device/hp/raptor/proprietary-blobs.mk)

DEVICE_PACKAGE_OVERLAYS += device/hp/raptor/overlay

PRODUCT_PACKAGES += \
    Camera2 \
    Recorder

PRODUCT_PACKAGES += \
    android.hardware.vibrator@1.0-impl \
    android.hardware.vibrator@1.0-service \
    vibrator.default

# The Nougat audio HAL requires the HIDL 2.0 stream ABI.
PRODUCT_PACKAGES += \
    android.hardware.audio@2.0-service \
    android.hardware.audio@2.0-impl:32 \
    android.hardware.audio.effect@2.0-impl:32 \
    audio.r_submix.default:32 \
    libaudioroute:32 \
    libtinycompress:32

PRODUCT_PACKAGES += \
    android.hardware.camera.provider@2.4-impl:32 \
    android.hardware.camera.provider@2.4-service

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml

# The legacy camera statistics module blocks waiting for the unported sensor service.
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    persist.camera.HAL3.enabled=0 \
    persist.camera.gyro.disable=1

PRODUCT_PACKAGES += \
    android.hardware.bluetooth@1.0-impl \
    android.hardware.bluetooth@1.0-service

PRODUCT_COPY_FILES += \
    device/hp/raptor/rootdir/init.raptor.bt-address.sh:$(TARGET_COPY_OUT_VENDOR)/etc/init.raptor.bt-address.sh \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml

# The Nougat vendor library selects the QCA6174 UART transport.
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    qcom.bluetooth.soc=rome \
    ro.bt.bdaddr_path=/data/vendor/bluetooth/bdaddr \
    persist.bluetooth.bluetooth_audio_hal.disabled=true

PRODUCT_PACKAGES += \
    android.hardware.wifi@1.0-service \
    wpa_supplicant \
    wpa_supplicant.conf

PRODUCT_COPY_FILES += \
    device/hp/raptor/audio/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml

raptor_audio_policy_dir := frameworks/av/services/audiopolicy/config
PRODUCT_COPY_FILES += \
    device/hp/raptor/audio/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    $(raptor_audio_policy_dir)/a2dp_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_audio_policy_configuration.xml \
    device/hp/raptor/audio/primary_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/primary_audio_policy_configuration.xml \
    $(raptor_audio_policy_dir)/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    $(raptor_audio_policy_dir)/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    $(raptor_audio_policy_dir)/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    $(raptor_audio_policy_dir)/surround_sound_configuration_5_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/surround_sound_configuration_5_0.xml

PRODUCT_COPY_FILES += \
    device/hp/raptor/rootdir/fstab.qcom:$(TARGET_COPY_OUT_RAMDISK)/fstab.qcom \
    device/hp/raptor/rootdir/fstab.qcom:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.qcom \
    device/hp/raptor/rootdir/init.qcom.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.qcom.rc \
    device/hp/raptor/rootdir/ueventd.rc:$(TARGET_COPY_OUT_VENDOR)/ueventd.rc \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.xml \
    device/hp/raptor/permissions/raptor.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/raptor.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.sf.lcd_density=360

# Optional host public key for local debugging. AOSP applies this to debuggable builds.
ifdef RAPTOR_ADB_KEYS
PRODUCT_ADB_KEYS := $(RAPTOR_ADB_KEYS)
endif

PRODUCT_NAME := lineage_raptor
PRODUCT_DEVICE := raptor
PRODUCT_BRAND := HP
PRODUCT_MODEL := HP Pro x3
PRODUCT_MANUFACTURER := HP
