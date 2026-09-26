#!/usr/bin/env bash

setup_brew_tap() {
  local tap=$1 formula_dir=$2
  as_user mkdir -p "$tap"
  if [[ ! -L $tap/Formula ]]; then
    [[ ! -e $tap/Formula ]] || die "$tap/Formula exists and is not a symlink"
    as_user ln -s "$formula_dir" "$tap/Formula"
  elif [[ $(readlink "$tap/Formula") != "$formula_dir" ]]; then
    as_user ln -sfn "$formula_dir" "$tap/Formula"
  fi
}

setup_brew_font() {
  local brew=$1
  if ! as_user "$brew" list --cask font-ubuntu-mono-nerd-font >/dev/null 2>&1; then
    as_user "$brew" install --cask font-ubuntu-mono-nerd-font
    as_user fc-cache -fv
  fi
}

setup_brew_prefix() {
  # Homebrew's Linux installer needs a writable ancestor of its default prefix.
  # Do not change ownership of an existing directory that may belong to someone else.
  [[ $BREW_PREFIX == /home/linuxbrew/.linuxbrew ]] || return 0
  local parent=/home/linuxbrew
  [[ ! -L $parent ]] || die "$parent is a symlink; review it before installing Homebrew"
  if [[ ! -e $parent ]]; then
    root install -d -m 0755 -o "$SETUP_USER" -g "$(id -gn "$SETUP_USER")" "$parent"
  fi
  if ! as_user test -d "$parent" || ! as_user test -w "$parent" || ! as_user test -x "$parent"; then
    die "$parent must be a writable directory for $SETUP_USER; refusing to change existing permissions"
  fi
}

setup_brew_install() {
  local installer
  installer=$(as_user curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)
  as_user env NONINTERACTIVE=1 HOMEBREW_NO_SUDO=1 /bin/bash -c "$installer"
}

setup_brew() {
  local brew=$BREW_PREFIX/bin/brew tap=$BREW_PREFIX/Homebrew/Library/Taps/karl/homebrew-local
  local formula_dir=$SETUP_HOME/.config/homebrew-formulas
  local -a formulas=(
    karl/local/lazygit
    karl/local/jetbrains-toolbox
    karl/local/typing-test
    fnm
    go
    helm
    lf
    neovim
    yt-dlp
  )
  need curl
  if [[ ! -x $brew ]]; then
    run_step "Homebrew prefix" setup_brew_prefix
    run_step "install Homebrew" setup_brew_install
  fi
  [[ -x $brew ]] || die "Homebrew not found at $brew (check config.sh)"
  run_step "update" as_user "$brew" update
  [[ -d $formula_dir ]] || die "Run stow first (missing $formula_dir)"
  run_step "local tap" setup_brew_tap "$tap" "$formula_dir"
  run_step "formulas" as_user "$brew" install "${formulas[@]}"
  run_step "font" setup_brew_font "$brew"
}
