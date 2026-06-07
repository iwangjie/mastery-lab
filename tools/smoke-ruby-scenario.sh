#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCENARIO="$ROOT/problems/ruby/001-order-summary-enumerable"
WORK="$SCENARIO/work"

"$SCENARIO/setup.sh" >/dev/null

if "$SCENARIO/verify.sh" >/tmp/mastery-lab-ruby-verify.log 2>&1; then
  echo "Expected initial Ruby scenario to fail verification before repair."
  exit 1
fi

cat > "$WORK/lib/order_summary.rb" <<'EOF'
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
    value_for(order, :status).to_s.empty? ? "unknown" : value_for(order, :status).to_s
  end

  def cents_for(order)
    value_for(order, :total_cents) || 0
  end

  def value_for(order, key)
    order.key?(key) ? order[key] : order[key.to_s]
  end
end
EOF

"$SCENARIO/verify.sh"

