#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "run as root" >&2
    exit 1
fi

user_name="${1:-}"
tty_name="${2:-tty1}"
term_type="${3:-linux}"

if [[ -z "$user_name" ]]; then
    echo "usage: $0 <user> [tty] [term]" >&2
    exit 1
fi

if ! id "$user_name" >/dev/null 2>&1; then
    echo "user not found: $user_name" >&2
    exit 1
fi

if ! command -v agetty >/dev/null 2>&1; then
    echo "agetty not found" >&2
    exit 1
fi

service_name="agetty-autologin-${tty_name}"
service_dir="/etc/runit/sv/${service_name}"
persist_link="/etc/runit/runsvdir/default/${service_name}"
current_link="/run/runit/service/${service_name}"

mkdir -p "${service_dir}"

cat > "${service_dir}/run" <<EOF
#!/bin/sh
exec agetty --autologin ${user_name} --noclear ${tty_name} ${term_type}
EOF

chmod +x "${service_dir}/run"

rm -f "/etc/runit/runsvdir/default/agetty-${tty_name}"
rm -f "/run/runit/service/agetty-${tty_name}"

ln -sfn "${service_dir}" "${persist_link}"

if [[ -d /run/runit/service ]]; then
    ln -sfn "${service_dir}" "${current_link}"
fi

cat <<EOF

Autologin service installed.

User: ${user_name}
TTY:  ${tty_name}
TERM: ${term_type}

Persistent link:
  ${persist_link}

Current runlevel link:
  ${current_link}

If ${tty_name} was active already, switch away and back or reboot.
EOF
