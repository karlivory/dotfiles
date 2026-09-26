#!/usr/bin/env bash

setup_docker_repository() {
  local arch codename keytemp
  need curl
  need gpg
  arch=$(dpkg --print-architecture)
  # shellcheck source=/dev/null
  source /etc/os-release
  [[ ${ID:-} == ubuntu && -n ${VERSION_CODENAME:-} ]] || die "Docker setup requires Ubuntu"
  codename=$VERSION_CODENAME
  root install -m 0755 -d /etc/apt/keyrings
  keytemp=$(mktemp)
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor >"$keytemp"
  write_root /etc/apt/keyrings/docker.gpg <"$keytemp"
  rm -f "$keytemp"
  DOCKER_CODENAME=$codename DOCKER_ARCH=$arch install_config etc/apt/sources.list.d/docker.sources.in
  root apt-get update
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

setup_docker() {
  run_step "repository" setup_docker_repository
  run_step "packages" setup_docker_packages
  run_step "service" setup_docker_service
}
