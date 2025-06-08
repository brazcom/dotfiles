set -x LANG en_US.UTF-8
set -x LC_ALL en_US.UTF-8
set -U fish_greeting
if status is-interactive
    # Commands to run in interactive sessions can go here
end

echo "ciao!!"

export PATH="$PATH:$HOME/.config/scripts"
export MICRO_TRUECOLOR=1

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

set -gx EDITOR micro

alias ls='lsd'
alias tree='exa --tree'
alias ll='exa -alh'
alias cdwm='chezmoi edit ~/.config/dwm/config.h; chezmoi apply'
alias mdwm='cd ~/.config/dwm; sudo make clean install'
alias cfish='chezmoi edit ~/.config/fish/config.fish; chezmoi apply'
alias infoz='cd ~/.config/misc; bash welcome; cd'

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

