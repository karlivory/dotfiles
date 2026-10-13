#!/usr/bin/env bash

set -euo pipefail

SETUP_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
REPO_DIR=$(cd -- "$SETUP_DIR/.." && pwd)
# Accepted origins; promote.sh moves HTTPS clones to SSH.
HTTPS_ORIGIN=https://github.com/karlivory/dotfiles
SSH_ORIGIN=git@github.com:karlivory/dotfiles.git
# shellcheck source=config.sh
source "$REPO_DIR/config.sh"
# Optional private layer: extra components, files and settings (see setup.sh).
PERSONAL_DIR=$REPO_DIR/dotfiles-personal
PERSONAL_SETUP_DIR=$PERSONAL_DIR/setup
# shellcheck source=/dev/null
[[ ! -f $PERSONAL_SETUP_DIR/config.sh ]] || source "$PERSONAL_SETUP_DIR/config.sh"
# Untracked per-machine overrides; see config.local.sh.example. First run records
# the invoking user, plus whatever the layer's personal_first_run_config prints.
if [[ ! -f $REPO_DIR/config.local.sh ]]; then
  {
    echo '# Per-machine overrides of config.sh (untracked).'
    echo "SETUP_USER=$SETUP_USER"
    if declare -F personal_first_run_config >/dev/null; then personal_first_run_config; fi
  } >"$REPO_DIR/config.local.sh"
fi
# shellcheck source=/dev/null
[[ ! -f $REPO_DIR/config.local.sh ]] || source "$REPO_DIR/config.local.sh"
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
is_chroot() {
  local detected pid1_root current_root
  if command -v systemd-detect-virt >/dev/null; then
    if detected=$(systemd-detect-virt --chroot 2>&1); then return 0; fi
    [[ -n $detected ]] || return 1
  fi
  pid1_root=$(stat -Lc '%d:%i' /proc/1/root 2>/dev/null) ||
    die "Cannot determine whether this is a chroot; mount /proc before running setup"
  current_root=$(stat -Lc '%d:%i' / 2>/dev/null) || die "Cannot inspect root directory"
  [[ $pid1_root != "$current_root" ]]
}
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
# An unchanged file still gets its mode corrected.
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
  elif ((8#$(root stat -c %a "$dest") != 8#$mode)); then
    root chmod "$mode" "$dest"
    log "Set mode $mode on $dest"
    WRITE_CHANGED=1
  else
    WRITE_CHANGED=0
  fi
  rm -f "$temp"
}

# Print the path of a setup file, preferring the personal layer's copy.
setup_file() {
  local relative=$1 dir
  for dir in "$PERSONAL_SETUP_DIR/files" "$SETUP_DIR/files"; do
    if [[ -f $dir/$relative ]]; then
      printf '%s\n' "$dir/$relative"
      return
    fi
  done
  return 1
}

# Replace each @NAME@ on stdin with the value of $NAME.
render_template() {
  local line name
  while IFS= read -r line || [[ -n $line ]]; do
    while [[ $line =~ @([A-Z][A-Z0-9_]*)@ ]]; do
      name=${BASH_REMATCH[1]}
      [[ -v $name ]] || die "Template variable $name is not set"
      line=${line//"@$name@"/"${!name}"}
    done
    printf '%s\n' "$line"
  done
}

# Source files mirror their /etc destinations. .in files are templates.
install_config() {
  local relative=$1 mode=${2:-0644} source_file temp
  source_file=$(setup_file "$relative") || die "Missing setup file: $relative"
  temp=$(mktemp)
  if [[ $relative == *.in ]]; then
    render_template <"$source_file" >"$temp"
  else
    cp "$source_file" "$temp"
  fi
  write_root "/${relative%.in}" "$mode" <"$temp"
  rm -f "$temp"
}

# apt_key and apt_source set APT_SOURCES_CHANGED=1 when they change a file;
# callers reset it and run apt-get update only when it is set.
apt_key() {
  local name=$1 url=$2 temp
  need curl
  need gpg
  temp=$(mktemp)
  curl -fsSL "$url" | gpg --dearmor >"$temp"
  write_root "/etc/apt/keyrings/$name.gpg" <"$temp"
  ((WRITE_CHANGED == 0)) || APT_SOURCES_CHANGED=1
  rm -f "$temp"
}

# Uses files/etc/apt/sources.list.d/<name>.sources, or its .in template.
apt_source() {
  local file=etc/apt/sources.list.d/$1.sources
  setup_file "$file" >/dev/null || file+=.in
  install_config "$file"
  ((WRITE_CHANGED == 0)) || APT_SOURCES_CHANGED=1
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
