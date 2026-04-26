#!/bin/bash                                                                   
                                                                            
packages=(
    pywal  # generates color schemes from wallpapers, used in i3 and polybar | rice
    yt-dlp # YouTube video downloader
    bpytop # terminal resource monitor, alternative to htop, written in Python | multiuse dependency
    #gallery-dl
    wpgtk    # GTK theme generator with pywal integration | rice
    pywalfox # pushes pywal palette into Firefox via native messenger | rice
)

for pkg in "${packages[@]}"; do
    echo -e "\n\e[32mInstalling $pkg...\e[0m"
    pipx install "$pkg"
done

# Register pywalfox's native messenger with Firefox so the extension can connect
echo -e "\n\e[32mRegistering pywalfox native messenger...\e[0m"
pywalfox install