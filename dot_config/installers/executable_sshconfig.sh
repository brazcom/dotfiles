#!/bin/bash

# Script per configurazione automatica SSH per GitHub
# Author: Setup automatico per bassinimattia@gmail.com

set -e  # Esce se qualsiasi comando fallisce

EMAIL="sobahighroller@gmail.com"
SSH_DIR="$HOME/.ssh"
KEY_FILE="$SSH_DIR/id_ed25519"
FISH_CONFIG="$HOME/.config/fish/config.fish"

echo "🔧 Configurazione SSH per GitHub in corso..."
echo "📧 Email: $EMAIL"
echo ""

# Crea la directory .ssh se non esiste
if [ ! -d "$SSH_DIR" ]; then
    echo "📁 Creazione directory $SSH_DIR..."
    mkdir -p "$SSH_DIR"
    chmod 700 "$SSH_DIR"
fi

# Genera la chiave SSH se non esiste già
if [ ! -f "$KEY_FILE" ]; then
    echo "🔑 Generazione chiave SSH ED25519..."
    ssh-keygen -t ed25519 -C "$EMAIL" -f "$KEY_FILE" -N ""
    echo "✅ Chiave SSH generata: $KEY_FILE"
else
    echo "⚠️  Chiave SSH già esistente: $KEY_FILE"
fi

# Avvia ssh-agent e aggiunge la chiave
echo "🚀 Avvio ssh-agent e aggiunta chiave..."
eval "$(ssh-agent -s)"
ssh-add "$KEY_FILE"
echo "✅ Chiave aggiunta a ssh-agent"

# Configura fish per avviare automaticamente ssh-agent
echo "🐠 Configurazione fish shell..."

# Crea la directory config di fish se non esiste
FISH_CONFIG_DIR="$(dirname "$FISH_CONFIG")"
if [ ! -d "$FISH_CONFIG_DIR" ]; then
    echo "📁 Creazione directory $FISH_CONFIG_DIR..."
    mkdir -p "$FISH_CONFIG_DIR"
fi

# Backup del config esistente se presente
if [ -f "$FISH_CONFIG" ]; then
    echo "💾 Backup configurazione fish esistente..."
    cp "$FISH_CONFIG" "$FISH_CONFIG.backup.$(date +%Y%m%d_%H%M%S)"
fi

# Aggiunge la configurazione ssh-agent a fish
echo "📝 Aggiunta configurazione ssh-agent a fish..."

cat >> "$FISH_CONFIG" << 'EOF'

# ===== SSH AGENT AUTO-START =====
# Configurazione automatica per ssh-agent
if not pgrep -u (whoami) ssh-agent > /dev/null
    eval (ssh-agent -c) > /dev/null
    set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
    set -Ux SSH_AGENT_PID $SSH_AGENT_PID
end

# Aggiungi automaticamente la chiave se non è già caricata
if not ssh-add -l > /dev/null 2>&1
    ssh-add ~/.ssh/id_ed25519 > /dev/null 2>&1
end
# ===== END SSH AGENT CONFIG =====

EOF

echo "✅ Configurazione fish completata"

# Mostra la chiave pubblica
echo ""
echo "🔓 La tua chiave pubblica SSH:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
cat "$KEY_FILE.pub"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Copia automaticamente negli appunti se xclip è disponibile
if command -v xclip > /dev/null 2>&1; then
    cat "$KEY_FILE.pub" | xclip -selection clipboard
    echo "📋 Chiave copiata negli appunti automaticamente!"
elif command -v xsel > /dev/null 2>&1; then
    cat "$KEY_FILE.pub" | xsel --clipboard --input
    echo "📋 Chiave copiata negli appunti automaticamente!"
fi

echo ""
echo "🎉 CONFIGURAZIONE COMPLETATA!"
echo ""
echo "📋 PROSSIMI PASSI:"
echo "1. Copia la chiave pubblica mostrata sopra"
echo "2. Vai su GitHub.com → Settings → SSH and GPG keys"
echo "3. Clicca 'New SSH key'"
echo "4. Incolla la chiave e dai un titolo descrittivo"
echo "5. Salva la chiave"
echo ""
echo "🧪 Per testare la connessione:"
echo "   ssh -T git@github.com"
echo ""
echo "🔄 Riavvia fish o esegui 'source ~/.config/fish/config.fish' per applicare le modifiche"

# Test automatico della connessione se richiesto
read -p "🧪 Vuoi testare subito la connessione a GitHub? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🔍 Test connessione GitHub..."
    if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
        echo "✅ Connessione GitHub riuscita!"
    else
        echo "⚠️  Aggiungi prima la chiave su GitHub, poi testa con: ssh -T git@github.com"
    fi
fi

echo ""
echo "🏁 Script completato!"
