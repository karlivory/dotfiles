# !/usr/bin/env bash

cd dwm-flexipatch

sudo rm patches.h config.h
cp ../patches.h .
git apply ../dwm.patch
sudo make install
git apply ../dwm.patch --reverse
