# Fonts

## Currently Installed (system)

Monospace (good for bars/terminals):
- DejaVu Sans Mono
- Liberation Mono
- Noto Mono
- Noto Sans Mono
- Ubuntu Mono
- Ubuntu Sans Mono

Sans-serif:
- DejaVu Sans
- Liberation Sans
- Noto Sans
- Ubuntu
- Ubuntu Sans

Serif:
- DejaVu Serif
- Liberation Serif
- Noto Serif

Emoji/Symbols:
- Noto Color Emoji
- Noto Sans Symbols
- Noto Sans Symbols2
- OpenSymbol

## Not Installed — Needed for Fancy Polybar Icons

The fancy polybar config (config.ini.fancy) was written for these fonts.
Without them, no icons show — only text labels.

### JetBrains Mono Nerd Font (used in config as font-0)
Provides: programming ligatures + all Nerd Font icons (,  , , etc.)
Install: https://www.nerdfonts.com/font-downloads
  or: `curl -fLo ~/.local/share/fonts/JetBrainsMono.zip \
        https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip \
        && unzip ~/.local/share/fonts/JetBrainsMono.zip -d ~/.local/share/fonts/ \
        && fc-cache -fv`

### Font Awesome 6 Free (used in config as font-1)
Provides: web/UI icons (, , , , etc.)
Install: https://fontawesome.com/download (Free version)
  or via package: `sudo apt install fonts-font-awesome`

## After Installing New Fonts

Run `fc-cache -fv` to refresh the font cache.
Then in polybar config swap:
  font-0 = "DejaVu Sans Mono:size=9;2"
to:
  font-0 = "JetBrainsMono Nerd Font:style=Bold:size=9;2"
  font-1 = "Font Awesome 6 Free:style=Solid:size=10;2"
