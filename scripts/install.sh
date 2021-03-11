#!/bin/bash

# This is a complete system setup script for Fedora 
# as I would set it up on bare metal setup.
# Copyright (c) Budhaditya Saha, 2021

# V0 - Script is interactive and not unattended.
# Todo - V1 - Make Unattended

###########################################
###### Main System Setup & Softwares ######
###########################################

echo "1) Phase 1: "
echo "2) Phase 2: "
echo "3) Quit: "
read -p "Enter Which Phase you want to Install: " choice

if [ $choice -eq 1 ]; then
    echo "Installing Phase 1..."
    # Perform a clean system update and suggest to reboot the system and restart the script.
    sudo dnf update -y
    clear
    echo "Recommend you to restart the PC to complete update process."
    sleep 10
    clear
    exit

elif [ $choice -eq 2 ]; then
    echo "Installing Phase 2..."
    # Enabling Repositories and Features
    # - Enable non-free RPM-Fusion Repos.
    # - Enable Flatpak remote Flathub.

    # Pre Req Install
    sudo dnf install dnf-plugins-core -y

    # RPM Based Repos
    sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
    sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

    # Base update run
    sudo dnf update -y

    # Base and Devel Packages
    sudo dnf groupinstall "Development Tools" -y
    sudo dnf group install "C Development Tools and Libraries" -y
    sudo dnf install ninja-build flex bison libtool autoconf automake cmake gcc gcc-c++ make pkgconfig unzip patch -y

    # Basic Terminal Programs
    sudo dnf install git curl wget aria2 zsh -y
    sudo dnf install neofetch cowsay htop xclip fortune-mod cmatrix -y

    # Media Codecs
    # Ref : https://docs.fedoraproject.org/en-US/quick-docs/assembly_installing-plugins-for-playing-movies-and-music/

    sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel -y
    sudo dnf install lame\* --exclude=lame-devel -y
    sudo dnf group upgrade --with-optional Multimedia -y
    sudo dnf install unrar unace unzip p7zip vlc smplayer discord -y

    # Brave and Code 
    sudo dnf install brave-browser code -y

    # Flatpak Setup
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    flatpak install flathub org.qbittorrent.qBittorrent com.spotify.Client com.github.micahflee.torbrowser-launcher org.telegram.desktop com.obsproject.Studio md.obsidian.Obsidian org.signal.Signal -y


    ###########################################
    ##### Fonts, Themes, Icons and Others #####
    ###########################################

    # Base Update
    sudo dnf update -y

    # Theme and Tweak Tools
    sudo dnf install materia-gtk-theme gnome-tweak-tool -y

    # Fonts
    mkdir -p tmp && cd tmp
    wget -i ../fonts.txt
    mkdir -p /home/sam/.local/share/fonts

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
    clear

    # Icon Theme
    wget -qO- https://git.io/papirus-icon-theme-install | sh

    clear
    echo "All Done Mate!"
    sleep 5
    exit

elif [ $choice -eq 3 ]; then
    echo "Quitting..."
    exit
fi
