#!/bin/bash
# to be run as root
USERNAME=karl

apt update
adduser $USERNAME --shell /bin/bash --gecos "user" --disabled-password
usermod -aG sudo $USERNAME
echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/nopasswd

su - $USERNAME -c 'rm -rf "$HOME/config" && git clone https://github.com/karlivory/config "$HOME/config" && cd "$HOME/config" && sed -i "s/^vm:.*/vm: true/g" vars/main.yml && ./run.sh'
