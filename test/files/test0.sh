#!/bin/bash

# to be run as root

adduser karl
usermod -aG sudo karl
echo "karl ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/karl
su - karl -c 'git clone https://github.com/karlivory/config "$HOME/config" && cd "$HOME/config" && ./run.sh system'
