#!/usr/bin/env bash
# Machine settings. Override per host in config.local.sh (untracked) instead of editing here.
SETUP_USER=${SUDO_USER:-$(id -un)}
ROOT_ZFS_DATASET=zroot/ROOT/ubuntu
DOCKER_ZFS_DATASET=zroot/docker
DATA_DIR=/setup
DOCKER_DATA_DIR=/docker
BREW_PREFIX=/home/linuxbrew/.linuxbrew
# Pinned upstream commits built by setup/setup.sh desktop (bump here to update).
# Must be full 40-character commit hashes: not branches, tags or abbreviations.
LUASTATUS_REV=8d88d258d88e5de7f01ec44d72b2dae3982d1d67
DWM_REV=4c963b33681b277a0ff4d3bf39a27b2feab68950
ST_REV=aa56259643e29080394ee1e36a833d18027a0628
DMENU_REV=c9a0958b71a55a1b3cad475d535ad99286ead454
SLOCK_REV=3c89626a09a543de104bd766d471f9e16e4e4002
