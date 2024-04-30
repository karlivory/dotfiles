# !/usr/bin/env bash

cd slock-flexipatch

sudo rm patches.h config.h
cp ../patches.h .
git apply ../slock.patch
sudo make install
git apply ../slock.patch --reverse
