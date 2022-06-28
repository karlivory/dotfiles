#!/bin/bash

if [ "$0" != "./unstow.sh" ]; then
    echo -e "\033[33mWARNING: script was run outside of its directory. Fixing...\033[0m"
    cd "$(dirname "$0")"
fi

rm_if_link(){ [ ! -L "$1" ] || rm -v "$1"; }
rm_if_not_link(){ [ -L "$1" ] || rm -rfv "$1"; }

stow -D dotfiles -t ~
if [ ! $(find config_personal -maxdepth 0 -empty) ]
then
    echo "stowing personal dotfiles"
    cd config_personal
    stow -D dotfiles_personal -t ~
    cd ..
fi

echo "done"
