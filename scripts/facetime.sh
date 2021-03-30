#!/usr/bin/bash

# Very basic install script for the Facetime HD Driver for Linux
# Software - Tested only on Fedora 33/34.
# Hardware - MacBook Pro 13" Late 2015 (i5 Model) --- Broadcom Inc. and subsidiaries 720p FaceTime HD - Camera
# This is useful for building the module on both Stock & Custom Kernels
# For Automating this --- You can read in the main Github for more info on DKMS auto setup.
# Ref: https://github.com/patjak/bcwc_pcie/wiki/Installation#get-started-on-fedora

# Basic Username Check
read -p "Please enter your user name: " username


cd /home/$username/Downloads/
git clone https://github.com/patjak/bcwc_pcie.git FaceTime_Driver
cd /home/$username/Downloads/FaceTime_Driver

make clean
make -j$(nproc)
sudo make install

sleep 3
sudo depmod -A
sudo modprobe facetimehd

clear
echo "Done.. Installed.."
echo " "
echo "Run Gnome-Cheese to Test!"
sleep 3
exit
