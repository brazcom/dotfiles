#!/bin/bash

echo "Incolla l'URL del video YouTube e premi Invio:"
read -r url

# Controlla se l'URL è vuoto o non di YouTube
if [ -z "$url" ]; then
    echo "Errore: Nessun URL inserito."
    exit 1
fi
if [[ ! "$url" =~ youtube\.com|youtu\.be ]]; then
    echo "Errore: L'URL non sembra essere di YouTube."
    exit 1
fi


# Esegui yt-dlp con --ignore-config
yt-dlp --ignore-config --extract-audio --audio-format best --split-chapters --output "%(chapter_number)02d - %(chapter)s.%(ext)s" "$url"

if [ $? -eq 0 ]; then
    echo "Download completato! I file sono nella cartella 'output'."
else
    echo "Errore durante il download. Assicurati che yt-dlp e ffmpeg siano installati."
    echo "Se il problema persiste, verifica l'URL o prova a usare un file di cookie con --cookies cookies.txt."
fi