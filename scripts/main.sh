#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# Fedora 44 Bootstrap — interactive installer
# Copyright (c) Budhaditya Saha, 2021–2026
#
# V0 — interactive, non-unattended
# V1 — offer choices
# V2 — modular
# V3 — Fedora 44 / dnf5 refresh; AMD/RDNA4; modernized stack (2026)
# ------------------------------------------------------------------------------

set -uo pipefail

# Resolve script directory so the menu can be launched from anywhere.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULES="${SCRIPT_DIR}/modules"

# Sanity check: Fedora only.
if ! grep -q '^ID=fedora' /etc/os-release 2>/dev/null; then
    echo "This bootstrap targets Fedora. Aborting." >&2
    exit 1
fi

# Keep sudo alive for the duration of a module run so prompts don't surprise us.
keep_sudo_alive() {
    sudo -v || exit 1
    ( while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done ) 2>/dev/null &
}

run_module() {
    local name="$1"
    local path="${MODULES}/${name}"
    if [[ ! -f "$path" ]]; then
        echo "Module not found: $path" >&2
        return 1
    fi
    echo
    echo "===== Running: ${name} ====="
    bash "$path"
    local rc=$?
    if [[ $rc -ne 0 ]]; then
        echo "WARN: ${name} exited with status ${rc}" >&2
    fi
    return $rc
}

print_menu() {
    cat <<'EOF'

╔══════════════════════════════════════════════════════════╗
║          Fedora 44 Bootstrap — Module Selector           ║
╠══════════════════════════════════════════════════════════╣
║  1) System Update + Enable RPM Fusion                    ║
║  2) Development Toolchain (gcc/meson/ninja/rust/zig)     ║
║  3) Terminal & CLI Utilities (eza/bat/ripgrep/...)       ║
║  4) Multimedia Codecs & Players                          ║
║  5) AMD Graphics (RDNA4) + Gaming Stack                  ║
║  6) Fonts (Nerd, Noto, Roboto, Inter, GSF, mac)          ║
║  7) Themes & Icons (Tela, Papirus, WhiteSur)             ║
║                                                          ║
║  9) Run ALL modules in order                             ║
║  0) Quit                                                 ║
╚══════════════════════════════════════════════════════════╝
EOF
}

run_all() {
    run_module 01_update.sh       || true
    run_module 02_devel.sh        || true
    run_module 03_terminal.sh     || true
    run_module 04_media.sh        || true
    run_module 05_amd_gaming.sh   || true
    run_module 06_fonts.sh        || true
    run_module 07_themes.sh       || true
}

keep_sudo_alive

while true; do
    print_menu
    read -rp "Select an option: " choice
    case "${choice}" in
        1) run_module 01_update.sh       ;;
        2) run_module 02_devel.sh        ;;
        3) run_module 03_terminal.sh     ;;
        4) run_module 04_media.sh        ;;
        5) run_module 05_amd_gaming.sh   ;;
        6) run_module 06_fonts.sh        ;;
        7) run_module 07_themes.sh       ;;
        9) run_all                       ;;
        0|q|Q) echo "Done. Reboot is recommended after changes." ; exit 0 ;;
        *) echo "Invalid option: ${choice}" ;;
    esac
done
