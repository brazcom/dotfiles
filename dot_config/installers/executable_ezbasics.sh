#!/bin/bash

# Verifica che lo script sia eseguito come root
if [[ $EUID -ne 0 ]]; then
    echo "Per favore esegui questo script con sudo o come root."
    exit 1
fi

# Pacchetti ufficiali da installare con pacman
PACMAN_PKGS=(
    git
    chezmoi
    kitty
    lsd
    pass
    feh
    mc
    qbittorrent
    rofi
    cmus
    xclip
    maim
    mpv
    micro
    firefox-ublock-origin
    otf-commit-mono-nerd
    pokemon-colorscripts-git
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

echo "✅ Tutti i pacchetti sono stati installati con successo."
