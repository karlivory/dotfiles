#!/bin/bash

rm_if_link() { [ ! -L "$1" ] || rm -v "$1"; }
rm_if_not_link() { [ -L "$1" ] || rm -rfv "$1"; }

mkdir -p ~/.local/share/gnupg
mkdir -p ~/.config/systemd/user

# remove existing files/dirs
rm_if_not_link ~/.bin
rm_if_not_link ~/.bashrc
rm_if_not_link ~/.ideavimrc
rm_if_not_link ~/.bash_logout
rm_if_not_link ~/.bash_profile
rm_if_not_link ~/.xinitrc
rm_if_not_link ~/.inputrc
rm_if_not_link ~/.config/lazygit
rm_if_not_link ~/.config/tmuxinator
rm_if_not_link ~/.config/picom
rm_if_not_link ~/.config/autorandr
rm_if_not_link ~/.config/ranger
rm_if_not_link ~/.config/nvim/lua/user
rm_if_not_link ~/.config/user-dirs.dirs
rm_if_not_link ~/.config/mimeapps.list
rm_if_not_link ~/.local/share/gnupg/gpg.conf
rm_if_not_link ~/.local/share/gnupg/gpg-agent.conf

stow home -v -t ~ 2>&1
if [ ! $(find config_personal -maxdepth 0 -empty) ]; then
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
