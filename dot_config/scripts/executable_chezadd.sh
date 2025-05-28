#!/bin/bash

# Cartelle da monitorare
DOTFILES_DIRS=(
  "$HOME/.config/scripts"
  "$HOME/.config/rofi"
  "$HOME/.config/i3"
  "$HOME/.config/installers"
  "$HOME/.config/kitty"
  "$HOME/.config/polybar"
  "$HOME/.local/share/applications"
)

echo "📦 Aggiunta dei file modificati o nuovi a chezmoi..."

for path in "${DOTFILES_DIRS[@]}"; do
  if [ -e "$path" ]; then
    if [ -d "$path" ]; then
      # Se è una directory, aggiungi tutti i file contenuti
      find "$path" -type f | while read -r file; do
        chezmoi add "$file"
        echo "➕ Aggiunto: $file"
      done
    else
      # Se è un singolo file
      chezmoi add "$path"
      echo "➕ Aggiunto: $path"
    fi
  else
    echo "⚠️  Non trovato: $path"
  fi
done

echo "✅ Sincronizzazione completata!"
