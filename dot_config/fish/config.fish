set -x LANG en_US.UTF-8
set -x LC_ALL en_US.UTF-8
set -U fish_greeting
if status is-interactive
    # Commands to run in interactive sessions can go here
end
fastfetch -c /home/mattia/.config/fastfetch/config1.jsonc

export PATH="$PATH:$HOME/.config/scripts"

# Avvia ssh-agent se non è già in esecuzione
if not pgrep -u (whoami) ssh-agent > /dev/null
    eval (ssh-agent -c) > /dev/null
    set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
    set -Ux SSH_AGENT_PID $SSH_AGENT_PID
end

# Aggiungi automaticamente la chiave se non è già caricata
if not ssh-add -l > /dev/null 2>&1
    ssh-add ~/.ssh/id_ed25519 > /dev/null 2>&1
end

set -gx EDITOR nano

function chezmoipush
    chezmoi git add .
    and chezmoi git commit -- -m "Update dotfiles"
    and chezmoi git push
end
