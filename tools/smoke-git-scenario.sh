#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCENARIO="$ROOT/problems/git/001-public-rebase-damage"
LEARNER="$SCENARIO/work/learner"

"$SCENARIO/setup.sh" >/dev/null

if "$SCENARIO/verify.sh" >/tmp/mastery-lab-verify.log 2>&1; then
  echo "Expected damaged scenario to fail verification before repair."
  exit 1
fi

git -C "$LEARNER" remote add teammate ../teammate
git -C "$LEARNER" fetch teammate feature/checkout-flow >/dev/null
git -C "$LEARNER" cherry-pick teammate/feature/checkout-flow >/dev/null
git -C "$LEARNER" push origin feature/checkout-flow >/dev/null

"$SCENARIO/verify.sh"

