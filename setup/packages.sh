#!/usr/bin/env bash

# Everything the public components need, installed before them: stow (and
# update-desktop-database for stow.sh), the build dependencies of the suckless
# tools and luastatus (with its plugins), Xorg to run them, and the YubiKey tools.
setup_packages() {
  local -a packages=(
    build-essential
    cmake
    desktop-file-utils
    git
    libasound2-dev
    libdbus-1-dev
    libfontconfig1-dev
    libfreetype-dev
    libharfbuzz-dev
    libimlib2-dev
    liblua5.1-0-dev
    libnl-3-dev
    libnl-genl-3-dev
    libpam0g-dev
    libudev-dev
    libx11-dev
    libx11-xcb-dev
    libxcb-ewmh-dev
    libxcb-icccm4-dev
    libxcb-res0-dev
    libxcb-xrm-dev
    libxft-dev
    libxinerama-dev
    libxrandr-dev
    libxrender-dev
    libyajl-dev
    lua5.1
    pkg-config
    python3-docutils
    stow
    xorg
    xutils-dev
  )
  # YubiKey for gpg and SSH, needed to clone dotfiles-personal (gpg-agent and
  # its sockets come with Ubuntu's gnupg; scdaemon.conf shares the key with pcscd).
  local -a yubikey=(
    pcscd
    pinentry-qt
    scdaemon
  )
  root apt-get install -y --no-install-recommends "${packages[@]}" "${yubikey[@]}"
}
