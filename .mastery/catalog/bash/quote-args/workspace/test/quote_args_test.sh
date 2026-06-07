#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT="$ROOT/bin/quote_args.sh"
chmod +x "$SCRIPT"

actual="$(mktemp)"
expected="$(mktemp)"
trap 'rm -f "$actual" "$expected"' EXIT

"$SCRIPT" "hello world" "two  spaces" "asterisk * stays" > "$actual"
printf '%s\n' "hello world" "two  spaces" "asterisk * stays" > "$expected"

diff -u "$expected" "$actual"
