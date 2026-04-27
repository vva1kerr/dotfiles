● The colors are not hardcoded — they come from wal's palette which changes with each
  wallpaper. The issue is Vesktop only reads quickCss.css at startup, so it won't
  automatically reflect a wallpaper change while it's running.

  The chain currently works like this:

  wallpaper changes → wal generates new palette → quickCss.css updated
                                                        ↓
                                                Vesktop needs restart
                                                to pick up new CSS

  Two options:

  Option A — manual restart (simplest): after a wallpaper change, pkill -f vesktop &&
  flatpak run dev.vencord.Vesktop &

  Option B — auto-restart in wallpaper.sh (fully automatic but disruptive if you're
  mid-conversation):

  # restart Vesktop if it's running so it picks up the new palette
  if pgrep -f vesktop > /dev/null; then
      pkill -f vesktop
      sleep 1
      flatpak run dev.vencord.Vesktop &>/dev/null &
  fi

  Want me to add Option B to wallpaper.sh? The tradeoff is Vesktop briefly closes and
  reopens every 350 seconds when the wallpaper rotates.





● --scale=bilinear and --cscale=bilinear swap the luma/chroma scalers from lanczos to bilinear — indistinguishable on a background, measurably cheaper. --dither=no skips dithering on output, which is also  
  invisible at wallpaper viewing distance.                                                                                                                                                                    

  Priority order for reducing load:                                                                                                                                                                           
  1. Re-encode to 24fps (ffmpeg -i input.mp4 -r 24 output.mp4)
  2. Use MP4, never GIF                                                                                                                                                                                       
  3. Encode at native screen resolution                                                                                                                                                                     
  4. The bilinear scaling flags above    












● Good. Now to answer your GTK_THEME question directly — you won't need to set it manually.
   Here's what the full chain now does:

  How GTK theming actually works after these fixes:

  1. wpg -a <wallpaper> — generates a GTK2/3 theme from the wal palette and stores it in
  ~/.themes/
  2. wpg --restore — writes the theme name into ~/.config/xsettingsd/xsettingsd.conf and
  sets it via gsettings
  3. xsettingsd (running since i3 login) — sees that change and broadcasts it to all
  running GTK3 apps in real time, so they repaint without restarting

  GTK_THEME as an env var is a fallback for apps that don't read from xsettingsd — you'd
  only need it if something still doesn't update after this chain is working.

  To test it after installing xsettingsd:
  cd scripts && bash update-dots.sh
  bash ~/.config/i3/wallpaper.sh

  Then open Thunar or any GTK3 app and watch it repaint.

  Broader machine theming — what's next:

  ┌───────────────────────────────────┬─────────────────────────────────┬────────┐
  │              Target               │             Method              │ Effort │
  ├───────────────────────────────────┼─────────────────────────────────┼────────┤
  │ GTK3 apps (Thunar, dialogs, etc.) │ wpgtk + xsettingsd (just fixed) │ Done   │
  ├───────────────────────────────────┼─────────────────────────────────┼────────┤
  │ Dunst notifications               │ wal template                    │ Easy   │
  ├───────────────────────────────────┼─────────────────────────────────┼────────┤
  │ Rofi launcher                     │ wal template                    │ Easy   │
  ├───────────────────────────────────┼─────────────────────────────────┼────────┤
  │ i3 window borders                 │ wal template + i3-msg reload    │ Easy   │
  ├───────────────────────────────────┼─────────────────────────────────┼────────┤
  │ Firefox                           │ pywalfox extension              │ Medium │
  ├───────────────────────────────────┼─────────────────────────────────┼────────┤
  │ Qt apps                           │ qt5ct + kvantum                 │ Medium │
  ├───────────────────────────────────┼─────────────────────────────────┼────────┤
  │ GTK4 / libadwaita (Nautilus)      │ Partially, no clean solution    │ Hard   │
  ├───────────────────────────────────┼─────────────────────────────────┼────────┤
  │ Electron apps (Obsidian, Vesktop) │ App-specific approaches         │ Varies │
  └───────────────────────────────────┴─────────────────────────────────┴────────┘



  ffvii-cloud-mako-reactor-1.jpg  pixel-koi-pond.1920x1080.mp4
foobar@3090:~/Pictures/wallpapers$ systemctl --user restart wallpaper.service
foobar@3090:~/Pictures/wallpapers$ pipx install pywalfox
  installed package pywalfox 2.7.4, installed using Python 3.12.3
  These apps are now globally available
    - pywalfox
done! ✨ 🌟 ✨
foobar@3090:~/Pictures/wallpapers$ pywalfox install
Copied manifest to: /home/foobar/.mozilla/native-messaging-hosts/pywalfox.json
Set daemon executable path to: /home/foobar/.local/share/pipx/venvs/pywalfox/lib/python3.12/site-packages/pywalfox/bin/main.sh
Set execute permissions on daemon executable
foobar@3090:~/Pictures/wallpapers$













❯ how do i disable this machine from falling asleep

● On Linux, you can disable sleep with systemctl:

  sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

  To re-enable later:

  sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target

  Alternatively, if you just want to prevent sleep while on AC power via a config file,
  edit /etc/systemd/logind.conf and set:

  HandleLidSwitch=ignore
  HandleSuspendKey=ignore
  IdleAction=ignore

  Then sudo systemctl restart systemd-logind.

  The systemctl mask approach is the quickest one-liner if you want it disabled now.

● For disabling sleep, you only need to care about these lines:

  HandleSuspendKey=ignore
  HandleLidSwitch=ignore
  HandleLidSwitchExternalPower=ignore
  IdleAction=ignore

  - HandleSuspendKey — what happens when you press the sleep key
  - HandleLidSwitch — what happens when you close the lid (on battery)
  - HandleLidSwitchExternalPower — same, but when plugged in
  - IdleAction — what happens after idle timeout (already ignore by default, so you can
  skip this one)

  The rest (HandlePowerKey, HandleHibernateKey, etc.) are for different hardware buttons
  and don't affect automatic sleep.

  After editing, run sudo systemctl restart systemd-logind.


● ~/.config/systemd/user/ is for user-level systemd units (services, timers) — not for
  logind.conf. That won't work here since logind runs as root.

  The cleanest approach for dotfiles is a drop-in file instead of replacing the main
  config:

  Create /etc/systemd/logind.conf.d/nosleep.conf with only your overrides:

  [Login]
  HandleSuspendKey=ignore
  HandleLidSwitch=ignore
  HandleLidSwitchExternalPower=ignore

  This is better than copying the full file because:
  - The original /etc/systemd/logind.conf stays untouched (and gets package updates)
  - Your dotfiles only track the small override file
  - Drop-ins are the officially recommended way per the file's own comments

  For your dotfiles repo, store it at something like
  dots/logind/current/etc/systemd/logind.conf.d/nosleep.conf and symlink or copy it into
  place with your install script (with sudo).

❯ logind.conf.d does not exist whats a drop file?

● A drop-in is just a config file that systemd automatically merges with the main config —
  you don't touch the original, you just add a small file with your overrides.

  Create the directory and file:

  sudo mkdir -p /etc/systemd/logind.conf.d
  sudo nano /etc/systemd/logind.conf.d/nosleep.conf

  Put this in it:

  [Login]
  HandleSuspendKey=ignore
  HandleLidSwitch=ignore
  HandleLidSwitchExternalPower=ignore

  Then restart logind:

  sudo systemctl restart systemd-logind

  That's it. systemd scans that .d directory automatically and merges any .conf files it
  finds there on top of the main config. You made the directory yourself — it doesn't need
  to pre-exist.








❯ how can i add my ~/Applications/ to the rofi search?                                                                                                                                               

● Let me check the current rofi config.

  Read 1 file (ctrl+o to expand)

● Rofi's drun mode searches XDG data dirs for .desktop files. The cleanest way to add ~/Applications/ is to set the drun-directories option in the config:

● Update(dots/rofi/current/config.rasi)
  ⎿  Added 1 line
      2      modi:                "drun,window,run";
      3      show-icons:          true;
      4      drun-display-format: "{name}";                                                                                                                                                          
      5 +    drun-directories:    "/usr/share/applications,/usr/local/share/applications,~/.local/share/applications,~/Applications";                                                         
      6      font:                "DejaVu Sans Mono 11";                                                                                                                                             
      7  }                                                                                                                                                                                         
      8  

● drun-directories overrides rofi's default search list entirely, so the standard paths are included explicitly alongside ~/Applications.

  For this to work, the apps in ~/Applications/ need .desktop files. If they're AppImages or raw binaries without .desktop files, drun won't find them — you'd need to create a .desktop file for    
  each one and place it in ~/Applications/ (or ~/.local/share/applications/).
                                                                                                                                                                                                     
  Deploy the updated config with:                                                                                                                                                                  
  cd scripts && bash update-dots.sh

  ? for shortcuts
● .desktop file — a plain text file that tells the desktop environment (and rofi) how to launch an app. Example:

  [Desktop Entry]
  Type=Application
  Name=MyApp
  Exec=/home/foobar/Applications/myapp.AppImage
  Icon=myapp
  Categories=Utility;

  Rofi's drun mode reads these to build its app list — it doesn't scan for raw executables, only .desktop files.

  ---
  ~/Applications/ vs ~/.local/share/applications/

  ┌─────────────────────────────┬──────────────────────────────────────────────────────────────┬──────────────────────────────────────────────┐
  │                             │                       ~/Applications/                        │         ~/.local/share/applications/         │
  ├─────────────────────────────┼──────────────────────────────────────────────────────────────┼──────────────────────────────────────────────┤
  │ Standard?                   │ No — unofficial convention (used by some AppImage launchers) │ Yes — XDG standard, recognized by everything │
  ├─────────────────────────────┼──────────────────────────────────────────────────────────────┼──────────────────────────────────────────────┤
  │ Rofi default search?        │ No                                                           │ Yes                                          │
  ├─────────────────────────────┼──────────────────────────────────────────────────────────────┼──────────────────────────────────────────────┤
  │ .desktop files or binaries? │ Both, depending on the tool                                  │ .desktop files only                          │
  ├─────────────────────────────┼──────────────────────────────────────────────────────────────┼──────────────────────────────────────────────┤
  │ What reads it?              │ Only tools you explicitly configure                          │ Rofi, GNOME, KDE, xdg-open, etc.             │
  └─────────────────────────────┴──────────────────────────────────────────────────────────────┴──────────────────────────────────────────────┘

  Practical recommendation: put the .desktop files in ~/.local/share/applications/ and keep the actual AppImage binaries wherever you want (e.g. ~/Applications/). The .desktop file just points to
  the binary via Exec=.

  That way rofi finds them with zero extra config (you can revert my change), and everything else on the system does too.