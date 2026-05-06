#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

patterns=(
  "Text\\(['\"]"
  "TextSpan\\([^)]*text: ['\"]"
  "SnackBar\\([^)]*content: Text\\(['\"]"
  "showSnack\\(context, ['\"]"
  "labelText: ['\"]"
  "hintText: ['\"]"
  "tooltip: ['\"]"
  "title: const Text\\(['\"]"
  "label: const Text\\(['\"]"
  "child: const Text\\(['\"]"
)

pattern="$(IFS='|'; echo "${patterns[*]}")"
matches="$({ find lib/screens lib/widgets -name '*.dart' -print0 \
  | xargs -0 grep -En "$pattern"; } || true)"

if [[ -n "$matches" ]]; then
  echo "Hardcoded UI strings detected. Move user-facing text to lib/l10n/*.arb:" >&2
  echo "$matches" >&2
  exit 1
fi

echo "No hardcoded UI strings detected in lib/screens or lib/widgets."