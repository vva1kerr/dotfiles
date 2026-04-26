# Firefox — Pywalfox Setup

Themes Firefox automatically from the wallpaper palette via the Pywalfox extension + native messenger.

## How it works

```
wallpaper.sh
  └─ wal -i <wallpaper>         generates new palette in ~/.cache/wal/
       └─ pywalfox update       reads palette, sends it to Firefox via native messaging
            └─ Pywalfox extension applies colors to the Firefox UI
```

Firefox theming runs as part of every wallpaper change — no manual steps needed after setup.

## Files

| File | Where it lives on the system | Purpose |
|---|---|---|
| `pywalfox.json` | `~/.mozilla/native-messaging-hosts/pywalfox.json` | Tells Firefox where to find the daemon executable |
| `main.sh` | `~/.local/share/pipx/venvs/pywalfox/lib/python3.12/site-packages/pywalfox/bin/main.sh` | The daemon Firefox spawns; patched to use the pipx venv Python |

## Fresh system install

```bash
pipx install pywalfox
pywalfox install          # writes pywalfox.json to ~/.mozilla/native-messaging-hosts/

# Patch main.sh — the original uses system python3 which can't find pywalfox in the pipx venv
cp dots/firefox/current/main.sh \
   ~/.local/share/pipx/venvs/pywalfox/lib/python3.12/site-packages/pywalfox/bin/main.sh
```

Then install the **Pywalfox** extension from the Firefox Add-ons store and restart Firefox.

> **After every `pipx upgrade pywalfox`** — re-apply the main.sh patch, since pipx overwrites it.

## Why main.sh needs patching

The original `main.sh` calls bare `python3 -m pywalfox start`. When pywalfox is installed via
pipx it lives in an isolated venv, so the system `python3` has no idea it exists and the daemon
fails to start. The fix points directly at the venv's Python interpreter.

If the Python version ever changes (e.g. Ubuntu upgrade), update the path in `main.sh` to match:

```bash
find ~/.local/share/pipx/venvs/pywalfox -name "main.sh"
```

## Wiring in wallpaper.sh

`pywalfox update` is called in `wallpaper.sh` after every `wal` run:

```bash
pywalfox update 2>/dev/null || true
```

The `|| true` means the wallpaper script won't fail if pywalfox isn't installed on a fresh system.

## Customizing colors

Pywalfox uses wal's palette directly — no template file. To shift which palette colors map to
which Firefox UI zones, use the extension's settings panel in Firefox (`about:addons` → Pywalfox → Preferences).
