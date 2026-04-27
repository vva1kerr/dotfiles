#!/bin/bash                           

packages=(                                                                    
    curl
    git                                                                       
    vim 
    nano        
    htop
    nvtop

    ripgrep
    fzf                                                                       
    tmux      

    # rice
    i3
    alacritty # terminal emulator | rice
    picom     # compositor for i3, also used by pywal to set the wallpaper | rice
    polybar   # status bar | rice
    feh # for setting static wallpapers, also used by pywal to set the wallpaper | rice
    mpv    # for video wallpapers | rice
    rofi   # fuzzy app launcher + window switcher, replaces dmenu | rice
    pavucontrol # graphical audio settings manager, used in i3 for managing audio devices and volume | rice8
    
    # xwinwrap — NOT in apt; build from source: github.com/ujjwal96/xwinwrap
    #   deps below are needed for the build:
    xorg-dev build-essential libx11-dev x11proto-xext-dev libxrender-dev libxext-dev


    # reverse engineering
    ghex  # hex editor | reverse engineering
    gdb  # GNU Debugger | reverse engineering
    #radare2 # reverse engineering framework | reverse engineering

    # networking
    net-tools # ifconfig, netstat, etc. | networking
    openssh-client # for ssh, scp, etc. | networking
    iproute2 # for `ip` and `ss` commands, replaces net-tools | networking
    nmap # network scanner | networking
    wireshark # network protocol analyzer | networking

    # multiuse dependencies
    ffmpeg # for extracting frames from videos to use as wallpapers with pywal
    pulseaudio-utils # for `pactl` to control audio from the command line, used in i3 keybindings
    pipx # system wide pypi package installer

    # proton-mail

    neofetch
    
    # eye candy
    cmatrix # terminal matrix rain screensaver
    cava # terminal audio visualizer
    mesa-utils # for `glxgears` and `glxinfo` to test OpenGL performance and check GPU info in terminal
    tty-clock # terminal clock
    cbonsai # terminal bonsai tree
    genact # generates random fake data
    bb # ascii animation masterpiece demo
    rig # generates random fake data
    fortune # terminal fortune cookie generator
    caca-utils # for `cacafire` and `cacaview` to view images in the terminal
    
    #asciinema

    code
    codium
    curl
    flatpak
    tree
    bat # cat clone with syntax highlighting and other features, used in terminal file previews with fzf
    jq # parse and pretty-print JSON in terminal

    nodejs
    npm

    wine # for running Windows applications on Linux, used by my custom script to run the Windows version of Spotify

    tesseract-ocr # OCR engine, used by my custom screenshot script to extract text from screenshots

    qbittorrent # torrent client

    arandr # graphical tool for managing display settings, used in i3 for multi-monitor setups

    nvidia-settings # for managing NVIDIA graphics settings, used in i3 for multi-monitor setups

    nautilus # file manager, used in i3 for opening files and folders from the terminal with `nautilus .`

    xsettingsd # for setting X11 settings like cursor theme, used in i3 to set the cursor theme on startup

    sonic-pi

    pipewire

    pipewire-jack
)

sudo apt update
for pkg in "${packages[@]}"; do
    echo -e "\n\e[32mInstalling $pkg...\e[0m"
    sudo apt install -y "$pkg"
done

# \n — blank line before each package for spacing
# \e[32m — green text
# \e[0m — resets color back to normal after the package name
# echo -e — needed to actually interpret the \n and \e escape codes