# Rice Documentation

Ubuntu + i3 desktop rice. Everything is themed from the wallpaper automatically.

---

## How It All Chains Together

```
systemd wallpaper.timer (every 350s)
  └─▶ wallpaper.service
        └─▶ ~/.config/i3/wallpaper.sh
              ├─ feh          → sets wallpaper on screen
              ├─ wal -i       → generates color palette from wallpaper image
              │    ├─ writes ~/.cache/wal/colors-polybar.ini
              │    ├─ writes ~/.cache/wal/colors-alacritty.toml
              │    └─ sends escape sequences → updates all open terminals live
              ├─ cp colors-polybar.ini → ~/.config/polybar/colors-polybar.ini
              └─ launch_bar.sh polybar
                    ├─ kills existing polybar
                    └─ polybar example &   → restarts with new colors loaded
```

On i3 login/reload, two separate things start independently:

- `exec systemctl --user start wallpaper.timer` — arms the timer (runs once at login, timer handles the rest)
- `exec_always launch_bar.sh polybar` — starts polybar fresh on every i3 reload or restart

---

## Components

### i3 — Window Manager
**Config:** `~/.config/i3/config`

Handles window layout, keybindings, workspaces, gaps, and borders. The `$mod` key is `Alt`. `$super` (Win key) is reserved for lock screen to avoid conflicts with Alt-based app shortcuts.

Notable settings:
- `gaps inner 20` — 20px gaps between all windows
- `for_window [class=".*"] border pixel 8` — 8px colored border on every window
- `client.focused` etc. — border/titlebar colors (static, not wal-themed)
- `$active_bar polybar` — selector that controls which bar `launch_bar.sh` starts

### Polybar — Status Bar
**Config:** `~/.config/polybar/config.ini`
**Colors:** `~/.config/polybar/colors-polybar.ini` (generated, do not edit directly)
**Scripts:** `~/.config/polybar/scripts/`

Full-width docked bar at the top. Colors are loaded from `colors-polybar.ini` via `include-file` at the top of the config. The bar restarts whenever the wallpaper changes so it picks up the new palette.

**Left side modules:**
| Module | Type | Description |
|---|---|---|
| `xworkspaces` | internal/xworkspaces | Live workspace list from i3 via IPC |

**Right side modules:**
| Module | Script | Updates |
|---|---|---|
| `net-type` | `net_type.sh` | ETH/WIFI + interface name, every 5s |
| `ip-addr` | `ip_addr.sh` | Current local IP, every 5s |
| `cpu-temp` | `cpu_temp.sh` | CPU temp from hwmon (AMD k10temp or Intel coretemp), every 2s |
| `cpu` | internal/cpu | CPU usage %, every 1s |
| `gpu-temp` | `gpu_temp.sh` | GPU temp via nvidia-smi or rocm-smi, every 2s |
| `gpu-load` | `gpu_load.sh` | GPU utilization %, every 2s |
| `gpu-fan` | `gpu_fan.sh` | GPU fan speed %, every 5s |
| `memory` | internal/memory | RAM usage %, every 2s |
| `filesystem` | internal/fs | Root disk usage %, every 30s |
| `volume` | `volume.sh` | Volume % or mute state via pamixer, event-driven |
| `date` | internal/date | Time (HH:MM), click for full date, every 1s |

### pywal — Color Engine
**Tool:** `wal` (pywal16, installed via pipx)
**Templates:** `~/.config/wal/templates/`

pywal reads a wallpaper image, extracts a 16-color palette, and writes it to multiple output formats simultaneously. The template files in `~/.config/wal/templates/` define the output format for each app. The generated files land in `~/.cache/wal/`.

What gets themed automatically on every wallpaper change:
- **Polybar** — via `colors-polybar.ini` (copied from cache, then polybar restarts)
- **Alacritty** — via `~/.cache/wal/colors-alacritty.toml` (imported at terminal launch)
- **Open terminals** — live, via escape sequences sent directly to each terminal's pty

### Alacritty — Terminal
**Config:** `~/.config/alacritty/alacritty.toml`

The only relevant line is:
```toml
import = ["~/.cache/wal/colors-alacritty.toml"]
```
Every new terminal window reads this file at launch, so it always opens with the current wallpaper's palette. Open windows get updated live via wal's escape sequences when the wallpaper changes.

### feh — Wallpaper Setter
Sets the wallpaper with `--bg-fill` (fills the screen, crops to fit without stretching). The chosen wallpaper path is written to `~/.config/i3/current-wallpaper` so other scripts can reference it. Wallpapers are pulled from `~/Pictures/wallpapers/` at random.

### Systemd Timer — Wallpaper Rotation
**Files:** `~/.config/systemd/user/wallpaper.timer` + `wallpaper.service`

Replaces a bash sleep loop. The timer fires `wallpaper.service` 5 seconds after boot, then every 350 seconds. `KillMode=process` in the service is critical — it tells systemd to only kill the shell script when the service exits, leaving polybar (which was spawned as a background child) running.

### launch_bar.sh — Bar Switcher
**File:** `~/.config/i3/launch_bar.sh`

Called by both i3 (`exec_always`) and `wallpaper.sh`. Kills any existing polybar, waits for it to fully exit, auto-detects the primary monitor via `xrandr`, exports `$MONITOR`, then starts `polybar example` in the background.

### Picom — Compositor
**Config:** `~/.config/picom.conf`

Handles transparency, shadows, and vsync to eliminate screen tearing. Runs with `exec_always` in i3.

### matrixlock — Lock Screen
**File:** `~/.config/i3/matrixlock.py`

Triggered by `Super+L`. Opens a fullscreen Alacritty window running `cmatrix`, then locks with i3lock underneath. The i3 rule `for_window [class="matrixlock"] fullscreen enable, border none` enforces fullscreen and hides the border.

---

## What Updates Automatically vs. What Doesn't

| Thing | How it updates |
|---|---|
| Wallpaper | Every 350s (systemd timer) |
| Polybar colors | Every wallpaper change (bar restarts) |
| Open terminal colors | Every wallpaper change (wal escape sequences) |
| New terminal colors | Every new terminal launch (reads cache file) |
| Workspace indicators | Live via i3 IPC |
| CPU/GPU/network stats | Polled every 1–5s by polybar |
| i3 border colors | Static — hardcoded in i3 config, not wal-themed |

---

## What's Customizable

### Change the wallpaper rotation interval
`~/.config/systemd/user/wallpaper.timer` → `OnUnitActiveSec=350`

After editing: `systemctl --user daemon-reload`

### Change the wallpaper directory
`~/.config/i3/wallpaper.sh` → `find ~/Pictures/wallpapers/ ...`

### Add or remove bar modules
`~/.config/polybar/config.ini` → `modules-left` and `modules-right` lines in `[bar/example]`

### Change bar height, font, padding
`~/.config/polybar/config.ini` → `height`, `font-0`, `padding-left/right`, `module-margin`

### Change which bar is active (polybar vs i3status vs i3blocks)
`~/.config/i3/config` → `set $active_bar polybar`

### Change window gaps
`~/.config/i3/config` → `gaps inner 20`

### Change window border width or color
`~/.config/i3/config` → `for_window [class=".*"] border pixel 8` and `client.focused` etc.

### Change wallpaper scaling mode
`~/.config/i3/wallpaper.sh` → replace `--bg-fill` with another feh flag:
- `--bg-fill` — fill, crop to fit (current)
- `--bg-max` — scale up to fit, no crop, may leave bars
- `--bg-center` — centered, no scaling
- `--bg-tile` — tile the image

### Add a new polybar script module
1. Create a script in `~/.config/polybar/scripts/` that prints one line of output
2. Add a module block to `config.ini`:
   ```ini
   [module/my-module]
   type = custom/script
   exec = ~/.config/polybar/scripts/my-script.sh
   interval = 5
   label = %output%
   ```
3. Add `my-module` to the `modules-left` or `modules-right` line

### Change the color template
`~/.config/wal/templates/colors-polybar.ini` — maps wal palette variables (`{color0}`–`{color15}`, `{background}`, `{foreground}`) to the color names polybar's config references. Change which palette index maps to `primary`, `secondary`, etc. to shift the theme accent color.

---

## File Map

```
~/.config/i3/
  config                    i3 window manager config
  wallpaper.sh              one-shot: pick wallpaper → run wal → restart bar
  launch_bar.sh             kills + restarts polybar (or i3bar)
  current-wallpaper         last chosen wallpaper path (written by wallpaper.sh)
  matrixlock.py             matrix lock screen script

~/.config/polybar/
  config.ini                bar layout, modules, fonts
  colors-polybar.ini        generated by wal — do not edit directly
  scripts/
    net_type.sh             ETH or WIFI + interface info
    ip_addr.sh              local IP address
    cpu_temp.sh             CPU temperature (AMD/Intel hwmon)
    gpu_temp.sh             GPU temperature (NVIDIA/AMD)
    gpu_load.sh             GPU utilization %
    gpu_fan.sh              GPU fan speed %
    volume.sh               volume % or mute state

~/.config/alacritty/
  alacritty.toml            imports wal color cache file

~/.config/wal/templates/
  colors-polybar.ini        wal template → defines polybar color format
  colors-alacritty.toml    wal template → defines alacritty color format

~/.config/systemd/user/
  wallpaper.timer           fires every 350s
  wallpaper.service         runs wallpaper.sh as a one-shot unit

~/.config/picom.conf        compositor settings

~/.cache/wal/               generated by wal — do not edit, rebuilt on each wallpaper change
  colors-polybar.ini
  colors-alacritty.toml
  (+ other format outputs)
```

---

## Startup Sequence (Cold Boot)

1. X session starts, i3 launches
2. i3 reads config → fires all `exec` and `exec_always` lines
3. `launch_bar.sh polybar` starts polybar with whatever colors are currently in `colors-polybar.ini` (last run's palette)
4. `systemctl --user start wallpaper.timer` arms the timer
5. 5 seconds later: `wallpaper.service` fires, picks a new wallpaper, runs wal, copies new colors, restarts polybar with the new palette
6. From that point: timer fires every 350 seconds, repeating step 5
