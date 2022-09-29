#!/bin/bash

if [ "$0" != "./stow.sh" ]; then
    echo -e "\033[33mWARNING: script was run outside of its directory. Fixing...\033[0m"
    cd "$(dirname "$0")"
fi

rm_if_link() { [ ! -L "$1" ] || rm -v "$1"; }
rm_if_not_link() { [ -L "$1" ] || rm -rfv "$1"; }

# remove existing files/dirs
rm_if_not_link ~/.bin
rm_if_not_link ~/.bashrc
rm_if_not_link ~/.ideavimrc
rm_if_not_link ~/.bash_logout
rm_if_not_link ~/.bash_profile
rm_if_not_link ~/.xinitrc
rm_if_not_link ~/.inputrc
mkdir -p ~/.config
rm_if_not_link ~/.config/picom
rm_if_not_link ~/.config/ranger
rm_if_not_link ~/.config/nvim
rm_if_not_link ~/.config/user-dirs.dirs
rm_if_not_link ~/.config/mimeapps.list

mkdir -p ~/.config/systemd/user

stow dotfiles -t ~
if [ ! $(find config_personal -maxdepth 0 -empty) ]; then
    echo "stowing personal dotfiles"
    cd config_personal
    stow dotfiles_personal -t ~
    cd ..
fi

# Init themes if they do not exist
if [ ! -f ~/.config/themes/dwm/theme ]; then
    cp ~/.config/themes/dwm/gruvbox ~/.config/themes/dwm/theme
fi
if [ ! -f ~/.config/themes/dmenu/theme ]; then
    cp ~/.config/themes/dmenu/gruvbox ~/.config/themes/dmenu/theme
fi
if [ ! -f ~/.config/themes/luastatus/theme ]; then
    cp ~/.config/themes/luastatus/gruvbox.lua ~/.config/themes/luastatus/color.lua
fi

echo "done"
