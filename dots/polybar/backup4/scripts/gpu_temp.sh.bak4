#!/bin/bash
# Auto-detects GPU vendor and queries temperature accordingly.
if command -v nvidia-smi &>/dev/null && nvidia-smi &>/dev/null 2>&1; then
    temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader)
    echo "${temp}°C"
elif command -v rocm-smi &>/dev/null; then
    rocm-smi --showtemp 2>/dev/null | grep -oP '\d+(?=\.\d+\s*°C)' | head -1 | awk '{print $1"°C"}'
else
    echo "N/A"
fi
