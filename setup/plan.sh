#!/usr/bin/env bash

# This is a read-only summary, not an execution trace. Do not call component
# functions here: several install packages or modify files on entry.
plan_setup() {
    local component mounted_root
    # shellcheck source=/dev/null
    source /etc/os-release
    printf 'DRY RUN: no sudo, installers, stow, or system changes will run.\n'
    printf 'Managed file sources: %s/files/ (.in files use config.sh values)\n' "$SETUP_DIR"
    printf 'Backups of replaced files: %s/backups/dotfiles/\n' "$DATA_DIR"
    printf 'Target: %s %s; configured user: %s; root dataset: %s\n' \
        "${NAME:-unknown}" "${VERSION_ID:-unknown}" "$SETUP_USER" "$ROOT_ZFS_DATASET"
    if [[ ${ID:-} != ubuntu || ${VERSION_ID:-} != 26.04 ]]; then
        printf 'WARNING: The actual setup requires Ubuntu 26.04.\n'
    fi
    mounted_root=$(findmnt -n -o SOURCE / 2>/dev/null || true)
    if [[ -n $mounted_root && $mounted_root != "$ROOT_ZFS_DATASET" ]]; then
        printf 'WARNING: / is mounted from %s, not configured %s. Review config.sh!\n' \
            "$mounted_root" "$ROOT_ZFS_DATASET"
    fi
    printf 'Actions below are planned, not checked for necessity or success.\n'
    for component in "$@"; do
        printf '\n==> %s\n' "$component"
        plan_component "$component"
    done
}

plan_component() {
    case $1 in
        apt)
            cat <<EOF
  Install /etc/apt/sources.list.d/ubuntu.sources with all Ubuntu components
    and pockets; back up/remove the minimal legacy /etc/apt/sources.list if present
  apt-get update; install ca-certificates, curl, gnupg
  Write (backing up changed files) /etc/apt/preferences.d/custom.pref
  Fetch repository keys for Google Chrome, Lens, and Mozilla into /etc/apt/keyrings/
  Write /etc/apt/sources.list.d/{google,lens,mozilla}.sources; refresh apt
  Install packages listed in setup/apt.sh (no GNOME purge)
EOF
            ;;
        system)
            cat <<EOF
  Create/update ZFS $DOCKER_ZFS_DATASET (mountpoint $DOCKER_DATA_DIR, dedup on)
  Set snapdir=visible on $ROOT_ZFS_DATASET
  Mask systemd-networkd-wait-online; set HandleLidSwitch=ignore
  Remove /lib/systemd/system/autorandr.service (back up first), reload systemd
  Write (backing up changed files) /etc/sanoid/sanoid.conf,
    /etc/apt/apt.conf.d/20apt-esm-hook.conf, /etc/profile.d/global_env.sh,
    /etc/netplan/netcfg.yaml; create /usr/local/bin
  Enable UFW with default deny incoming (keep existing rules)
  Disable SSH password authentication; restart ssh only if config changes
EOF
            ;;
        stow)
            printf '  Run the existing stow.sh as %s in %s\n' "$SETUP_USER" "$REPO_DIR"
            printf '  WARNING: stow.sh deletes existing non-symlinks at these paths before linking:\n'
            sed -n 's/^rm_if_not_link /    /p' "$REPO_DIR/stow.sh"
            printf '  Stow home/ and, if present, dotfiles-personal/home/; initialize themes.\n'
            ;;
        desktop)
            printf '  Initialize the four public flexipatch submodules (not dotfiles-personal).\n'
            for item in dwm st dmenu luastatus slock; do
                printf '  %s:\n' "$item"
                plan_desktop "$item"
            done
            ;;
        dwm|st|dmenu|slock)
            printf '  Initialize public submodule %s/%s-flexipatch.\n' "$1" "$1"
            plan_desktop "$1"
            ;;
        luastatus)
            plan_desktop "$1"
            ;;
        brew)
            cat <<EOF
  Install Homebrew at $BREW_PREFIX if absent; update it
  Link $SETUP_HOME/.config/homebrew-formulas as local tap Formula/
  Install local lazygit, jetbrains-toolbox, typing-test; fnm, go, helm, lf,
    neovim, yt-dlp; install UbuntuMono Nerd Font cask and refresh font cache
EOF
            ;;
        docker)
            cat <<EOF
  Fetch Docker signing key into /etc/apt/keyrings/docker.gpg
  Add official Ubuntu 26.04 Docker apt source; refresh apt
  Install docker-ce, docker-ce-cli, containerd.io, buildx and compose plugins
  Write /etc/docker/daemon.json (data-root $DOCKER_DATA_DIR,
    bip 172.20.0.1/24, default-address-pool 172.20.0.0/16 size 24)
  Restart Docker if config changed; enable/start Docker
EOF
            ;;
    esac
}

plan_desktop() {
    case $1 in
        luastatus)
            printf '    Clone/update luastatus at %s/luastatus to %s; build and install if needed\n' \
                "$DATA_DIR" "$LUASTATUS_REV"
            ;;
        *)
            printf '    Build %s in a temporary copy of %s/%s-flexipatch, applying %s.patch\n' \
                "$1" "$REPO_DIR/$1" "$1" "$1"
            printf '    Install binaries and manual pages under /usr/local (no desktop entries)\n'
            [[ $1 != slock ]] || printf '    Install slock setuid, as the upstream installer does\n'
            [[ $1 != st ]] || printf '    Install st terminfo with tic\n'
            ;;
    esac
}
