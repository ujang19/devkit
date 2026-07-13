#!/usr/bin/env bash
# Hanya export GitHub token (untuk test clone cepat)
#
#   export GH_TOKEN='github_pat_xxx'   # atau isi di ~/.devkit.env
#   source ~/linux-devkit/scripts/export-gh.sh
#   devkit restore
#
# shellcheck disable=SC1091
_KIT="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")/.." 2>/dev/null && pwd)"
if [[ -z "${GH_TOKEN:-}" && -z "${GITHUB_TOKEN:-}" ]]; then
  for f in "${HOME}/.devkit.env" "${_KIT}/.devkit.env"; do
    [[ -f "$f" ]] || continue
    # shellcheck disable=SC1090
    set -a; source "$f"; set +a
    break
  done
fi

if [[ -n "${GH_TOKEN:-}" ]]; then
  export GH_TOKEN
  export GITHUB_TOKEN="${GITHUB_TOKEN:-$GH_TOKEN}"
elif [[ -n "${GITHUB_TOKEN:-}" ]]; then
  export GITHUB_TOKEN
  export GH_TOKEN="${GITHUB_TOKEN}"
else
  echo "✗ Set dulu: export GH_TOKEN='github_pat_...'"
  echo "  atau isi GH_TOKEN= di ~/.devkit.env"
  return 1 2>/dev/null || exit 1
fi

echo "✓ GH_TOKEN set (${#GH_TOKEN} chars)"
if command -v gh >/dev/null 2>&1; then
  echo "$GH_TOKEN" | gh auth login --with-token 2>/dev/null || true
  gh auth setup-git 2>/dev/null || true
  gh api user --jq '"GitHub user: \(.login)"' 2>/dev/null || echo "(gh api user gagal — cek token)"
fi
