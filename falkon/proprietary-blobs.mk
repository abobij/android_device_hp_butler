hp_device_blob_dir := vendor/hp/falkon/proprietary
include device/hp/msm8996-common/device-blobs.mk

# FALKON Nougat wireless configuration and Qualcomm Rome transport.
falkon_wireless_blob_paths := \
    lib64/libbt-vendor.so \
    lib64/libbtnv.so \
    bin/wcnss_filter \
    etc/wifi/wpa_supplicant_overlay.conf \
    firmware/wlan/qca_cld/WCNSS_qcom_cfg.ini
PRODUCT_COPY_FILES += $(foreach blob,$(falkon_wireless_blob_paths),\
    $(hp_device_blob_dir)/$(blob):$(TARGET_COPY_OUT_VENDOR)/$(blob))
