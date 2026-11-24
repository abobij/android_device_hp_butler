raptor_blob_dir := vendor/hp/raptor/proprietary
hp_device_blob_dir := $(raptor_blob_dir)
include device/hp/msm8996-common/device-blobs.mk

PRODUCT_COPY_FILES += \
    $(raptor_blob_dir)/firmware/wlan/qca_cld/WCNSS_qcom_cfg.ini:$(TARGET_COPY_OUT_VENDOR)/firmware/wlan/qca_cld/WCNSS_qcom_cfg.ini \
    $(raptor_blob_dir)/etc/wifi/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf

# RAPTOR Android 7.1.2 primary audio HAL and ACDB client.
raptor_audio_blob_paths := \
    lib/hw/audio.primary.msm8996.so \
    lib/libacdbloader.so \
    lib/libacdb-fts.so \
    lib/libacdbrtac.so \
    lib/libadiertac.so \
    lib/libaudcal.so \
    lib/libdiag.so
PRODUCT_COPY_FILES += $(foreach blob,$(raptor_audio_blob_paths), \
    $(raptor_blob_dir)/$(blob):$(TARGET_COPY_OUT_VENDOR)/$(blob))

# These stock libraries look for their configuration under /system/etc.
raptor_audio_config_paths := \
    etc/mixer_paths_tasha_raptor.xml \
    etc/audio_platform_info.xml \
    etc/acdbdata/QRD/QRD_Bluetooth_cal.acdb \
    etc/acdbdata/QRD/QRD_General_cal.acdb \
    etc/acdbdata/QRD/QRD_Global_cal.acdb \
    etc/acdbdata/QRD/QRD_Handset_cal.acdb \
    etc/acdbdata/QRD/QRD_Hdmi_cal.acdb \
    etc/acdbdata/QRD/QRD_Headset_cal.acdb \
    etc/acdbdata/QRD/QRD_Speaker_cal.acdb
PRODUCT_COPY_FILES += $(foreach blob,$(raptor_audio_config_paths), \
    $(raptor_blob_dir)/$(blob):system/$(blob))
PRODUCT_COPY_FILES += \
    $(raptor_blob_dir)/etc/mixer_paths_tasha_raptor.xml:system/etc/mixer_paths_tasha.xml

# RAPTOR Android 7.1.2 Qualcomm Rome Bluetooth UART transport.
raptor_bluetooth_blob_paths := \
    bin/wcnss_filter \
    lib64/libbt-vendor.so \
    lib64/libbtnv.so
PRODUCT_COPY_FILES += $(foreach blob,$(raptor_bluetooth_blob_paths), \
    $(raptor_blob_dir)/$(blob):$(TARGET_COPY_OUT_VENDOR)/$(blob))

include device/hp/raptor/camera/blobs.mk
