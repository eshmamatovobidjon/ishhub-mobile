#!/usr/bin/env bash
# Run the IshHub Flutter app on a USB-attached Android device.
# - Sets up adb reverse so the phone can reach the host backend on :8765.
# - Passes the right --dart-define for API_BASE / WS_BASE.
#
# Usage:
#   ./scripts/dev-mobile.sh                # picks first Android device
#   ./scripts/dev-mobile.sh <deviceId>     # explicit serial from `adb devices`

set -euo pipefail
cd "$(dirname "$0")/.."

DEVICE="${1:-}"
PORT=8765

if [ -z "$DEVICE" ]; then
  DEVICE=$(adb devices | awk '/\tdevice$/ {print $1; exit}')
fi
[ -z "$DEVICE" ] && { echo "no Android device attached. Run \`adb devices\`"; exit 1; }

echo "==> using device $DEVICE"
adb -s "$DEVICE" reverse tcp:${PORT} tcp:${PORT} >/dev/null

export ANDROID_HOME="${ANDROID_HOME:-$HOME/Library/Android/sdk}"
export ANDROID_SDK_ROOT="$ANDROID_HOME"

flutter pub get
exec flutter run -d "$DEVICE" \
  --dart-define=API_BASE=http://localhost:${PORT}/api/v1 \
  --dart-define=WS_BASE=ws://localhost:${PORT}/ws
