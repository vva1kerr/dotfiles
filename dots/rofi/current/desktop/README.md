# Rofi .desktop Entries

These `.desktop` files expose AppImages in `~/Applications/` to rofi's `drun` launcher. `update-dots.sh` copies them to `~/.local/share/applications/`, which is the standard XDG path rofi searches by default.

## Adding a new app

Create a new `.desktop` file here:

```ini
[Desktop Entry]
Type=Application
Name=My App
Comment=What it does
Exec=/home/foobar/Applications/MyApp.AppImage
Icon=icon-name
Categories=Utility;
```

Then deploy:

```bash
cd scripts && bash update-dots.sh
```

## Electron AppImages and sandboxing

Most of these apps (Obsidian, LM Studio, Heroic, balenaEtcher, Upscayl) are Electron-based. Electron uses Chromium's process sandbox, which on Ubuntu 24.04 requires unprivileged user namespaces — a kernel feature Ubuntu restricts by default.

`update-dots.sh` writes `/etc/sysctl.d/99-userns.conf` to re-enable this:

```
kernel.apparmor_restrict_unprivileged_userns = 0
```

This lets Electron build its sandbox normally. Without it, Electron either crashes with a SUID sandbox error or requires `--no-sandbox` in the `Exec=` line, which disables the sandbox entirely and is worse from a security standpoint.

The sysctl file loads last (99-prefix) so it wins over Ubuntu's default restriction set at boot.

## AppImage permissions

All AppImages in `~/Applications/` must be executable:

```bash
chmod +x ~/Applications/*.AppImage
```

## Current entries

| File | App | Notes |
|---|---|---|
| `balena-etcher.desktop` | balenaEtcher 1.7.9 | USB/SD flash tool, ia32 |
| `heroic.desktop` | Heroic Games Launcher 2.20.1 | Epic + GOG |
| `lm-studio.desktop` | LM Studio 0.4.11 | Local LLM runner |
| `obsidian.desktop` | Obsidian 1.12.7 | Note-taking (also installed as flatpak — two rofi entries is normal) |
| `openshot-3.4.desktop` | OpenShot 3.4.0 | Video editor, older version |
| `openshot-3.5.desktop` | OpenShot 3.5.1 | Video editor, current version |
| `upscayl.desktop` | Upscayl 2.15.0 | AI image upscaler |
