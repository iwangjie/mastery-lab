#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LEARNER="$ROOT/work/learner"

if [[ ! -d "$LEARNER/.git" ]]; then
  echo "Missing work/learner. Run ./setup.sh first."
  exit 1
fi

git -C "$LEARNER" fetch origin >/dev/null

branch="$(git -C "$LEARNER" rev-parse --abbrev-ref HEAD)"
if [[ "$branch" != "feature/checkout-flow" ]]; then
  echo "Expected learner to be on feature/checkout-flow, got $branch."
  exit 1
fi

if ! git -C "$LEARNER" diff --quiet; then
  echo "Working tree has uncommitted changes."
  exit 1
fi

if ! git -C "$LEARNER" merge-base --is-ancestor origin/main HEAD; then
  echo "feature/checkout-flow does not contain origin/main."
  exit 1
fi

if [[ ! -f "$LEARNER/app/routes.txt" ]] || ! grep -q "render checkout page" "$LEARNER/app/routes.txt"; then
  echo "Missing checkout route change."
  exit 1
fi

if [[ ! -f "$LEARNER/app/fraud.txt" ]] || ! grep -q "fraud screen" "$LEARNER/app/fraud.txt"; then
  echo "Missing main branch fraud screen change."
  exit 1
fi

if [[ ! -f "$LEARNER/app/telemetry.txt" ]] || ! grep -q "checkout_attempt" "$LEARNER/app/telemetry.txt"; then
  echo "Missing recovered teammate telemetry change."
  exit 1
fi

if ! git -C "$LEARNER" log --format=%H --grep="Add checkout telemetry" -1 | grep -q .; then
  echo "Recovered history should include the teammate commit message."
  exit 1
fi

local_head="$(git -C "$LEARNER" rev-parse HEAD)"
remote_head="$(git -C "$LEARNER" rev-parse origin/feature/checkout-flow)"
if [[ "$local_head" != "$remote_head" ]]; then
  echo "origin/feature/checkout-flow is not updated to the repaired branch."
  exit 1
fi

echo "Verified: public rebase damage repaired."
