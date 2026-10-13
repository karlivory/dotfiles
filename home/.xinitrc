# fixes slow gtk application (thunar, virt-manager etc) startup issue; also
# gives the user units below DISPLAY
dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY PATH

# desktop.target pulls in picom; other layers add units with a Wants= drop-in.
systemctl --user start desktop.target gpg-agent.service

remaps

unclutter -noevents &
wrap "$HOME/.config/luastatus/statusbar.sh" &
sxhkd &
xrdb -merge -I$HOME $HOME/.config/X11/.Xresources

autorandr -c
set_default_wallpaper

exec dwm
