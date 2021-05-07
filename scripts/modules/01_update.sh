#!/bin/bash

# Perform a clean system update and suggest to reboot the system and restart the script.
sudo dnf upgrade --refresh -y
clear
echo "Recommend you to restart the PC to complete update process."
sleep 5
clear
