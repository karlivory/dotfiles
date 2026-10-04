#!/usr/bin/env bash

setup_system_zfs() {
  local mounted_root
  mounted_root=$(findmnt -n -o SOURCE /)
  [[ $mounted_root == "$ROOT_ZFS_DATASET" ]] ||
    die "Root is mounted from $mounted_root, but config.sh specifies $ROOT_ZFS_DATASET (see config.local.sh)"
  if ! root zfs list -H -o name "$DOCKER_ZFS_DATASET" >/dev/null 2>&1; then
    root zfs create -o mountpoint="$DOCKER_DATA_DIR" -o dedup=off -o compression=lz4 "$DOCKER_ZFS_DATASET"
  fi
  [[ $(root zfs get -H -o value mountpoint "$DOCKER_ZFS_DATASET") == "$DOCKER_DATA_DIR" ]] || root zfs set mountpoint="$DOCKER_DATA_DIR" "$DOCKER_ZFS_DATASET"
  [[ $(root zfs get -H -o value dedup "$DOCKER_ZFS_DATASET") == off ]] || root zfs set dedup=off "$DOCKER_ZFS_DATASET"
  [[ $(root zfs get -H -o value compression "$DOCKER_ZFS_DATASET") == lz4 ]] || root zfs set compression=lz4 "$DOCKER_ZFS_DATASET"
  [[ $(root zfs get -H -o value snapdir "$ROOT_ZFS_DATASET") == visible ]] || root zfs set snapdir=visible "$ROOT_ZFS_DATASET"
}

# In a chroot, steps that need the booted system or its final ZFS layout are
# skipped; setup.sh tells the user to rerun system after boot.

setup_system_services() {
  if ((!IN_CHROOT)); then root systemctl mask systemd-networkd-wait-online.service; fi
  set_directive /etc/systemd/logind.conf HandleLidSwitch ignore
  mask_autorandr
}

# Masking survives package upgrades, unlike deleting the packaged unit.
mask_autorandr() {
  root systemctl mask autorandr.service
}

# A broken sudoers drop-in disables sudo, so validate before installing.
install_sudoers() {
  local source_file=$SETUP_DIR/files/etc/sudoers.d/$1
  root visudo -cqf "$source_file" || die "Invalid sudoers file: $source_file"
  write_root "/etc/sudoers.d/$1" 0440 <"$source_file"
}

setup_system_hosts() {
  local entries=$REPO_DIR/dotfiles-personal/hosts.entries
  local begin='# BEGIN dotfiles-personal hosts' end='# END dotfiles-personal hosts' temp
  [[ -f $entries ]] || return 0

  temp=$(mktemp)
  if ! root cat /etc/hosts | awk -v begin="$begin" -v end="$end" -v entries="$entries" \
    -v has_entries="$( [[ -s $entries ]] && printf 1 || printf 0 )" '
    function block(   line) {
      print begin
      while ((getline line < entries) > 0) print line
      close(entries)
      print end
    }
    $0 == begin {
      if (inside || seen++) exit 1
      inside = 1
      if (has_entries) block()
      next
    }
    $0 == end {
      if (!inside) exit 1
      inside = 0
      next
    }
    !inside { print }
    END {
      if (inside) exit 1
      if (!seen && has_entries) {
        print ""
        block()
      }
    }
  ' >"$temp"; then
    rm -f -- "$temp"
    die "Malformed managed block in /etc/hosts"
  fi
  write_root /etc/hosts <"$temp"
  rm -f -- "$temp"
}

setup_system_config_files() {
  root install -d -m 0755 /usr/local/bin
  # ROOT_ZFS_DATASET is only reviewed after boot.
  if ((!IN_CHROOT)); then install_config etc/sanoid/sanoid.conf.in; fi
  install_config etc/apt/apt.conf.d/20apt-esm-hook.conf
  install_config etc/profile.d/global_env.sh
  install_config etc/netplan/netcfg.yaml 0600
  install_sudoers timeout
  setup_system_hosts
}

# Ubuntu's sshd_config includes sshd_config.d before its own settings, and
# sshd keeps the first value it reads, so this drop-in wins.
SSH_DROP_IN=/etc/ssh/sshd_config.d/10-no-passwords.conf

restore_ssh_config() {
  local rollback_dir=$1 had_previous=$2
  if ((had_previous)); then
    root cp -a -- "$rollback_dir/previous" "$SSH_DROP_IN"
  else
    root rm -f -- "$SSH_DROP_IN"
  fi
  rm -f -- "$rollback_dir/previous"
  rmdir -- "$rollback_dir"
}

setup_ssh_config() {
  local rollback_dir had_previous=0 changed effective password_auth keyboard_auth
  if ((IN_CHROOT)); then
    install_config "${SSH_DROP_IN#/}"
    return
  fi

  if ! command -v sshd >/dev/null 2>&1; then
    install_config "${SSH_DROP_IN#/}"
    log "OpenSSH server is not installed; staged $SSH_DROP_IN without validation or reload"
    return
  fi

  rollback_dir=$(mktemp -d)
  if root test -e "$SSH_DROP_IN"; then
    root cp -a -- "$SSH_DROP_IN" "$rollback_dir/previous"
    had_previous=1
  fi

  install_config "${SSH_DROP_IN#/}"
  changed=$WRITE_CHANGED

  if ! root sshd -t; then
    restore_ssh_config "$rollback_dir" "$had_previous"
    die "sshd configuration is invalid; restored the previous $SSH_DROP_IN"
  fi
  if ! effective=$(root sshd -T | awk '
    $1 == "passwordauthentication" { password = $2 }
    $1 == "kbdinteractiveauthentication" { keyboard = $2 }
    END {
      if (password == "" || keyboard == "") exit 1
      printf "%s %s\n", password, keyboard
    }
  '); then
    restore_ssh_config "$rollback_dir" "$had_previous"
    die "Could not read effective sshd configuration; restored the previous $SSH_DROP_IN"
  fi
  read -r password_auth keyboard_auth <<<"$effective"
  if [[ $password_auth != no || $keyboard_auth != no ]]; then
    restore_ssh_config "$rollback_dir" "$had_previous"
    die "PasswordAuthentication/KbdInteractiveAuthentication are still effective as '$password_auth/$keyboard_auth'; restored the previous $SSH_DROP_IN"
  fi

  rm -f -- "$rollback_dir/previous"
  rmdir -- "$rollback_dir"
  if ((changed)) && root systemctl is-active --quiet ssh; then
    root systemctl reload ssh
  fi
}

setup_system_security() {
  # Do not reset existing rules: remote access and user-defined rules survive.
  if ((!IN_CHROOT)); then
    root ufw default deny incoming
    root ufw --force enable
  fi
  setup_ssh_config
}

setup_system() {
  if ((!IN_CHROOT)); then
    need zfs
    need ufw
    run_step "ZFS" setup_system_zfs
  fi
  run_step "services" setup_system_services
  run_step "config files" setup_system_config_files
  run_step "security" setup_system_security
}
