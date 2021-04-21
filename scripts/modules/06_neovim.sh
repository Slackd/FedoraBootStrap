#!/bin/bash

# Referred from - https://github.com/neovim/neovim/wiki/Building-Neovim
# NodeJS and NPM latest versions are required for CoC. These are not available in the default
# repos. Therefore we are getting the packages from : https://github.com/nodesource/distributions
# V0 - Initial Launch which supports Fedora.
# V1 - Implement distro check. Currently support only Ubuntu and Fedora.
# V2 - TODO - Other distros and maybe install the vim plug sets automatically.

# Current Version : V1

# Note
    # NodeJS Build Deps (Optional - This is required my COC). If you are not interested in
    # intellisense, then please comment out line 17 or 30.
    # Use Nodesource onyl for the latest version of the nodejs.
    # This is sub-optimal for production / full stability.
    # Would suggest to use NVM for managing various node versions.

# Check for which OS is running
# If Fedora is detected. Commands to follow:

if [[ $(cat /etc/os-release | head -1 | cut -d "=" -f 2) == 'Fedora' ]]; then 
    echo "You're Running Fedora!"
    echo "Installing Build Dependencies..."
    echo " "
    sleep 2

    # Build prerequisites
    sudo dnf install ninja-build libtool autoconf automake cmake gcc gcc-c++ make pkgconfig unzip patch -y

    curl -fsSL https://rpm.nodesource.com/setup_current.x | sudo bash -
    sudo dnf install nodejs -y
fi

if [[ $(cat /etc/os-release | head -1 | cut -d "=" -f 2) == 'Ubuntu' ]]; then 
    echo "You're Running Ubuntu"
    echo "Installing Build Dependencies..."
    echo " "
    sleep 2
 
    # Build prerequisites
    sudo apt install install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip -y

    curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash -
    sudo apt install nodejs -y
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
sudo pip3 install -g neovim

# Install Lunar Vim from Git. This is very close to what I use anyways.
bash <(curl -s https://raw.githubusercontent.com/ChristianChiarulli/lunarvim/master/utils/installer/install.sh)

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
