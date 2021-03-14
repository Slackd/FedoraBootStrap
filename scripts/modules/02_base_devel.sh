#!/bin/bash

# Pre Req Install
sudo dnf install dnf-plugins-core -y

# RPM Based Repos
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

# Sync The Repos we have just added
sudo dnf update -y

# Base and Devel Packages
sudo dnf groupinstall "Development Tools" -y
sudo dnf group install "C Development Tools and Libraries" -y
sudo dnf install ninja-build flex bison libtool autoconf automake cmake gcc gcc-c++ make pkgconfig unzip patch dwarves ncurses ncurses-devel -y
sudo dnf install git make gcc openssl-devel yasm gmp-devel libpcap-devel bzip2-devel -y

# Clear Screen
sleep 5
clear