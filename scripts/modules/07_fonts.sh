#!/bin/bash

#Basic Username Check
read -p "Please enter your user name: " username

# Fonts Working Directory
mkdir -p font_tmp && cd font_tmp

# Download from Wget List
wget -i ../assets/fonts.txt

# Local Directory of Fonts
mkdir -p /home/$username/.local/share/fonts

# Unzip Files
unzip IBMPlexMono.zip
unzip CodeNewRoman.zip
unzip FiraCode.zip
unzip Hack.zip
unzip Inconsolata.zip
unzip Iosevka.zip
unzip JetBrainsMono.zip
unzip UbuntuMono.zip
unzip SourceCodePro.zip
unzip FantasqueSansMono.zip
unzip 'Inter-3.15.zip'
unzip CascadiaCode-2102.25.zip

find . -type f \( -name "*.ttf" -o -name "*.otf" \) | xargs -I '{}' mv -f {} /home/$username/.local/share/fonts
cd .. && rm -rf tmp

sudo dnf install google-carlito-fonts.noarch google-tinos-fonts.noarch google-cousine-fonts.noarch google-noto-emoji-color-fonts.noarch google-arimo-fonts.noarch google-rubik-fonts.noarch -y
fc-cache -fv

# Clear Screen Output
sleep 5
clear
