if [[ "$(tty)" = "/dev/tty1" ]]; then
	pgrep dwm || mkdir -p "$HOME/.startxlog" && startx -- -keeptty 2>&1 >> "$HOME/.startxlog/xorg_$(date +%F).log"
fi
