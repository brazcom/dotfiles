if status is-login
    if test -z "$DISPLAY"; and test "$XDG_VTNR" = "1"
        set -x XAUTHORITY "$XDG_RUNTIME_DIR/Xauthority"
        startx ~/.config/.xinitrc
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

alias ls='lsd'
alias tree='exa --tree'
alias ll='exa -alh'
alias cdwm='chezmoi edit ~/.config/dwm/config.h; chezmoi apply'
alias mdwm='cd ~/.config/dwm; sudo make clean install'
alias cfish='chezmoi edit ~/.config/fish/config.fish; chezmoi apply'

# pyenv (safe for fish)
set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin
