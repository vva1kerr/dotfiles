#!/usr/bin/env bash
# install-grub-theme.sh
# Non-interactive build + install of the WinTux GRUB theme.
# Called from autoinstall late-commands inside the installed system chroot.
#
# Usage: bash install-grub-theme.sh <resolution> <scaling>
# Example: bash install-grub-theme.sh 1920x1080 1
#
# Scaling guide:
#   1   = standard 1080p display
#   1.5 = 2K / laptop QHD
#   2   = 4K / HiDPI

set -euo pipefail

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <resolution> <scaling>"
    echo "Example: $0 1920x1080 1"
    exit 1
fi

RESOLUTION="$1"
SCALING="$2"
THEME_SOURCE_DIR="/tmp/grub-theme"
INSTALL_LOCATION="/boot/grub/themes"
THEME_COMPLIANT_NAME="win-tux-dualboot-fullscreen"

# ── Build ─────────────────────────────────────────────────────────────────────

echo "==> Building WinTux GRUB theme for ${RESOLUTION} at ${SCALING}x scaling..."
cd "$THEME_SOURCE_DIR"
bash build.sh "$RESOLUTION" "$SCALING"

# build.sh names the output directory: "WinTux Dualboot Fullscreen <res>-<scale>x"
RES_NO_X="${RESOLUTION}"
BUILD_DIR="./build/WinTux Dualboot Fullscreen ${RES_NO_X}-${SCALING}x"

if [[ ! -d "$BUILD_DIR" ]]; then
    echo "ERROR: expected build output at '$BUILD_DIR' but it doesn't exist"
    exit 1
fi

# ── Install ───────────────────────────────────────────────────────────────────

echo "==> Copying theme to ${INSTALL_LOCATION}/${THEME_COMPLIANT_NAME}..."
mkdir -p "${INSTALL_LOCATION}/${THEME_COMPLIANT_NAME}"
cp -ar "${BUILD_DIR}/${THEME_COMPLIANT_NAME}/." "${INSTALL_LOCATION}/${THEME_COMPLIANT_NAME}/"

THEME_TXT="${INSTALL_LOCATION}/${THEME_COMPLIANT_NAME}/theme.txt"

# ── Patch /etc/default/grub ───────────────────────────────────────────────────

echo "==> Backing up /etc/default/grub..."
[[ ! -f /etc/default/grub.wintux.bak ]] && cp /etc/default/grub /etc/default/grub.wintux.bak

echo "==> Patching /etc/default/grub..."

# GRUB_GFXMODE
if grep -q "^GRUB_GFXMODE=" /etc/default/grub; then
    sed -i "s|^GRUB_GFXMODE=.*|GRUB_GFXMODE=\"${RESOLUTION}\"|" /etc/default/grub
else
    echo "" >> /etc/default/grub
    echo "GRUB_GFXMODE=\"${RESOLUTION}\"" >> /etc/default/grub
fi

# GRUB_THEME
ESCAPED_THEME_TXT=$(echo "$THEME_TXT" | sed 's|/|\\/|g')
if grep -q "^GRUB_THEME=" /etc/default/grub; then
    sed -i "s|^GRUB_THEME=.*|GRUB_THEME=\"${THEME_TXT}\"|" /etc/default/grub
else
    echo "" >> /etc/default/grub
    echo "GRUB_THEME=\"${THEME_TXT}\"" >> /etc/default/grub
fi

# GRUB_DISABLE_MEMTEST (theme has no memtest screen)
if grep -q "^GRUB_DISABLE_MEMTEST=" /etc/default/grub; then
    sed -i "s|^GRUB_DISABLE_MEMTEST=.*|GRUB_DISABLE_MEMTEST=true|" /etc/default/grub
else
    echo "" >> /etc/default/grub
    echo "GRUB_DISABLE_MEMTEST=true" >> /etc/default/grub
fi

# ── Patch 10_linux (Advanced options submenu icon) ────────────────────────────

echo "==> Patching /etc/grub.d/10_linux..."
[[ ! -d /etc/grub.d/wintux-backup ]] && mkdir -p /etc/grub.d/wintux-backup
[[ ! -f /etc/grub.d/wintux-backup/10_linux ]] && cp /etc/grub.d/10_linux /etc/grub.d/wintux-backup/10_linux

if ! grep -q '^SUBMENU_CLASS="--class gnu-linux-adv"' /etc/grub.d/10_linux; then
    sed -i '/CLASS="--class gnu-linux --class gnu --class os"/ a\
SUBMENU_CLASS="--class gnu-linux-adv"
' /etc/grub.d/10_linux
fi
sed -i 's|\(echo "submenu '"'"'$(.*)'"'"' \).*\(\\$menuentry_id_option.*\)|\1${SUBMENU_CLASS} \2|' /etc/grub.d/10_linux

# ── Patch 30_uefi-firmware (EFI entry icon) ───────────────────────────────────

echo "==> Patching /etc/grub.d/30_uefi-firmware..."
[[ ! -f /etc/grub.d/wintux-backup/30_uefi-firmware ]] && cp /etc/grub.d/30_uefi-firmware /etc/grub.d/wintux-backup/30_uefi-firmware
sed -i 's|\(menuentry '"'"'$LABEL'"'"' \).*\(\\$menuentry_id_option.*\)|\1--class efi \2|' /etc/grub.d/30_uefi-firmware

# ── Regenerate GRUB config ────────────────────────────────────────────────────

echo "==> Running update-grub..."
update-grub

echo "==> WinTux GRUB theme installed successfully for ${RESOLUTION}."
