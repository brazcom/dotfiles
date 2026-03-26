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


set -gx PATH $PATH $HOME/.config/scripts
set -gx MICRO_TRUECOLOR 1
set -gx EDITOR micro
set -x CALCHISTFILE ~/.local/state/calc/history
set -Ux FIGLET_FONTDIR ~/.config/figletfonts

alias ls='lsd'
alias tree='exa --tree'
alias ll='exa -alh'
alias cfish='chezmoi edit ~/.config/fish/config.fish; chezmoi apply'
alias pf="/home/mattia/vaults/arch-vault/AIworkspace/Crypto/portfolio.py"
alias cm="/home/mattia/vaults/arch-vault/AIworkspace/Crypto/monitor.sh"
alias ccc="chromium --user-data-dir=$HOME/.chromium-crypto --disable-sync"
alias eu="/home/mattia/vaults/arch-vault/AIworkspace/Crypto/fx_rate.py"
alias ytdl="yt-dlp --remote-components ejs:github"

# pyenv (safe for fish)
set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin

function gg
    firejail --noprofile \
        --private=/home/mattia/AAA/AIworkspace \
        --private-tmp \
        bash -lc '
            export GNUPGHOME="$HOME/.config/.gnupg"
            mkdir -p "$GNUPGHOME"
            chmod 700 "$GNUPGHOME"
            cd "$HOME" && exec /usr/local/bin/gemini-real "$@"
        ' -- $argv
end

function cx
    firejail --noprofile \
        --private=/home/mattia/AAA/AIworkspace \
        --private-tmp \
        bash -lc '
            export GNUPGHOME="$HOME/.config/.gnupg"
            mkdir -p "$GNUPGHOME"
            chmod 700 "$GNUPGHOME"
            cd "$HOME" && exec /usr/local/bin/codex-real "$@"
        ' -- $argv
end
