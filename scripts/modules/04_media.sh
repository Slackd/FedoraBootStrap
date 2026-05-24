#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# 04_media.sh — Codecs, media frameworks, players, browsers, VPN, networking.
#
# Assumes RPM Fusion is enabled (see 01_update.sh). On Fedora 44 the canonical
# way to get full ffmpeg is the `dnf swap` from ffmpeg-free.
# ------------------------------------------------------------------------------
set -euo pipefail

# ---- Multimedia codecs -------------------------------------------------------
echo "==> Swapping ffmpeg-free for full ffmpeg from RPM Fusion..."
sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing || true

echo "==> Installing multimedia group (with optional packages)..."
sudo dnf group upgrade -y multimedia --setopt=install_weak_deps=True --exclude=PackageKit-gstreamer-plugin || true
sudo dnf group install -y sound-and-video || true

echo "==> Installing GStreamer plugins for broad codec coverage..."
sudo dnf install -y \
    gstreamer1-plugins-base \
    gstreamer1-plugins-good \
    gstreamer1-plugins-good-gtk \
    gstreamer1-plugins-good-extras \
    gstreamer1-plugins-bad-free \
    gstreamer1-plugins-bad-free-extras \
    gstreamer1-plugins-ugly \
    gstreamer1-libav \
    gstreamer1-plugin-openh264 \
    mozilla-openh264 \
    lame\* --exclude=lame-devel

echo "==> Installing media players..."
sudo dnf install -y \
    mpv \
    vlc \
    celluloid

# ---- Browsers ----------------------------------------------------------------
# Google Chrome (via fedora-workstation-repositories).
echo "==> Installing Google Chrome..."
sudo dnf install -y fedora-workstation-repositories
sudo dnf config-manager setopt google-chrome.enabled=1 || \
    sudo dnf config-manager --set-enabled google-chrome
sudo dnf install -y google-chrome-stable

# Brave (official RPM repo).
echo "==> Installing Brave Browser..."
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo dnf config-manager addrepo --overwrite \
    --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
sudo dnf install -y brave-browser

# Helium (privacy-focused Chromium fork) from jhuang6451/helium-browser COPR.
echo "==> Installing Helium Browser (jhuang6451/helium-browser COPR)..."
sudo dnf copr enable -y jhuang6451/helium-browser
sudo dnf install --skip-unavailable -y helium-browser

# Tell Firefox to use Cisco's OpenH264 plugin in browser-side video playback.
sudo dnf install -y openh264 gstreamer1-plugin-openh264

# ---- Music / streaming -------------------------------------------------------
# Spotify client via negativo17.
echo "==> Installing Spotify client (negativo17)..."
sudo dnf config-manager addrepo --overwrite \
    --from-repofile=https://negativo17.org/repos/fedora-spotify.repo
sudo dnf install -y spotify-client

# ---- Networking / VPN --------------------------------------------------------
# Mullvad VPN (official repo).
echo "==> Installing Mullvad VPN..."
sudo dnf config-manager addrepo --overwrite \
    --from-repofile=https://repository.mullvad.net/rpm/stable/mullvad.repo
sudo dnf install -y mullvad-vpn

# NetBird (zero-trust mesh networking).
echo "==> Installing NetBird (CLI + UI)..."
sudo dnf config-manager addrepo --overwrite \
    --from-repofile=https://pkgs.netbird.io/yum/netbird.repo
sudo dnf install --skip-unavailable -y netbird netbird-ui

echo
echo "✓ Media stack + browsers + VPN/networking installed."
echo "  Mullvad: launch from app menu, log in with your account number."
echo "  NetBird: 'netbird up' to join your network (requires setup key)."
