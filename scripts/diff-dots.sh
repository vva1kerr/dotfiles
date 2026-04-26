#!/bin/bash

DOTS="$(cd "$(dirname "$0")/../dots" && pwd)"

timestamp() {
    stat -c '%.19y' "$1" 2>/dev/null || echo "not found"
}

show_diff() {
    local repo="$1"
    local machine="$2"
    echo "  repo:    $repo"
    echo "           ($(timestamp "$repo"))"
    echo "  machine: $machine"
    echo "           ($(timestamp "$machine"))"
    echo
}

check_file() {
    local repo="$1"
    local machine="$2"
    if ! diff "$repo" "$machine" >/dev/null 2>&1; then
        show_diff "$repo" "$machine"
    fi
}

check_dir() {
    local repo_dir="$1"
    local machine_dir="$2"
    for repo_file in "$repo_dir"/*; do
        local filename
        filename=$(basename "$repo_file")
        check_file "$repo_file" "$machine_dir/$filename"
    done
}

# bashrc
check_file "$DOTS/bashrc/current/.bashrc" ~/.bashrc

# i3
if [ ! -d ~/.config/i3 ]; then
    mkdir -p ~/.config/i3
else
    check_file "$DOTS/i3/current/config"             ~/.config/i3/config
    check_file "$DOTS/i3/current/wallpaper.sh"       ~/.config/i3/wallpaper.sh
    check_file "$DOTS/i3/current/current-wallpaper"  ~/.config/i3/current-wallpaper
    check_file "$DOTS/i3/current/matrixlock.py"      ~/.config/i3/matrixlock.py
fi

# polybar
if [ ! -d ~/.config/polybar ]; then
    mkdir -p ~/.config/polybar
else
    check_file "$DOTS/polybar/current/config.ini"         ~/.config/polybar/config.ini
    check_file "$DOTS/polybar/current/colors-polybar.ini" ~/.config/polybar/colors-polybar.ini
    check_dir  "$DOTS/polybar/current/scripts"            ~/.config/polybar/scripts
fi

# alacritty
if [ ! -d ~/.config/alacritty ]; then
    mkdir -p ~/.config/alacritty
fi

# systemd
if [ ! -d ~/.config/systemd/user ]; then
    mkdir -p ~/.config/systemd/user
else
    check_file "$DOTS/systemd/current/wallpaper.service" ~/.config/systemd/user/wallpaper.service
    check_file "$DOTS/systemd/current/wallpaper.timer"   ~/.config/systemd/user/wallpaper.timer
fi

# picom
check_file "$DOTS/picom/current/picom.conf" ~/.config/picom.conf