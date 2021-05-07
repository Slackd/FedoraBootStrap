#!/bin/bash

# Flathub Remote Add the Flathub Repo.
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
# We are adding beta just for Gnome-Boxes. (Reconsider removing this, if the issues are fixed with gnome-nightly images.)
flatpak remote-add --user flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo

# Install Programs
flatpak install flathub org.qbittorrent.qBittorrent com.spotify.Client com.github.micahflee.torbrowser-launcher org.telegram.desktop com.leinardi.gst org.gnome.Geary org.signal.Signal -y
flatpak install --user flathub-beta com.obsproject.Studio

# Clear Screen Output
sleep 5
clear
