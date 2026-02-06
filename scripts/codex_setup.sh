#!/usr/bin/env bash
set -euo pipefail

log() {
  printf '[codex_setup] %s\n' "$*"
}

log "Starting setup (cwd: $(pwd))"

missing_pkgs=()

if ! command -v pandoc >/dev/null 2>&1; then
  missing_pkgs+=("pandoc")
fi

if ! command -v rg >/dev/null 2>&1; then
  missing_pkgs+=("ripgrep")
fi

if ! command -v git >/dev/null 2>&1; then
  missing_pkgs+=("git")
fi

if ((${#missing_pkgs[@]} > 0)); then
  if ! command -v apt-get >/dev/null 2>&1; then
    log "Missing packages: ${missing_pkgs[*]}"
    log "apt-get not found; cannot install. Aborting."
    exit 1
  fi

  log "Installing via apt-get: ${missing_pkgs[*]}"
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get install -y --no-install-recommends "${missing_pkgs[@]}"
else
  log "All required tools already present."
fi

log "Tool versions:"
git --version || true
rg --version || true
pandoc --version || true

log "Setup complete."

