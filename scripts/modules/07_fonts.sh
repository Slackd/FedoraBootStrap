#!/bin/bash

# Fonts Working Directory
mkdir -p font_tmp && cd font_tmp

# Download from Wget List
wget -i ../../assets/fonts.txt

# Local Directory of Fonts
mkdir -p /home/sam/.local/share/fonts

# Unzip Files
unzip IBMPlexMono.zip
unzip CodeNewRoman.zip
unzip FiraCode.zip
unzip Hack.zip
unzip Inconsolata.zip
unzip Iosevka.zip
unzip JetBrainsMono.zip
unzip UbuntuMono.zip
unzip 'Inter-3.15.zip'

find . -type f \( -name "*.ttf" -o -name "*.otf" \) | xargs -I '{}' mv -f {} /home/sam/.local/share/fonts
cd .. && rm -rf tmp
fc-cache -fv

# Clear Screen Output
sleep 5
clear