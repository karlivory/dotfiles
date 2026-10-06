#!/usr/bin/env bash

setup_desktop() {
  local item=$1
  case $item in
    dwm | st | dmenu | slock | luastatus) ;;
    *) die "Unknown desktop component: $item" ;;
  esac
  "setup_$item"
}

# Fetch one pinned commit into its own user-owned cache dir (<name>-<rev>) and
# print the dir. A new rev gets a new dir; an existing one is reused as is.
fetch_pinned() {
  local name=$1 url=$2 rev=$3 dir
  dir=$SETUP_HOME/.cache/dotfiles/$name-$rev
  need git
  if ! as_user git -C "$dir" cat-file -e "$rev^{commit}" 2>/dev/null; then
    as_user mkdir -p "$dir"
    as_user git -C "$dir" init --quiet
    as_user git -C "$dir" fetch --quiet --depth 1 "$url" "$rev" >&2 ||
      die "Cannot fetch $name revision $rev from $url"
  fi
  printf '%s\n' "$dir"
}

# Build the pinned flexipatch revision (<ITEM>_REV in config.sh) in a disposable
# directory so nothing root-built is left behind.
build_flexipatch() (
  local item=$1 source_dir=$REPO_DIR/$1
  local rev_var=${1^^}_REV rev cache build_dir path mode temp_base=${TMPDIR:-/tmp}
  rev=${!rev_var}
  need make
  need tar
  cache=$(fetch_pinned "$item-flexipatch" "https://github.com/bakkeby/$item-flexipatch" "$rev") || exit 1

  build_dir=$(as_user mktemp -d "$temp_base/flexipatch.XXXXXXXX")
  trap 'as_user rm -rf -- "$build_dir"' EXIT
  as_user git -C "$cache" archive "$rev" | as_user tar -x -C "$build_dir"
  as_user git -C "$build_dir" apply "$source_dir/$item.patch"
  as_user cp "$build_dir/config.def.h" "$build_dir/config.h"
  as_user cp "$source_dir/patches.h" "$build_dir/patches.h"
  as_user make -C "$build_dir"

  # Install into a user-owned staging directory first. Do not copy the
  # upstream dwm.desktop / st.desktop into the live system.
  as_user mkdir -p "$build_dir/terminfo"
  as_user env TERMINFO="$build_dir/terminfo" make -C "$build_dir" install DESTDIR="$build_dir/stage"
  for path in "$build_dir/stage/usr/local/bin/"*; do
    mode=0755
    [[ $item != slock ]] || mode=4755
    root install -D -m "$mode" "$path" "/usr/local/bin/${path##*/}"
  done
  if [[ -d $build_dir/stage/usr/local/share/man/man1 ]]; then
    for path in "$build_dir/stage/usr/local/share/man/man1/"*; do
      root install -D -m 0644 "$path" "/usr/local/share/man/man1/${path##*/}"
    done
  fi
  if [[ $item == st ]]; then root tic -sx "$build_dir/st.info"; fi
)

setup_dwm() { build_flexipatch dwm; }
setup_st() { build_flexipatch st; }
setup_dmenu() { build_flexipatch dmenu; }
setup_slock() { build_flexipatch slock; }

setup_luastatus() (
  local cache work path stamp=$SETUP_HOME/.cache/dotfiles/luastatus.installed
  need cmake
  need make
  need tar
  cache=$(fetch_pinned luastatus https://github.com/shdown/luastatus "$LUASTATUS_REV") || exit 1
  if [[ $(cat "$stamp" 2>/dev/null) != "$LUASTATUS_REV" ]] || ! [[ -x /usr/local/bin/luastatus ]]; then
    work=$(as_user mktemp -d "${TMPDIR:-/tmp}/luastatus.XXXXXXXX")
    trap 'root rm -rf -- "$work"' EXIT
    as_user git -C "$cache" archive "$LUASTATUS_REV" | as_user tar -x -C "$work"
    as_user cmake -S "$work" -B "$work/build"
    as_user make -C "$work/build"
    root make -C "$work/build" install
    printf '%s\n' "$LUASTATUS_REV" | as_user tee "$stamp" >/dev/null
  fi
  # Repair resource permissions after a restrictive-umask install, including
  # files and existing installs that do not need rebuilding.
  for path in /usr/local/share/luastatus /usr/local/lib/luastatus; do
    if [[ -d $path ]]; then root chmod -R a+rx "$path"; fi
  done
)
