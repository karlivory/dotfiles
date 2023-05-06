#!/bin/bash

if ! zfs list | grep -q rpool/log; then
  sudo zfs create -o canmount=noauto zroot/log
fi
if ! ls /log; then
  sudo zfs mount zroot/log
  if ! ls /log/personal; then
    sudo mkdir -p /log/personal/
    sudo chown karl:karl -R /log/personal/
  fi
  # syncthing
  if ! ls /log/personal/st; then
    sudo mkdir -p /log/personal/st/
    sudo chown karl:karl -R /log/personal/st/
  fi
fi
