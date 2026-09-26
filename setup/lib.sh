#!/usr/bin/env bash

set -euo pipefail

SETUP_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
REPO_DIR=$(cd -- "$SETUP_DIR/.." && pwd)
# shellcheck source=setup/config.sh
source "$SETUP_DIR/config.sh"
SETUP_HOME=$(getent passwd "$SETUP_USER" | cut -d: -f6)
[[ -n $SETUP_HOME ]] || {
  echo "Unknown user: $SETUP_USER" >&2
  exit 1
}

log() { printf '\n==> %s\n' "$*"; }
die() {
  echo "Error: $*" >&2
  exit 1
}
need() { command -v "$1" >/dev/null || die "Missing command: $1"; }
root() {
  [[ $(id -u) -eq 0 ]] || die "Root session required for: $*"
  "$@"
}
as_user() {
  if [[ $(id -un) == "$SETUP_USER" ]]; then
    "$@"
  else
    root runuser -u "$SETUP_USER" -- "$@"
  fi
}

# Keep backups outside managed directories (notably apt's sources.list.d).
backup_root_file() {
  local file=$1 backup_dir
  backup_dir=$DATA_DIR/backups/dotfiles$(dirname "$file")
  if ! root test -d "$DATA_DIR"; then
    root install -d -m 0755 "$DATA_DIR"
  fi
  root install -d -m 0700 "$DATA_DIR/backups/dotfiles"
  root install -d -m 0700 "$backup_dir"
  root cp -a -- "$file" "$backup_dir/$(basename "$file").bak.$(date +%Y%m%d%H%M%S%N)"
}

# Install stdin only when it differs. Preserve the old file once per change.
write_root() {
  local dest=$1 mode=${2:-0644} temp
  temp=$(mktemp)
  cat >"$temp"
  if ! root test -f "$dest" || ! root cmp -s "$temp" "$dest"; then
    root mkdir -p "$(dirname "$dest")"
    if root test -e "$dest"; then
      backup_root_file "$dest"
    fi
    root install -m "$mode" "$temp" "$dest"
    log "Updated $dest"
    WRITE_CHANGED=1
  else
    WRITE_CHANGED=0
  fi
  rm -f "$temp"
}

# Source files mirror their /etc destinations. .in files use config.sh values.
install_config() {
  local relative=$1 source_file=$SETUP_DIR/files/$1 temp line
  [[ -f $source_file ]] || die "Missing setup file: $source_file"
  temp=$(mktemp)
  if [[ $relative == *.in ]]; then
    while IFS= read -r line || [[ -n $line ]]; do
      line=${line//@ROOT_ZFS_DATASET@/$ROOT_ZFS_DATASET}
      line=${line//@DOCKER_DATA_DIR@/$DOCKER_DATA_DIR}
      line=${line//@DOCKER_CODENAME@/${DOCKER_CODENAME:-}}
      line=${line//@DOCKER_ARCH@/${DOCKER_ARCH:-}}
      printf '%s\n' "$line"
    done <"$source_file" >"$temp"
  else
    cp "$source_file" "$temp"
  fi
  write_root "/${relative%.in}" <"$temp"
  rm -f "$temp"
}

# Replace a key-value directive without dropping unrelated settings.
set_directive() {
  local file=$1 key=$2 value=$3 temp
  temp=$(mktemp)
  if root test -f "$file"; then
    root cat "$file" | awk -v key="$key" -v value="$value" '
            $0 ~ "^[[:space:]]*#?[[:space:]]*" key "[[:space:]]*=" {
                if (!found++) print key "=" value
                next
            }
            { print }
            END { if (!found) print key "=" value }
        ' >"$temp"
  else
    printf '%s=%s\n' "$key" "$value" >"$temp"
  fi
  write_root "$file" <"$temp"
  rm -f "$temp"
}
