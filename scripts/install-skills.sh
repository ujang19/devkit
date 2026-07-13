#!/usr/bin/env bash
# Install standard global agent skills (OpenCode, Claude, …)
set -euo pipefail
export PATH="${HOME}/.local/bin:${HOME}/.bun/bin:${PATH}"

add() {
  echo "==> skills add $*"
  npx --yes skills@latest add "$@" -g -a '*' -y || {
    echo "warn: failed: $*" >&2
    return 0
  }
}

add emilkowalski/skills --skill '*'
add mattpocock/skills --skill '*'
add https://github.com/shadcn/ui --skill shadcn
add shadcn/improve --skill '*'
add obra/superpowers --skill '*'
add https://github.com/jakubantalik/transitions-dev --skill transitions-dev
add pbakaus/impeccable --skill '*'

# local devkit skill if present
if [[ -f "${HOME}/.agents/skills/devkit/SKILL.md" ]]; then
  add "${HOME}/.agents/skills" --skill devkit
elif [[ -f "${HOME}/linux-devkit/.agents/skills/devkit/SKILL.md" ]]; then
  add "${HOME}/linux-devkit/.agents/skills" --skill devkit
fi

echo ""
npx --yes skills@latest list -g
echo "Done."
