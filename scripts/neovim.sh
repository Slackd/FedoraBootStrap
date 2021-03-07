#!/bin/bash

# Referred from - https://github.com/neovim/neovim/wiki/Building-Neovim
# V0 - Initial Launch which supports Fedora.
# V1 - TODO - Plan to conditionally check for distro and adapt the script.

# Build prerequisites
sudo dnf install ninja-build libtool autoconf automake \
    cmake gcc gcc-c++ make pkgconfig unzip patch -y

# NodeJS Build Deps (Optional - This is required my COC). If you are not interested in
# intellisense, then please comment out this line.
curl -fsSL https://rpm.nodesource.com/setup_current.x | sudo bash -
#sudo dnf install nodejs

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

# Clone my dotfiles and copy over the neovim configs
git clone https://github.com/Slackd/dotfiles.git
cp -rf dotfiles/.config/nvim /home/sam/.config/
cd ..

# Install vim-plug and set up the directories
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Check installation

echo 'Installed Successfully. Please start with "nvim" and then wait for modules to install...'
nvim -v
node -v
npm -v






