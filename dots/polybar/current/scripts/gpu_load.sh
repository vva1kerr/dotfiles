#!/bin/bash
if command -v nvidia-smi &>/dev/null && nvidia-smi &>/dev/null 2>&1; then
    nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader | tr -d ' '
elif command -v rocm-smi &>/dev/null; then
    rocm-smi --showuse 2>/dev/null | grep -oP '\d+(?=\s*%)' | head -1 | awk '{print $1"%"}'
else
    echo "N/A"
fi
