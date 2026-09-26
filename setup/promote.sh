#!/usr/bin/env bash
set -euo pipefail

SETUP_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
# shellcheck source=setup/lib.sh
source "$SETUP_DIR/lib.sh"

[[ $# -eq 0 ]] || die "Usage: setup/promote.sh"
[[ $(id -un) == "$SETUP_USER" ]] || die "Run as $SETUP_USER, not root"

https_origin=https://github.com/karlivory/dotfiles
ssh_origin=git@github.com:karlivory/dotfiles.git
origin=$(git -C "$REPO_DIR" config --get remote.origin.url) || die "No origin remote is configured"
case $origin in
  "$https_origin" | "$https_origin.git" | "$ssh_origin") ;;
  *) die "Refusing to replace unexpected origin: $origin" ;;
esac

if [[ $origin == "$ssh_origin" && -e $REPO_DIR/dotfiles-personal/.git ]]; then
  echo "Already promoted: private submodule is initialized and origin uses SSH."
  exit 0
fi

# GitHub prints an authentication success message but normally exits with 1
# because it does not offer an interactive shell.
ssh_status=0
ssh_output=$(ssh -o BatchMode=yes -o ConnectTimeout=10 -T git@github.com 2>&1) || ssh_status=$?
if ((ssh_status > 1)) || [[ $ssh_output != *"successfully authenticated"* ]]; then
  printf 'GitHub SSH authentication failed:\n%s\n' "$ssh_output" >&2
  die "Configure your SSH key and verify github.com in known_hosts before retrying"
fi
echo "$ssh_output"

if [[ ! -e $REPO_DIR/dotfiles-personal/.git ]]; then
  git -C "$REPO_DIR" submodule update --init -- dotfiles-personal
fi
[[ -e $REPO_DIR/dotfiles-personal/.git ]] || die "dotfiles-personal was not initialized"

if [[ $origin != "$ssh_origin" ]]; then
  git -C "$REPO_DIR" remote set-url origin "$ssh_origin"
fi
echo "Promotion complete: dotfiles-personal is initialized and origin uses $ssh_origin"
