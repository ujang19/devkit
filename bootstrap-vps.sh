#!/usr/bin/env bash
# Thin wrapper → full setup (run.sh)
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/ujang19/devkit/main/bootstrap-vps.sh | bash
#
# With secrets:
#   export GH_TOKEN=...
#   export INFISICAL_UNIVERSAL_AUTH_CLIENT_ID=...
#   export INFISICAL_UNIVERSAL_AUTH_CLIENT_SECRET=...
#   curl -fsSL .../bootstrap-vps.sh | bash
set -euo pipefail

KIT_REPO="${DEVKIT_KIT_REPO:-https://github.com/ujang19/devkit.git}"
export PATH="${HOME}/.local/bin:${PATH}"

if ! command -v git >/dev/null 2>&1 || ! command -v curl >/dev/null 2>&1; then
  if command -v sudo >/dev/null 2>&1 && sudo -n true 2>/dev/null; then
    sudo apt-get update -y
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y git curl ca-certificates
  else
    echo "Need git + curl. Install: sudo apt-get install -y git curl" >&2
    exit 1
  fi
fi

if [[ -f "${HOME}/linux-devkit/run.sh" ]]; then
  git -C "${HOME}/linux-devkit" pull --ff-only 2>/dev/null || true
else
  git clone --depth 1 "${KIT_REPO}" "${HOME}/linux-devkit"
fi

exec bash "${HOME}/linux-devkit/run.sh"
