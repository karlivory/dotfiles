# !/usr/bin/env bash

cd st-flexipatch

cp ../patches.h .
git apply ../st.patch
sudo make install
git apply ../st.patch --reverse
