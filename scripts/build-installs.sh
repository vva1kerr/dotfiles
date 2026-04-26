#!/bin/bash
# Packages that must be built from source (not available in apt)

set -e

# xwinwrap — desktop window wrapper, used to play mpv video wallpapers
sudo apt install -y xorg-dev build-essential libx11-dev x11proto-xext-dev libxrender-dev libxext-dev
git clone https://github.com/ujjwal96/xwinwrap /tmp/xwinwrap
cd /tmp/xwinwrap && make && sudo make install