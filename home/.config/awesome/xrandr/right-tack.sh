#!/bin/sh
#
# the secondary monitor(portrait) is on the right of the primary monitor(lanscape)
eval `\`dirname -- "$0"\`/monitor_resolutions.sh`
expected_monitors=2
if [ "${monitor_count:-0}" -ne "$expected_monitors" ]
then
    echo "$0: Expected ${expected_monitors} monitors; found ${monitor_count:-0}." >&2
    exit 1
fi

offset=$(( ( ${monitor1_width} - ${monitor2_height} ) / 2 ))

xrandr \
    --output "$monitor1_name" \
        --mode ${monitor1_width}x${monitor1_height} \
        --pos ${monitor2_width}x-1000 \
        --rotate left \
    --output "$monitor2_name" \
        --mode ${monitor2_width}x${monitor2_height} \
        --pos 0x0 \
        --primary \
        --rotate normal
