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


#set -gx PATH $PATH $HOME/.config/scripts
set -gx MICRO_TRUECOLOR 1
set -gx EDITOR micro
set -x CALCHISTFILE ~/.local/state/calc/history
set -Ux FIGLET_FONTDIR ~/.config/figletfonts

abbr -a md mkdir -p
abbr -a ff fastfetch
abbr -a v micro
abbr -a cf 'chezmoi edit ~/.config/fish/config.fish'
abbr -a ytd "yt-dlp --remote-components ejs:github"

# confirm deleting files
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias ls='eza -al --color=auto --group-directories-first' # my preferred listing
alias la='eza -a --color=auto --group-directories-first'  # all files and dirs
alias ll='eza -l --color=auto --group-directories-first'  # long format
alias lt='eza -aT' # tree listing
alias l.='eza -ald .* --color=auto'

alias chox="chmod +x"

alias cfish='chezmoi edit ~/.config/fish/config.fish; chezmoi apply'
#alias ytdl="yt-dlp --remote-components ejs:github"
alias go2bios="sudo systemctl reboot --firmware-setup"

# pyenv (safe for fish)
set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin

# AI safe launch wrappers
function __aiwrapper
    set -l cmd $argv[1]
    set -e argv[1]

    if not test -x $cmd
        echo "wrapper error: executable not found: $cmd" >&2
        return 127
    end

    firejail --noprofile \
        --private=/home/mattia/AAA/AIworkspace \
        --private-tmp \
        bash -lc '
            export GNUPGHOME="$HOME/.config/.gnupg"
            mkdir -p "$GNUPGHOME"
            chmod 700 "$GNUPGHOME"
            cd "$HOME" && exec "$0" "$@"
        ' $cmd $argv
end

function gg
    __aiwrapper /usr/local/bin/gemini-real $argv
end

function cx
    __aiwrapper /usr/local/bin/codex-real $argv
end
