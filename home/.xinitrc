# TODO: more elegant way to enable/start picom
systemctl --user enable picom && systemctl --user start picom
systemctl --user enable syncthing && systemctl --user start syncthing
systemctl --user enable redshift && systemctl --user start redshift

# fixes slow gtk application (thunar, virt-manager etc) startup issue
dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY

remaps

unclutter -noevents &
wrap "$HOME/.config/luastatus/statusbar.sh" &
sxhkd &
xrdb -merge -I$HOME $HOME/.config/X11/.Xresources

autorandr -c
set_default_wallpaper

exec dwm
