$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)
$(call inherit-product, vendor/lineage/config/common_mini.mk)
$(call inherit-product, device/hp/msm8996-common/msm8996.mk)
$(call inherit-product, device/hp/raptor/proprietary-blobs.mk)

# Keep framework audio services available during hardware bring-up.
PRODUCT_PACKAGES += \
    android.hardware.audio@2.0-service \
    android.hardware.audio@4.0-impl:32 \
    android.hardware.audio.effect@4.0-impl:32 \
    audio.r_submix.default:32

PRODUCT_PACKAGES += \
    android.hardware.keymaster@3.0-impl \
    android.hardware.keymaster@3.0-service

raptor_audio_policy_dir := frameworks/av/services/audiopolicy/config
PRODUCT_COPY_FILES += \
    $(raptor_audio_policy_dir)/audio_policy_configuration_generic.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    $(raptor_audio_policy_dir)/primary_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/primary_audio_policy_configuration.xml \
    $(raptor_audio_policy_dir)/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    $(raptor_audio_policy_dir)/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    $(raptor_audio_policy_dir)/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    $(raptor_audio_policy_dir)/surround_sound_configuration_5_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/surround_sound_configuration_5_0.xml

PRODUCT_COPY_FILES += \
    device/hp/raptor/rootdir/fstab.qcom:$(TARGET_COPY_OUT_RAMDISK)/fstab.qcom \
    device/hp/raptor/rootdir/fstab.qcom:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.qcom \
    device/hp/raptor/rootdir/init.qcom.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.qcom.rc \
    device/hp/raptor/rootdir/ueventd.rc:$(TARGET_COPY_OUT_VENDOR)/ueventd.rc \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.xml

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.sf.lcd_density=360
PRODUCT_PROPERTY_OVERRIDES += ro.hardware.egl=adreno
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += persist.sys.usb.config=adb

# Optional host public key for local debugging. AOSP applies this to debuggable builds.
ifdef RAPTOR_ADB_KEYS
PRODUCT_ADB_KEYS := $(RAPTOR_ADB_KEYS)
endif

PRODUCT_NAME := lineage_raptor
PRODUCT_DEVICE := raptor
PRODUCT_BRAND := HP
PRODUCT_MODEL := HP Pro x3
PRODUCT_MANUFACTURER := HP
