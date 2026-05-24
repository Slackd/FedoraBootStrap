#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# 07_themes.sh — Icon themes and GTK theme for GNOME 50.
#
# Icons:
#   - Tela    — github.com/vinceliuice/Tela-icon-theme
#   - Papirus — github.com/PapirusDevelopmentTeam/papirus-icon-theme
#                (formerly installed via git.io URLs which are dead since 2022)
#
# GTK theme:
#   - WhiteSur GTK theme installed with `-l` so libadwaita apps (GNOME 50
#     core apps) pick up the theming too. WhiteSur explicitly refuses to be
#     installed with sudo, so we run its installer as the current user.
#
# Also installs gnome-tweaks (replaces the old `gnome-tweak-tool` name) and
# dconf-editor for fine-grained customization.
# ------------------------------------------------------------------------------
set -euo pipefail

# ---- GNOME utility apps ------------------------------------------------------
# sassc is needed by WhiteSur when it compiles the libadwaita CSS overrides.
echo "==> Installing gnome-tweaks and dconf-editor..."
sudo dnf install -y \
    gnome-tweaks \
    dconf-editor \
    gnome-extensions-app \
    sassc

# Working directory for theme clones.
WORK="$(mktemp -d)"
trap 'rm -rf "${WORK}"' EXIT
cd "${WORK}"

# ---- Tela icon theme ---------------------------------------------------------
echo "==> Installing Tela icon theme..."
if git clone --depth=1 https://github.com/vinceliuice/Tela-icon-theme.git tela; then
    # Tela's install.sh installs to ~/.local/share/icons when run without sudo.
    ( cd tela && ./install.sh )
else
    echo "  WARN: failed to clone Tela. Skipping."
fi

# ---- Papirus icon theme ------------------------------------------------------
echo "==> Installing Papirus icon theme..."
PAPIRUS_INSTALL="https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/install.sh"
if curl -fsSL "${PAPIRUS_INSTALL}" | DESTDIR="${HOME}/.local/share/icons" sh; then
    echo "  ok"
else
    echo "  WARN: Papirus installer failed. You can rerun later from:"
    echo "        ${PAPIRUS_INSTALL}"
fi

# Optional: Papirus folder colour helper (handy if you tweak directory colours).
PAPIRUS_FOLDERS="https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-folders/master/install.sh"
echo "==> Installing papirus-folders helper..."
curl -fsSL "${PAPIRUS_FOLDERS}" | DESTDIR="${HOME}/.local/share/icons" sh || echo "  (skipped)"

# ---- WhiteSur GTK theme (with libadwaita patching) ---------------------------
echo "==> Installing WhiteSur GTK theme (with -l for libadwaita)..."
if git clone --depth=1 https://github.com/vinceliuice/WhiteSur-gtk-theme.git whitesur; then
    # WhiteSur refuses sudo for --libadwaita; user-scope install is correct.
    ( cd whitesur && ./install.sh -l )
    # Tweaks: if you later want a specific colour or Nautilus style, re-run
    # ~/.themes/WhiteSur-Dark/... or rerun install.sh -t blue -N stable -l etc.
else
    echo "  WARN: failed to clone WhiteSur. Skipping."
fi

# ---- Apply themes via gsettings (best-effort) --------------------------------
# These commands take effect immediately under GNOME. Comment out if you'd
# rather pick the theme manually from Tweaks.
if command -v gsettings &>/dev/null; then
    echo "==> Applying default theme selections via gsettings..."
    gsettings set org.gnome.desktop.interface icon-theme 'Tela-dark' 2>/dev/null || \
        gsettings set org.gnome.desktop.interface icon-theme 'Tela' 2>/dev/null || true
    gsettings set org.gnome.desktop.interface gtk-theme 'WhiteSur-Dark' 2>/dev/null || \
        gsettings set org.gnome.desktop.interface gtk-theme 'WhiteSur' 2>/dev/null || true
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null || true
fi

echo
echo "✓ Themes installed."
echo "  Open 'Tweaks' (or 'Extension Manager') to fine-tune the look."
echo "  To undo WhiteSur's libadwaita patch, run:"
echo "    rm -rf ~/.config/gtk-4.0/{gtk.css,gtk-dark.css,assets}"
echo "  To reapply with different options, re-clone WhiteSur and run e.g.:"
echo "    ./install.sh -l -t blue -N stable    # blue accent, Nautilus stable"
