#!/bin/bash

# Basic Terminal Programs
sudo dnf install git curl wget aria2 -y
sudo dnf install zsh exa fzf neofetch figlet ranger cowsay htop xclip fortune-mod cmatrix -y

# Media Codecs
# Ref : https://docs.fedoraproject.org/en-US/quick-docs/assembly_installing-plugins-for-playing-movies-and-music/
sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel -y
sudo dnf install lame\* --exclude=lame-devel -y
sudo dnf group upgrade --with-optional Multimedia -y

# Compression & De-compression Libraries, ffmpeg and media
sudo dnf install unrar unace unzip p7zip vlc celluloid mpv discord ffmpeg -y

# Visual Studio Code 
sudo dnf install code -y

# Google Chrome
sudo dnf install fedora-workstation-repositories
sudo dnf config-manager --set-enabled google-chrome
sudo dnf install google-chrome-stable -y

# Clear Screen Output
sleep 5
clear
