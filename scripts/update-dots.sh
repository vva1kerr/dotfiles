#!/bin/bash

# bashrc
cat ../dots/bashrc/current/.bashrc > ~/.bashrc

# i3
if [ ! -d ~/.config/i3 ]; then                                                
    mkdir -p ~/.config/i3
else
    cat ../dots/i3/current/config > ~/.config/i3/config
    cat ../dots/i3/current/wallpaper.sh > ~/.config/i3/wallpaper.sh
    cat ../dots/i3/current/current-wallpaper > ~/.config/i3/current-wallpaper
    cat ../dots/i3/current/matrixlock.py > ~/.config/i3/matrixlock.py
    mkdir -p ~/.config/i3/workspaces
    cp -f ../dots/i3/current/workspaces/current/*.json ~/.config/i3/workspaces/
fi

# polybar
if [ ! -d ~/.config/polybar ]; then                                                
    mkdir -p ~/.config/polybar
else
    cat ../dots/polybar/current/config.ini > ~/.config/polybar/config.ini
    cat ../dots/polybar/current/colors-polybar.ini > ~/.config/polybar/colors-polybar.ini
    cat ../dots/polybar/current/modules.ini > ~/.config/polybar/modules.ini
    cp -rf ../dots/polybar/current/scripts/* ~/.config/polybar/scripts/
fi

# alacritty
if [ ! -d ~/.config/alacritty ]; then                                                
    mkdir -p ~/.config/alacritty
fi

# systemd
if [ ! -d ~/.config/systemd/user ]; then                                                
    mkdir -p ~/.config/systemd/userd
else
    cat ../dots/systemd/current/wallpaper.service > ~/.config/systemd/user/wallpaper.service
    cat ../dots/systemd/current/wallpaper.timer > ~/.config/systemd/user/wallpaper.timer
fi

# rofi
if [ ! -d ~/.config/rofi ]; then
    mkdir -p ~/.config/rofi
fi
cat ../dots/rofi/current/config.rasi > ~/.config/rofi/config.rasi
# wal template — processed by wal on every wallpaper change to generate ~/.cache/wal/colors-rofi.rasi
mkdir -p ~/.config/wal/templates
cat ../dots/rofi/current/colors-rofi.rasi > ~/.config/wal/templates/colors-rofi.rasi

# discord — wal template for Vesktop Quick CSS
mkdir -p ~/.config/wal/templates
cat ../dots/discord/current/colors-discord.css > ~/.config/wal/templates/colors-discord.css

# firefox — pywalfox native messenger patch
# main.sh is patched to use the pipx venv Python instead of system python3
# (system python3 can't find pywalfox since it lives in an isolated pipx venv)
# Re-apply after every `pipx upgrade pywalfox` since pipx overwrites the file
pywalfox_main=$(find ~/.local/share/pipx/venvs/pywalfox -name "main.sh" 2>/dev/null | head -1)
if [ -n "$pywalfox_main" ]; then
    cat ../dots/firefox/current/main.sh > "$pywalfox_main"
    chmod +x "$pywalfox_main"
    echo "Patched pywalfox main.sh at $pywalfox_main"
else
    echo "pywalfox not installed via pipx — skipping main.sh patch"
fi

# speech-dispatcher — mask both units so Vesktop's --enable-speech-dispatcher
# flag doesn't spin up a daemon that keeps PipeWire at 10% CPU continuously
systemctl --user mask speech-dispatcher.service speech-dispatcher.socket 2>/dev/null || true
systemctl --user stop speech-dispatcher.service speech-dispatcher.socket 2>/dev/null || true

# picom
cat ../dots/picom/current/picom.conf > ~/.config/picom.conf


