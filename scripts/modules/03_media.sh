#!/bin/bash

# Basic Terminal Programs
sudo dnf install git curl wget aria2 -y
sudo dnf install zsh neofetch cowsay htop xclip fortune-mod cmatrix -y

# Media Codecs
# Ref : https://docs.fedoraproject.org/en-US/quick-docs/assembly_installing-plugins-for-playing-movies-and-music/
sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel -y
sudo dnf install lame\* --exclude=lame-devel -y
sudo dnf group upgrade --with-optional Multimedia -y

# Compression & De-compression Libraries
sudo dnf install unrar unace unzip p7zip vlc smplayer discord -y

# Brave Browser and Code 
sudo dnf install brave-browser code -y

# Clear Screen Output
clear
