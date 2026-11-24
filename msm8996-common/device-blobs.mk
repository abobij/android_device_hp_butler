# A530 firmware and QSEE clients from each device's own stock 7.1.2 image.
hp_firmware_blob_paths := \
    firmware/a530_gpmu.fw2 \
    firmware/a530_pfp.fw \
    firmware/a530_pm4.fw \
    firmware/a530_zap.b00 \
    firmware/a530_zap.b01 \
    firmware/a530_zap.b02 \
    firmware/a530_zap.mdt \
    firmware/a530v1_pfp.fw \
    firmware/a530v1_pm4.fw \
    firmware/a530v2_seq.fw2 \
    firmware/a530v3_gpmu.fw2 \
    firmware/a530v3_seq.fw2

PRODUCT_COPY_FILES += $(foreach blob,$(hp_firmware_blob_paths),\
    $(hp_device_blob_dir)/$(blob):$(TARGET_COPY_OUT_VENDOR)/$(blob))

hp_keymaster_blob_paths := \
    lib/hw/keystore.msm8996.so \
    lib/libQSEEComAPI.so \
    lib64/hw/keystore.msm8996.so \
    lib64/hw/gatekeeper.msm8996.so \
    lib64/libQSEEComAPI.so \
    bin/qseecomd \
    lib64/lib-sec-disp.so \
    lib64/libGPreqcancel.so \
    lib64/libGPreqcancel_svc.so \
    lib64/libStDrvInt.so \
    lib64/libdiag.so \
    lib64/libdrmfs.so \
    lib64/libdrmtime.so \
    lib64/libqisl.so \
    lib64/librpmb.so \
    lib64/libsecureui.so \
    lib64/libsecureui_svcsock.so \
    lib64/libssd.so \
    lib64/libtime_genoff.so
PRODUCT_COPY_FILES += $(foreach blob,$(hp_keymaster_blob_paths),\
    $(hp_device_blob_dir)/$(blob):$(TARGET_COPY_OUT_VENDOR)/$(blob))
