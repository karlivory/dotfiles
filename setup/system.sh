#!/usr/bin/env bash

setup_system_zfs() {
  root install -d -m 0755 /usr/local/bin
  if ! root zfs list -H -o name "$DOCKER_ZFS_DATASET" >/dev/null 2>&1; then
    root zfs create -o mountpoint="$DOCKER_DATA_DIR" -o dedup=on "$DOCKER_ZFS_DATASET"
  fi
  [[ $(root zfs get -H -o value mountpoint "$DOCKER_ZFS_DATASET") == "$DOCKER_DATA_DIR" ]] || root zfs set mountpoint="$DOCKER_DATA_DIR" "$DOCKER_ZFS_DATASET"
  [[ $(root zfs get -H -o value dedup "$DOCKER_ZFS_DATASET") == on ]] || root zfs set dedup=on "$DOCKER_ZFS_DATASET"
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

setup_system_security() {
  # Do not reset existing rules: remote access and user-defined rules survive.
  root ufw default deny incoming
  root ufw --force enable
  set_directive /etc/ssh/sshd_config PasswordAuthentication no
  if ((WRITE_CHANGED)); then root systemctl restart ssh; fi
}

setup_system() {
  need zfs
  need ufw
  run_step "ZFS" setup_system_zfs
  run_step "services" setup_system_services
  run_step "config files" setup_system_config_files
  run_step "security" setup_system_security
}
