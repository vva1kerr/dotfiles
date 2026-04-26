# Discord — Vesktop + Pywal Theming

Themes Discord automatically from the wallpaper palette by writing a generated CSS file
directly into Vesktop's Quick CSS config on every wallpaper change.

## How it works

```
wallpaper.sh
  └─ wal -i <wallpaper>             generates palette in ~/.cache/wal/
       └─ colors-discord.css        wal processes the template, outputs the CSS
            └─ wallpaper.sh copies  ~/.cache/wal/colors-discord.css
                 └─ into            ~/.var/app/.../vesktop/settings/quickCss.css
                      └─ wallpaper.sh restarts Vesktop so it picks up the new CSS
```

Vesktop only reads quickCss.css at startup — it does not watch the file for changes.
wallpaper.sh handles this by killing and relaunching Vesktop automatically after each
palette update, so Discord always matches the current wallpaper.

## Files

| File | Purpose |
|---|---|
| `colors-discord.css` | wal template — installed to `~/.config/wal/templates/` by `update-dots.sh` |

## What gets themed

The CSS targets both legacy Discord and the newer visual refresh UI by covering both
sets of CSS variable names, plus direct element selectors as a fallback.

### Visual refresh variables (current Discord)

| Variable | Role | wal color |
|---|---|---|
| `--background-base-low` | Main chat area | `{background}` |
| `--background-base-lower` | Secondary backgrounds | `{color0}` |
| `--background-base-lowest` | Deepest background | `{color0}` |
| `--chat-background-default` | Chat background | `{background}` |
| `--input-background` | Message input box | `{color8}` |
| `--bg-surface-overlay` | Overlays, dropdowns | `{color0}` |

### Legacy variables (older Discord)

| Variable | Role | wal color |
|---|---|---|
| `--background-primary` | Main chat area | `{background}` |
| `--background-secondary` | Channel/DM sidebar | `{color0}` |
| `--background-tertiary` | Server list | `{color0}` |
| `--background-floating` | Dropdowns, context menus | `{color0}` |
| `--channeltextarea-background` | Message input box | `{color8}` |
| `--background-accent` | Accent / online dot | `{color2}` |

### Text & interactive (both versions)

| Variable | Role | wal color |
|---|---|---|
| `--text-normal` / `--text-default` | Regular text | `{foreground}` |
| `--text-muted` | Muted/secondary text | `{color7}` |
| `--text-link` | Link color | `{color4}` |
| `--interactive-normal` | Icons, buttons | `{color7}` |
| `--interactive-active` | Active/selected state | `{foreground}` |
| `--scrollbar-*` | Scrollbars | `{color8}` / `{color0}` |

### Direct element targeting (visual refresh fallback)

```css
.visual-refresh nav[class*="guilds"]  → server list background
.visual-refresh div[class*="sidebar"] → channel sidebar background
```

## Tweaking accent colors

Swap which `{colorN}` maps to `--background-accent` and `--text-link` in
`colors-discord.css` to shift the accent. After editing run:

```bash
cd scripts && bash update-dots.sh
wal -R
# then restart Vesktop to see the change
pkill -f vesktop && flatpak run dev.vencord.Vesktop &
```

## Fresh system install

```bash
# 1. Install Vesktop
flatpak install flathub dev.vencord.Vesktop

# 2. Launch it once so the config directory is created, then close it

# 3. Run update-dots to install the wal template
cd scripts && bash update-dots.sh

# 4. Trigger a wallpaper change — generates CSS, copies it, and restarts Vesktop
bash ~/.config/i3/wallpaper.sh
```

## Requirements

- Vesktop installed via Flatpak (`dev.vencord.Vesktop`)
- Vesktop launched at least once (creates the settings directory)
- No additional Vesktop plugins needed — Quick CSS is built into Vesktop
- wallpaper.sh handles CSS copy + Vesktop restart automatically on every wallpaper change
