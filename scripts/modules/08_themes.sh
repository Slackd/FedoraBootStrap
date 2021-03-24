#!/bin/bash

# Theme and Tweak Tools
sudo dnf install materia-gtk-theme gnome-tweak-tool -y

# Icon Theme
wget -qO- https://git.io/papirus-icon-theme-install | sh
wget -qO- https://git.io/papirus-folders-install | sh
papirus-folders -C yaru --theme Papirus-Dark

# Clear Screen Output
sleep 5
clear
