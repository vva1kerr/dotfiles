#!/bin/bash
# Reads CPU temp from hwmon — tries k10temp (AMD) then coretemp (Intel).
for name in k10temp coretemp; do
    for d in /sys/class/hwmon/hwmon*; do
        if [ "$(cat "$d/name" 2>/dev/null)" = "$name" ]; then
            temp=$(cat "$d/temp1_input" 2>/dev/null)
            [ -n "$temp" ] && echo "$((temp / 1000))°C" && exit 0
        fi
    done
done
echo "N/A"
