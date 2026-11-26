#!/vendor/bin/sh
# Apply MSM8996 post-boot CPU, scheduler, bus DCVS, and low-power settings.

# Disable thermal/BCL core control while switching governors.
echo 0 > /sys/module/msm_thermal/core_control/enabled
echo -n disable > /sys/devices/soc/soc:qcom,bcl/mode
bcl_hotplug_mask=$(cat /sys/devices/soc/soc:qcom,bcl/hotplug_mask)
echo 0 > /sys/devices/soc/soc:qcom,bcl/hotplug_mask
bcl_soc_hotplug_mask=$(cat /sys/devices/soc/soc:qcom,bcl/hotplug_soc_mask)
echo 0 > /sys/devices/soc/soc:qcom,bcl/hotplug_soc_mask
echo -n enable > /sys/devices/soc/soc:qcom,bcl/mode

echo 1 > /proc/sys/kernel/sched_prefer_sync_wakee_to_waker

# Configure interactive governor for the LITTLE cluster.
echo "interactive" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_sched_load
echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_migration_notif
echo 19000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay
echo 90 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load
echo 20000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate
echo 960000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/hispeed_freq
echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/io_is_busy
echo 80 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads
echo 19000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time
echo 79000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/max_freq_hysteresis
echo 307200 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/ignore_hispeed_on_notif

# Configure interactive governor for the big cluster.
echo 1 > /sys/devices/system/cpu/cpu2/online
echo "interactive" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
echo 1 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/use_sched_load
echo 1 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/use_migration_notif
echo "19000 1400000:39000 1700000:19000 2100000:79000" > /sys/devices/system/cpu/cpu2/cpufreq/interactive/above_hispeed_delay
echo 90 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/go_hispeed_load
echo 20000 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/timer_rate
echo 1248000 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/hispeed_freq
echo 1 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/io_is_busy
echo "85 1500000:90 1800000:70 2100000:95" > /sys/devices/system/cpu/cpu2/cpufreq/interactive/target_loads
echo 19000 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/min_sample_time
echo 79000 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/max_freq_hysteresis
echo 307200 > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
echo 1 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/ignore_hispeed_on_notif

# Re-enable thermal and BCL hotplug.
echo 1 > /sys/module/msm_thermal/core_control/enabled
echo -n disable > /sys/devices/soc/soc:qcom,bcl/mode
echo "$bcl_hotplug_mask" > /sys/devices/soc/soc:qcom,bcl/hotplug_mask
echo "$bcl_soc_hotplug_mask" > /sys/devices/soc/soc:qcom,bcl/hotplug_soc_mask
echo -n enable > /sys/devices/soc/soc:qcom,bcl/mode

# Input boost and HMP scheduler tunables.
echo "0:1324800 2:1324800" > /sys/module/cpu_boost/parameters/input_boost_freq
echo 40 > /sys/module/cpu_boost/parameters/input_boost_ms
echo 0 > /proc/sys/kernel/sched_boost
echo 1 > /proc/sys/kernel/sched_migration_fixup
echo 45 > /proc/sys/kernel/sched_downmigrate
echo 45 > /proc/sys/kernel/sched_upmigrate
echo 400000 > /proc/sys/kernel/sched_freq_inc_notify
echo 400000 > /proc/sys/kernel/sched_freq_dec_notify
echo 3 > /proc/sys/kernel/sched_spill_nr_run
echo 100 > /proc/sys/kernel/sched_init_task_load

# Enable bus DCVS and memory latency scaling.
for cpubw in /sys/class/devfreq/*qcom,cpubw*; do
    [ -d "$cpubw" ] || continue
    echo "bw_hwmon" > "$cpubw/governor"
    echo 50 > "$cpubw/polling_interval"
    echo 1525 > "$cpubw/min_freq"
    echo "1525 5195 11863 13763" > "$cpubw/bw_hwmon/mbps_zones"
    echo 4 > "$cpubw/bw_hwmon/sample_ms"
    echo 34 > "$cpubw/bw_hwmon/io_percent"
    echo 20 > "$cpubw/bw_hwmon/hist_memory"
    echo 10 > "$cpubw/bw_hwmon/hyst_length"
    echo 0 > "$cpubw/bw_hwmon/low_power_ceil_mbps"
    echo 34 > "$cpubw/bw_hwmon/low_power_io_percent"
    echo 20 > "$cpubw/bw_hwmon/low_power_delay"
    echo 0 > "$cpubw/bw_hwmon/guard_band_mbps"
    echo 250 > "$cpubw/bw_hwmon/up_scale"
    echo 1600 > "$cpubw/bw_hwmon/idle_mbps"
done

for memlat in /sys/class/devfreq/*qcom,memlat-cpu*; do
    [ -d "$memlat" ] || continue
    echo "mem_latency" > "$memlat/governor"
    echo 10 > "$memlat/polling_interval"
done

if [ -d /sys/class/devfreq/soc:qcom,mincpubw ]; then
    echo "cpufreq" > /sys/class/devfreq/soc:qcom,mincpubw/governor
fi

soc_revision=$(cat /sys/devices/soc0/revision 2>/dev/null)
if [ "$soc_revision" = "2.1" ]; then
    echo 0 > /sys/module/lpm_levels/system/pwr/pwr-l2-gdhs/idle_enabled
    echo 0 > /sys/module/lpm_levels/system/perf/perf-l2-gdhs/idle_enabled
    echo N > /sys/module/lpm_levels/system/pwr/cpu0/fpc-def/idle_enabled
    echo N > /sys/module/lpm_levels/system/pwr/cpu1/fpc-def/idle_enabled
    echo N > /sys/module/lpm_levels/system/perf/cpu2/fpc-def/idle_enabled
    echo N > /sys/module/lpm_levels/system/perf/cpu3/fpc-def/idle_enabled
fi
echo N > /sys/module/lpm_levels/parameters/sleep_disabled
