#!/bin/bash

# Verifica che lo script sia eseguito come root
if [[ $EUID -ne 0 ]]; then
    echo "Per favore esegui questo script con sudo o come root."
    exit 1
fi

# Pacchetti ufficiali da installare con pacman
PACMAN_PKGS=(
    i3-wm
    git
    chezmoi
    micro
    ncdu
    firefox-ublock-origin
    pass
    rofi-emoji
    pokemon-colorscripts-git
    kitty
    rofi
    mousepad
    feh
    mc
    polybar
    maim
    xdotool
    xclip
    qbittorrent
)

# Installa pacchetti ufficiali
echo "🔧 Installazione pacchetti ufficiali con pacman..."
pacman -Syu --noconfirm "${PACMAN_PKGS[@]}"

# Controlla se paru è installato
if ! command -v paru &> /dev/null; then
    echo "⚙️ paru non trovato. Installazione in corso..."

    # Installa paru per l'utente non-root
    sudo -u "$SUDO_USER" bash -c '
        cd /tmp
        git clone https://aur.archlinux.org/paru.git
        cd paru
        makepkg -si --noconfirm
    '
fi

# Pacchetti da AUR
#AUR_PKGS=(
#    pokemon-colorscripts-git
#    autotiling
#)

# Installa pacchetti AUR
#echo "📦 Installazione pacchetti AUR con paru..."
#sudo -u "$SUDO_USER" paru -S --noconfirm "${AUR_PKGS[@]}"

echo "✅ Tutti i pacchetti sono stati installati con successo."
