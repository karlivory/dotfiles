#!/usr/bin/env bash
set -euo pipefail
SETUP_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
# shellcheck source=setup/lib.sh
source "$SETUP_DIR/lib.sh"

usage() {
  cat <<'EOF'
Usage: setup/setup.sh [--dry-run] [--verbose] [all | system | apt | stow | desktop | dwm | st | dmenu | slock | luastatus | brew | docker]...

No arguments runs all components. Selected components run in the order given.
Desktop is shorthand for dwm, st, dmenu, luastatus, and slock.
For desktop builds, install packages and initialize submodules first (or run all).
Machine settings live in setup/config.sh. Ubuntu 26.04 is expected.
--dry-run prints a read-only plan; it does not check whether each step is needed.
Successful components and selected subtasks show elapsed time (e.g. 0.43s).
--verbose also streams command output.
EOF
}

dry_run=0
verbose=0
root_session=0
all_selected=0
components=()
for arg in "$@"; do
  case $arg in
    -h | --help)
      usage
      exit 0
      ;;
    --dry-run) dry_run=1 ;;
    --verbose) verbose=1 ;;
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

if ((dry_run)); then
  # Do not source component scripts: some of them perform work during setup.
  # shellcheck source=/dev/null
  source "$SETUP_DIR/plan.sh"
  plan_setup "${components[@]}"
  exit 0
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
    esac
  done
  if ((needs_root)); then
    options=()
    if ((verbose)); then options+=(--verbose); fi
    # One foreground sudo process for the entire setup. User-owned steps
    # run through runuser; no new timestamp is needed between components.
    if ((full_setup)); then
      exec sudo -- bash "$SETUP_DIR/setup.sh" --root-session "${options[@]}" all
    fi
    exec sudo -- bash "$SETUP_DIR/setup.sh" --root-session "${options[@]}" "${components[@]}"
  fi
fi

current_log=
component_active=0
step_active=0
exec 3>&1
if [[ -t 3 && -z ${NO_COLOR:-} && ${TERM:-} != dumb ]]; then
  green=$'\033[32m'
  red=$'\033[31m'
  reset=$'\033[0m'
else
  green='' red='' reset=''
fi

now_us() { printf '%s' "${EPOCHREALTIME/./}"; }
elapsed() {
  local micros=$1 centiseconds
  if ((micros < 0)); then micros=0; fi
  centiseconds=$(((micros + 5000) / 10000))
  printf '%d.%02ds' "$((centiseconds / 100))" "$((centiseconds % 100))"
}

run_step() {
  local name=$1 started duration
  shift
  step_name=$name
  step_active=1
  started=$(now_us)
  step_started=$started
  if ((verbose)); then
    printf '    %-18s\n' "$name" >&3
  else
    printf '    %-18s ' "$name" >&3
  fi
  "$@"
  duration=$(elapsed "$(($(now_us) - started))")
  if ((verbose)); then
    printf '    %s✓%s %-18s %s\n' "$green" "$reset" "$name" "$duration" >&3
  else
    printf '%s✓%s %s\n' "$green" "$reset" "$duration" >&3
  fi
  step_active=0
}

finish() {
  local status=$?
  trap - EXIT INT TERM
  if ((status != 0)); then
    if ((step_active)); then
      if ((verbose)); then printf '    %-18s ' "$step_name" >&3; fi
      printf '%s✗%s failed (%s)\n' "$red" "$reset" \
        "$(elapsed "$(($(now_us) - step_started))")" >&3
    fi
    if ((component_active)); then
      printf '  %s✗%s %s failed after %s\n' "$red" "$reset" "$component" \
        "$(elapsed "$(($(now_us) - component_started))")" >&3
    fi
    if [[ -n $current_log && -f $current_log ]]; then
      printf '\nCaptured output for %s:\n' "$component" >&2
      cat "$current_log" >&2
    fi
  fi
  [[ -z $current_log ]] || rm -f -- "$current_log"
  exit "$status"
}
trap finish EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

init_public_submodules() {
  local -a paths=(
    dwm/dwm-flexipatch
    st/st-flexipatch
    dmenu/dmenu-flexipatch
    slock/slock-flexipatch
  )
  as_user git -C "$REPO_DIR" submodule update --init -- "${paths[@]}"
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
      need stow
      (cd "$REPO_DIR" && as_user bash "$REPO_DIR/stow.sh")
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
component_noun=components
if ((total == 1)); then component_noun=component; fi
for index in "${!components[@]}"; do
  component=${components[index]}
  component_started=$(now_us)
  component_active=1
  printf '[%d/%d] %s\n' "$((index + 1))" "$total" "$component" >&3
  if ((verbose)); then
    run_component "$component"
  else
    current_log=$(mktemp)
    run_component "$component" >"$current_log" 2>&1
    rm -f -- "$current_log"
    current_log=
  fi
  printf '  %s✓%s %s completed in %s\n\n' "$green" "$reset" "$component" \
    "$(elapsed "$(($(now_us) - component_started))")" >&3
  component_active=0
done
printf 'Finished %d %s in %s.\n' "$total" "$component_noun" \
  "$(elapsed "$(($(now_us) - total_started))")" >&3
if ((full_setup)); then
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
