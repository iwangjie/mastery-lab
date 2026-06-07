module OrderSummary
  module_function

  def call(orders)
    {
      total_orders: orders.length,
      totals_by_status: {},
      paid_total_cents: 0,
      high_value_order_ids: [],
      customers: []
    }
  end
end
