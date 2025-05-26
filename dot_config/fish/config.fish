set -x LANG en_US.UTF-8
set -x LC_ALL en_US.UTF-8
set -U fish_greeting
if status is-interactive
    # Commands to run in interactive sessions can go here
end
fastfetch -c /home/mattia/.config/fastfetch/config1.jsonc

#My shortcuts
#$ alias yabridgectl="~/.local/share/yabridge/yabridgectl"
export PATH="$PATH:$HOME/.local/share/yabridge"
export PATH="$PATH:$HOME/.config/scripts"

# Created by `pipx` on 2025-05-23 07:49:04
set PATH $PATH /home/mattia/.local/bin

if not set -q SSH_AUTH_SOCK
    eval (ssh-agent -c)
    ssh-add ~/.ssh/id_ed25519
end
