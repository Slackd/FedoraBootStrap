# Fedora Linux Bootstrap Scripts

A modular bootstrap for a fresh **Fedora 44 Workstation** (GNOME 50, DNF5) on
**AMD Radeon RX 9070 XT** (RDNA4) hardware.

Originally authored 2021, refreshed May 2026 for Fedora 44.

## What it does

A menu-driven shell installer that brings up a fresh Fedora install to a
working developer + gaming setup. Each module is independent — pick one,
several, or run all in order.

### Modules

| # | Module                | What it installs                                                            |
|---|-----------------------|------------------------------------------------------------------------------|
| 1 | `01_update.sh`        | Full system upgrade, `dnf5-plugins`, RPM Fusion (free + nonfree), Cisco OpenH264 repo. |
| 2 | `02_devel.sh`         | gcc, clang, make, cmake, meson, ninja, autotools, git, gh, Rust (rustup), Zig, Neovim, VS Code, PyCharm Community (COPR: `phracek/PyCharm`). |
| 3 | `03_terminal.sh`      | eza (COPR: `alternateved/eza`), starship (COPR: `atim/starship`), bat, ripgrep, fd-find, fzf, fastfetch, lazygit, zoxide, aria2, btop, htop, tmux, ranger, chezmoi, RAR (negativo17), then `chezmoi init --apply https://github.com/Slackd/.dotfiles`. |
| 4 | `04_media.sh`         | ffmpeg (RPM Fusion), GStreamer codecs, mpv/vlc/celluloid, Google Chrome, Brave, Helium (COPR: `jhuang6451/helium-browser`), Spotify (negativo17), Mullvad VPN, NetBird. |
| 5 | `05_amd_gaming.sh`    | Mesa + 32-bit Mesa, Vulkan, Steam, Lutris, Wine, Gamemode, MangoHud, Gamescope, vkBasalt, ProtonPlus (COPR: `wehagy/protonplus`), Faugus Launcher (COPR: `faugus/faugus-launcher`). Optional CachyOS kernel (COPR: `bieszczaders/kernel-cachyos`) via `CACHYOS_KERNEL=1`. |
| 6 | `06_fonts.sh`         | Noto, Roboto, Inter (dnf), Nerd Fonts via COPR `che/nerd-fonts` (9 families + Symbols-Only), Google Sans Flex, macfonts (fefelixa). |
| 7 | `07_themes.sh`        | gnome-tweaks, dconf-editor, Tela icons, Papirus icons + papirus-folders, WhiteSur GTK (with libadwaita patch). |

## Usage

```bash
git clone https://github.com/<your-user>/FedoraBootStrap.git
cd FedoraBootStrap/scripts
./main.sh
```

Pick a module from the menu, or `9` to run them all in order.

The menu loops — you don't need to re-launch between modules.

## Hardware target

Built and tested for:

- **Fedora Linux 44 Workstation** (released April 28, 2026)
- **GNOME 50** (default DE)
- **DNF5** package manager (now mandatory)
- **AMD Radeon RX 9070 XT** (Navi 48 / RDNA4)
- **Kernel 6.19+** (ships with F44)

If you're on different hardware (older AMD, Intel iGPU, NVIDIA) the gaming
module needs swapping out. The rest of the modules are GPU-agnostic.

## What's *not* here

Removed from the 2021 version (now considered better done elsewhere):

- **Neovim build-from-source** — `dnf install neovim` is fine; use a config
  manager like LazyVim or NvChad on top.
- **Flatpak module** — Flathub is on by default in modern Fedora; install
  apps interactively from GNOME Software when you actually want them.
- **Pen-testing tools** — better run from a Kali `distrobox` container than
  scattered across the host.
- **FaceTime HD camera driver / kernel build helper** — Mac-specific cruft.
- **Old Nerd Fonts v2.1 archive list** — replaced by `:latest/download/` URLs.
- **NVIDIA-specific bits** — none, this is an AMD-only target now.

## Notes on the refresh

A few things that changed in Fedora-land between 2021 and 2026 that this
script accounts for:

- `dnf` is now `dnf5`. Most syntax still works but `config-manager --add-repo`
  is `config-manager addrepo --from-repofile=URL` and a few flag shapes moved.
- `gnome-tweak-tool` was renamed to `gnome-tweaks`.
- `git.io` shut down in April 2022 — Papirus install URLs were updated.
- `exa` is unmaintained; `eza` is the active fork.
- `neofetch` is archived (April 2024); `fastfetch` replaces it.
- `ffmpeg` swap pattern replaces the old gstreamer-bad wildcard.

## Third-party repos and COPRs enabled

For traceability, here's everything outside Fedora's main repos that this
bootstrap turns on, with what it pulls in:

| Source                              | Purpose                                    |
|-------------------------------------|--------------------------------------------|
| RPM Fusion free + nonfree           | Multimedia codecs, Steam, Wine, gamescope  |
| Cisco OpenH264 (fedora-cisco)       | H.264 video decoding                       |
| Microsoft (packages.microsoft.com)  | VS Code                                    |
| Google Chrome                       | Chrome stable                              |
| Brave (brave-browser-rpm-release)   | Brave browser                              |
| Mullvad (repository.mullvad.net)    | Mullvad VPN                                |
| NetBird (pkgs.netbird.io)           | NetBird mesh networking                    |
| negativo17 — Spotify                | spotify-client                             |
| negativo17 — RAR                    | proprietary `rar` archiver                 |
| COPR `phracek/PyCharm`              | pycharm-community                          |
| COPR `atim/starship`                | starship prompt                            |
| COPR `alternateved/eza`             | newer eza than stock                       |
| COPR `jhuang6451/helium-browser`    | helium-browser                             |
| COPR `wehagy/protonplus`            | ProtonPlus (GE-Proton manager)             |
| COPR `faugus/faugus-launcher`       | Faugus Launcher (Wine/Proton GUI)          |
| COPR `che/nerd-fonts`               | Nerd Fonts (per-family RPMs)               |
| COPR `bieszczaders/kernel-cachyos`  | CachyOS kernel (opt-in)                    |

## Tweaking

Each module is a standalone bash script under `scripts/modules/`. Edit them
freely — they're meant as a starting point, not a frozen baseline. Run any
one directly with `bash scripts/modules/05_amd_gaming.sh`.

## Dotfiles

Shell configuration (zsh, prompt, aliases, plugin managers, etc.) is **not**
managed by this bootstrap. It lives in [chezmoi](https://chezmoi.io) and is
applied at the tail end of `03_terminal.sh` from
[Slackd/.dotfiles](https://github.com/Slackd/.dotfiles). To re-sync after a
change to that repo, run:

```bash
chezmoi update --apply
```

Re-running `03_terminal.sh` after the first install will do the same thing.
