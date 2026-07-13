#!/usr/bin/env bash
# ONE command on a brand-new Ubuntu VPS
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/ujang19/devkit/main/bootstrap-vps.sh | bash
set -euo pipefail

PROFILE="${DEVKIT_PROFILE:-default}"
WITH_DOCKER="${DEVKIT_WITH_DOCKER:-1}"
KIT_REPO="${DEVKIT_KIT_REPO:-}"   # e.g. https://github.com/ujang19/devkit.git

export PATH="$HOME/.local/bin:$PATH"

if [[ -n "$KIT_REPO" ]]; then
  git clone "$KIT_REPO" "$HOME/linux-devkit" 2>/dev/null \
    || (cd "$HOME/linux-devkit" && git pull --ff-only)
  bash "$HOME/linux-devkit/install.sh" --profile "$PROFILE" $([[ "$WITH_DOCKER" == "1" ]] && echo --with-docker) -y
else
  # fallback: only installer if kit repo not set
  if [[ -f "$HOME/linux-devkit/install.sh" ]]; then
    bash "$HOME/linux-devkit/install.sh" --profile "$PROFILE" $([[ "$WITH_DOCKER" == "1" ]] && echo --with-docker) -y
  else
    echo "Set DEVKIT_KIT_REPO=git@github.com:ujang19/devkit.git"
    exit 1
  fi
fi

export PATH="$HOME/.local/bin:$PATH"
# restore all apps
if command -v devkit >/dev/null; then
  devkit restore || true
  devkit doctor || true
fi

# Agent skills pack
if [[ -x "$HOME/linux-devkit/scripts/install-skills.sh" ]]; then
  bash "$HOME/linux-devkit/scripts/install-skills.sh" || true
elif [[ -x "$HOME/devkit/scripts/install-skills.sh" ]]; then
  bash "$HOME/devkit/scripts/install-skills.sh" || true
fi


echo
echo "Next: gh auth login  (if not already)"
echo "      infisical login"
echo "      cd \$(devkit path wabase)   # etc"
