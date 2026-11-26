/*
 * Direct sysfs PowerHAL backend for HP Butler (MSM8996) without QTI perfd.
 */

#define LOG_TAG "HP PowerHAL"

#include <errno.h>
#include <fcntl.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

#include <hardware/power.h>
#include <log/log.h>

#include "power-common.h"

#define LITTLE_GOV_PATH "/sys/devices/system/cpu/cpu0/cpufreq/interactive"
#define BIG_GOV_PATH "/sys/devices/system/cpu/cpu2/cpufreq/interactive"
#define LITTLE_MIN_FREQ "/sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq"
#define LITTLE_MAX_FREQ "/sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq"
#define LITTLE_INFO_MAX "/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq"
#define BIG_MIN_FREQ "/sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq"
#define BIG_MAX_FREQ "/sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq"
#define BIG_INFO_MAX "/sys/devices/system/cpu/cpu2/cpufreq/cpuinfo_max_freq"
#define SCHED_BOOST_PATH "/proc/sys/kernel/sched_boost"

#define MIN_INTERACTION_INTERVAL_US 80000LL

static int current_power_profile = PROFILE_BALANCED;
static bool launch_boost_active = false;
static char little_max_buf[32] = "1363200";
static char big_max_buf[32] = "1804800";
static bool max_freqs_cached = false;

static int write_sysfs(const char* path, const char* val) {
    int fd = open(path, O_WRONLY);
    if (fd < 0) return -errno;
    ssize_t ret = write(fd, val, strlen(val));
    int err = (ret < 0) ? -errno : 0;
    close(fd);
    return err;
}

static void cache_max_freqs(void) {
    if (max_freqs_cached) return;

    struct {
        const char* path;
        char* out;
        size_t size;
    } entries[] = {
        {LITTLE_INFO_MAX, little_max_buf, sizeof(little_max_buf)},
        {BIG_INFO_MAX, big_max_buf, sizeof(big_max_buf)},
    };

    for (size_t i = 0; i < ARRAY_SIZE(entries); i++) {
        int fd = open(entries[i].path, O_RDONLY);
        if (fd < 0) continue;
        ssize_t n = read(fd, entries[i].out, entries[i].size - 1);
        close(fd);
        if (n > 0) {
            entries[i].out[n] = '\0';
            char* nl = strchr(entries[i].out, '\n');
            if (nl) *nl = '\0';
        }
    }
    max_freqs_cached = true;
}

static void pulse_clusters(void) {
    write_sysfs(LITTLE_GOV_PATH "/boostpulse", "1");
    write_sysfs(BIG_GOV_PATH "/boostpulse", "1");
}

static void set_cluster_boost(bool enable) {
    const char* val = enable ? "1" : "0";
    write_sysfs(LITTLE_GOV_PATH "/boost", val);
    write_sysfs(BIG_GOV_PATH "/boost", val);
    write_sysfs(SCHED_BOOST_PATH, val);
}

#ifdef INTERACTION_BOOST
int get_number_of_profiles(void) {
    return 5;
}
#endif

static int set_power_profile(int profile) {
    if (profile == current_power_profile) return 0;

    cache_max_freqs();
    launch_boost_active = false;

    switch (profile) {
        case PROFILE_POWER_SAVE:
            set_cluster_boost(false);
            write_sysfs(LITTLE_MIN_FREQ, "307200");
            write_sysfs(BIG_MIN_FREQ, "307200");
            write_sysfs(LITTLE_MAX_FREQ, "960000");
            write_sysfs(BIG_MAX_FREQ, "1036800");
            break;
        case PROFILE_BIAS_POWER:
            set_cluster_boost(false);
            write_sysfs(LITTLE_MIN_FREQ, "307200");
            write_sysfs(BIG_MIN_FREQ, "307200");
            write_sysfs(LITTLE_MAX_FREQ, "1113600");
            write_sysfs(BIG_MAX_FREQ, "1401600");
            break;
        case PROFILE_BALANCED:
            set_cluster_boost(false);
            write_sysfs(LITTLE_MIN_FREQ, "307200");
            write_sysfs(BIG_MIN_FREQ, "307200");
            write_sysfs(LITTLE_MAX_FREQ, little_max_buf);
            write_sysfs(BIG_MAX_FREQ, big_max_buf);
            break;
        case PROFILE_BIAS_PERFORMANCE:
            set_cluster_boost(false);
            write_sysfs(LITTLE_MAX_FREQ, little_max_buf);
            write_sysfs(BIG_MAX_FREQ, big_max_buf);
            write_sysfs(LITTLE_MIN_FREQ, "729600");
            write_sysfs(BIG_MIN_FREQ, "806400");
            break;
        case PROFILE_HIGH_PERFORMANCE:
            write_sysfs(LITTLE_MAX_FREQ, little_max_buf);
            write_sysfs(BIG_MAX_FREQ, big_max_buf);
            write_sysfs(LITTLE_MIN_FREQ, "1113600");
            write_sysfs(BIG_MIN_FREQ, "1324800");
            set_cluster_boost(true);
            break;
        default:
            ALOGW("Unsupported power profile: %d", profile);
            return -EINVAL;
    }

    current_power_profile = profile;
    ALOGD("%s: profile=%d", __func__, profile);
    return 0;
}

static void handle_interaction_hint(void) {
    static struct timespec last_boost = {0, 0};
    struct timespec now;

    clock_gettime(CLOCK_MONOTONIC, &now);
    long long elapsed_us = (long long)(now.tv_sec - last_boost.tv_sec) * 1000000LL +
                           (now.tv_nsec - last_boost.tv_nsec) / 1000LL;
    if (elapsed_us >= 0 && elapsed_us < MIN_INTERACTION_INTERVAL_US) return;

    last_boost = now;
    pulse_clusters();
}

static void handle_launch_hint(void* data) {
    bool start = (data != NULL);
    if (start) {
        if (!launch_boost_active) {
            set_cluster_boost(true);
            launch_boost_active = true;
        }
        pulse_clusters();
    } else if (launch_boost_active) {
        set_cluster_boost(false);
        launch_boost_active = false;
    }
}

int power_hint_override(power_hint_t hint, void* data) {
    if (hint == POWER_HINT_SET_PROFILE) {
        set_power_profile(data ? *((int*)data) : PROFILE_BALANCED);
        return HINT_HANDLED;
    }

    if (current_power_profile == PROFILE_POWER_SAVE ||
        current_power_profile == PROFILE_HIGH_PERFORMANCE) {
        return HINT_HANDLED;
    }

    switch (hint) {
        case POWER_HINT_INTERACTION:
            handle_interaction_hint();
            return HINT_HANDLED;
        case POWER_HINT_LAUNCH:
            handle_launch_hint(data);
            return HINT_HANDLED;
        default:
            return HINT_NONE;
    }
}

int set_interactive_override(int on) {
    if (current_power_profile == PROFILE_HIGH_PERFORMANCE) return HINT_HANDLED;

    if (!on && launch_boost_active) {
        set_cluster_boost(false);
        launch_boost_active = false;
    } else if (on && current_power_profile != PROFILE_POWER_SAVE) {
        pulse_clusters();
    }
    return HINT_HANDLED;
}
