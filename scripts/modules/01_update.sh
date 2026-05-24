#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# 01_update.sh — Refresh metadata, upgrade the system, enable third-party repos.
# ------------------------------------------------------------------------------
set -euo pipefail

echo "==> Refreshing metadata and upgrading system..."
sudo dnf upgrade --refresh -y

echo "==> Ensuring dnf5-plugins is present (provides 'copr' and 'config-manager')..."
sudo dnf install -y dnf5-plugins

FEDORA_VERSION="$(rpm -E %fedora)"

echo "==> Enabling RPM Fusion (free + nonfree) for Fedora ${FEDORA_VERSION}..."
sudo dnf install -y \
    "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_VERSION}.noarch.rpm" \
    "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_VERSION}.noarch.rpm"

echo "==> Enabling Cisco OpenH264 repository (used by Firefox and gstreamer)..."
sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1 || true

echo "==> Re-syncing metadata after enabling RPM Fusion..."
sudo dnf upgrade --refresh -y

echo
echo "✓ System updated and RPM Fusion is live."
echo "  A reboot is recommended if the kernel or firmware was updated."
