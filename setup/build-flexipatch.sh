#!/usr/bin/env bash
set -euo pipefail

SETUP_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
# shellcheck source=setup/lib.sh
source "$SETUP_DIR/lib.sh"
# shellcheck source=setup/desktop.sh
source "$SETUP_DIR/desktop.sh"

[[ $# -eq 1 ]] || die "Usage: build-flexipatch.sh <dwm|st|dmenu|slock>"
case $1 in dwm | st | dmenu | slock) ;; *) die "Unknown flexipatch: $1" ;; esac
[[ $(id -u) -eq 0 ]] || die "Run build-flexipatch.sh as root"
setup_desktop "$1"
