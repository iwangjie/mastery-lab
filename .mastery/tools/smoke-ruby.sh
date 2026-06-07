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

./mastery start "继续学习 Ruby" >/dev/null

if ./mastery check >/tmp/mastery-smoke-fail.log 2>&1; then
  echo "Expected starter task to fail before the learner edits it."
  exit 1
fi

cat > current_task/workspace/lib/order_summary.rb <<'RUBY'
module OrderSummary
  module_function

  def call(orders)
    {
      total_orders: orders.length,
      totals_by_status: totals_by_status(orders),
      paid_total_cents: paid_total_cents(orders),
      high_value_order_ids: high_value_order_ids(orders),
      customers: customers(orders)
    }
  end

  def totals_by_status(orders)
    orders.each_with_object(Hash.new(0)) do |order, counts|
      counts[status_for(order)] += 1
    end
  end

  def paid_total_cents(orders)
    orders
      .select { |order| status_for(order) == "paid" }
      .reduce(0) { |sum, order| sum + cents_for(order) }
  end

  def high_value_order_ids(orders)
    orders
      .select { |order| status_for(order) == "paid" && cents_for(order) >= 2000 }
      .map { |order| value_for(order, :id) }
  end

  def customers(orders)
    orders
      .map { |order| value_for(order, :customer) }
      .compact
      .uniq
  end

  def status_for(order)
    raw = value_for(order, :status)
    raw.nil? || raw.to_s.empty? ? "unknown" : raw.to_s
  end

  def cents_for(order)
    value_for(order, :total_cents) || 0
  end

  def value_for(order, key)
    order.key?(key) ? order[key] : order[key.to_s]
  end
end
RUBY

./mastery check >/dev/null
./mastery next >/dev/null

cat > current_task/workspace/lib/enumerable_drill.rb <<'RUBY'
module EnumerableDrill
  module_function

  def my_select(items)
    raise ArgumentError, "block required" unless block_given?

    result = []
    items.each do |item|
      result << item if yield(item)
    end
    result
  end
end
RUBY

./mastery check
