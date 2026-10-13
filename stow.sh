#!/bin/bash

rm_if_link() { [ ! -L "$1" ] || rm -v "$1"; }
rm_if_not_link() { [ -L "$1" ] || rm -rfv "$1"; }

# Pre-create so stow links files inside it instead of folding the whole
# directory into the repo (apps install their own .desktop files here).
mkdir -p ~/.local/share/applications
install -d -m 700 ~/.local/share/gnupg # gpg rejects a group-writable homedir
mkdir -p ~/.config/systemd/user

# remove existing files/dirs
rm_if_not_link ~/.bin
rm_if_not_link ~/.bashrc
rm_if_not_link ~/.bash_logout
rm_if_not_link ~/.bash_profile
rm_if_not_link ~/.xinitrc
rm_if_not_link ~/.inputrc
rm_if_not_link ~/.config/lazygit
rm_if_not_link ~/.config/picom
rm_if_not_link ~/.config/nvim/lua/user
rm_if_not_link ~/.local/share/gnupg/gpg-agent.conf
rm_if_not_link ~/.local/share/gnupg/scdaemon.conf

# Links left behind by files that moved or were removed from either repo
# would block stow; only dangling links into a stowed home/ are removed.
find ~ -maxdepth 4 \( -path ~/.cache -o -path ~/.local/share/docker \) -prune -o \
  -xtype l \( -lname '*/dotfiles/home/*' -o -lname '*/dotfiles-personal/home/*' \) -exec rm -v {} +

personal=0
[ -n "$(find dotfiles-personal -maxdepth 0 -empty)" ] || personal=1
# The personal layer prepares its own targets (functions above are available).
if [ $personal = 1 ] && [ -f dotfiles-personal/pre-stow.sh ]; then
  . dotfiles-personal/pre-stow.sh
fi

stow home -v -t ~ 2>&1 || exit 1
if [ $personal = 1 ]; then
  cd dotfiles-personal || exit 1
  stow home -v -t ~ || exit 1
  cd ..
fi

# Index the stowed .desktop files (nvim.desktop MimeType) for xdg-mime.
update-desktop-database ~/.local/share/applications

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
