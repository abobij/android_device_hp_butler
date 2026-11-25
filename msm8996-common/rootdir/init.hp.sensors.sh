#!/vendor/bin/sh
# Prepare SLPI sensor registry permissions and start the SSC daemon.

if [ -c /dev/msm_dsps -o -c /dev/sensors ]; then
    mkdir -p /persist/sensors/registry/registry
    if [ ! -f /persist/sensors/sensors_settings ]; then
        echo 1 > /persist/sensors/sensors_settings
    fi
    chmod -h 775 /persist/sensors
    chmod -h 664 /persist/sensors/sensors_settings
    chown -h system.root /persist/sensors/sensors_settings
    start vendor.sensors
fi
