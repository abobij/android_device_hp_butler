$(call inherit-product, device/hp/msm8996-common/msm8996.mk)
$(call inherit-product, device/hp/falkon/proprietary-blobs.mk)

DEVICE_PACKAGE_OVERLAYS := device/hp/falkon/overlay $(DEVICE_PACKAGE_OVERLAYS)

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
