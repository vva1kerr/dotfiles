#!/bin/bash
# One-shot wallpaper changer — called by systemd wallpaper.timer, not looped.

# Detect DISPLAY dynamically — works whether called by systemd or directly
export DISPLAY="${DISPLAY:-$(who | grep -oP '\(:\d+\)' | tr -d '()' | head -1)}"
export DISPLAY="${DISPLAY:-:1}"

# Make sure pipx bins are on PATH
export PATH="$HOME/.local/bin:$PATH"

FRAME_STATE="$HOME/.config/i3/current-wallpaper-frame"
BG_PID="/var/run/user/$UID/bg.pid"

# --- Cleanup from previous run ---
if [[ -f "$BG_PID" ]]; then
    pid=$(cat "$BG_PID")
    [[ $(ps -p "$pid" -o comm= 2>/dev/null) == "xwinwrap" ]] && kill "$pid"
fi
prev_frame=$(cat "$FRAME_STATE" 2>/dev/null)
[[ -n "$prev_frame" && -f "$prev_frame" ]] && rm -f "$prev_frame"

# --- Select wallpaper ---
wallpaper=$(find ~/Pictures/wallpapers/ -type f | shuf -n1)
#wallpaper=~/Pictures/wallpapers/NGE-Robot01-sprint.gif

echo "$wallpaper" > ~/.config/i3/current-wallpaper

# --- Branch on file type ---
if [[ "$wallpaper" =~ \.(mp4|webm|mkv|avi)$ ]]; then
    frame=$(mktemp /tmp/wallpaper-frame-XXXX.jpg)
    ffmpeg -i "$wallpaper" -vframes 1 -q:v 2 "$frame" -y -loglevel quiet
    echo "$frame" > "$FRAME_STATE"

    wal -i "$frame"

    xwinwrap -b -s -fs -st -sp -nf -ov -fdt -- \
        mpv -wid WID \
            --loop \
            --no-audio \
            --really-quiet \
            --framedrop=vo \
            --hwdec=auto \
            --panscan=1.0 \
            "$wallpaper" &
    echo $! > "$BG_PID"
else
    echo "" > "$FRAME_STATE"
    feh --bg-fill "$wallpaper"
    wal -i "$wallpaper"
fi

cp ~/.cache/wal/colors-polybar.ini ~/.config/polybar/colors-polybar.ini

# Skip bar restart while locked — polybar teardown can knock matrixlock out of fullscreen
if ! pgrep -x i3lock > /dev/null; then
    ~/.config/i3/launch_bar.sh polybar
fi

# Other feh scaling options:
# --bg-fill   — fill without stretching (crops to fit)
# --bg-max    — scale up to fit, no crop
# --bg-center — centered, no scaling
# --bg-tile   — tile the image
