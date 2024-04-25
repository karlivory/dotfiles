#!/bin/bash

if [ "$0" != "./unstow.sh" ]; then
    echo -e "\033[33mWARNING: script was run outside of its directory. Fixing...\033[0m"
    cd "$(dirname "$0")"
fi

stow -D home -t ~
if [ ! "$(find dotfiles-personal -maxdepth 0 -empty)" ]; then
    echo "stowing personal dotfiles"
    cd dotfiles-personal
    stow -D home -t ~
    cd ..
fi

echo "done"
