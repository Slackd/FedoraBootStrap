#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# 03_terminal.sh — Modern command-line utilities + dotfiles via chezmoi.
#
# This module only installs binaries. All shell configuration (aliases, zsh
# init, zoxide hooks, fzf bindings, prompt, etc.) is owned by chezmoi and
# applied from https://github.com/Slackd/.dotfiles — the script does not
# touch ~/.bashrc, ~/.zshrc, or anything under ~/.config.
# ------------------------------------------------------------------------------
set -euo pipefail

# ---- Third-party repos / COPRs used by this module ---------------------------
# - alternateved/eza : newer eza than what's in Fedora repos
# - atim/starship    : cross-shell prompt (paired with chezmoi-managed config)
# - negativo17 RAR   : proprietary `rar` archiver
echo "==> Enabling COPRs and repos used by the terminal stack..."
sudo dnf copr enable -y alternateved/eza
sudo dnf copr enable -y atim/starship
sudo dnf config-manager addrepo --overwrite --from-repofile=https://negativo17.org/repos/fedora-rar.repo

echo "==> Installing core CLI tooling (strict)..."
sudo dnf install -y \
    bash-completion \
    zsh \
    tmux \
    git curl wget aria2 \
    fzf ripgrep fd-find bat eza \
    starship \
    fastfetch \
    htop btop \
    zoxide \
    lazygit \
    chezmoi \
    jq \
    ranger \
    wl-clipboard xclip \
    most \
    tree \
    unzip \
    p7zip p7zip-plugins \
    unrar \
    rar

echo "==> Installing nice-to-haves (best-effort; skipped if any are missing)..."
for pkg in lolcat figlet cowsay fortune-mod cmatrix tealdeer; do
    sudo dnf install -y "$pkg" 2>/dev/null || echo "  (skipped $pkg)"
done

# ---- Bootstrap dotfiles via chezmoi ------------------------------------------
# Idempotent: first run does `chezmoi init --apply`, subsequent runs do
# `chezmoi update --apply` (git pull + re-template + re-apply).
DOTFILES_REPO="https://github.com/Slackd/.dotfiles.git"
CHEZMOI_SOURCE="${HOME}/.local/share/chezmoi"

echo "==> Bootstrapping dotfiles via chezmoi from ${DOTFILES_REPO}..."
if [[ -d "${CHEZMOI_SOURCE}/.git" ]]; then
    echo "  chezmoi source dir already exists — pulling latest and re-applying."
    chezmoi update --apply
else
    chezmoi init --apply "${DOTFILES_REPO}"
fi

echo
echo "✓ Terminal tooling installed and dotfiles applied."
echo "  Set zsh as your default shell when you're ready:"
echo "    chsh -s \"\$(command -v zsh)\""
echo "  (Log out and back in for the shell change to take effect.)"
