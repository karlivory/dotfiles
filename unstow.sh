#!/bin/bash
# Remove the links stow.sh made: the personal layer first, then the public one.

cd "$(dirname "$0")" || exit 1

if [ -n "$(find dotfiles-personal -mindepth 1 -maxdepth 1 2>/dev/null)" ]; then
  (cd dotfiles-personal && stow -D home -v -t ~) || exit 1
fi
stow -D home -v -t ~ || exit 1
