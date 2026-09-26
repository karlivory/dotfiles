#!/usr/bin/env bash

# Sourced by setup.sh after argument parsing; uses verbose and no_spinner.
# shellcheck disable=SC2154 # Component and option state is supplied by setup.sh.
current_log=
component_active=0
step_active=0
spinner_pid=
spinner_active=0
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

start_spinner() {
  local name=$1
  [[ -t 3 && ${TERM:-dumb} != dumb && $verbose -eq 0 && $no_spinner -eq 0 ]] || return 0

  (
    local -a frames=('|' '/' '-' $'\\')
    local frame=0 sleep_pid=
    trap 'if [[ -n $sleep_pid ]]; then kill "$sleep_pid" 2>/dev/null || :; wait "$sleep_pid" 2>/dev/null || :; fi; exit 0' INT TERM
    while :; do
      printf '\r    %-18s %s' "$name" "${frames[frame]}" >&3
      frame=$(((frame + 1) % ${#frames[@]}))
      sleep 0.1 &
      sleep_pid=$!
      wait "$sleep_pid" || :
      sleep_pid=
    done
  ) &
  spinner_pid=$!
  spinner_active=1
}

stop_spinner() {
  [[ -n $spinner_pid ]] || return 0
  kill "$spinner_pid" 2>/dev/null || true
  wait "$spinner_pid" 2>/dev/null || true
  spinner_pid=
}

run_step() {
  local name=$1 started duration
  shift
  step_name=$name
  step_active=1
  started=$(now_us)
  step_started=$started
  spinner_active=0
  if ((verbose)); then
    printf '    %-18s\n' "$name" >&3
  else
    printf '    %-18s ' "$name" >&3
    start_spinner "$name"
  fi
  "$@"
  duration=$(elapsed "$(($(now_us) - started))")
  stop_spinner
  if ((verbose)); then
    printf '    %s✓%s %-18s %s\n' "$green" "$reset" "$name" "$duration" >&3
  elif ((spinner_active)); then
    printf '\r    %-18s %s✓%s %s\n' "$name" "$green" "$reset" "$duration" >&3
  else
    printf '%s✓%s %s\n' "$green" "$reset" "$duration" >&3
  fi
  spinner_active=0
  step_active=0
}

finish() {
  local status=$? finished
  finished=$(now_us)
  trap - EXIT INT TERM
  stop_spinner
  if ((status != 0)); then
    if ((step_active)); then
      if ((spinner_active)); then
        printf '\r    %-18s %s✗%s failed (%s)\n' "$step_name" "$red" "$reset" \
          "$(elapsed "$((finished - step_started))")" >&3
      else
        if ((verbose)); then printf '    %-18s ' "$step_name" >&3; fi
        printf '%s✗%s failed (%s)\n' "$red" "$reset" \
          "$(elapsed "$((finished - step_started))")" >&3
      fi
    fi
    if ((component_active)); then
      printf '  %s✗%s %s failed after %s\n' "$red" "$reset" "$component" \
        "$(elapsed "$((finished - component_started))")" >&3
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
