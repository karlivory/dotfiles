#!/usr/bin/env bash
set -euo pipefail
SETUP_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
# shellcheck source=setup/lib.sh
source "$SETUP_DIR/lib.sh"

usage() {
  cat <<'EOF'
Usage: setup/setup.sh [--verbose] [--no-spinner] [all | system | apt | stow | desktop | dwm | st | dmenu | slock | luastatus | brew | docker]...

No arguments runs all components. Selected components run in the order given.
Desktop is shorthand for dwm, st, dmenu, luastatus, and slock.
For desktop builds, install packages and initialize submodules first (or run all).
Machine settings live in setup/config.sh. Ubuntu 26.04 is expected.
Successful components and selected subtasks show elapsed time (e.g. 0.43s).
--verbose also streams command output.
--no-spinner disables the terminal spinner without changing output or timings.
EOF
}

verbose=0
no_spinner=0
root_session=0
all_selected=0
components=()
for arg in "$@"; do
  case $arg in
    -h | --help)
      usage
      exit 0
      ;;
    --verbose) verbose=1 ;;
    --no-spinner) no_spinner=1 ;;
    --root-session) root_session=1 ;;
    all) all_selected=1 ;;
    system | apt | stow | desktop | dwm | st | dmenu | slock | luastatus | brew | docker)
      components+=("$arg")
      ;;
    *)
      usage >&2
      die "Unknown component: $arg"
      ;;
  esac
done
if ((all_selected || ${#components[@]} == 0)); then
  full_setup=1
  components=(
    apt
    system
    stow
    desktop
    brew
    docker
  )
else
  full_setup=0
fi

# shellcheck source=/dev/null
source /etc/os-release
[[ ${ID:-} == ubuntu && ${VERSION_ID:-} == 26.04 ]] || die "This setup targets Ubuntu 26.04"
if ((root_session)); then
  [[ $(id -u) -eq 0 && ${SUDO_USER:-} == "$SETUP_USER" ]] || die "Root session must be started by $SETUP_USER"
else
  [[ $(id -un) == "$SETUP_USER" ]] || die "Run as $SETUP_USER, not root"
  needs_root=0
  for component in "${components[@]}"; do
    case $component in
      apt | system | desktop | dwm | st | dmenu | luastatus | slock | docker)
        needs_root=1
        break
        ;;
      brew)
        if [[ $BREW_PREFIX == /home/linuxbrew/.linuxbrew && ! -x $BREW_PREFIX/bin/brew ]]; then
          needs_root=1
          break
        fi
        ;;
    esac
  done
  if ((needs_root)); then
    options=()
    if ((verbose)); then options+=(--verbose); fi
    if ((no_spinner)); then options+=(--no-spinner); fi
    # One foreground sudo process for the entire setup. User-owned steps
    # run through runuser; no new timestamp is needed between components.
    if ((full_setup)); then
      exec sudo -- bash "$SETUP_DIR/setup.sh" --root-session "${options[@]}" all
    fi
    exec sudo -- bash "$SETUP_DIR/setup.sh" --root-session "${options[@]}" "${components[@]}"
  fi
fi

IN_CHROOT=0
if ((root_session)) && is_chroot; then IN_CHROOT=1; fi

# shellcheck source=setup/util/progress.sh
source "$SETUP_DIR/util/progress.sh"

init_public_submodules() {
  local -a paths=(
    dwm/dwm-flexipatch
    st/st-flexipatch
    dmenu/dmenu-flexipatch
    slock/slock-flexipatch
  )
  as_user git -C "$REPO_DIR" submodule update --init -- "${paths[@]}"
}

setup_stow() {
  need stow
  (cd "$REPO_DIR" && as_user bash "$REPO_DIR/stow.sh")
}

run_component() {
  local component=$1 item
  case $component in
    system | apt | brew | docker)
      # shellcheck source=/dev/null
      source "$SETUP_DIR/$component.sh"
      "setup_$component"
      ;;
    stow)
      run_step "dotfiles" setup_stow
      ;;
    desktop)
      # shellcheck source=/dev/null
      source "$SETUP_DIR/desktop.sh"
      run_step "public submodules" init_public_submodules
      local -a desktop_items=(
        dwm
        st
        dmenu
        luastatus
        slock
      )
      for item in "${desktop_items[@]}"; do
        run_step "$item" setup_desktop "$item"
      done
      ;;
    dwm | st | dmenu | slock)
      # shellcheck source=/dev/null
      source "$SETUP_DIR/desktop.sh"
      run_step "submodule" as_user git -C "$REPO_DIR" submodule update --init -- \
        "$component/$component-flexipatch"
      run_step "build" setup_desktop "$component"
      ;;
    luastatus)
      # shellcheck source=/dev/null
      source "$SETUP_DIR/desktop.sh"
      run_step "build" setup_desktop "$component"
      ;;
  esac
}

total_started=$(now_us)
total=${#components[@]}
deferred=0
component_noun=components
if ((total == 1)); then component_noun=component; fi
for index in "${!components[@]}"; do
  component=${components[index]}
  component_started=$(now_us)
  component_active=1
  printf '[%d/%d] %s\n' "$((index + 1))" "$total" "$component" >&3
  if ((IN_CHROOT)) && [[ $component == docker ]]; then
    printf '  docker deferred until boot (packages, daemon, and service)\n\n' >&3
    deferred=$((deferred + 1))
    component_active=0
    continue
  fi
  if ((verbose)); then
    run_component "$component"
  else
    current_log=$(mktemp)
    run_component "$component" >"$current_log" 2>&1
    rm -f -- "$current_log"
    current_log=
  fi
  if ((IN_CHROOT)) && [[ $component == system ]]; then
    printf '  %s✓%s system target files prepared in %s (runtime work deferred)\n\n' \
      "$green" "$reset" "$(elapsed "$(($(now_us) - component_started))")" >&3
    deferred=$((deferred + 1))
  else
    printf '  %s✓%s %s completed in %s\n\n' "$green" "$reset" "$component" \
      "$(elapsed "$(($(now_us) - component_started))")" >&3
  fi
  component_active=0
done
if ((deferred)); then
  printf 'Chroot preparation finished in %s; %d runtime %s deferred until boot.\n' \
    "$(elapsed "$(($(now_us) - total_started))")" "$deferred" \
    "$([[ $deferred == 1 ]] && echo component || echo components)" >&3
  printf 'After boot, review ROOT_ZFS_DATASET in setup/config.sh, then run: %s/setup.sh system docker\n' \
    "$SETUP_DIR" >&3
  if ((full_setup)); then
    printf 'After completing booted setup, optionally run: %s/promote.sh\n' "$SETUP_DIR" >&3
  fi
else
  printf 'Finished %d %s in %s.\n' "$total" "$component_noun" \
    "$(elapsed "$(($(now_us) - total_started))")" >&3
fi
if ((full_setup && !IN_CHROOT)); then
  origin=$(as_user git -C "$REPO_DIR" config --get remote.origin.url || true)
  if [[ $origin == https://github.com/karlivory/dotfiles ||
    $origin == https://github.com/karlivory/dotfiles.git ||
    $origin == git@github.com:karlivory/dotfiles.git ]] &&
    { [[ $origin != git@github.com:karlivory/dotfiles.git ]] ||
      [[ ! -e $REPO_DIR/dotfiles-personal/.git ]]; }; then
    printf '\nOptional next step after configuring GitHub SSH: %s/promote.sh\n' "$SETUP_DIR" >&3
    printf 'This initializes dotfiles-personal and switches origin to SSH.\n' >&3
  fi
fi
