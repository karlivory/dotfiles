# TODO: more elegant way to enable/start picom
systemctl --user enable picom && systemctl --user start picom
systemctl --user enable syncthing && systemctl --user start syncthing

# fixes slow gtk application (thunar, virt-manager etc) startup issue
dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY

remaps
set_default_wallpaper

unclutter -noevents &
wrap "$HOME/.config/luastatus/statusbar.sh" &
sxhkd &
xrdb -merge -I$HOME $HOME/.config/X11/.Xresources

exec dwm
