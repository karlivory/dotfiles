#!/usr/bin/env bash
# Machine settings. Override per host in config.local.sh (untracked) instead of editing here.
SETUP_USER=${SUDO_USER:-$(id -un)}
ROOT_ZFS_DATASET=zroot/ROOT/ubuntu
DOCKER_ZFS_DATASET=zroot/docker
DATA_DIR=/setup
DOCKER_DATA_DIR=/docker
BREW_PREFIX=/home/linuxbrew/.linuxbrew
LUASTATUS_REV=8d88d258d88e5de7f01ec44d72b2dae3982d1d67
