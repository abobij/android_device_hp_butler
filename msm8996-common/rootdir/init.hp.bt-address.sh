#!/vendor/bin/sh

# Qualcomm NV item 1 stores the six address bytes in controller byte order.
nv=/persist/bluetooth/.bt_nv.bin
address=/data/vendor/bluetooth/bdaddr

umask 077
: > "$address" || exit 1
bytes=$(/system/bin/od -An -v -t x1 -N 9 "$nv") || exit 0
set -- $bytes
[ "$#" -eq 9 ] && [ "$1$2$3" = 010006 ] || exit 0
case "$4$5$6$7$8$9" in
    000000000000|ffffffffffff) exit 0 ;;
esac
printf '%s:%s:%s:%s:%s:%s\n' "$9" "$8" "$7" "$6" "$5" "$4" > "$address"
