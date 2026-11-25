#!/vendor/bin/sh

export PATH=/vendor/bin:/system/bin

device=$(getprop ro.product.device)
simconfig_file=/persist/OEM/SimConfig
if [ "$device" = "raptor" ]; then
    setprop persist.radio.multisim.config dsds
elif [ -r "$simconfig_file" ]; then
    simconfig=$(cat "$simconfig_file")
    case "$simconfig" in
        SS|ss)
            setprop persist.radio.multisim.config ssss
            ;;
        dsda|DSDA)
            setprop persist.radio.multisim.config dsda
            ;;
        tsts|TSTS)
            setprop persist.radio.multisim.config tsts
            ;;
        *)
            setprop persist.radio.multisim.config dsds
            ;;
    esac
else
    setprop persist.radio.multisim.config dsds
fi

cursimconfig=$(getprop persist.radio.multisim.config)
prevsimconfig=""
if [ -f /data/vendor/radio/prevsimconfig ]; then
    prevsimconfig=$(cat /data/vendor/radio/prevsimconfig)
fi

if [ "$prevsimconfig" != "$cursimconfig" ]; then
    rm -rf /data/vendor/radio/qcril.db
    rm -rf /data/vendor/radio/iccid_*
    rm -rf /data/user_de/0/com.android.providers.telephony/databases/*
    echo "$cursimconfig" > /data/vendor/radio/prevsimconfig
fi

if [ -f /vendor/radio/qcril_database/qcril.db ] && [ ! -f /data/vendor/radio/qcril.db ]; then
    cp /vendor/radio/qcril_database/qcril.db /data/vendor/radio/qcril.db
    chown radio:radio /data/vendor/radio/qcril.db
fi
echo 1 > /data/vendor/radio/db_check_done

prev_version_info=""
if [ -f /data/vendor/radio/ver_info.txt ]; then
    prev_version_info=$(cat /data/vendor/radio/ver_info.txt)
fi

cur_version_info=""
if [ -f /firmware/verinfo/ver_info.txt ]; then
    cur_version_info=$(cat /firmware/verinfo/ver_info.txt)
fi

if [ ! -f /firmware/verinfo/ver_info.txt ] || [ "$prev_version_info" != "$cur_version_info" ]; then
    rm -rf /data/vendor/radio/modem_config
    mkdir -p /data/vendor/radio/modem_config/mcfg_hw/generic/common/msm8996/la/7+5_mode
    chmod 770 /data/vendor/radio/modem_config
    cp -r /firmware/image/modem_pr/mcfg/configs/mcfg_hw/generic/common/msm8996/la/7+5_mode/sr_dsds \
        /data/vendor/radio/modem_config/mcfg_hw/generic/common/msm8996/la/7+5_mode/
    cp -r /firmware/image/modem_pr/mcfg/configs/mcfg_hw/generic/common/msm8996/la/ss \
        /data/vendor/radio/modem_config/mcfg_hw/generic/common/msm8996/la/
    cp -r /firmware/image/modem_pr/mcfg/configs/mcfg_sw /data/vendor/radio/modem_config/
    setprop persist.vendor.radio.hw_mbn_update 1
    setprop persist.vendor.radio.sw_mbn_update 1
    chown -hR radio:radio /data/vendor/radio/modem_config
    if [ -f /firmware/verinfo/ver_info.txt ]; then
        cp /firmware/verinfo/ver_info.txt /data/vendor/radio/ver_info.txt
        chown radio:radio /data/vendor/radio/ver_info.txt
    fi
fi

if [ -f /firmware/image/modem_pr/mbn_ota.txt ]; then
    cp /firmware/image/modem_pr/mbn_ota.txt /data/vendor/radio/modem_config/
    chown radio:radio /data/vendor/radio/modem_config/mbn_ota.txt
fi
echo 1 > /data/vendor/radio/copy_complete
