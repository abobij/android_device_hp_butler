include device/hp/msm8996-common/BoardConfigCommon.mk

BOARD_KERNEL_CMDLINE := console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 \
    androidboot.hardware=qcom earlycon=msm_hsl_uart,0x075b0000 \
    user_debug=31 msm_rtb.filter=0x237 ehci-hcd.park=3 lpm_levels.sleep_disabled=1 \
    cma=32M@0-0xffffffff ramoops.mem_address=0x9ff00000 \
    ramoops.mem_size=0x00100000 ramoops.console_size=0x00040000 \
    androidboot.selinux=permissive adreno.nopreempt=1

TARGET_KERNEL_ADDITIONAL_FLAGS += \
    ARM64_APPENDED_DTB_BUNDLE=$(abspath vendor/hp/raptor/proprietary/boot/stock-dtbs.bin)

BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 67108864
TARGET_RECOVERY_DENSITY := xxhdpi
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 5583458304
BOARD_CACHEIMAGE_PARTITION_SIZE := 5583458304
BOARD_FLASH_BLOCK_SIZE := 131072
