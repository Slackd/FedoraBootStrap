#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# 05_amd_gaming.sh — AMD Radeon RX 9070 XT (RDNA4) drivers + gaming stack.
#
# The 9070 XT (Navi 48) is supported out of the box by the kernel amdgpu driver
# and Mesa/RADV in Fedora 44 (kernel 6.19, Mesa 25.x+). No proprietary AMDGPU
# PRO driver is needed for normal gaming — Mesa's open RADV is the recommended
# Vulkan implementation and is generally faster than AMDVLK.
#
# Steam, Lutris, Gamemode, MangoHud, Wine, and friends come from RPM Fusion
# nonfree (enabled in 01_update.sh) and the Fedora main repos.
# ------------------------------------------------------------------------------
set -euo pipefail

echo "==> Verifying AMD GPU is the active card..."
if lspci -k 2>/dev/null | grep -A 2 -E '(VGA|3D)' | grep -qi amd; then
    echo "  Found AMD GPU. Proceeding."
else
    echo "  WARN: No AMD GPU detected. Continuing anyway, but verify hardware."
fi

# ---- Mesa userspace: OpenGL, Vulkan (RADV), VA-API, VDPAU --------------------
echo "==> Installing Mesa userspace drivers (OpenGL / Vulkan / VA-API)..."
sudo dnf install -y \
    mesa-dri-drivers \
    mesa-vulkan-drivers \
    mesa-libGL \
    mesa-libEGL \
    mesa-libgbm \
    mesa-va-drivers \
    mesa-vdpau-drivers \
    libva libva-utils \
    libvdpau libvdpau-va-gl

# 32-bit Mesa is required for Steam, Wine, and Proton games.
echo "==> Installing 32-bit Mesa for Steam/Wine/Proton..."
sudo dnf install -y \
    mesa-dri-drivers.i686 \
    mesa-vulkan-drivers.i686 \
    mesa-libGL.i686 \
    mesa-libEGL.i686

# Vulkan tooling.
echo "==> Installing Vulkan loader and tools..."
sudo dnf install -y \
    vulkan-loader \
    vulkan-loader.i686 \
    vulkan-tools \
    vulkan-headers \
    vulkan-validation-layers \
    vulkan-validation-layers.i686

# Linux firmware (amdgpu firmware blobs). Usually preinstalled; ensure latest.
echo "==> Ensuring amdgpu firmware is current..."
sudo dnf install -y linux-firmware

# Render/video groups: required for hardware acceleration and GPU compute.
if ! id -nG "$USER" | grep -qw render; then
    echo "==> Adding $USER to render and video groups..."
    sudo usermod -aG render,video "$USER"
    NEED_RELOGIN=1
else
    NEED_RELOGIN=0
fi

# ---- Gaming stack ------------------------------------------------------------
echo "==> Enabling gaming COPRs (ProtonPlus, Faugus Launcher)..."
sudo dnf copr enable -y wehagy/protonplus
sudo dnf copr enable -y faugus/faugus-launcher

echo "==> Installing Steam, Lutris, Wine, and the rest of the gaming stack..."
sudo dnf install -y \
    steam \
    lutris \
    gamemode \
    gamescope \
    mangohud mangohud.i686 \
    goverlay \
    wine wine.i686 \
    winetricks \
    protontricks \
    vkbasalt vkbasalt.i686

echo "==> Installing ProtonPlus + Faugus Launcher (from COPRs above)..."
sudo dnf install --skip-unavailable -y protonplus faugus-launcher

# Optional: ROCm for GPU compute (PyTorch, llama.cpp, etc.).
# Uncomment the block below if you want ROCm now. Pulls in a lot of weight.
#
# echo "==> Installing ROCm (GPU compute)..."
# sudo dnf install -y \
#     rocminfo rocm-clinfo rocm-smi rocm-opencl rocm-hip rocm-runtime

# ---- CachyOS kernel (opt-in) -------------------------------------------------
# CachyOS ships performance-tuned kernels with scheduler patches (BORE/EEVDF),
# kernel-level Wine NTSYNC support and other gaming-friendly tweaks. Installing
# it does NOT remove the stock kernel — both stay in GRUB and you can pick at
# boot. To roll back, just select the fedora kernel in GRUB and `dnf remove
# kernel-cachyos*`.
#
# Set CACHYOS_KERNEL=1 in your environment to install it; default skips.
if [[ "${CACHYOS_KERNEL:-0}" == "1" ]]; then
    echo "==> Enabling CachyOS kernel COPRs..."
    sudo dnf copr enable -y bieszczaders/kernel-cachyos
    sudo dnf copr enable -y bieszczaders/kernel-cachyos-addons
    echo "==> Installing CachyOS kernel + addons..."
    sudo dnf install --skip-unavailable -y \
        kernel-cachyos \
        kernel-cachyos-devel-matched \
        kernel-cachyos-addons \
        kernel-cachyos-addons-devel
    echo "  CachyOS kernel installed. Stock Fedora kernel remains as a fallback."
else
    echo "==> Skipping CachyOS kernel (opt-in)."
    echo "    To install on next run:  CACHYOS_KERNEL=1 bash ${BASH_SOURCE[0]}"
fi

echo
echo "✓ AMD graphics and gaming stack installed."
echo
echo "Quick sanity checks (run after reboot):"
echo "  vulkaninfo --summary    # should show 'RADV GFX1201' for 9070 XT"
echo "  glxinfo -B              # should show AMD Radeon RX 9070 XT"
echo "  vkcube                  # spinning Vulkan cube"
echo

if [[ ${NEED_RELOGIN} -eq 1 ]]; then
    echo "IMPORTANT: log out and back in (or reboot) for render/video group"
    echo "           membership to take effect, or DRM access will be denied."
fi
