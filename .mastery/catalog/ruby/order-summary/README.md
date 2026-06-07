# 任务：订单汇总

你接手了一个小型电商后台。运营同事每天会导出一批订单数据，用来做简易报表。

问题是，这些数据并不总是干净的：有些订单来自内部 Ruby 代码，字段是 symbol key；有些来自外部 JSON，字段是 string key；有些订单缺少状态或金额。你的任务是写出一段足够稳的 Ruby 汇总逻辑，而不是只让正常样例跑通。

## 你要完成什么

请修改：

```text
workspace/lib/order_summary.rb
```

让 `OrderSummary.call(orders)` 返回一个 Hash，包含：

- `:total_orders`：订单数量。
- `:totals_by_status`：按状态计数，状态统一为字符串；nil 或缺失状态归为 `"unknown"`。
- `:paid_total_cents`：只统计 paid 订单金额；nil 或缺失金额按 0 处理。
- `:high_value_order_ids`：paid 且金额大于等于 2000 cents 的订单 id。
- `:customers`：非 nil 客户名，按首次出现顺序去重。

## 约束

- 不要引入 Rails、ActiveSupport 或第三方 gem。
- 不要修改测试。
- 不要修改传入的订单数组或其中的订单 Hash。
- 不要用 `for` 或 `while` 绕过 Ruby 的集合表达。

## 验证

回到项目根目录运行：

```bash
./mastery check
```

如果失败，先读测试名和报错位置。不要急着问答案，先判断失败来自业务规则、Ruby 语义，还是输入边界。
