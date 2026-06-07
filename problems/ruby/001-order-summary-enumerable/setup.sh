#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK="$ROOT/work"

rm -rf "$WORK"
mkdir -p "$WORK/lib" "$WORK/test"

cat > "$WORK/lib/order_summary.rb" <<'EOF'
module OrderSummary
  module_function

  def call(orders)
    totals_by_status = Hash.new(0)

    orders.each do |order|
      totals_by_status[order[:status].to_s] += 1
    end

    {
      total_orders: orders.length,
      totals_by_status: totals_by_status,
      paid_total_cents: orders
        .select { |order| order[:status] == :paid }
        .map { |order| order[:total_cents] }
        .reduce(0, :+),
      high_value_order_ids: [],
      customers: orders.map { |order| order[:customer] }.uniq
    }
  end
end
EOF

cat > "$WORK/test/order_summary_test.rb" <<'EOF'
require "minitest/autorun"
require_relative "../lib/order_summary"

class OrderSummaryTest < Minitest::Test
  SAMPLE_ORDERS = [
    { id: "A-1001", customer: "Ada", status: :paid, total_cents: 1200 },
    { "id" => "A-1002", "customer" => "Lin", "status" => "paid", "total_cents" => 3400 },
    { id: "A-1003", customer: "Ada", status: :pending, total_cents: 500 },
    { id: "A-1004", customer: nil, status: :paid, total_cents: nil },
    { id: "A-1005", customer: "Matz", status: :refunded, total_cents: 1800 },
    { id: "A-1006", customer: "Lin", status: nil, total_cents: 2300 }
  ].freeze

  def deep_copy(value)
    Marshal.load(Marshal.dump(value))
  end

  def test_summarizes_mixed_internal_and_external_order_data
    summary = OrderSummary.call(deep_copy(SAMPLE_ORDERS))

    assert_equal 6, summary[:total_orders]
    assert_equal(
      {
        "paid" => 3,
        "pending" => 1,
        "refunded" => 1,
        "unknown" => 1
      },
      summary[:totals_by_status]
    )
    assert_equal 4600, summary[:paid_total_cents]
    assert_equal ["A-1002"], summary[:high_value_order_ids]
    assert_equal ["Ada", "Lin", "Matz"], summary[:customers]
  end

  def test_handles_empty_orders
    summary = OrderSummary.call([])

    assert_equal 0, summary[:total_orders]
    assert_equal({}, summary[:totals_by_status])
    assert_equal 0, summary[:paid_total_cents]
    assert_equal [], summary[:high_value_order_ids]
    assert_equal [], summary[:customers]
  end

  def test_does_not_mutate_input_orders
    orders = deep_copy(SAMPLE_ORDERS)
    before = deep_copy(orders)

    OrderSummary.call(orders)

    assert_equal before, orders
  end
end
EOF

cat <<EOF
Created Ruby mastery scenario.

Start here:
  cd "$WORK"
  ruby -Itest test/order_summary_test.rb

Repair lib/order_summary.rb, then run:
  cd "$ROOT"
  ./verify.sh
EOF

