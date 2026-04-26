

![rice-preview](rice-preview/first-rice-800.gif)

# setup manually
* `cd ~`
* git clone ...
* `sudo apt install i3`
* `cp -r ~/dotfiles/dotfiles/i3/* ~/.config/i3/`
* `sudo apt install alacritty`
* `mkdir -p ~/.config/alacritty`
* `touch ~/.config/alacritty/alacritty.toml`
* `cp -r ~/dotfiles/dotfiles/alacritty/* ~/.config/alacritty`
* `cp -r ~/dotfiles/dotfiles/wallpapers/ ~/Pictures/`
* `sudo apt install feh`
* `feh --bg-fill "$(find ~/Pictures/wallpapers/ -type f | shuf -n1)"` or `~/.config/i3/wallpaper.sh &`
* `sudo apt install picom`
* `touch ~/.config/picom.conf`
* `cat ~/dotfiles/dotfiles/picom.conf ~/.config/picom.conf`
* `sudo apt install polybar`
* `sudo apt install pamixer`
* `sudo apt install cmatrix`

* `mkdir ~/.local/share/fonts`
* `sudo apt install pipx && pipx install pywal`
* `pipx ensurepath`

# ubuntu install config paths
* https://www.youtube.com/watch?v=DtXZ6BMaKbA
```bash
foobar@3090:/var/log/installer$ ls
autoinstall-user-data  media-info
block                  subiquity-server-debug.log
casper-md5check.json   subiquity-server-debug.log.2677
cloud-init.log         subiquity-server-info.log
cloud-init-output.log  subiquity-server-info.log.2677
curtin-install         telemetry
curtin-install.log     ubuntu_bootstrap.log
device-map.json        ubuntu_bootstrap.log.4051
installer-journal.txt
foobar@3090:/var/log/installer$
```
* `/var/log/installer/autoinstall-user-data`
```yaml
#cloud-config
# See the autoinstall documentation at:
# https://canonical-subiquity.readthedocs-hosted.com/en/latest/reference/autoinstall-reference.html
autoinstall:
  apt:
    disable_components: []
    fallback: offline-install
    geoip: true
    mirror-selection:
      primary:
      - country-mirror
      - arches: &id001
        - amd64
        - i386
        uri: http://archive.ubuntu.com/ubuntu/
      - arches: &id002
        - s390x
        - arm64
        - armhf
        - powerpc
        - ppc64el
        - riscv64
        uri: http://ports.ubuntu.com/ubuntu-ports
    preserve_sources_list: false
    security:
    - arches: *id001
      uri: http://security.ubuntu.com/ubuntu/
    - arches: *id002
      uri: http://ports.ubuntu.com/ubuntu-ports
  codecs:
    install: true
  drivers:
    install: true
  identity:
    hostname: '3090'
    password: $6$..
    realname: foobar
    username: foobar
  kernel:
    package: linux-generic-hwe-24.04
  keyboard:
    layout: us
    toggle: null
    variant: ''
  locale: en_US.UTF-8
  network:
    ethernets: {}
    version: 2
    wifis: {}
  oem:
    install: auto
  source:
    id: ubuntu-desktop
    search_drivers: true
  ssh:
    allow-pw: true
    authorized-keys: []
    install-server: false
  storage:
    config:
    - transport: pcie
      preserve: true
      id: nvme-controller-nvme0
      type: nvme_controller
    - ptable: gpt
      serial: Samsung_SSD_990_EVO_Plus_2TB_S7U6NJ0Y114204N_1
      wwn: eui.00253851514193ee
      nvme_controller: nvme-controller-nvme0
      path: /dev/nvme0n1
      wipe: superblock-recursive
      preserve: false
      name: ''
      grub_device: false
      id: disk-nvme0n1
      type: disk
    - device: disk-nvme0n1
      size: 1127219200
      wipe: superblock
      flag: boot
      number: 1
      preserve: false
      grub_device: true
      offset: 1048576
      path: /dev/nvme0n1p1
      id: partition-0
      type: partition
    - fstype: fat32
      volume: partition-0
      preserve: false
      id: format-0
      type: format
    - device: disk-nvme0n1
      size: 1999269527552
      wipe: superblock
      number: 2
      preserve: false
      offset: 1128267776
      path: /dev/nvme0n1p2
      id: partition-1
      type: partition
    - fstype: ext4
      volume: partition-1
      preserve: false
      id: format-1
      type: format
    - path: /
      device: format-1
      id: mount-1
      type: mount
    - path: /boot/efi
      device: format-0
      id: mount-0
      type: mount
  timezone: America/New_York
  updates: security
  version: 1
```
* `mkdir source-files`
* `xorriso -osirrox on -indev ubuntu.iso --extract_boot_images source-files/bootpart -extract / source-files`
* `cd source-files/`
* `mkdir nocloud`
* `cd nocloud/`
* `cp ../../autoinstall-user-data user-data`
* `touch meta-data`
* `cd ..`
* `cd boot/grub/`
* `ls`
* `ls -al`
* `chmod 644 grub.cfg`
* `ls`
* `ls -al`
* `nano grub.cfg`
* paste
```yaml
menuentry "Autoinstall Ubuntu Server" {
    set gfxpayload=keep
    linux /casper/vmlinuz quiet autoinstall ds=nocloud\;s=/cdrom/nocloud/ ---
    initrd /casper/initrd
}
```
* path should be `~/work/ubuntuauto/source-files`
* `xorriso -as mkisofs -r -V "ubuntu-autoinstall" -J -boot-load-size 4 -boot-info-table -input-charset utf-8 -eltorito-alt-boot -b bootpart/eltorito_img1_bios.img -no-emu1-boot -o ../installer.iso .`


| Action                                    | Keybinding                                   |
| ----------------------------------------- | -------------------------------------------- |
| Focus left / down / up / right            | `$mod+j/k/l/;` or `$mod+ArrowKeys`           |
| Move window left / down / up / right      | `$mod+Ctrl+j/k/l/;` or `$mod+Ctrl+ArrowKeys` |
| Resize window                             | `$mod+Shift+ArrowKeys` (50 px increments)    |
| Enter resize mode                         | `$mod+r`                                     |
| Split horizontally                        | `Mod1+h`                                     |
| Split vertically                          | `Mod1+v`                                     |
| Toggle fullscreen                         | `$mod+f`                                     |
| Change layout: stacked / tabbed / split   | `Mod1+s / Mod1+w / Mod1+e`                   |
| Toggle floating                           | `$mod+Shift+Space`                           |
| Toggle focus mode between tiling/floating | `$mod+Space`                                 |

### Workspaces

| Action                                   | Keybinding                        |
| ---------------------------------------- | --------------------------------- |
| Switch to workspace 1-10                 | `$mod+1` ... `$mod+0`             |
| Move window to workspace 1-10 and switch | `$mod+Shift+1` ... `$mod+Shift+0` |


# config files
```
┌────────────────────────────┬─────────────────────────────────────────────────┐
│          Purpose           │                      File                       │
├────────────────────────────┼─────────────────────────────────────────────────┤
│ i3 window manager          │ ~/.config/i3/config                             │
├────────────────────────────┼─────────────────────────────────────────────────┤
│ i3 status bar              │ ~/.config/i3status/config                       │
├────────────────────────────┼─────────────────────────────────────────────────┤
│ Polybar (kept, not active) │ ~/.config/polybar/config.ini                    │
├────────────────────────────┼─────────────────────────────────────────────────┤
│ Polybar scripts            │ ~/.config/polybar/scripts/                      │
├────────────────────────────┼─────────────────────────────────────────────────┤
│ Wallpaper script           │ ~/.config/i3/wallpaper.sh                       │
├────────────────────────────┼─────────────────────────────────────────────────┤
│ Terminal (Alacritty)       │ ~/.config/alacritty/alacritty.toml              │
├────────────────────────────┼─────────────────────────────────────────────────┤
│ App launcher (Rofi)        │ ~/.config/rofi/config.rasi (+ many theme files) │
├────────────────────────────┼─────────────────────────────────────────────────┤
│ Compositor (Picom)         │ ~/.config/picom.conf                            │
└────────────────────────────┴─────────────────────────────────────────────────┘
```

/target/                                                                                  
                                         
  When the Ubuntu installer runs, it installs the new OS onto your disk — but it still needs
   to be somewhere while it does that work. The installer itself is running in the live USB 
  environment (in RAM basically). The disk it's installing to gets mounted at /target.
  
# ssh
  - chmod 700 ~/.ssh — only you can open that folder. Anyone else gets denied entry
  entirely.                                                                                 
  - chmod 600 private_key — only you can read or write it. SSH refuses to use a key if
  anyone else can read it, because a readable private key is a security hole.               
  - chmod 644 key.pub — you can write it, everyone can read it. That's fine because public  
  keys are meant to be shared — that's the whole point of them.                           
                                                                                            
  In short: private keys get 600 (yours only), public keys get 644 (readable by all), the
  .ssh folder itself gets 700 (no one else can even look inside).
  
# sshd in user-data

  install-server: true is a subiquity autoinstall directive — it does two things in one:    
  1. Installs the openssh-server package                    
  2. Enables the sshd systemd service so it starts on every boot
  

# mounted installation usb
foobar@3090:/$ df
/dev/sdb1         6494184    6494184         0 100% /media/foobar/Ubuntu 24.04.4 LTS amd64
/dev/sdb4        23262624      20556  22035028   1% /media/foobar/writable
foobar@3090:/$ 


# sdb2 grub.cfg
  What was happening: the EFI partition (sdb2) was empty — Ubuntu's USB layout relies on    
  UEFI chainloading from the ISO rather than storing a standalone grub.cfg on sdb2. The
  script now detects that, mounts the ISO (sdb1) read-only, copies boot/grub/grub.cfg to    
  sdb2, then patches it there. From that point on sdb2 has its own grub.cfg that UEFI will
  pick up directly.

  Check what's actually on sdb2 now:

  ! sudo mount /dev/sdb2 /mnt/autoinstall-esp && find /mnt/autoinstall-esp | sort

# boot chain

● That's perfect. sdb2 has everything:

  - bootx64.efi — the UEFI entry point                                                      
  - grubx64.efi — GRUB binary
  - mmx64.efi — Secure Boot MOK manager                                                     
  - grub.cfg — our patched config ✓                                                         
  - grub.cfg.bak — the original safe copy ✓
                                                                                            
  The boot chain is complete and self-contained on sdb2. When any machine boots this USB in 
  UEFI mode it will:                                                                        
                                                                                            
  1. Load bootx64.efi from sdb2                             
  2. Hand off to grubx64.efi
  3. Read our patched grub.cfg — which has the autoinstall ds=nocloud;s=file:/// parameters 
  4. Boot the kernel, casper overlays sdb4, cloud-init finds user-data, autoinstall runs    
                                                                                            
  This will work identically on physical hardware and in a VM. You're ready to test. Spin up
   a VM pointing at /dev/sdb as the boot device and it should run the full unattended       
  install. Make sure to give the VM:                                                        
  - At least 25GB of virtual disk                           
  - At least 4GB RAM             
  - Firmware set to UEFI (not BIOS) — critical, since the whole boot chain is EFI-based
                                                                                            
  ! sudo umount /mnt/autoinstall-esp

# testing

! sudo apt install gnome-boxes
! sudo apt install virt-manager
! sudo systemctl start libvirtd && sudo systemctl enable libvirtd

  If it still shows the error after that, your user also needs to be in the libvirt group
  (you may have installed it earlier in the session before the group took effect):         
   
  ! sudo usermod -aG libvirt foobar && newgrp libvirt 
  

# sys cmds
* `ssh-keygen -t ed25519 -C "Your-Name"`
* `cat Your-Name.pub`
* `eval "$(ssh-agent -s)"`
* `ssh-add Your-Name`
* `ssh-add -l`
* `ssh -T git@github.com`

# show linux kernel
* `dpkg --list | grep linux-image | grep -v deinstall`
```
  To set 6.17.0-20 as default, edit /etc/default/grub:

  sudo nano /etc/default/grub

  Change this line:
  GRUB_DEFAULT=0
  to:
  GRUB_DEFAULT="Advanced options for Ubuntu>Ubuntu, with Linux 6.17.0-20-generic"

  Then apply it:
  sudo update-grub

  ---
```
* `sudo sed -i 's/^GRUB_DEFAULT=.*/GRUB_DEFAULT="Advanced options for Ubuntu>Ubuntu, with Linux 6.17.0-20-generic"/' /etc/default/grub`
* `sudo update-grub`


# notes
```
  ┌─────────┬────────────────────────┬─────────────────────────────────────────────────┐
  │  Thing  │         Before         │                       Now                       │
  ├─────────┼────────────────────────┼─────────────────────────────────────────────────┤
  │ Monitor │ Hardcoded eDP-1        │ xrandr detects primary → first connected →      │
  │         │ fallback               │ HDMI-0                                          │
  ├─────────┼────────────────────────┼─────────────────────────────────────────────────┤
  │ DPI     │ Hardcoded 124 (laptop  │ Auto-detected from X (101 on your desktop,      │
  │         │ HiDPI)                 │ correct on laptop)                              │
  ├─────────┼────────────────────────┼─────────────────────────────────────────────────┤
  │ GPU fan │ nvidia-smi only        │ Tries NVIDIA first, then AMD (rocm-smi), then   │
  │         │                        │ N/A                                             │
  └─────────┴────────────────────────┴─────────────────────────────────────────────────┘
```
● Yes, xprop WM_CLASS is a terminal command — you run it, your cursor turns into a
  crosshair, and you click any open window to print its class name.

  On the naming: the exec commands use the binary name (what you type to launch the app),
  while the assign rules need the WM_CLASS (what the app reports to X11 after it opens) —
  those are often different. For example, the telegram-desktop binary reports
  TelegramDesktop as its class, and nvidia-settings likely reports Nvidia-settings

● Both work fine. The practical difference:

  - /boot/grub/themes — lives on your boot partition, survives GRUB package updates without
   being overwritten
  - /usr/share/grub/themes — standard system location, but a GRUB package update could wipe
   it

  Pick 1 (/boot/grub/themes) — it's safer.

●  In the [[ ]] condition:
  - -z "$1" — true if the string is empty (zero length). Catches the case where you called
  gpu-fan with no argument.
  - -lt — less than (numeric comparison). -lt 0 = less than 0.
  - -gt — greater than (numeric comparison). -gt 100 = greater than 100.

  In the nvidia-settings command:
  - -c :1 — connect to X display :1 (which X server to talk to)
  - -a — assign a value to an attribute. Each -a sets one setting, so three -a flags sets
  three things: fan control mode on the GPU, fan 0 speed, fan 1 speed.

  The || between the conditions is just "or" — so the check reads: "if no argument was
  given, OR the number is below 0, OR above 100, then print usage and bail."
  
# helpful commands
* `xprop`
* `xprop | grep WM_CLASS`
* `sudo update-grub`
* `sed -i`
* `whatis`
* `man`
* `nautilus`
* `fc-list`
* `fc-cache -fv`
* `wal -i $(cat ~/.config/i3/current-wallpaper`
* `systemctl`
* `journalctl`
* `systemctl --user start wallpaper.service`
* `systemd`
* `networkd`
* `journald`
* `logind`
* `apt-mark showmanual`
* 'curl wttr.in` # local weather
* `grep -r "word" .` # searches that word for all files in the tree of the current dir
* `sed -i 's/oldword/newword/g'` # s substitute, g for global aka all matching words on found line 

# logs
* [INFO] Log file: /tmp/wintux-installer-20260422-093012.log
* ~/.cache/wal/colors-polybar
* ~/.config/systemd/user/wallpaper.service
* ~/.cache/wal/colors-alacritty.toml


# grub files
* /etc/default/grub

# upscale images with ai
* `git clone https://github.com/xinntao/Real-ESRGAN.git`
* `cd Real-ESRGAN`
* `python3 -m venv venv`
* `source venv/bin/activate`
* `python3 -m pip install -r requirements.txt`
* `pip install facexlib`
* `pip install gfpgan`
* `pip install basicsr`
* `pip install basicsr --upgrade`
* `python setup.py develop`
* `wget https://github.com/xinntao/Real-ESRGAN/releases/download/v0.1.0/RealESRGAN_x4plus.pth -P weights/`
* `wget https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.2.4/RealESRGAN_x4plus_anime_6B.pth -P weights/`
* `python inference_realesrgan.py -n RealESRGAN_x4plus_anime_6B -i ~/Pictures/wallpapers/ps2-bootup.jpg -o ~/Pictures/ --outscale 1 --tile 128`

# create a github pull request
1. Fork on GitHub
2. Clone your fork
3. Create a new branch
4. Make your changes
5. Commit
6. Push the branch
7. Go to the original repo on GitHub and open a Pull Request from your branch


# grub
```
  ┌───────────────────────┬─────────────────────────────────────────────────────────────────────────────────────────┐
  │         File          │                                         Purpose                                         │
  ├───────────────────────┼─────────────────────────────────────────────────────────────────────────────────────────┤
  │ /etc/default/grub     │ Main settings — default kernel, timeout, theme, cmdline options. This is what you edit. │
  ├───────────────────────┼─────────────────────────────────────────────────────────────────────────────────────────┤
  │ /etc/grub.d/          │ Scripts that generate grub.cfg (10_linux, 40_custom, etc.)                              │
  ├───────────────────────┼─────────────────────────────────────────────────────────────────────────────────────────┤
  │ /etc/grub.d/40_custom │ Where you add custom menu entries manually                                              │
  ├───────────────────────┼─────────────────────────────────────────────────────────────────────────────────────────┤
  │ /boot/grub/grub.cfg   │ Auto-generated output — don't edit directly, it gets overwritten by update-grub         │
  ├───────────────────────┼─────────────────────────────────────────────────────────────────────────────────────────┤
  │ /boot/grub/custom.cfg │ Optional override file sourced by grub.cfg at boot (yours doesn't exist currently)      │
  └───────────────────────┴─────────────────────────────────────────────────────────────────────────────────────────┘
```


# rice linking
* polybar and i3 chaining
```
  ~/.config/i3/config
    └── exec_always → ~/.config/i3/launch_bar.sh
                          └── polybar left / right / center
                                  └── ~/.config/polybar/config.ini
                                          └── ~/.config/polybar/scripts/
                                                  ├── check_updates.sh   (pkgupdates module)
                                                  ├── cpu_temp.sh        (cpu-temp module)
                                                  ├── gpu_temp.sh        (gpu-temp module)
                                                  ├── gpu_fan.sh         (gpu-fan module)
                                                  ├── network_status.sh  (wired-network module)
                                                  └── volume.sh          (volume module)
```
* wallpaper chaining
```
● Here's how the full chain looks now:

  BOOT / i3 LOGIN
  │
  └── i3 config
        exec systemctl --user start wallpaper.timer
              Hands off to systemd — i3 is done, it doesn't manage timing


  SYSTEMD (runs independently, survives i3 reloads)
  │
  └── wallpaper.timer  (ticks every 350s, first fire after 5s)
        │
        └── wallpaper.service  (oneshot)
              │
              └── wallpaper.sh
                    ├── feh --bg-fill               → sets wallpaper
                    ├── echo > current-wallpaper     → saves path
                    ├── wal -i                       → generates colors from wallpaper
                    ├── cp colors-polybar.ini        → copies colors to polybar
                    └── launch_bar.sh polybar        → restarts polybar with new colors

  i3 reloads now have zero effect on the timer — systemd owns it.

  And your template (~/.config/wal/templates/colors-polybar.ini) is what controls which of wal's 16 colors map to which polybar color role:

  [colors]
  background = {background}   ← darkest color from wallpaper
  foreground = {foreground}   ← lightest color
  primary    = {color4}       ← mid palette color used for highlights
  alert      = {color1}       ← typically a red-ish tone
  disabled   = {color8}       ← muted/grey tone
  ...

  You can swap {color0} through {color15} around in the template to change which wallpaper colors land on which bar elements.
```

# more chaining
```
● Here's the full picture of how everything chains together:

  ---
  The Boot Chain

  i3 starts → reads ~/.config/i3/config → fires two relevant things:

  1. exec --no-startup-id systemctl --user start wallpaper.timer — arms the systemd timer once at login
  2. exec_always --no-startup-id ~/.config/i3/launch_bar.sh polybar — starts polybar on every i3 load/reload

  ---
  The Wallpaper Timer Loop

  Every 350 seconds (and 5 seconds after boot), systemd fires wallpaper.service, which runs ~/.config/i3/wallpaper.sh:

  wallpaper.timer (350s)
    └─▶ wallpaper.service
          └─▶ wallpaper.sh
                ├─ feh --bg-fill <random image>       # sets wallpaper on screen
                ├─ echo path > current-wallpaper       # saves which one was picked
                ├─ wal -i <same image>                 # generates color palette
                │     └─ writes ~/.cache/wal/
                │           ├─ colors-polybar.ini      # polybar color template output
                │           ├─ colors-alacritty.toml   # alacritty color template output
                │           └─ escape sequences sent   # to all open terminal ptys
                ├─ cp colors-polybar.ini → ~/.config/polybar/colors-polybar.ini
                └─ launch_bar.sh polybar
                      ├─ killall polybar               # clean kill
                      ├─ waits for polybar to die
                      └─ polybar example &             # restart with new colors loaded

  KillMode=process in the service means systemd only kills wallpaper.sh when the service exits — it does not touch polybar, which was spawned as a child that detached into the background.

  ---
  Color Theming

  pywal (wal) is the engine. It reads a wallpaper image, extracts a palette, and writes it into multiple format templates simultaneously:

  - ~/.cache/wal/colors-polybar.ini — via your template at ~/.config/wal/templates/colors-polybar.ini
  - ~/.cache/wal/colors-alacritty.toml — alacritty's color format
  - Live escape sequences → sent directly to every open terminal, updating colors instantly without restart

  Alacritty picks up the file automatically because ~/.config/alacritty/alacritty.toml has:
  import = ["~/.cache/wal/colors-alacritty.toml"]
  Every new terminal launched after a wallpaper change gets the new theme. Open terminals get it live via the escape sequences wal writes.

  Polybar reads colors from ~/.config/polybar/colors-polybar.ini (the copied file) via:
  include-file = ~/.config/polybar/colors-polybar.ini
  Since polybar reads this at startup, it only gets new colors after launch_bar.sh restarts it.

  ---
  The Polybar Bar Itself

  config.ini defines one bar ([bar/example]) with:

  - Left side: xworkspaces (built-in, talks to i3 directly — shows which workspaces exist and which is active) + menu-apps (commented out currently)
  - Right side: all custom scripts polled on intervals — net_type.sh, ip_addr.sh, cpu_temp.sh, cpu (built-in), gpu_temp.sh, gpu_load.sh, gpu_fan.sh, memory (built-in), filesystem
  (built-in), volume.sh, date (built-in)

  The custom scripts just run shell commands (nvidia-smi, hwmon reads, pamixer, ip route) and print one line of output, which polybar displays as %output%.

  ---
  What's Static vs Dynamic

  ┌────────────────────────┬────────────────────────────────────────────────────┐
  │         Thing          │                    Updates how                     │
  ├────────────────────────┼────────────────────────────────────────────────────┤
  │ Wallpaper              │ Every 350s via systemd timer                       │
  ├────────────────────────┼────────────────────────────────────────────────────┤
  │ Polybar colors         │ Every wallpaper change (restarted by wallpaper.sh) │
  ├────────────────────────┼────────────────────────────────────────────────────┤
  │ Alacritty new windows  │ Every wallpaper change (reads file at launch)      │
  ├────────────────────────┼────────────────────────────────────────────────────┤
  │ Alacritty open windows │ Instantly via wal escape sequences                 │
  ├────────────────────────┼────────────────────────────────────────────────────┤
  │ Workspace indicators   │ Live via i3 IPC                                    │
  ├────────────────────────┼────────────────────────────────────────────────────┤
  │ CPU/GPU/network stats  │ Polled every 1-5 seconds by polybar                │
  └────────────────────────┴────────────────────────────────────────────────────┘
```
# gaps
  - Alacritty — controls padding inside the terminal window (between the text and the terminal edge)
  - Picom — compositor, handles transparency, shadows, blur, and rounded corners on windows
  - i3 — controls gaps between windows and between windows and screen edges (gaps inner, gaps outer, gaps top, etc.)


# dev logs
● Bash(echo $DISPLAY; echo $DBUS_SESSION_BUS_ADDRESS)
  ⎿  :1
     unix:path=/run/user/1000/bus

● Update(~/.config/systemd/user/wallpaper.service)
  ⎿  Added 1 line, removed 1 line
      4  [Service]
      5  Type=oneshot
      6  ExecStart=/bin/bash %h/.config/i3/wallpaper.sh
      7 -Environment=DISPLAY=:0
      7 +Environment=DISPLAY=:1
      8  Environment=DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus

● Bash(systemctl --user daemon-reload && systemctl --user restart wallpaper.timer && cp ~/.config/systemd/user/wallpaper.service ~/dotfiles/dots/systemd/user/wallpaper…)
  ⎿  (No output)

● That should fix it — the service was using :0 but your
  ⎿  Interrupted · What should Claude do instead?

❯ okay explain what you just did

● The systemd service runs in a minimal environment — it doesn't automatically know which display to connect to. I had DISPLAY=:0 hardcoded in the service file, but your actual X display
  is :1. So when the timer fired and wallpaper.sh tried to restart polybar, polybar couldn't find the X server and crashed silently, taking the bar with it.

  I just changed DISPLAY=:0 to DISPLAY=:1 in the service file so it points to the right display.
  
# resources
* https://canonical-subiquity.readthedocs-hosted.com/en/latest/reference/autoinstall-reference.html
* https://i3wm.org/docs/userguide.html 
* https://i3wm.org/i3status/manpage.html


# systemd stuff
 1990  cat ~/.config/systemd/user/wallpaper.service
 1991  systemctl --user cat wallpaper.service
 1992  systemctl --user show wallpaper.service -p After,Wants,WantedBy,Environment
 1993  systemctl --user cat wallpaper.service
 1994  systemctl --user daemon-reload
 1995  systemctl --user stop wallpaper.timer
 1996  systemctl --user start wallpaper.timer
 1997  systemctl --user list-timers wallpaper.timer
 1998  systemctl --user status wallpaper.service
 1999  systemctl --user status wallpaper.timer

# wallpaper options
  ---
  1. Change rotation interval — wallpaper.timer:6
  OnUnitActiveSec=350   # change to whatever you want, e.g. 1800 for 30min, 3600 for 1hr
  After editing: systemctl --user daemon-reload && systemctl --user restart wallpaper.timer

  ---
  2. Hardcode a specific wallpaper — wallpaper.sh:11-13

  Replace:
  wallpaper=$(find ~/Pictures/wallpapers/ -type f | shuf -n1)
  feh --bg-fill "$wallpaper"
  With:
  wallpaper=~/Pictures/wallpapers/your-image.jpg
  feh --bg-fill "$wallpaper"
  And disable the timer so it doesn't keep changing it:
  systemctl --user disable --now wallpaper.timer
  Then add a one-shot trigger in i3 config instead of the timer start.

  ---
  3. Random pick on boot only (no rotation) — wallpaper.timer:6

  Just remove the OnUnitActiveSec line entirely:
  [Timer]
  OnActiveSec=5
  Unit=wallpaper.service
  This fires once 5 seconds after login, picks a random wallpaper, and never rotates. The
  shuf -n1 in wallpaper.sh:11 already handles the random pick.

● Instead of the timer, you'd call the service directly from i3 on startup. In your i3
  config, replace:

  exec --no-startup-id systemctl --user start wallpaper.timer

  With:

  exec --no-startup-id systemctl --user start wallpaper.service

  That fires the service once when i3 starts — no timer involved. Since wallpaper.sh
  already picks randomly with shuf -n1, you get a random wallpaper each login without any
  rotation.

# i3 exec
--no-startup-id tells i3 not to wait for it — use it for anything that's a background daemon or doesn't support the protocol.
https://github.com/i3/i3lock/issues/375

# ubuntu xset
https://manpages.ubuntu.com/manpages/trusty/man1/xset.1.html

# sleep
System sleep on idle is controlled by /etc/systemd/logind.conf with settings like IdleAction and IdleActionSec. That's
  completely separate from DPMS.
