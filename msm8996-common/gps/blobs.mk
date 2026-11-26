hp_gps_oreo_dir := vendor/hp/msm8996-common/proprietary/8.1-gps

# Android 8.1 QMI GNSS HAL implementation and board configuration.
hp_gps_blob_paths := \
    etc/gps.conf \
    lib64/hw/android.hardware.gnss@1.0-impl-qti.so \
    lib64/libgnss.so \
    lib64/libgps.utils.so \
    lib64/libloc_api_v02.so \
    lib64/libloc_core.so \
    lib64/libloc_pla.so \
    lib64/libloc_stub.so \
    lib64/liblocation_api.so

PRODUCT_COPY_FILES += $(foreach blob,$(hp_gps_blob_paths), \
    $(hp_gps_oreo_dir)/$(blob):$(TARGET_COPY_OUT_VENDOR)/$(blob))
