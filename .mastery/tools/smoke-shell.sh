#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"

LOCK_DIR=".mastery/tmp/smoke.lock"
mkdir -p .mastery/tmp

acquire_lock() {
  local waited=0
  until mkdir "$LOCK_DIR" 2>/dev/null; do
    if [[ "$waited" -ge 30 ]]; then
      echo "Timed out waiting for smoke test lock."
      exit 1
    fi
    sleep 1
    waited=$((waited + 1))
  done
}

release_lock() {
  rmdir "$LOCK_DIR" 2>/dev/null || true
}

acquire_lock

TMP_DIR="$(mktemp -d)"
HAD_STATE=0
HAD_TASK=0

cp roadmap.md "$TMP_DIR/roadmap.md"
if [[ -f .mastery/state.json ]]; then
  cp .mastery/state.json "$TMP_DIR/state.json"
  HAD_STATE=1
fi
if [[ -d current_task ]]; then
  cp -R current_task "$TMP_DIR/current_task"
  HAD_TASK=1
fi

restore() {
  cp "$TMP_DIR/roadmap.md" roadmap.md
  if [[ "$HAD_STATE" -eq 1 ]]; then
    cp "$TMP_DIR/state.json" .mastery/state.json
  else
    rm -f .mastery/state.json
  fi
  if [[ "$HAD_TASK" -eq 1 ]]; then
    rm -rf current_task
    cp -R "$TMP_DIR/current_task" current_task
  else
    rm -rf current_task
  fi
  rm -rf "$TMP_DIR"
  release_lock
}

trap restore EXIT

./mastery start "学点 shell" >/dev/null

if ! grep -Fq 'bash "$ROOT/workspace/test"/*_test.sh' current_task/verify.sh; then
  echo "Expected shell verify command to come from track metadata."
  sed -n '1,40p' current_task/verify.sh
  exit 1
fi

if ./mastery check >/tmp/mastery-smoke-shell-fail.log 2>&1; then
  echo "Expected starter shell task to fail before the learner edits it."
  exit 1
fi

cat > current_task/workspace/bin/quote_args.sh <<'SH'
#!/usr/bin/env bash
set -euo pipefail

for arg in "$@"; do
  printf '%s\n' "$arg"
done
SH

./mastery check
