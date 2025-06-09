if status is-login
    if test -z "$DISPLAY"; and test "$XDG_VTNR" = "1"
        set -x XAUTHORITY "$XDG_RUNTIME_DIR/Xauthority"

        # Log diagnostico su file
        echo "Starting X at (date)" >> ~/.config/.xsession.log

        # Avvia startx e salva output su file di log per debug
        startx ~/.config/.xinitrc >> ~/.config/.xsession.log 2>&1

        # Dopo startx, esci dalla shell
        exit
    end
end

set -x LANG en_US.UTF-8
set -U fish_greeting
set -x CARGO_HOME ~/.cache/.cargo
set -x GNUPGHOME ~/.config/.gnupg

if status is-interactive
    echo "ciao!!"
end

set -gx PATH $PATH $HOME/.config/scripts
set -gx MICRO_TRUECOLOR 1
set -gx EDITOR micro

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

alias ls='lsd'
alias tree='exa --tree'
alias ll='exa -alh'
alias cdwm='chezmoi edit ~/.config/dwm/config.h; chezmoi apply'
alias mdwm='cd ~/.config/dwm; sudo make clean install'
alias cfish='chezmoi edit ~/.config/fish/config.fish; chezmoi apply'
alias infoz='cd ~/.config/misc; bash welcome; cd'
