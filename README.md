# chezmoi.dots

---

## fresh start

### initialize

```bash
chezmoi init --apply brazcom
```

---

### installer scripts

```bash
cd .config/installers
```

-basic packages

```bash
ezbasics.sh
```

-tty autologin

```bash
ezautologin.sh
```

-ssh + github config

```bash
sshconfig.sh
```

---

## daily usage

write local changes to chezmoi:

```bash
chezadd
```

commit and push:

```bash
chezpush
```

---

[chezadd.sh](http://chezadd.sh) monitored directories:

```bash
  "$HOME/.config/scripts"
  "$HOME/.config/rofi"
  "$HOME/.config/i3"
  "$HOME/.config/installers"
  "$HOME/.config/kitty"
  "$HOME/.config/polybar"
  "$HOME/.local/share/applications"
```
