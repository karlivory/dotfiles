# !/usr/bin/env bash

cd dmenu-flexipatch

sudo rm patches.h config.h
cp ../patches.h .
git apply ../dmenu.patch
sudo make install
git apply ../dmenu.patch --reverse
