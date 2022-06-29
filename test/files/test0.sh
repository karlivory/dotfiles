#!/bin/bash

# to be run as root
USERNAME=karl

adduser $USERNAME
usermod -aG sudo $USERNAME
echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/nopasswd
su - $USERNAME -c 'git clone https://github.com/karlivory/config "$HOME/config" && cd "$HOME/config" && sed -i "s/^vm:.*/vm: true/g" vars/main.yml && ./run.sh system'
