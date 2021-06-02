#!/bin/bash

# Flathub Remote Add the Flathub Repo.
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Install Programs
flatpak install flathub com.obsproject.Studio org.qbittorrent.qBittorrent com.spotify.Client com.github.micahflee.torbrowser-launcher org.telegram.desktop com.leinardi.gst org.gnome.Geary org.signal.Signal -y

# Clear Screen Output
sleep 5
clear
