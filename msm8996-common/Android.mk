LOCAL_PATH := $(call my-dir)

ifneq ($(filter raptor falkon,$(TARGET_DEVICE)),)

RFS_MSM_MPSS_SYMLINKS := \
    $(TARGET_OUT_VENDOR)/rfs/msm/mpss/hlos \
    $(TARGET_OUT_VENDOR)/rfs/msm/mpss/ramdumps \
    $(TARGET_OUT_VENDOR)/rfs/msm/mpss/readwrite \
    $(TARGET_OUT_VENDOR)/rfs/msm/mpss/shared \
    $(TARGET_OUT_VENDOR)/rfs/msm/mpss/readonly/firmware \
    $(TARGET_OUT_VENDOR)/rfs/msm/mpss/readonly/vendor/firmware

$(TARGET_OUT_VENDOR)/rfs/msm/mpss/hlos:
	@mkdir -p $(dir $@)
	@ln -sfn /persist/hlos_rfs/shared $@

$(TARGET_OUT_VENDOR)/rfs/msm/mpss/ramdumps:
	@mkdir -p $(dir $@)
	@ln -sfn /data/vendor/tombstones/rfs/modem $@

$(TARGET_OUT_VENDOR)/rfs/msm/mpss/readwrite:
	@mkdir -p $(dir $@)
	@ln -sfn /persist/rfs/msm/mpss $@

$(TARGET_OUT_VENDOR)/rfs/msm/mpss/shared:
	@mkdir -p $(dir $@)
	@ln -sfn /persist/rfs/shared $@

$(TARGET_OUT_VENDOR)/rfs/msm/mpss/readonly/firmware:
	@mkdir -p $(dir $@)
	@ln -sfn /firmware $@

$(TARGET_OUT_VENDOR)/rfs/msm/mpss/readonly/vendor/firmware:
	@mkdir -p $(dir $@)
	@ln -sfn /vendor/firmware $@

include $(CLEAR_VARS)
LOCAL_MODULE := rfs_msm_mpss_symlinks
LOCAL_ADDITIONAL_DEPENDENCIES := $(RFS_MSM_MPSS_SYMLINKS)
include $(BUILD_PHONY_PACKAGE)

include $(call all-makefiles-under,$(LOCAL_PATH))

endif
