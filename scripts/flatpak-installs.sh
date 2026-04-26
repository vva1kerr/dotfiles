#!/bin/bash                                                                   

packages=(                                                                    
    com.usebottles.bottles # run Windows apps/games with Wine, GUI frontend
    com.heroicgameslauncher.hgl # Epic/GOG games on Linux
    md.obsidian.Obsidian # notes
    dev.vencord.Vesktop # Discord client with better Linux support
)                                                                             
                
for pkg in "${packages[@]}"; do                                               
    echo -e "\n\e[32mInstalling $pkg...\e[0m"
    flatpak install -y flathub "$pkg"                                         
done