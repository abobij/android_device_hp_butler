$(call inherit-product, device/hp/msm8996-common/msm8996.mk)
$(call inherit-product, device/hp/raptor/proprietary-blobs.mk)

PRODUCT_COPY_FILES += \
    device/hp/raptor/audio/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.sf.lcd_density=360

# Optional host public key for local debugging. AOSP applies this to debuggable builds.
ifdef RAPTOR_ADB_KEYS
PRODUCT_ADB_KEYS := $(RAPTOR_ADB_KEYS)
endif

PRODUCT_NAME := lineage_raptor
PRODUCT_DEVICE := raptor
PRODUCT_BRAND := HP
PRODUCT_MODEL := HP Pro x3
PRODUCT_MANUFACTURER := HP
