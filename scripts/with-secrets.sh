#!/usr/bin/env bash
# Usage: with-secrets grok | with-secrets opencode | with-secrets -- env
set -euo pipefail
export PATH="$HOME/.local/bin:$HOME/.opencode/bin:$HOME/.local/go/bin:$PATH"
if command -v infisical >/dev/null 2>&1; then
  if [[ -n "${INFISICAL_TOKEN:-}" ]] || infisical user get 2>/dev/null | grep -q .; then
    exec infisical run --env="${INFISICAL_ENV:-dev}" -- "$@"
  fi
fi
# fallback: plain exec if already exported
exec "$@"
