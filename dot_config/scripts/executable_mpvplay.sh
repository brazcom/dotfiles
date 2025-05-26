#!/bin/bash

file=$(realpath "$1")
dir=$(dirname "$file")

mapfile -t files < <(find "$dir" -maxdepth 1 -type f \( -iname "*.mp3" -o -iname "*.flac" -o -iname "*.ogg" -o -iname "*.opus" -o -iname "*.wav" -o -iname "*.m4a" -o -iname "*.aac" \) -exec realpath {} \; | sort)

echo "File selezionato: $file"
echo "File trovati nella cartella:"
for f in "${files[@]}"; do
  echo "[$f]"
done

start_idx=-1
for i in "${!files[@]}"; do
  if [[ "${files[i]}" == "$file" ]]; then
    start_idx=$i
    break
  fi
done

if (( start_idx == -1 )); then
  echo "File selezionato non trovato nella lista."
  exit 1
fi

playlist=("${files[@]:start_idx}")

echo "Playlist da riprodurre:"
printf '%s\n' "${playlist[@]}"

mpv --player-operation-mode=pseudo-gui "${playlist[@]}"
