$(call inherit-product, device/hp/msm8996-common/msm8996.mk)
$(call inherit-product, device/hp/falcon/proprietary-blobs.mk)

# Keep Android audio services available while the FALCON routes are brought up.
PRODUCT_PACKAGES += \
    android.hardware.audio@2.0-service \
    android.hardware.audio@4.0-impl:32 \
    android.hardware.audio.effect@4.0-impl:32 \
    audio.primary.default:32 \
    audio.r_submix.default:32

falcon_audio_policy_dir := frameworks/av/services/audiopolicy/config
PRODUCT_COPY_FILES += \
    $(falcon_audio_policy_dir)/audio_policy_configuration_generic.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    $(falcon_audio_policy_dir)/primary_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/primary_audio_policy_configuration.xml \
    $(falcon_audio_policy_dir)/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    $(falcon_audio_policy_dir)/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    $(falcon_audio_policy_dir)/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    $(falcon_audio_policy_dir)/surround_sound_configuration_5_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/surround_sound_configuration_5_0.xml

PRODUCT_COPY_FILES += \
    device/hp/falcon/rootdir/fstab.qcom:$(TARGET_COPY_OUT_RAMDISK)/fstab.qcom \
    device/hp/falcon/rootdir/fstab.qcom:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.qcom \
    device/hp/falcon/rootdir/init.qcom.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.qcom.rc \
    device/hp/falcon/rootdir/ueventd.rc:$(TARGET_COPY_OUT_VENDOR)/ueventd.rc \
    device/hp/falcon/permissions/falcon.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/falcon.xml

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.sf.lcd_density=480

ifdef FALCON_ADB_KEYS
PRODUCT_ADB_KEYS := $(FALCON_ADB_KEYS)
endif

PRODUCT_NAME := lineage_falcon
PRODUCT_DEVICE := falcon
PRODUCT_BRAND := HP
PRODUCT_MODEL := HP Elite x3
PRODUCT_MANUFACTURER := HP
