#!/bin/bash

# Flathub Remote Add the Flathub Repo.
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Install Programs
flatpak install flathub com.obsproject.Studio org.qbittorrent.qBittorrent com.spotify.Client com.github.micahflee.torbrowser-launcher org.telegram.desktop com.leinardi.gst org.gnome.Geary org.signal.Signal -y
flatpak install flathub de.haeckerfelix.Shortwave com.github.fabiocolacio.marker com.github.johnfactotum.Foliate com.github.tchx84.Flatseal -y
flatpak install flathub com.gitlab.newsflash -y
flatpak install flathub com.github.jeromerobert.pdfarranger -y
flatpak install flathub org.gnome.Builder -y

# Clear Screen Output
sleep 5
clear
