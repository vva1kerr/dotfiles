# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

Personal dotfiles for an Ubuntu + i3 desktop rice. All theming is driven automatically from the wallpaper via pywal. The repo stores versioned config snapshots under `dots/` and install/update scripts under `scripts/`.

## Repository Layout

```
dots/
  alacritty/current/    terminal emulator config
  bashrc/current/       shell config
  discord/current/      colors-discord.css wal template for Vesktop Quick CSS
  firefox/current/      pywalfox native messenger patch (main.sh + config)
  fonts/                font files + installed.md (font reference doc)
  grub/                 GRUB config + 40_custom
  i3/current/           i3 config, wallpaper.sh, matrixlock.py, current-wallpaper
  i3status/             fallback status bar config
  picom/current/        compositor config
  polybar/current/      config.ini, modules.ini, colors-polybar.ini, scripts/
  rofi/current/         config.rasi + colors-rofi.rasi wal template
  systemd/current/      wallpaper.timer + wallpaper.service
scripts/
  apt-installs.sh       install all apt packages
  build-installs.sh     build from source (xwinwrap for video wallpapers)
  diff-dots.sh          show files that differ between dots/ and live ~/.config/
  flatpak-installs.sh   install Bottles, Heroic, Obsidian, Vesktop
  install-grub-theme.sh non-interactive WinTux GRUB theme builder + installer
  pipx-installs.sh      install pywal, yt-dlp, bpytop via pipx
  update-dots.sh        copy dots/ → live ~/.config/
grub-matrix-pill/       standalone GRUB theme subproject
wallpapers/             wallpaper images (also copied to ~/Pictures/wallpapers/)
need-to-test-autoinstall/  Ubuntu autoinstall USB scripts
```

Backups are kept as `backupN/` siblings of `current/` inside each component directory. The live system config files under `~/.config/` are the source of truth; `dots/current/` is the versioned snapshot.

## Applying Configs to the Live System

`update-dots.sh` uses relative paths (`../dots/…`) so it **must be run from the `scripts/` directory**:

```bash
cd scripts
bash update-dots.sh
```

Run this after editing anything in `dots/*/current/` to push changes to `~/.config/`. It also patches the pywalfox pipx venv `main.sh` and masks `speech-dispatcher` (prevents PipeWire CPU drain from Vesktop).

To check which files have drifted between `dots/` and the live system without applying anything:

```bash
cd scripts
bash diff-dots.sh
```

## Fresh System Bootstrap

```bash
# apt packages (i3, alacritty, polybar, picom, feh, etc.)
bash scripts/apt-installs.sh

# pipx packages (pywal/wal, yt-dlp, bpytop)
bash scripts/pipx-installs.sh
pipx ensurepath

# flatpak apps (run after flatpak is installed)
bash scripts/flatpak-installs.sh

# copy configs
bash scripts/update-dots.sh

# enable wallpaper timer
systemctl --user daemon-reload
systemctl --user enable --now wallpaper.timer
```

## The Wallpaper → Theme Chain

i3 login fires two things:
- `systemctl --user start wallpaper.timer` — arms the 350-second rotation
- `exec_always launch_bar.sh polybar` — starts polybar on every i3 reload

Every 350s the timer fires `wallpaper.service` → `wallpaper.sh`, which:
1. Picks a random image from `~/Pictures/wallpapers/`
2. Sets it with `feh --bg-fill`
3. Runs `wal -i` to generate a palette — writes color files to `~/.cache/wal/`, sends live escape sequences to open terminals; wal also processes all templates under `~/.config/wal/templates/` (polybar, rofi, discord)
4. Copies `~/.cache/wal/colors-polybar.ini` → `~/.config/polybar/colors-polybar.ini`
5. Copies `~/.cache/wal/colors-discord.css` → Vesktop's `quickCss.css`, then kills and relaunches Vesktop so it picks up the new palette (Vesktop only reads Quick CSS at startup)
6. Calls `launch_bar.sh polybar` to kill and restart polybar with the new palette

**Do not edit `~/.config/polybar/colors-polybar.ini` directly** — it is overwritten on every wallpaper change. Edit the wal template at `~/.config/wal/templates/colors-polybar.ini` instead. Same applies to `colors-rofi.rasi` and `colors-discord.css` — always edit the template in `dots/*/current/`, deploy with `update-dots.sh`, then regenerate with `wal -R`.

`launch_bar.sh` auto-detects the primary monitor via `xrandr`, exports `$MONITOR`, kills any existing polybar, waits for it to exit, then starts `polybar example &`. It is called by both i3 (`exec_always`) and `wallpaper.sh`.

## Key Config Locations (Live System)

| Component | Live path |
|---|---|
| i3 | `~/.config/i3/config` |
| Bar launcher | `~/.config/i3/launch_bar.sh` |
| Wallpaper script | `~/.config/i3/wallpaper.sh` |
| Current wallpaper path | `~/.config/i3/current-wallpaper` |
| Lock screen script | `~/.config/i3/matrixlock.py` |
| i3status (fallback bar) | `~/.config/i3status/config` |
| Polybar layout | `~/.config/polybar/config.ini` |
| Polybar modules | `~/.config/polybar/modules.ini` |
| Polybar colors (generated) | `~/.config/polybar/colors-polybar.ini` |
| Polybar scripts | `~/.config/polybar/scripts/` |
| Rofi config | `~/.config/rofi/config.rasi` |
| Rofi colors (generated) | `~/.cache/wal/colors-rofi.rasi` |
| Alacritty | `~/.config/alacritty/alacritty.toml` |
| Picom | `~/.config/picom.conf` |
| Systemd timer | `~/.config/systemd/user/wallpaper.timer` |
| wal color templates | `~/.config/wal/templates/` |
| wal color cache | `~/.cache/wal/` (generated, don't edit) |

## i3 Key Details

- `$mod` = Alt; `$super` = Win key (reserved for lock screen)
- `gaps inner 20` — 20px gaps between windows
- `for_window [class=".*"] border pixel 8` — 8px border on all windows
- `set $active_bar polybar` — controls which bar `launch_bar.sh` starts
- Lock screen: `Super+L` → `matrixlock.py` (fullscreen Alacritty running cmatrix + i3lock)

### i3 Keybindings Reference

| Action | Keybinding |
|---|---|
| Focus left/down/up/right | `$mod+j/k/l/;` or `$mod+ArrowKeys` |
| Move window | `$mod+Ctrl+j/k/l/;` or `$mod+Ctrl+ArrowKeys` |
| Resize window | `$mod+Shift+ArrowKeys` (50px increments) |
| Enter resize mode | `$mod+r` |
| Split horizontal / vertical | `Mod1+h` / `Mod1+v` |
| Toggle fullscreen | `$mod+f` |
| Layout: stacked/tabbed/split | `Mod1+s` / `Mod1+w` / `Mod1+e` |
| Toggle floating | `$mod+Shift+Space` |
| Toggle focus tiling/floating | `$mod+Space` |
| Switch to workspace 1–10 | `$mod+1` … `$mod+0` |
| Move window to workspace | `$mod+Shift+1` … `$mod+Shift+0` |

Use `xprop | grep WM_CLASS` to find the window class for `assign` rules in the i3 config.

### Rofi

Fuzzy app launcher and window switcher. Keybindings set in the i3 config:

| Key | Action |
|---|---|
| `$mod+d` | App launcher (`drun` mode) |
| `$mod+Shift+d` | Window switcher (`window` mode) |

Rofi colors come from `~/.cache/wal/colors-rofi.rasi`, generated by wal on every wallpaper change via the template in `~/.config/wal/templates/colors-rofi.rasi`. The accent color is `{color2}` in the template; change it to any `{color0}`–`{color15}` to shift accents.

## Polybar Module Scripts

Custom scripts live in `~/.config/polybar/scripts/` and print one line of output; polybar polls them via `exec =` + `interval =`.

| Module | Script | Data source | Interval |
|---|---|---|---|
| `net-type` | `net_type.sh` | `ip route` | 5s |
| `ip-addr` | `ip_addr.sh` | `ip route` | 5s |
| `cpu-temp` | `cpu_temp.sh` | hwmon (AMD k10temp / Intel coretemp) | 2s |
| `gpu-temp` | `gpu_temp.sh` | `nvidia-smi` or `rocm-smi` | 2s |
| `gpu-load` | `gpu_load.sh` | `nvidia-smi` | 2s |
| `gpu-fan` | `gpu_fan.sh` | `nvidia-smi` or `rocm-smi` | 5s |
| `volume` | `volume.sh` | `pamixer` | event-driven |

Built-in polybar modules also used: `xworkspaces`, `cpu`, `memory`, `filesystem`, `date`.

## wal Color Templates

wal processes every file under `~/.config/wal/templates/` on each palette change. Available variables: `{background}`, `{foreground}`, `{color0}`–`{color15}`. Use `{{` / `}}` for literal braces in output (required for `.rasi` files since Rofi uses `{}` for blocks).

| Template | Output | Purpose |
|---|---|---|
| `colors-polybar.ini` | `~/.cache/wal/colors-polybar.ini` | Named color roles for polybar |
| `colors-rofi.rasi` | `~/.cache/wal/colors-rofi.rasi` | Rofi theme colors |
| `colors-discord.css` | `~/.cache/wal/colors-discord.css` | Vesktop Quick CSS variables |

Swap which `{colorN}` maps to accent roles (`primary`, `secondary`, `border-col`, `--background-accent`) to shift accent colors across all apps without touching their main configs.

## Systemd Timer Notes

After editing `wallpaper.timer` or `wallpaper.service`, reload with:
```bash
systemctl --user daemon-reload && systemctl --user restart wallpaper.timer
```

`KillMode=process` in the service is intentional — prevents systemd from killing polybar (a detached child) when the service exits. `DISPLAY=:1` is hardcoded in the service; verify with `echo $DISPLAY` if the bar fails to restart.

## Fonts

`dots/fonts/` stores icon font files (Feather, Material Icons) and `installed.md` documents which system fonts are installed and which Nerd Fonts are needed for the fancy polybar icon config.

The current polybar config uses `DejaVu Sans Mono` (system default). To enable icon glyphs, install JetBrains Mono Nerd Font and Font Awesome 6 Free, then update `font-0` and `font-1` in `~/.config/polybar/config.ini`. After installing new fonts run `fc-cache -fv`.

## grub-matrix-pill Subproject

Standalone GRUB theme for Windows/Linux dual-boot. Install interactively:
```bash
chmod u+x grub-matrix-pill/universal-installer.sh grub-matrix-pill/build.sh
sudo ./grub-matrix-pill/universal-installer.sh
# or: sudo ./grub-matrix-pill/universal-installer.sh --auto
```

For non-interactive install (e.g. from autoinstall late-commands):
```bash
sudo bash scripts/install-grub-theme.sh 1920x1080 1
# args: <resolution> <scaling>  (scaling: 1=1080p, 1.5=2K, 2=4K)
```
