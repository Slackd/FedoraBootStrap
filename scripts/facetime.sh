#!/usr/bin/bash

# Very basic install script for the Facetime HD Driver for Linux
# Software - Tested only on Fedora 33/34.
# Hardware - MacBook Pro 15" 2015 Late (i5 Model)
# Broadcom Inc. and subsidiaries 720p FaceTime HD - Camera
# This is useful for Stock & Custom Kernels
# This is totally manual pathway to install. You can read in the main Github for more info on DKMS auto setup.

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
