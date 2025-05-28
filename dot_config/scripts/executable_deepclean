#!/bin/bash

echo "🧹 Avvio pulizia sistema..."

# 1. Pulisce cache utente
echo "➤ Pulizia ~/.cache"
rm -rf ~/.cache/*

# 2. Rimuove pacchetti orfani
echo "➤ Rimozione pacchetti orfani"
orphans=$(pacman -Qdtq)
if [ -n "$orphans" ]; then
  sudo pacman -Rns --noconfirm $orphans
else
  echo "   Nessun pacchetto orfano trovato."
fi

# 3. Pulisce cache di pacman (mantiene solo 1 versione)
echo "➤ Pulizia cache pacman (mantieni 1 versione)"
sudo paccache -rk1

# 4. Pulisce directory /tmp
echo "➤ Pulizia /tmp"
sudo rm -rf /tmp/*

# 5. Limita i log di journald a 50MB
#echo "➤ Pulizia log journald (max 50MB)"
#sudo journalctl --vacuum-size=50M

echo "✅ Pulizia completata!"
