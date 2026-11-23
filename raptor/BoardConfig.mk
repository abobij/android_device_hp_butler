include device/hp/msm8996-common/BoardConfigCommon.mk

BOARD_KERNEL_BASE := 0x80000000
BOARD_KERNEL_PAGESIZE := 4096
BOARD_MKBOOTIMG_ARGS := --kernel_offset 0x00008000 --ramdisk_offset 0x01000000 \
    --second_offset 0x00f00000 --tags_offset 0x00000100 --header_version 0
BOARD_KERNEL_CMDLINE := console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 \
    androidboot.hardware=qcom earlycon=msm_hsl_uart,0x075b0000 \
    user_debug=31 msm_rtb.filter=0x237 ehci-hcd.park=3 lpm_levels.sleep_disabled=1 \
    cma=32M@0-0xffffffff ramoops.mem_address=0x9ff00000 \
    ramoops.mem_size=0x00100000 ramoops.console_size=0x00040000 \
    androidboot.selinux=permissive adreno.nopreempt=1

TARGET_KERNEL_SOURCE := kernel/hp/msm8996
TARGET_KERNEL_CONFIG := raptor_lineage_defconfig
BOARD_KERNEL_IMAGE_NAME := Image.gz-dtb
TARGET_COMPILE_WITH_MSM_KERNEL := true
KERNEL_TOOLCHAIN := $(abspath ../kernel_hp_raptor/tools/aarch64-linux-android-4.9/bin)
TARGET_KERNEL_ADDITIONAL_FLAGS := -j4 \
    ARM64_APPENDED_DTB_BUNDLE=$(abspath ../kernel_hp_raptor/reference/firmware/raptor-7.1.2-appended-dtbs.bin)
TARGET_RECOVERY_FSTAB := device/hp/raptor/rootdir/fstab.qcom
DEVICE_MANIFEST_FILE := device/hp/raptor/manifest.xml

BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 67108864
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 5583458304
BOARD_FLASH_BLOCK_SIZE := 131072
