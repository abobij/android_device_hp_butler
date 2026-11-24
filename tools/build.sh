#!/usr/bin/env bash
set -eo pipefail

case "${1:-}" in
  raptor|falkon) device=$1; shift ;;
  *) printf 'Usage: %s {raptor|falkon} [build targets...]\n' "$0" >&2; exit 2 ;;
esac

tree=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../../.." && pwd -P)
cd -- "$tree"
if [[ ! -s "vendor/hp/$device/proprietary/boot/stock-dtbs.bin" ]]; then
  printf 'Run device/hp/tools/extract-stock.py for %s first.\n' "$device" >&2
  exit 1
fi

if command -v ccache >/dev/null; then
  export USE_CCACHE=1 CCACHE_EXEC
  CCACHE_EXEC=$(command -v ccache)
fi
export BUILD_USERNAME="${BUILD_USERNAME:-android}" BUILD_HOSTNAME="${BUILD_HOSTNAME:-build}"
export MKE2FS_CONFIG="$tree/system/extras/ext4_utils/mke2fs.conf"

output=${OUT_DIR:-out}
host_sysroot=prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.17-4.8/sysroot/usr/lib
for libdir in prebuilts/clang/host/linux-x86/clang-3289846/lib64 \
              "$output/soong/host/linux-x86/lib64" "$output/host/linux-x86/lib64"; do
  mkdir -p -- "$libdir"
  for library in libncurses.so.5 libtinfo.so.5; do
    if [[ ! -e "$libdir/$library" ]]; then
      ln -sr -- "$host_sysroot/$library" "$libdir/$library"
    fi
  done
done

source build/envsetup.sh
lunch "lineage_$device-userdebug"
if [[ $# -eq 0 ]]; then
  set -- bootimage systemimage
fi
m -j"${JOBS:-4}" "$@"
