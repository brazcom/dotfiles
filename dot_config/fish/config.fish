set -x LANG en_US.UTF-8
set -x LC_ALL en_US.UTF-8
set -U fish_greeting
if status is-interactive
    # Commands to run in interactive sessions can go here
end
fastfetch -c /home/mattia/.config/fastfetch/config1.jsonc

export PATH="$PATH:$HOME/.config/scripts"
