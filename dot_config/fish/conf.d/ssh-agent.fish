if status is-interactive
    if not set -q SSH_AUTH_SOCK; or not test -S "$SSH_AUTH_SOCK"
        eval (ssh-agent -c) >/dev/null
    end

    if test -f ~/.ssh/id_ed25519
        ssh-add -l >/dev/null 2>&1
        or ssh-add ~/.ssh/id_ed25519 </dev/null >/dev/null 2>&1
    end
end
