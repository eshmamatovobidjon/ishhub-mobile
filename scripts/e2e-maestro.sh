#!/usr/bin/env bash
# Build, install, and run Phase 9 Maestro acceptance flows.
#
# Prerequisites:
#   - Backend reachable on host port 8765.
#   - Maestro installed: https://maestro.mobile.dev/getting-started/installing-maestro
#   - Android emulator or USB device visible in `adb devices`.
#
# Usage:
#   ./scripts/e2e-maestro.sh                    # run unseeded first-pass flows
#   ./scripts/e2e-maestro.sh 01_onboarding.yaml # run one flow
#   DEVICE_ID=<serial> ./scripts/e2e-maestro.sh # choose device
#   RUN_SEEDED=1 ./scripts/e2e-maestro.sh       # include seed-dependent flows
#   E2E_SEED_MODE=host RUN_SEEDED=1 ./scripts/e2e-maestro.sh # force host manage.py seeding
#   SKIP_E2E_SEED=1 RUN_SEEDED=1 ./scripts/e2e-maestro.sh # reuse existing seed state

set -euo pipefail

cd "$(dirname "$0")/.."

APP_ID="uz.ishhub.ishhub"
PORT="${ISHHUB_API_PORT:-8765}"
MINIO_PORT="${ISHHUB_MINIO_PORT:-9000}"
API_DIR="${ISHHUB_API_DIR:-../ishhub-api}"
if [ -z "${PYTHON_BIN:-}" ] && [ -x "$API_DIR/.venv/bin/python" ]; then
  PYTHON_BIN="$API_DIR/.venv/bin/python"
else
  PYTHON_BIN="${PYTHON_BIN:-python3}"
fi
DEVICE="${DEVICE_ID:-}"
FLOW="${1:-}"

command -v adb >/dev/null 2>&1 || { echo "adb is required" >&2; exit 1; }
command -v flutter >/dev/null 2>&1 || { echo "flutter is required" >&2; exit 1; }
command -v maestro >/dev/null 2>&1 || { echo "maestro is required" >&2; exit 1; }

if [ -z "$DEVICE" ]; then
  DEVICE=$(adb devices | awk '/\tdevice$/ {print $1; exit}')
fi
[ -z "$DEVICE" ] && { echo "no Android device/emulator found. Run \`adb devices\`." >&2; exit 1; }

if [[ "$DEVICE" == emulator-* ]]; then
  API_BASE="http://10.0.2.2:${PORT}/api/v1"
  WS_BASE="ws://10.0.2.2:${PORT}/ws"
else
  adb -s "$DEVICE" reverse "tcp:${PORT}" "tcp:${PORT}" >/dev/null
  adb -s "$DEVICE" reverse "tcp:${MINIO_PORT}" "tcp:${MINIO_PORT}" >/dev/null
  API_BASE="http://localhost:${PORT}/api/v1"
  WS_BASE="ws://localhost:${PORT}/ws"
fi

RUN_ID="${RUN_ID:-$(date +%H%M%S)}"
CLIENT_PHONE="${CLIENT_PHONE:-+99890${RUN_ID:0:6}1}"
WORKER_PHONE="${WORKER_PHONE:-+99890${RUN_ID:0:6}2}"
OTP_CODE="${OTP_CODE:-000000}"

echo "==> device: $DEVICE"
echo "==> api:    $API_BASE"
echo "==> ws:     $WS_BASE"
echo "==> client: $CLIENT_PHONE"
echo "==> worker: $WORKER_PHONE"

if [ "${RUN_SEEDED:-0}" = "1" ] && [ "${SKIP_E2E_SEED:-0}" != "1" ]; then
  echo "==> seeding Phase 9 E2E data"
  (
    cd "$API_DIR"
    if [ "${E2E_SEED_MODE:-auto}" != "host" ] \
      && command -v docker >/dev/null 2>&1 \
      && docker compose ps api --status running --format '{{.Name}}' 2>/dev/null | grep -q .; then
      docker compose exec -T api python manage.py seed_phase9_e2e --reset \
        --client-phone "$CLIENT_PHONE" \
        --worker-phone "$WORKER_PHONE"
    else
      "$PYTHON_BIN" manage.py seed_phase9_e2e --reset \
        --client-phone "$CLIENT_PHONE" \
        --worker-phone "$WORKER_PHONE"
    fi
  )
fi

flutter pub get
flutter build apk --debug \
  --dart-define="API_BASE=${API_BASE}" \
  --dart-define="WS_BASE=${WS_BASE}"

adb -s "$DEVICE" install -r build/app/outputs/flutter-apk/app-debug.apk >/dev/null

if [ -n "$FLOW" ]; then
  TARGET=".maestro/$FLOW"
else
  TARGET=".maestro"
fi

EXTRA_ARGS=()
if [ "${RUN_SEEDED:-0}" != "1" ] && [ -z "$FLOW" ]; then
  EXTRA_ARGS+=(--exclude-tags=requires-seed)
fi

MAESTRO_CMD=(
  maestro test --udid "$DEVICE"
  -e APP_ID="$APP_ID"
  -e CLIENT_PHONE="$CLIENT_PHONE"
  -e WORKER_PHONE="$WORKER_PHONE"
  -e OTP_CODE="$OTP_CODE"
)

if [ ${#EXTRA_ARGS[@]} -gt 0 ]; then
  MAESTRO_CMD+=("${EXTRA_ARGS[@]}")
fi

MAESTRO_CMD+=("$TARGET")
exec "${MAESTRO_CMD[@]}"