#!/usr/bin/env bash

setup_system_zfs() {
  local mounted_root
  mounted_root=$(findmnt -n -o SOURCE /)
  [[ $mounted_root == "$ROOT_ZFS_DATASET" ]] ||
    die "Root is mounted from $mounted_root, but config.sh specifies $ROOT_ZFS_DATASET"
  root install -d -m 0755 /usr/local/bin
  if ! root zfs list -H -o name "$DOCKER_ZFS_DATASET" >/dev/null 2>&1; then
    root zfs create -o mountpoint="$DOCKER_DATA_DIR" -o dedup=off -o compression=lz4 "$DOCKER_ZFS_DATASET"
  fi
  [[ $(root zfs get -H -o value mountpoint "$DOCKER_ZFS_DATASET") == "$DOCKER_DATA_DIR" ]] || root zfs set mountpoint="$DOCKER_DATA_DIR" "$DOCKER_ZFS_DATASET"
  [[ $(root zfs get -H -o value dedup "$DOCKER_ZFS_DATASET") == off ]] || root zfs set dedup=off "$DOCKER_ZFS_DATASET"
  [[ $(root zfs get -H -o value compression "$DOCKER_ZFS_DATASET") == lz4 ]] || root zfs set compression=lz4 "$DOCKER_ZFS_DATASET"
  [[ $(root zfs get -H -o value snapdir "$ROOT_ZFS_DATASET") == visible ]] || root zfs set snapdir=visible "$ROOT_ZFS_DATASET"
}

setup_system_services() {
  root systemctl mask systemd-networkd-wait-online.service
  set_directive /etc/systemd/logind.conf HandleLidSwitch ignore
  if root test -e /lib/systemd/system/autorandr.service; then
    backup_root_file /lib/systemd/system/autorandr.service
    root rm /lib/systemd/system/autorandr.service
    root systemctl daemon-reload
  fi
}

setup_system_config_files() {
  install_config etc/sanoid/sanoid.conf.in
  install_config etc/apt/apt.conf.d/20apt-esm-hook.conf
  install_config etc/profile.d/global_env.sh
  install_config etc/netplan/netcfg.yaml
}

restore_ssh_config() {
  local rollback_dir=$1 had_previous=$2
  if ((had_previous)); then
    root cp -a -- "$rollback_dir/previous" /etc/ssh/sshd_config
  else
    root rm -f -- /etc/ssh/sshd_config
  fi
  rm -f -- "$rollback_dir/previous"
  rmdir -- "$rollback_dir"
}

setup_ssh_config() {
  local rollback_dir had_previous=0 changed effective password_auth keyboard_auth
  if ((IN_CHROOT)); then
    install_config etc/ssh/sshd_config
    return
  fi

  if ! command -v sshd >/dev/null 2>&1; then
    install_config etc/ssh/sshd_config
    log "OpenSSH server is not installed; staged sshd_config without validation or reload"
    return
  fi

  rollback_dir=$(mktemp -d)
  if root test -e /etc/ssh/sshd_config; then
    root cp -a -- /etc/ssh/sshd_config "$rollback_dir/previous"
    had_previous=1
  fi

  install_config etc/ssh/sshd_config
  changed=$WRITE_CHANGED

  if ! root sshd -t; then
    restore_ssh_config "$rollback_dir" "$had_previous"
    die "sshd configuration is invalid; restored the previous sshd_config"
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
    die "Could not read effective sshd configuration; restored the previous sshd_config"
  fi
  read -r password_auth keyboard_auth <<<"$effective"
  if [[ $password_auth != no || $keyboard_auth != no ]]; then
    restore_ssh_config "$rollback_dir" "$had_previous"
    die "PasswordAuthentication/KbdInteractiveAuthentication are still effective as '$password_auth/$keyboard_auth'; restored the previous sshd_config"
  fi

  rm -f -- "$rollback_dir/previous"
  rmdir -- "$rollback_dir"
  if ((changed)) && root systemctl is-active --quiet ssh; then
    root systemctl reload ssh
  fi
}

setup_system_security() {
  # Do not reset existing rules: remote access and user-defined rules survive.
  root ufw default deny incoming
  root ufw --force enable
  setup_ssh_config
}

setup_system_chroot_files() {
  root install -d -m 0755 /usr/local/bin
  set_directive /etc/systemd/logind.conf HandleLidSwitch ignore
  if root test -e /lib/systemd/system/autorandr.service; then
    backup_root_file /lib/systemd/system/autorandr.service
    root rm /lib/systemd/system/autorandr.service
  fi
  install_config etc/apt/apt.conf.d/20apt-esm-hook.conf
  install_config etc/profile.d/global_env.sh
  install_config etc/netplan/netcfg.yaml
  setup_ssh_config
}

setup_system() {
  if ((IN_CHROOT)); then
    run_step "target files" setup_system_chroot_files
    return
  fi
  need zfs
  need ufw
  run_step "ZFS" setup_system_zfs
  run_step "services" setup_system_services
  run_step "config files" setup_system_config_files
  run_step "security" setup_system_security
}
