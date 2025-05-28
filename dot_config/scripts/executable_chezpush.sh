#!/bin/bash

# Naviga nella directory dei dotfiles gestiti da chezmoi
cd "$(chezmoi source-path)" || exit 1

# Aggiunge, committa e pusha le modifiche
chezmoi git add .
chezmoi git commit -- -m "Update dotfiles"
chezmoi git push
