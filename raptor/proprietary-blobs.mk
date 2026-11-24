# The RAPTOR Android 8.1 EGL/GLES subdriver supports the gralloc1 HAL.
# A530 microcode comes from the Android 7.1.2 hardware baseline.
raptor_blob_dir := vendor/hp/raptor/proprietary

raptor_egl_blob_paths := \
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

raptor_firmware_blob_paths := \
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

PRODUCT_COPY_FILES += $(foreach blob,$(raptor_firmware_blob_paths),\
    $(raptor_blob_dir)/$(blob):$(TARGET_COPY_OUT_VENDOR)/$(blob))
PRODUCT_COPY_FILES += $(foreach blob,$(raptor_egl_blob_paths),\
    $(raptor_blob_dir)/8.1-graphics/$(blob):$(TARGET_COPY_OUT_VENDOR)/$(blob))

# RAPTOR Android 7.1.2 keystore and its QSEE client.
raptor_keymaster_blob_paths := \
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
PRODUCT_COPY_FILES += $(foreach blob,$(raptor_keymaster_blob_paths),\
    $(raptor_blob_dir)/$(blob):$(TARGET_COPY_OUT_VENDOR)/$(blob))

PRODUCT_COPY_FILES += \
    $(raptor_blob_dir)/firmware/wlan/qca_cld/WCNSS_qcom_cfg.ini:$(TARGET_COPY_OUT_VENDOR)/firmware/wlan/qca_cld/WCNSS_qcom_cfg.ini \
    $(raptor_blob_dir)/etc/wifi/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf
