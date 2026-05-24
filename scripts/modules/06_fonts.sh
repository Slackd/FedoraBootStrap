#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# 06_fonts.sh — Install fonts the user actually uses.
#
# Source mix:
#   - Fedora repos:     Noto (all), Roboto, Roboto Mono, Inter, emoji.
#   - che/nerd-fonts:   Nerd Fonts (9 families + Symbols-Only) as RPM packages,
#                       so updates flow through dnf.
#   - Google Sans Flex: pulled from Google Fonts download endpoint into
#                       ~/.local/share/fonts/GoogleSansFlex/.
#   - macfonts:         cloned from https://github.com/fefelixa/macfonts
#                       (SF Pro, SF Compact, SF Mono, New York) into
#                       ~/.local/share/fonts/MacFonts/.
# ------------------------------------------------------------------------------
set -euo pipefail

# ---- Packaged fonts (Fedora repos) -------------------------------------------
echo "==> Installing Fedora-packaged fonts (Noto / Roboto / Inter / emoji)..."
sudo dnf install -y \
    google-noto-fonts-all \
    google-noto-emoji-fonts \
    google-noto-color-emoji-fonts \
    google-roboto-fonts \
    google-roboto-mono-fonts \
    rsms-inter-fonts \
    fontawesome-fonts \
    fontawesome-fonts-web

# ---- User font directory -----------------------------------------------------
FONT_DIR="${HOME}/.local/share/fonts"
mkdir -p "${FONT_DIR}"

WORK="$(mktemp -d)"
trap 'rm -rf "${WORK}"' EXIT
cd "${WORK}"

# ---- Nerd Fonts via che/nerd-fonts COPR --------------------------------------
# Each Nerd Font family is a separate `nerd-fonts-<name>` package. The list
# below covers the common monospace families plus the Symbols-Only set (a
# drop-in overlay you can pair with any other font). `--skip-unavailable`
# lets the install proceed even if a particular package name has shifted.
echo "==> Enabling che/nerd-fonts COPR and installing Nerd Fonts..."
sudo dnf copr enable -y che/nerd-fonts

NERD_PACKAGES=(
    nerd-fonts-jetbrains-mono
    nerd-fonts-fira-code
    nerd-fonts-hack
    nerd-fonts-iosevka
    nerd-fonts-cascadia-code
    nerd-fonts-source-code-pro
    nerd-fonts-ibm-plex-mono
    nerd-fonts-ubuntu-mono
    nerd-fonts-inconsolata
    nerd-fonts-symbols-only
)
sudo dnf install --skip-unavailable -y "${NERD_PACKAGES[@]}"

# ---- Google Sans Flex --------------------------------------------------------
# Not in google/fonts repo as of 2026-05; pull from the Google Fonts download
# endpoint with a real User-Agent so the request isn't 403'd.
echo "==> Downloading Google Sans Flex..."
GSF_DIR="${FONT_DIR}/GoogleSansFlex"
mkdir -p "${GSF_DIR}"
if curl -fsSL \
    -A "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0 Safari/537.36" \
    -o GoogleSansFlex.zip \
    "https://fonts.google.com/download?family=Google%20Sans%20Flex"; then
    if unzip -oq GoogleSansFlex.zip -d "${GSF_DIR}"; then
        echo "  ok"
    else
        echo "  WARN: download succeeded but ZIP is invalid — download manually"
        echo "        from https://fonts.google.com/specimen/Google+Sans+Flex"
        echo "        and drop the .ttf into ${GSF_DIR}/"
    fi
else
    echo "  WARN: Google Fonts blocked the download. Get it manually from:"
    echo "        https://fonts.google.com/specimen/Google+Sans+Flex"
    echo "        Extract the ZIP and drop the .ttf into ${GSF_DIR}/"
fi

# ---- macfonts (SF Pro, SF Mono, New York) from fefelixa/macfonts -------------
echo "==> Cloning macfonts (Apple SF family) from fefelixa/macfonts..."
MAC_DIR="${FONT_DIR}/MacFonts"
mkdir -p "${MAC_DIR}"
if git clone --depth=1 https://github.com/fefelixa/macfonts.git macfonts; then
    find macfonts -type f \( -iname '*.ttf' -o -iname '*.otf' \) \
        -exec cp -f {} "${MAC_DIR}/" \;
    echo "  ok ($(find "${MAC_DIR}" -type f | wc -l) files)"
else
    echo "  FAILED (skipped)"
fi

# ---- Refresh font cache ------------------------------------------------------
echo "==> Refreshing fontconfig cache..."
fc-cache -f "${FONT_DIR}"

echo
echo "✓ Fonts installed."
echo "  Sanity checks:"
echo "    fc-list | grep -i 'jetbrains'    # Nerd Font present?"
echo "    fc-list | grep -i 'sf pro'       # macfonts present?"
echo "    fc-list | grep -i 'google sans'  # Google Sans Flex present?"
