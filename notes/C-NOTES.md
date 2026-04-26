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