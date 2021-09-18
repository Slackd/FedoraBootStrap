#!/bin/bash

# Referred from - https://github.com/neovim/neovim/wiki/Building-Neovim
# V0 - Initial Launch which supports Fedora.
# V1 - Implement distro check. Currently support only Ubuntu and Fedora.
# V2 - TODO - Other distros and maybe install the vim plug sets automatically.

# Current Version : V1

# Notes   
# - Would suggest to use NVM for managing various node versions.

# Check for which OS is running

# NodeJS via the nvm installer 
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
source ~/.bashrc
nvm install node

if [[ $(cat /etc/os-release | head -1 | cut -d "=" -f 2) == 'Fedora' ]]; then 
    echo "You're Running Fedora!"
    echo "Installing Build Dependencies..."
    echo " "
    sleep 2

    # Build prerequisites
    sudo dnf install ninja-build libtool autoconf automake cmake gcc gcc-c++ make pkgconfig unzip patch -y

fi

if [[ $(cat /etc/os-release | head -1 | cut -d "=" -f 2) == 'Ubuntu' ]]; then 
    echo "You're Running Ubuntu"
    echo "Installing Build Dependencies..."
    echo " "
    sleep 2
 
    # Build prerequisites
    sudo apt install install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip -y

fi

# Basic Username Check
read -p "Please enter your user name: " username

# Get sources
mkdir neo_tmp && cd neo_tmp
git clone https://github.com/neovim/neovim
cd neovim

# Building 
# Refer to the build guide for more details on what to choose.
# Release tag has the best compiler optimizations by default.

#make CMAKE_BUILD_TYPE=Debug
make CMAKE_BUILD_TYPE=Release #Default
#make CMAKE_BUILD_TYPE=RelWithDebInfo

# Install
sudo make install
cd ..

# Python Module for neovim
pip3 install neovim
pip3 install pynvim

# Node Module for neovim
npm install -g neovim
npm install -g tree-sitter-cli

# Two Options to use configs from:
# 1>> https://raw.githubusercontent.com/ChristianChiarulli/lunarvim/master/utils/installer/install.sh
# 2>> git clone https://github.com/NvChad/NvChad ~/.config/nvim && nvim +'hi NormalFloat guibg=#1e222a' +PackerSync

# Check installation

echo "Checking Installation:"
echo "Build Files have been preserved, for future use."
nvim -v
node -v
npm -v
sleep 5
clear
echo 'Installed Successfully. Please start with "nvim" and then wait for modules to install...'

# Clear Screen Output
sleep 5
clear
