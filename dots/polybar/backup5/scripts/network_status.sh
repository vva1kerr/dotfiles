#!/bin/bash
# Auto-detects the active ethernet interface via routing table.
# Falls back to first non-loopback, non-wireless interface with an IP.

# Old hardcoded interfaces (laptop USB adapters — kept for reference):
# iface1="enp116s0f1u1"
# iface2="enp0s20f0u2c4i2"

iface=$(ip route get 8.8.8.8 2>/dev/null | grep -oP 'dev \K\S+')
[ -z "$iface" ] && iface=$(ip -o addr show | grep 'inet ' | grep -vE ' lo | wl' | awk 'NR==1{print $2}')

if [ -z "$iface" ]; then
    echo " no ethernet"
    exit 0
fi

ip_addr=$(ip addr show "$iface" 2>/dev/null | grep 'inet ' | awk '{print $2}')
if [ -z "$ip_addr" ]; then
    echo " no IP ($iface)"
else
    echo " ${ip_addr}"
fi
