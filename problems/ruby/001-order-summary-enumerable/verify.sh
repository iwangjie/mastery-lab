#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK="$ROOT/work"

if [[ ! -f "$WORK/lib/order_summary.rb" ]]; then
  echo "Missing work/lib/order_summary.rb. Run ./setup.sh first."
  exit 1
fi

ruby -I"$WORK/test" "$WORK/test/order_summary_test.rb"

