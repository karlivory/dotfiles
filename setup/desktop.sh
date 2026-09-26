#!/usr/bin/env bash

setup_desktop() {
  local item=$1
  case $item in
    dwm | st | dmenu | slock | luastatus) ;;
    *) die "Unknown desktop component: $item" ;;
  esac
  "setup_$item"
}

# Build the pinned submodule revision in a disposable directory, not inside
# the checkout. Prior root-run builds may have left root-owned binaries there.
build_flexipatch() (
  local item=$1 source_dir=$REPO_DIR/$1
  local checkout=$source_dir/$1-flexipatch build_dir path mode temp_base=/tmp/opencode
  need git
  need make
  need tar
  [[ -d $checkout/.git || -f $checkout/.git ]] || die "Initialize the $item submodule first"

  # Allow the exact patch left by the old helper after an interrupted build,
  # but do not silently ignore other tracked edits in a submodule.
  if [[ -n $(as_user git -C "$checkout" status --porcelain --untracked-files=no) ]]; then
    if ! cmp -s <(as_user git -C "$checkout" diff --binary) "$source_dir/$item.patch"; then
      die "$checkout has local changes other than $item.patch; refusing to ignore them"
    fi
    log "$item checkout has the previous patch applied; leaving it untouched"
  fi

  [[ -d $temp_base && -w $temp_base ]] || temp_base=${TMPDIR:-/tmp}
  build_dir=$(as_user mktemp -d "$temp_base/flexipatch.XXXXXXXX")
  trap 'as_user rm -rf -- "$build_dir"' EXIT
  as_user git -C "$checkout" archive HEAD | as_user tar -x -C "$build_dir"
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

setup_luastatus() {
  local dest=$DATA_DIR/luastatus rev path
  need git
  need cmake
  root mkdir -p "$DATA_DIR"
  if ! root test -d "$dest/.git"; then
    root test ! -e "$dest" || die "$dest exists but is not a git checkout"
    root git clone https://github.com/shdown/luastatus "$dest"
  fi
  rev=$(root git -C "$dest" rev-parse HEAD)
  if [[ $rev != "$LUASTATUS_REV" ]]; then
    root git -C "$dest" fetch origin "$LUASTATUS_REV"
    root git -C "$dest" checkout --detach "$LUASTATUS_REV"
  fi
  if [[ $rev != "$LUASTATUS_REV" ]] || ! root test -x /usr/local/bin/luastatus; then
    root cmake -S "$dest" -B "$dest/build"
    root make -C "$dest/build"
    root make -C "$dest/build" install
  fi
  # Repair resource permissions after a restrictive-umask install, including
  # files and existing installs that do not need rebuilding.
  for path in /usr/local/share/luastatus /usr/local/lib/luastatus; do
    if [[ -d $path ]]; then root chmod -R a+rx "$path"; fi
  done
}
