#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK="$ROOT/work"

rm -rf "$WORK"
mkdir -p "$WORK"

git init --bare "$WORK/origin.git" >/dev/null

git clone "$WORK/origin.git" "$WORK/dev-a" >/dev/null 2>&1
git -C "$WORK/dev-a" config user.name "Dev A"
git -C "$WORK/dev-a" config user.email "dev-a@example.test"
git -C "$WORK/dev-a" checkout -b main >/dev/null

mkdir -p "$WORK/dev-a/app"
cat > "$WORK/dev-a/app/routes.txt" <<'EOF'
/login: auth controller
/checkout: TODO
/profile: profile controller
EOF

git -C "$WORK/dev-a" add app/routes.txt
git -C "$WORK/dev-a" commit -m "Initial route table" >/dev/null
git -C "$WORK/dev-a" push -u origin main >/dev/null
git -C "$WORK/origin.git" symbolic-ref HEAD refs/heads/main

git -C "$WORK/dev-a" checkout -b feature/checkout-flow >/dev/null
cat > "$WORK/dev-a/app/routes.txt" <<'EOF'
/login: auth controller
/checkout: render checkout page
/profile: profile controller
EOF
git -C "$WORK/dev-a" commit -am "Add checkout page route" >/dev/null
git -C "$WORK/dev-a" push -u origin feature/checkout-flow >/dev/null

git clone "$WORK/origin.git" "$WORK/learner" >/dev/null 2>&1
git -C "$WORK/learner" config user.name "Learner"
git -C "$WORK/learner" config user.email "learner@example.test"
git -C "$WORK/learner" checkout feature/checkout-flow >/dev/null

git clone "$WORK/origin.git" "$WORK/teammate" >/dev/null 2>&1
git -C "$WORK/teammate" config user.name "Teammate"
git -C "$WORK/teammate" config user.email "teammate@example.test"
git -C "$WORK/teammate" checkout feature/checkout-flow >/dev/null
cat > "$WORK/teammate/app/telemetry.txt" <<'EOF'
checkout_attempt
checkout_submit
EOF
git -C "$WORK/teammate" add app/telemetry.txt
git -C "$WORK/teammate" commit -m "Add checkout telemetry" >/dev/null
git -C "$WORK/teammate" push origin feature/checkout-flow >/dev/null

git -C "$WORK/dev-a" checkout main >/dev/null
cat > "$WORK/dev-a/app/fraud.txt" <<'EOF'
checkout requires fraud screen before payment
EOF
git -C "$WORK/dev-a" add app/fraud.txt
git -C "$WORK/dev-a" commit -m "Protect checkout with fraud screen" >/dev/null
git -C "$WORK/dev-a" push origin main >/dev/null

git -C "$WORK/learner" fetch origin main:refs/remotes/origin/main >/dev/null
git -C "$WORK/learner" rebase origin/main >/dev/null
git -C "$WORK/learner" push --force origin feature/checkout-flow >/dev/null

cat <<EOF
Created damaged Git scenario.

Start here:
  cd "$WORK/learner"

Then repair feature/checkout-flow and run:
  cd "$ROOT"
  ./verify.sh
EOF

