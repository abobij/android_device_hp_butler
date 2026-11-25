hp_sensors_oreo_dir := vendor/hp/msm8996-common/proprietary/8.1-sensors

# Android 8.1 SLPI / SSC sensor daemon, HAL module, and board configuration.
hp_sensors_blob_paths := \
    bin/sensors.qcom \
    etc/sensors/hals.conf \
    etc/sensors/sensor_def_qcomdev.conf \
    lib64/libsensor1.so \
    lib64/libsensor_reg.so \
    lib64/libsensor_thresh.so \
    lib64/libsensor_user_cal.so \
    lib64/sensors.ssc.so

PRODUCT_COPY_FILES += $(foreach blob,$(hp_sensors_blob_paths), \
    $(hp_sensors_oreo_dir)/$(blob):$(TARGET_COPY_OUT_VENDOR)/$(blob))
