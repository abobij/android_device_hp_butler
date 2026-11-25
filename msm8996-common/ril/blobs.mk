hp_ril_oreo_dir := vendor/hp/msm8996-common/proprietary/8.1-ril

# Android 8.1 QMI, RFS, and Qualcomm RIL stack for MPSS.TH modems.
hp_ril_blob_paths := \
    bin/irsc_util \
    bin/netmgrd \
    bin/pm-proxy \
    bin/pm-service \
    bin/port-bridge \
    bin/qti \
    bin/rmt_storage \
    bin/tftp_server \
    bin/time_daemon \
    etc/data/dsi_config.xml \
    etc/data/netmgr_config.xml \
    etc/qmi_fw.conf \
    etc/sec_config \
    lib64/android.hidl.base@1.0.so \
    lib64/com.quicinc.cne.api@1.0.so \
    lib64/com.quicinc.cne.constants@1.0.so \
    lib64/libcneapiclient.so \
    lib64/libconfigdb.so \
    lib64/libdsi_netctrl.so \
    lib64/libdsutils.so \
    lib64/libidl.so \
    lib64/liblqe.so \
    lib64/libmdmdetect.so \
    lib64/libmdmimgload.so \
    lib64/libnetmgr.so \
    lib64/libperipheral_client.so \
    lib64/libqcmaputils.so \
    lib64/libqcrilFramework.so \
    lib64/libqdi.so \
    lib64/libqdp.so \
    lib64/libqmi.so \
    lib64/libqmi_cci.so \
    lib64/libqmi_client_helper.so \
    lib64/libqmi_client_qmux.so \
    lib64/libqmi_common_so.so \
    lib64/libqmi_csi.so \
    lib64/libqmi_encdec.so \
    lib64/libqmiservices.so \
    lib64/libril-qc-ltedirectdisc.so \
    lib64/libril-qc-qmi-1.so \
    lib64/libril-qc-radioconfig.so \
    lib64/libril-qcril-hook-oem.so \
    lib64/librilqmiservices.so \
    lib64/libsettings.so \
    lib64/libsmemlog.so \
    lib64/libsystem_health_mon.so \
    lib64/libxml.so \
    lib64/vendor.qti.hardware.radio.am@1.0_vendor.so \
    lib64/vendor.qti.hardware.radio.ims@1.0_vendor.so \
    lib64/vendor.qti.hardware.radio.lpa@1.0_vendor.so \
    lib64/vendor.qti.hardware.radio.qcrilhook@1.0_vendor.so \
    lib64/vendor.qti.hardware.radio.qtiradio@1.0_vendor.so \
    lib64/vendor.qti.hardware.radio.uim@1.0_vendor.so \
    lib64/vendor.qti.hardware.radio.uim_remote_client@1.0_vendor.so \
    lib64/vendor.qti.hardware.radio.uim_remote_server@1.0_vendor.so \
    radio/qcril_database/qcril.db

PRODUCT_COPY_FILES += $(foreach blob,$(hp_ril_blob_paths), \
    $(hp_ril_oreo_dir)/$(blob):$(TARGET_COPY_OUT_VENDOR)/$(blob))
