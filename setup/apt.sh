#!/usr/bin/env bash

APT_PACKAGES=(
  age
  atool
  autorandr
  bat
  bluez
  bluez-alsa-utils
  bridge-utils
  build-essential
  catdoc
  cmake
  cmatrix
  curl
  dbus
  dbus-x11
  dnsmasq
  bind9-dnsutils
  docx2txt
  fastfetch
  dunst
  expect
  fd-find
  feh
  firefox
  ffmpeg
  ffmpegthumbnailer
  firmware-sof-signed
  flameshot
  fontconfig
  fonts-noto-color-emoji
  fzf
  gimp
  gir1.2-nm-1.0
  gir1.2-spiceclientgtk-3.0
  gnupg
  google-chrome-stable
  highlight
  htop
  intel-media-va-driver-non-free
  jq
  libasound2-dev
  libdbus-1-dev
  libfontconfig1-dev
  libfreetype-dev
  libharfbuzz-dev
  libimage-exiftool-perl
  libimlib2-dev
  liblua5.1-0-dev
  libnl-3-dev
  libnl-genl-3-dev
  libpam-yubico
  libpam0g-dev
  libtool
  libudev-dev
  libvirt-clients
  libvirt-daemon-system
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
  libyubikey-udev
  libyubikey0
  lua5.1
  luarocks
  lxrandr
  lynx
  mdp
  mediainfo
  moreutils
  mpv
  ncal
  ncurses-term
  net-tools
  network-manager-gnome
  odt2txt
  openjdk-17-jdk-headless
  openjdk-21-jdk-headless
  openjdk-25-jdk-headless
  openvpn-systemd-resolved
  7zip
  parallel
  pcscd
  picom
  pinentry-qt
  pkg-config
  psmisc
  pulseaudio-module-bluetooth
  pulsemixer
  python-is-python3
  python3-docutils
  python3-pip
  python3-pynvim
  python3.14-venv
  ranger
  redshift
  ripgrep
  rsync
  rustup
  sanoid
  scdaemon
  shellcheck
  shfmt
  software-properties-common
  stow
  sxhkd
  sxiv
  thunar
  tmux
  tree
  ufw
  unclutter
  unrar
  unzip
  virt-manager
  virtualenv
  vlc
  wpasupplicant
  xbindkeys
  xcape
  xcb
  xclip
  xdotool
  xorg
  xutils-dev
  xvkbd
  yubico-piv-tool
  yubikey-manager
  zathura
  zfsutils-linux
)

# curl/gnupg are needed to provision signed repositories on a clean host.
APT_PREREQUISITES=(
  ca-certificates
  curl
  gnupg
)

apt_key() {
  local name=$1 url=$2 temp
  temp=$(mktemp)
  curl -fsSL "$url" | gpg --dearmor >"$temp"
  write_root "/etc/apt/keyrings/$name.gpg" <"$temp"
  ((WRITE_CHANGED == 0)) || APT_SOURCES_CHANGED=1
  rm -f "$temp"
}

apt_source() {
  local dest=$1
  install_config "etc/apt/sources.list.d/$dest.sources"
  ((WRITE_CHANGED == 0)) || APT_SOURCES_CHANGED=1
}

setup_apt_ubuntu_sources() {
  local legacy=/etc/apt/sources.list content
  if root test -f "$legacy"; then
    content=$(root sed -e '/^[[:space:]]*#/d' -e '/^[[:space:]]*$/d' "$legacy")
    [[ $content == 'deb http://archive.ubuntu.com/ubuntu resolute main' ]] ||
      die "Refusing to replace custom $legacy; migrate its entries to ubuntu.sources manually"
    backup_root_file "$legacy"
  fi
  install_config etc/apt/sources.list.d/ubuntu.sources
  if root test -f "$legacy"; then root rm -- "$legacy"; fi
}

setup_apt_repositories() {
  install_config etc/apt/preferences.d/custom.pref
  root mkdir -p /etc/apt/keyrings
  apt_key google https://dl.google.com/linux/linux_signing_key.pub
  apt_key lens https://downloads.k8slens.dev/keys/gpg
  apt_key mozilla https://packages.mozilla.org/apt/repo-signing-key.gpg
  apt_source google
  apt_source lens
  apt_source mozilla
  if ((APT_SOURCES_CHANGED)); then root apt-get update; fi
}

setup_apt_packages() {
  root apt-get install -y --no-install-recommends "${APT_PACKAGES[@]}"
  # GNOME purge intentionally omitted.
}

setup_apt() {
  APT_SOURCES_CHANGED=0
  run_step "Ubuntu sources" setup_apt_ubuntu_sources
  run_step "apt cache" root apt-get update
  run_step "prerequisites" root apt-get install -y --no-install-recommends "${APT_PREREQUISITES[@]}"
  run_step "repositories" setup_apt_repositories
  run_step "packages" setup_apt_packages
}
