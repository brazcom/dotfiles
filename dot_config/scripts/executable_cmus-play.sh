#!/bin/bash

file="$1"
dir=$(dirname "$file")

extensions="mp3|flac|ogg|opus|wav|m4a|aac"

playlist=$(find "$dir" -maxdepth 1 -type f -iregex ".*\.($extensions)" | sort | sed -n "/$(basename "$file")/,\$p")

# Funzione per aggiungere file a cmus tramite cmus-remote
add_files_to_cmus() {
  cmus-remote -C "clear"
  while IFS= read -r f; do
    cmus-remote -C "add \"$f\""
  done <<< "$playlist"
  cmus-remote -C "play"
}

# Controlla se cmus è in esecuzione
if pgrep -x cmus > /dev/null; then
  echo "cmus è già attivo, aggiorno playlist"
  add_files_to_cmus
else
  echo "Avvio cmus in foreground"
  cmus &

  # Aspetta che cmus sia pronto
  for i in {1..10}; do
    sleep 0.3
    cmus-remote -C "status" &>/dev/null && break
  done

  add_files_to_cmus

  # Mantieni lo script aperto finché cmus è vivo
  wait $(pgrep -x cmus)
fi
