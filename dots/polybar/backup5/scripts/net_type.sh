#!/bin/bash
# Shows ETH or WIFI depending on which interface is carrying the default route
iface=$(ip route get 8.8.8.8 2>/dev/null | grep -oP 'dev \K\S+')
if [ -z "$iface" ]; then
    echo "offline"
elif [[ "$iface" == wl* ]]; then
    essid=$(iwgetid -r 2>/dev/null)
    [ -n "$essid" ] && echo "WIFI: $essid" || echo "WIFI"
else
    echo "ETH: $iface"
fi
