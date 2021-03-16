#!/bin/bash

# This is a complete system setup script for Fedora 
# as I would set it up on bare metal setup.
# Copyright (c) Budhaditya Saha, 2021

# V0 - Script is interactive and not unattended.
# V1 - Offer Choices
# V2 - Make Modular with choices

# Current Version : V2
#####################################################

# Declare Current Modules as variables
update=modules/01_update.sh
base_devel=modules/02_base_devel.sh
media=modules/03_media.sh
flatpack_mod=modules/04_flatpak.sh
pentools=modules/05_pentools.sh
neovim=modules/06_neovim.sh
fonts=modules/07_fonts.sh
themes=modules/08_themes.sh

# Offer Choices based on modules.
echo "1) Perform Systemwide Update: "
echo "2) Install Development Packages: "
echo "3) Install Multimedia Packages: "
echo "4) Enable Flathub & Install Packages: "
echo "5) Install Pen-testing Tools: "
echo "6) Install Neovim from Git: "
echo "7) Intall Fonts: "
echo "8) Install Themes & Icons: "
echo "9) All Packages / Run All Scripts: "
echo " "
echo "10) Clean and Exit: "
echo " "
 
read -p "Enter Which Phase you want to Install: " choice

##################
# Updates Module #
##################
if [[ $choice -eq 1 ]] && [[ -f "${update}" ]]; then
    clear
    echo "===== Installing Updates ====="
    ./"${update}"
fi

#####################
# Develpment Module #
#####################
if [[ $choice -eq 2 ]] && [[ -f "${base_devel}" ]]; then
    clear
    echo "===== Installing Development Packages ====="
    ./"${base_devel}"
fi

#####################
# Multimedia Module #
#####################
if [[ $choice -eq 3 ]] && [[ -f "${media}" ]]; then
    clear
    echo "===== Installing Multimedia Packages ====="
    ./"${media}"
fi

##################
# Flatpak Module #
##################
if [[ $choice -eq 4 ]] && [[ -f "${flatpack_mod}" ]]; then
    clear
    echo "===== Installing Flatpack Packages from Flathub ====="
    ./"${flatpack_mod}"
fi

###################
# PenTools Module #
###################
if [[ $choice -eq 5 ]] && [[ -f "${pentools}" ]]; then
    clear
    echo "===== Installing Pen Testing CTF Tools & Packages ====="
    ./"${pentools}"
fi

#################
# Neovim Module #
#################
if [[ $choice -eq 6 ]] && [[ -f "${neovim}" ]]; then
    clear
    echo "===== Installing Neovim & Sams Dots from Git ====="
    ./"${neovim}"
fi

################
# Fonts Module #
################
if [[ $choice -eq 7 ]] && [[ -f "${fonts}" ]]; then
    clear
    echo "===== Installing Fonts from Git & Nerd ====="
    ./"${fonts}"
fi

#################
# Themes Module #
#################
if [[ $choice -eq 8 ]] && [[ -f "${themes}" ]]; then
    clear
    echo "===== Installing GTK Themes and Icon Sets ====="
    ./"${themes}"
fi

########################
# Install Every Module #
########################

if [[ $choice -eq 9 ]]; then
    clear
    echo "===== Installing All the Modules ====="
    ./"${base_devel}"
    ./"${media}"
    ./"${flatpack_mod}"
    ./"${pentools}"
    ./"${neovim}"
    ./"${fonts}"
    ./"${themes}"
fi

# Quit Program #
if [[ $choice -eq 10 ]]; then
    clear
    rm -rf modules/neo_tmp
    rm -rf modules/font_tmp
    clear
    echo "Thanks! Bye..!"
    exit
fi
