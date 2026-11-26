LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := libpower_hp_msm8996
LOCAL_VENDOR_MODULE := true
LOCAL_SRC_FILES := power-hp.c
LOCAL_C_INCLUDES := vendor/qcom/opensource/power
LOCAL_HEADER_LIBRARIES := libhardware_headers
LOCAL_SHARED_LIBRARIES := liblog libcutils
LOCAL_CFLAGS := -Wall -Wextra -Werror

ifeq ($(TARGET_USES_INTERACTION_BOOST),true)
LOCAL_CFLAGS += -DINTERACTION_BOOST
endif

include $(BUILD_STATIC_LIBRARY)
