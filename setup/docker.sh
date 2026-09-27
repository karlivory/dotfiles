#!/usr/bin/env bash

setup_docker_repository() {
  # setup.sh has already sourced /etc/os-release and checked the release.
  [[ -n ${VERSION_CODENAME:-} ]] || die "VERSION_CODENAME missing from /etc/os-release"
  APT_SOURCES_CHANGED=0
  apt_key docker https://download.docker.com/linux/ubuntu/gpg
  DOCKER_CODENAME=$VERSION_CODENAME DOCKER_ARCH=$(dpkg --print-architecture) apt_source docker
  # Also update when a previous run wrote the source but never refreshed.
  if ((APT_SOURCES_CHANGED)) || ! apt-cache show docker-ce >/dev/null 2>&1; then
    root apt-get update
  fi
}

setup_docker_packages() {
  local -a packages=(
    docker-ce
    docker-ce-cli
    containerd.io
    docker-buildx-plugin
    docker-compose-plugin
  )
  root apt-get install -y --no-install-recommends "${packages[@]}"
}

setup_docker_service() {
  install_config etc/docker/daemon.json.in
  if ((WRITE_CHANGED)); then
    root systemctl restart docker
  fi
  root systemctl enable --now docker
}

# daemon.json points data-root here; refuse to fill the root dataset instead.
check_docker_data_dir() {
  local source
  source=$(findmnt -n -o SOURCE --mountpoint "$DOCKER_DATA_DIR" || true)
  [[ $source == "$DOCKER_ZFS_DATASET" ]] ||
    die "$DOCKER_DATA_DIR is not mounted from $DOCKER_ZFS_DATASET; run setup.sh system first"
}

setup_docker() {
  run_step "data dir" check_docker_data_dir
  run_step "repository" setup_docker_repository
  run_step "packages" setup_docker_packages
  run_step "service" setup_docker_service
}
