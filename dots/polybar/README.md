# master layout
left (left to right)
show workspaces that have apps on them

right (left to right)
datetime ss-mm-hh dd-mm-yy
wifi eth or wireless dynamic check
ipaddress
cpu temp
cpu load
gpu temp
gpu load
gpu fan speed
ram usage
disk space used







● Created ~/dotfiles/dots/polybar/config.ini.fancy with full annotations. Here's a summary of what creates the fancy look — it's really 3 things working together:

  1. Multiple floating bars instead of one
  The config defines four separate bars ([bar/left], [bar/music], [bar/center], [bar/right]), each narrow and independently positioned. The gaps between them let the wallpaper/desktop show
   through.

  2. The three properties that make bars float and look different
  override-redirect = true   ; tells i3 to ignore the bar — it becomes a floating overlay
  radius = 8                 ; rounded corners (only visible because of override-redirect)
  offset-x = 1%             ; positions the floating bar on screen
  offset-y = 10
  border-size = 3px          ; colored outline around each bar
  border-color = ${colors.border}
  Without override-redirect = true, radius does nothing — the WM would stretch it edge-to-edge.

  3. The [module/lb] and [module/rb] bracket modules
  These are just custom/text modules that print [ and ] in your accent color. When you add them around other modules in the modules-* line like lb cpu sep memory rb, you get [ CPU 12%  |
  RAM 34% ] with colored brackets.

  To actually use it, you'll also need to update ~/.config/i3/launch_bar.sh to launch all four bars instead of polybar mainbar-poly. Want me to do that?


# pipewire cpu fix (2026-04-25)

The `[module/volume]` in both `config.ini` and `modules.ini` uses a custom script
(`volume.sh`) that calls `pamixer --get-volume` and `pamixer --get-mute`.

`pamixer` talks to PipeWire through the PulseAudio compatibility layer — every
invocation opens a new connection, queries the volume, then disconnects. With
`interval = 0` (polybar's "run in a tight loop" mode), this was happening
hundreds of times per second and keeping `pipewire-pulse` at ~10% CPU
permanently.

Fix: changed `interval = 0` to `interval = 1` in both files.

A related fix also lives in `update-dots.sh`: Vesktop (Flatpak) hardcodes
`--enable-speech-dispatcher` in its launch script, which causes
`speech-dispatcher` to open a persistent audio stream into PipeWire even when
nothing is speaking. That stream (even when paused/corked) forces PipeWire's
graph to keep cycling. `update-dots.sh` now masks both
`speech-dispatcher.service` and `speech-dispatcher.socket` on install, which
permanently prevents the daemon from starting. Vesktop works fine without it
unless you use a screen reader.

# setup notes
* mkdir -p ~/.local/share/fonts && curl -fLo ~/.local/share/fonts/JetBrainsMono.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip && unzip -o ~/.local/share/fonts/JetBrainsMono.zip -d ~/.local/share/fonts/ && fc-cache -fv
* fc-list | grep -i jetbrains