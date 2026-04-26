# i3 Workspace Layouts

Saved workspace layouts for i3's `append_layout` system. Each JSON file defines the split
structure and window positions for a workspace, which i3 recreates on boot before apps launch.

## How it works

```
i3 config (on login)
  └─ i3-msg 'workspace 1; append_layout workspace-1.json'
       └─ i3 creates placeholder slots matching the layout
            └─ apps launch and fill slots by matching swallowing rules
                 └─ workspace snaps into the saved arrangement
```

The key is order: `append_layout` must run before the apps open. A `sleep 0.5` on each
app exec gives the placeholders time to register first.

## Swallowing rules

Each leaf node in the JSON has a `swallows` block that tells i3 which window fills that slot.
We match on `instance` (the second field of `WM_CLASS`) to differentiate multiple windows from
the same app (e.g. three Alacritty terminals each with a different role).

Alacritty sets the instance via `--class General,Instance`:
```bash
alacritty --class Alacritty,htop-monitor -e htop
#                            ^^^^^^^^^^^
#                            matched by "instance": "^htop-monitor$"
```

To find any window's class and instance:
```bash
xprop | grep WM_CLASS
# click the window — prints: WM_CLASS(STRING) = "instance", "class"
```

## Workspace 1 — monitors + terminal

**Layout:**
```
┌───────────────┬───────────────┐
│     htop      │     nvtop     │
│  (top-left)   │  (top-right)  │
├───────────────┴───────────────┤
│         ws1-terminal          │
│           (bottom)            │
└───────────────────────────────┘
```

**Apps and their instance names:**

| Slot | App | Instance | Launch command |
|---|---|---|---|
| Top-left | htop | `htop-monitor` | `alacritty --class Alacritty,htop-monitor -e htop` |
| Top-right | nvtop | `nvtop-monitor` | `alacritty --class Alacritty,nvtop-monitor -e nvtop` |
| Bottom | terminal | `ws1-terminal` | `alacritty --class Alacritty,ws1-terminal` |

**i3 config wiring (in dots/i3/current/config):**
```
exec --no-startup-id i3-msg 'workspace 1; append_layout ~/.config/i3/workspaces/workspace-1.json'
exec --no-startup-id sleep 0.5 && alacritty --class Alacritty,htop-monitor -e htop
exec --no-startup-id sleep 0.5 && alacritty --class Alacritty,nvtop-monitor -e nvtop
exec --no-startup-id sleep 0.5 && alacritty --class Alacritty,ws1-terminal
```

## Adding a new workspace layout

1. Arrange the workspace windows exactly how you want them
2. Save the layout:
   ```bash
   i3-save-tree --workspace 2 > ~/dotfiles/dots/i3/current/workspaces/workspace-2.json
   ```
3. Edit the JSON — uncomment and fill in the `swallows` block for each leaf node:
   ```json
   "swallows": [
       {
       // "class": "^Alacritty$",   <- original commented-out lines, keep for reference
       "instance": "^my-instance$"  <- the line that actually does the matching
       }
   ]
   ```
4. Add the `append_layout` exec and app execs to the i3 config
5. Add `assign` rules if needed (fallback placement if layout isn't loaded)
6. Run `update-dots.sh` to sync, then `mod+shift+r` to reload i3

## Troubleshooting

**Windows open but don't land in their slots** — increase the sleep delay from `0.5` to `1`:
```
exec --no-startup-id sleep 1 && alacritty --class Alacritty,ws1-terminal
```

**Wrong window fills wrong slot** — check instance names match exactly. Run
`xprop | grep WM_CLASS` on a running window to confirm the instance string.

**Layout loads but looks wrong** — re-capture with `i3-save-tree` after re-arranging,
then redo the swallowing edits.
