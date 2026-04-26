#!/bin/bash
# One-shot wallpaper changer — called by systemd wallpaper.timer, not looped.

# Detect DISPLAY dynamically — works whether called by systemd or directly
export DISPLAY="${DISPLAY:-$(who | grep -oP '\(:\d+\)' | tr -d '()' | head -1)}"
export DISPLAY="${DISPLAY:-:1}"

# Make sure pipx bins are on PATH
export PATH="$HOME/.local/bin:$PATH"

# wpgtk (wpg) uses gsettings/dbus to apply the GTK theme — without this export
# the dbus session is invisible to the script when launched by systemd
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$UID/bus"

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
    # Register the extracted frame with wpgtk so it generates a GTK theme from the palette
    wpg -a "$frame"

    xwinwrap -b -s -fs -st -sp -nf -ov -fdt -- \
        mpv -wid WID \
            --loop \
            --no-audio \
            --really-quiet \
            --framedrop=vo \
            --hwdec=auto \
            --panscan=1.0 \
            --scale=bilinear \
            --cscale=bilinear \
            --dither=no \
            "$wallpaper" &
    echo $! > "$BG_PID"
else
    echo "" > "$FRAME_STATE"
    feh --bg-fill "$wallpaper"
    wal -i "$wallpaper"
    # Register the wallpaper with wpgtk so it generates a GTK theme from the palette
    wpg -a "$wallpaper"
fi

# Apply the most recently generated wpgtk theme — writes to ~/.config/xsettingsd/xsettingsd.conf
# and calls gsettings so xsettingsd broadcasts the new GTK theme to running apps
wpg --restore

cp ~/.cache/wal/colors-polybar.ini ~/.config/polybar/colors-polybar.ini

# Push the new palette into Firefox — requires the pywalfox extension + native messenger installed
pywalfox update 2>/dev/null || true

# Push wal palette into Vesktop (Discord) Quick CSS — only runs if Vesktop has been launched once
vesktop_css="$HOME/.var/app/dev.vencord.Vesktop/config/vesktop/settings/quickCss.css"
if [ -d "$(dirname "$vesktop_css")" ]; then
    cp ~/.cache/wal/colors-discord.css "$vesktop_css"
    # Vesktop only reads quickCss.css at startup so restart it to pick up the new palette
    if pgrep -f vesktop > /dev/null; then
        pkill -f vesktop
        sleep 1
        flatpak run dev.vencord.Vesktop &>/dev/null &
    fi
fi

# Skip bar restart while locked — polybar teardown can knock matrixlock out of fullscreen
if ! pgrep -x i3lock > /dev/null; then
    ~/.config/i3/launch_bar.sh polybar
fi

# Other feh scaling options:
# --bg-fill   — fill without stretching (crops to fit)
# --bg-max    — scale up to fit, no crop
# --bg-center — centered, no scaling
# --bg-tile   — tile the image
