#!/bin/bash

################### personal log ####################
if ! zfs list | grep -q rpool/log; then
  sudo zfs create -o canmount=noauto rpool/log
fi

if ! ls /log; then
  sudo zfs mount rpool/log
fi

if ! ls /log/personal; then
  sudo mkdir -p /log/personal/
  sudo chown karl:karl -R /log/personal/
fi

if ! ls /log/st; then
  sudo mkdir -p /log/st/
  sudo chown karl:karl -R /log/st/
fi
#####################################################
