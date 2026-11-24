$(call inherit-product, device/hp/msm8996-common/msm8996.mk)
$(call inherit-product, device/hp/falkon/proprietary-blobs.mk)

# Keep Android audio services available while the FALKON routes are brought up.
PRODUCT_PACKAGES += \
    android.hardware.audio@2.0-service \
    android.hardware.audio@4.0-impl:32 \
    android.hardware.audio.effect@4.0-impl:32 \
    audio.primary.default:32 \
    audio.r_submix.default:32

falkon_audio_policy_dir := frameworks/av/services/audiopolicy/config
PRODUCT_COPY_FILES += \
    device/hp/msm8996-common/audio/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    $(falkon_audio_policy_dir)/a2dp_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_audio_policy_configuration.xml \
    $(falkon_audio_policy_dir)/primary_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/primary_audio_policy_configuration.xml \
    $(falkon_audio_policy_dir)/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    $(falkon_audio_policy_dir)/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    $(falkon_audio_policy_dir)/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    $(falkon_audio_policy_dir)/surround_sound_configuration_5_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/surround_sound_configuration_5_0.xml

PRODUCT_COPY_FILES += \
    device/hp/falkon/rootdir/fstab.qcom:$(TARGET_COPY_OUT_RAMDISK)/fstab.qcom \
    device/hp/falkon/rootdir/fstab.qcom:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.qcom \
    device/hp/falkon/rootdir/init.qcom.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.qcom.rc \
    device/hp/falkon/rootdir/ueventd.rc:$(TARGET_COPY_OUT_VENDOR)/ueventd.rc \
    device/hp/msm8996-common/rootdir/init.hp.bt-address.sh:$(TARGET_COPY_OUT_VENDOR)/etc/init.falkon.bt-address.sh \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.xml \
    device/hp/falkon/permissions/falkon.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/falkon.xml

PRODUCT_COPY_FILES += \
    device/hp/falkon/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video.xml

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.sf.lcd_density=480

ifdef FALKON_ADB_KEYS
PRODUCT_ADB_KEYS := $(FALKON_ADB_KEYS)
endif

PRODUCT_NAME := lineage_falkon
PRODUCT_DEVICE := falkon
PRODUCT_BRAND := HP
PRODUCT_MODEL := HP Elite x3
PRODUCT_MANUFACTURER := HP
