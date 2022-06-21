# TODO: more elegant way to enable/start picom
systemctl --user enable picom && systemctl --user start picom
systemctl --user enable syncthing && systemctl --user start syncthing

# fixes slow gtk application (thunar, virt-manager etc) startup issue
dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY

remaps
set_default_wallpaper

unclutter -noevents &
statusbar_wrapper &
sxhkd &

exec dwm
