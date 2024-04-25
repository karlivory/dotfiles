# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
    fi
fi

if [[ "$(tty)" = "/dev/tty1" ]]; then
	pgrep dwm || mkdir -p "$HOME/.startxlog" && startx -- -keeptty 2>&1 >> "$HOME/.startxlog/xorg_$(date +%F).log"
fi
. "$HOME/.cargo/env"
