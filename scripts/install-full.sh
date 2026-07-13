#!/usr/bin/env bash
# =============================================================================
# install-full.sh — export env + full install sampai siap pakai
#
# 1) Isi token:
#      cp ~/linux-devkit/.devkit.env.example ~/.devkit.env
#      nano ~/.devkit.env
#
# 2) Jalankan:
#      bash ~/linux-devkit/scripts/install-full.sh
#
# Atau sekali di VM baru (setelah env file ada):
#      curl -fsSL https://raw.githubusercontent.com/ujang19/devkit/main/scripts/install-full.sh | bash
# =============================================================================
set -euo pipefail

KIT_REPO="${DEVKIT_KIT_REPO:-https://github.com/ujang19/devkit.git}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)" || SCRIPT_DIR=""

# ── pastikan kit ada ────────────────────────────────────────────────────────
if [[ ! -f "${HOME}/linux-devkit/run.sh" ]]; then
  if command -v git >/dev/null 2>&1; then
    git clone --depth 1 "${KIT_REPO}" "${HOME}/linux-devkit"
  else
    echo "Need git. Install: sudo apt-get install -y git curl"
    exit 1
  fi
else
  git -C "${HOME}/linux-devkit" pull --ff-only 2>/dev/null || true
fi

KIT="${HOME}/linux-devkit"

# ── load env ────────────────────────────────────────────────────────────────
if [[ -f "${HOME}/.devkit.env" ]] || [[ -f "${KIT}/.devkit.env" ]] || [[ -n "${DEVKIT_ENV_FILE:-}" ]]; then
  # shellcheck disable=SC1091
  source "${KIT}/scripts/export-env.sh"
else
  echo "⚠  Belum ada ~/.devkit.env"
  echo "   Buat dulu:"
  echo "     cp ${KIT}/.devkit.env.example ~/.devkit.env"
  echo "     nano ~/.devkit.env"
  echo ""
  echo "   Lanjut tanpa secret? (private clone & Infisical akan skip)"
  echo "   Tekan Enter untuk lanjut, Ctrl+C untuk batal."
  read -r _
fi

# ── full pipeline ───────────────────────────────────────────────────────────
echo ""
echo "==> running full setup (run.sh)..."
bash "${KIT}/run.sh"

# ── Infisical login ulang explicit (kalau credentials ada) ──────────────────
if command -v infisical >/dev/null 2>&1 \
  && [[ -n "${INFISICAL_UNIVERSAL_AUTH_CLIENT_ID:-}" ]] \
  && [[ -n "${INFISICAL_UNIVERSAL_AUTH_CLIENT_SECRET:-}" ]]; then
  echo ""
  echo "==> Infisical login (universal-auth)..."
  infisical login \
    --domain="${INFISICAL_DOMAIN:-https://app.infisical.com/api}" \
    --method=universal-auth \
    --client-id="${INFISICAL_UNIVERSAL_AUTH_CLIENT_ID}" \
    --client-secret="${INFISICAL_UNIVERSAL_AUTH_CLIENT_SECRET}" \
    && echo "✓ Infisical OK" \
    || echo "⚠ Infisical login gagal — cek domain US/EU + credentials"
fi

# ── ringkas ─────────────────────────────────────────────────────────────────
export PATH="${HOME}/.local/bin:${HOME}/.bun/bin:${PATH}"
echo ""
echo "════════════════════════════════════════"
echo "  SELESAI"
echo "════════════════════════════════════════"
if command -v devkit >/dev/null 2>&1; then
  devkit list || true
  echo ""
  echo "Masuk project:"
  echo "  cd \"\$(devkit path wabase-core)\""
  echo "  cd \"\$(devkit path wazapin-platform)\""
  echo "  cd \"\$(devkit path wazapin-web)\""
  echo "  cd \"\$(devkit path betterpay)\""
  echo ""
  echo "Dengan secrets:"
  echo "  infisical run --env=${INFISICAL_ENV:-dev} -- bun run dev"
fi
