# Rofi

Fuzzy app launcher and window switcher, themed automatically from the wallpaper via pywal.

## Keybindings (set in i3 config)

| Key | Action |
|---|---|
| `mod+d` | App launcher (`drun` mode) |
| `mod+shift+d` | Window switcher (`window` mode) |

## How the theme chain works

```
wallpaper.sh
  └─ wal -i <wallpaper>
       └─ reads ~/.config/wal/templates/colors-rofi.rasi   <- the template
            └─ writes ~/.cache/wal/colors-rofi.rasi         <- hex values filled in
                 └─ rofi reads this on every launch via @theme in config.rasi
```

Every wallpaper change automatically produces a new rofi theme — no manual steps needed.

## Files

| File | Purpose |
|---|---|
| `config.rasi` | Rofi config — sets mode list, icons, font, and points `@theme` at the wal cache file |
| `colors-rofi.rasi` | wal template — installed to `~/.config/wal/templates/colors-rofi.rasi` by `update-dots.sh` |

## Editing the theme

Edit `colors-rofi.rasi` in this folder. wal template syntax:

- `{background}`, `{foreground}`, `{color0}` ... `{color15}` — replaced with hex values from the current palette
- `{{` / `}}` — escaped braces, become literal `{` / `}` in the output (required since rasi uses `{}` for blocks)

After editing, run from the `scripts/` directory:

```bash
bash update-dots.sh   # copies template to ~/.config/wal/templates/
wal -R                # regenerates ~/.cache/wal/colors-rofi.rasi from current palette
```

Then open rofi to see the result. The next wallpaper change will also pick up the new template automatically.

## Swapping accent colors

The accent color (`border-col`, `selected-bg`) is mapped to `{color2}` in the template. To shift which palette color is used as the accent, change `{color2}` to any `{color0}` through `{color15}` and regenerate with `wal -R`.
