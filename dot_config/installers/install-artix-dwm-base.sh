#!/usr/bin/env bash
set -euo pipefail

if ! command -v pacman >/dev/null 2>&1; then
    echo "pacman not found" >&2
    exit 1
fi

x_pkgs=(
    xlibre-xserver
    xlibre-xf86-input-libinput
    xinit
    xorg-xauth
    xorg-xrandr
    xorg-xsetroot
    xclip
)

dwm_build_pkgs=(
    base-devel
    git
    libx11
    libxft
    libxinerama
)

desktop_pkgs=(
    dwm
    dmenu
    alacritty
    feh
    maim
    firefox
)

cli_pkgs=(
    pass
    gnupg
    openssh
    chezmoi
    fastfetch
    ufw
    eza
    htop
    mc
)

font_pkgs=(
    noto-fonts-emoji
    ttf-jetbrains-mono-nerd
)

all_pkgs=(
    "${x_pkgs[@]}"
    "${dwm_build_pkgs[@]}"
    "${desktop_pkgs[@]}"
    "${cli_pkgs[@]}"
    "${font_pkgs[@]}"
)

missing=()
for pkg in "${all_pkgs[@]}"; do
    if ! pacman -Si "$pkg" >/dev/null 2>&1; then
        missing+=("$pkg")
    fi
done

if ((${#missing[@]} > 0)); then
    printf 'Missing packages in enabled repos:\n' >&2
    printf '  %s\n' "${missing[@]}" >&2
    printf '\nHint: on Artix, XLibre packages may require the proper repo to be enabled.\n' >&2
    exit 1
fi

sudo pacman -Syu --needed "${all_pkgs[@]}"

cat <<'EOF'

Installed package groups:
- XLibre/X11 base
- DWM build dependencies
- DWM userland
- CLI essentials
- fonts for Nerd icons and emoji

Next sensible steps:
1. Enable services you actually want, for example:
   sudo ln -s /etc/runit/sv/ufw /etc/runit/runsvdir/default/
   sudo ln -s /etc/runit/sv/ufw /run/runit/service/
2. Configure ~/.xinitrc to start dwm.
3. Set Alacritty font to JetBrainsMono Nerd Font.
EOF
