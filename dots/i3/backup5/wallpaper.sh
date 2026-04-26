#!/bin/bash
# One-shot wallpaper changer — called by systemd wallpaper.timer, not looped.

# Detect DISPLAY dynamically — works whether called by systemd or directly
export DISPLAY="${DISPLAY:-$(who | grep -oP '\(:\d+\)' | tr -d '()' | head -1)}"
export DISPLAY="${DISPLAY:-:1}"

# Make sure pipx bins are on PATH
export PATH="$HOME/.local/bin:$PATH"

wallpaper=$(find ~/Pictures/wallpapers/ -type f | shuf -n1)
#wallpaper=~/Pictures/wallpapers/NGE-Robot01-sprint.gif

feh --bg-fill "$wallpaper"

echo "$wallpaper" > ~/.config/i3/current-wallpaper

wal -i "$wallpaper"
cp ~/.cache/wal/colors-polybar.ini ~/.config/polybar/colors-polybar.ini

~/.config/i3/launch_bar.sh polybar

# Other feh scaling options:
# --bg-fill   — fill without stretching (crops to fit)
# --bg-max    — scale up to fit, no crop
# --bg-center — centered, no scaling
# --bg-tile   — tile the image
