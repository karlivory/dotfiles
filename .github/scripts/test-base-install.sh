#!/usr/bin/env bash
# Smoke test: the public setup installs on a fresh Ubuntu 26.04. Run locally with
#   docker run --rm --mount "type=bind,src=$PWD,dst=/src,readonly" ubuntu:26.04 \
#     bash /src/.github/scripts/test-base-install.sh
set -euo pipefail

# Installs packages and edits sudoers, so it refuses to run outside a container.
[[ -f /.dockerenv && $(id -u) -eq 0 ]] || {
  echo 'Run this test as root inside a disposable Ubuntu 26.04 container.' >&2
  exit 1
}
# shellcheck source=/dev/null
source /etc/os-release
[[ $ID == ubuntu && $VERSION_ID == 26.04 ]]
REPO_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)
export DEBIAN_FRONTEND=noninteractive NO_COLOR=1
USER_NAME=tester
USER_HOME=/home/$USER_NAME
DOTFILES=$USER_HOME/dotfiles

phase() {
  local label=$1 started=${EPOCHREALTIME/./} status=0
  shift
  printf '\n==> %s\n' "$label"
  "$@" || status=$?
  printf 'Test: %s finished in %dms (exit %d)\n' "$label" \
    "$(((${EPOCHREALTIME/./} - started) / 1000))" "$status"
  return "$status"
}

as_tester() { runuser -u "$USER_NAME" -- "$@"; }

# Approximate a debootstrapped system (userland only, no kernel or bootloader):
# ubuntu-minimal brings sudo, locales and the rest; setup.sh installs the others.
phase bootstrap bash -c 'apt-get update && apt-get install -y --no-install-recommends ubuntu-minimal ca-certificates curl'
useradd -m -s /bin/bash "$USER_NAME"
printf '%s ALL=(ALL:ALL) NOPASSWD: ALL\n' "$USER_NAME" >/etc/sudoers.d/base-install-test
chmod 0440 /etc/sudoers.d/base-install-test

# A public-only copy: no private layer, no local config, no git metadata.
install -d -o "$USER_NAME" -g "$USER_NAME" "$DOTFILES" "$DOTFILES/dotfiles-personal"
tar -C "$REPO_DIR" --exclude=./.git --exclude=./dotfiles-personal --exclude=./config.local.sh -cf - . |
  as_tester tar -C "$DOTFILES" -xf -
cd "$DOTFILES"

phase install as_tester setup/setup.sh --verbose --no-spinner
phase repeat-install as_tester setup/setup.sh --verbose --no-spinner

for binary in dwm st dmenu luastatus slock; do
  mode=755
  [[ $binary != slock ]] || mode=4755
  [[ $(stat -c '%u:%g %a' "/usr/local/bin/$binary") == "0:0 $mode" ]] ||
    { echo "Unexpected owner or mode: /usr/local/bin/$binary" >&2; exit 1; }
done
if ldd /usr/local/bin/{dwm,st,dmenu,luastatus,slock} | grep 'not found'; then exit 1; fi
as_tester infocmp st-256color >/dev/null
for link in .bashrc .bin .xinitrc; do
  [[ -L $USER_HOME/$link && -e $USER_HOME/$link ]] || { echo "Not stowed: ~/$link" >&2; exit 1; }
done

# Stow runs as the user: it must work once sudo is no longer available.
rm /etc/sudoers.d/base-install-test
phase stow-without-sudo as_tester setup/setup.sh --verbose --no-spinner stow
printf '\nAll base-install checks passed.\n'
