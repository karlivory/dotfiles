# !/usr/bin/env bash

cd st-flexipatch

sudo rm patches.h config.h
cp ../patches.h .
git apply ../st.patch
sudo make install
git apply ../st.patch --reverse
