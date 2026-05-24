#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# 02_devel.sh — Lean development toolchain.
#
# Replaces the old "Development Tools" group install with a focused set of
# packages. Adds Rust via rustup (per-user, freshest toolchain) and Zig from
# Fedora repos (0.15.x in F44).
# ------------------------------------------------------------------------------
set -euo pipefail

echo "==> Installing compilers and build systems..."
sudo dnf install -y \
    gcc gcc-c++ \
    clang clang-tools-extra lld lldb \
    make cmake meson ninja-build \
    autoconf automake libtool \
    pkgconf-pkg-config \
    patch unzip \
    git gh \
    python3 python3-pip python3-devel \
    nodejs npm \
    neovim

echo "==> Installing Zig from Fedora repos..."
sudo dnf install -y zig || \
    echo "WARN: zig not available via dnf — grab a tarball from https://ziglang.org/download/ if needed."

echo "==> Installing Rust via rustup (per-user toolchain)..."
if ! command -v rustup &>/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
        | sh -s -- -y --default-toolchain stable --profile default
    # shellcheck disable=SC1091
    source "${HOME}/.cargo/env"
else
    rustup update stable
fi

echo "==> Installing VS Code from Microsoft's repository..."
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
if [[ ! -f /etc/yum.repos.d/vscode.repo ]]; then
    sudo tee /etc/yum.repos.d/vscode.repo > /dev/null <<'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
autorefresh=1
type=rpm-md
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF
fi
sudo dnf install -y code

echo "==> Enabling phracek/PyCharm COPR and installing PyCharm Community..."
sudo dnf copr enable -y phracek/PyCharm
sudo dnf install --skip-unavailable -y pycharm-community

echo
echo "✓ Toolchain installed."
echo "  Versions:"
gcc --version    | head -1 | sed 's/^/    /'
clang --version  | head -1 | sed 's/^/    /'
meson --version  | sed 's/^/    meson /'
ninja --version  | sed 's/^/    ninja /'
rustc --version  | sed 's/^/    /' 2>/dev/null || true
zig version 2>/dev/null | sed 's/^/    zig /' || true
nvim --version   | head -1 | sed 's/^/    /'
