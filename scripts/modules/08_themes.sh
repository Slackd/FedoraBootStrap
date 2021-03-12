#!/bin/bash

# Theme and Tweak Tools
sudo dnf install materia-gtk-theme gnome-tweak-tool -y

# Icon Theme
wget -qO- https://git.io/papirus-icon-theme-install | sh

# Clear Screen Output
sleep 5
clear