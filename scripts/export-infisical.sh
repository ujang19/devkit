#!/usr/bin/env bash
# Hanya export + login Infisical Universal Auth
#
#   source ~/linux-devkit/scripts/export-infisical.sh
#   infisical run --env=dev -- printenv | head
#
# shellcheck disable=SC1091
_KIT="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")/.." 2>/dev/null && pwd)"
if [[ -z "${INFISICAL_UNIVERSAL_AUTH_CLIENT_ID:-}" ]]; then
  for f in "${HOME}/.devkit.env" "${_KIT}/.devkit.env"; do
    [[ -f "$f" ]] || continue
    # shellcheck disable=SC1090
    set -a; source "$f"; set +a
    break
  done
fi

export INFISICAL_DOMAIN="${INFISICAL_DOMAIN:-https://app.infisical.com/api}"
export INFISICAL_ENV="${INFISICAL_ENV:-dev}"

if [[ -z "${INFISICAL_UNIVERSAL_AUTH_CLIENT_ID:-}" || -z "${INFISICAL_UNIVERSAL_AUTH_CLIENT_SECRET:-}" ]]; then
  echo "✗ Isi dulu di ~/.devkit.env:"
  echo "    INFISICAL_UNIVERSAL_AUTH_CLIENT_ID=..."
  echo "    INFISICAL_UNIVERSAL_AUTH_CLIENT_SECRET=..."
  echo "  EU: INFISICAL_DOMAIN=https://eu.infisical.com/api"
  return 1 2>/dev/null || exit 1
fi

export INFISICAL_UNIVERSAL_AUTH_CLIENT_ID
export INFISICAL_UNIVERSAL_AUTH_CLIENT_SECRET

echo "✓ Infisical credentials loaded"
echo "  CLIENT_ID: ${INFISICAL_UNIVERSAL_AUTH_CLIENT_ID}"
echo "  DOMAIN:    ${INFISICAL_DOMAIN}"
echo "  ENV:       ${INFISICAL_ENV}"

if command -v infisical >/dev/null 2>&1; then
  if infisical login \
      --domain="${INFISICAL_DOMAIN}" \
      --method=universal-auth \
      --client-id="${INFISICAL_UNIVERSAL_AUTH_CLIENT_ID}" \
      --client-secret="${INFISICAL_UNIVERSAL_AUTH_CLIENT_SECRET}"; then
    echo "✓ Infisical login OK"
    infisical login status 2>/dev/null | head -15 || true
  else
    echo "✗ Login gagal — cek secret / domain US vs EU"
    return 1 2>/dev/null || exit 1
  fi
else
  echo "⚠ infisical CLI belum terpasang. Jalankan dulu: bash ~/linux-devkit/run.sh"
fi
