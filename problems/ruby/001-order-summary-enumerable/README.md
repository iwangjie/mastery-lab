# 掌握场景：订单汇总函数漏算外部输入

## 对应课题

- 课题：Ruby 语言与工程基础
- 能力节点：集合处理、Hash 和键、nil 边界、对象可变性、测试反馈
- 难度等级：L2 修复

## 背景

你接手了一个小型运营报表脚本。它需要把订单数组汇总成 dashboard 使用的数据。

这段代码在开发者手写的 symbol key 数据上看起来正常，但真实订单来自外部 JSON、队列或 CSV 清洗结果，可能包含 string key、nil 字段、缺失金额。

你的任务不是背 Ruby 语法，而是修复这段业务代码，并通过测试解释 Ruby 的集合处理和边界行为。

## 初始化现场

```bash
./setup.sh
cd work
```

## 任务

修复 `work/lib/order_summary.rb`，让它满足 `work/test/order_summary_test.rb` 中描述的业务规则。

最终 `OrderSummary.call(orders)` 应返回：

- `:total_orders`：订单数量。
- `:totals_by_status`：按状态计数，状态统一为字符串；nil 或缺失状态归到 `"unknown"`。
- `:paid_total_cents`：只统计 paid 订单金额；nil 或缺失金额按 0。
- `:high_value_order_ids`：paid 且金额大于等于 2000 cents 的订单 id。
- `:customers`：非 nil 客户名，按首次出现顺序去重。

## 限制条件

- 不要引入 Rails、ActiveSupport 或第三方 gem。
- 不要修改测试来让它通过。
- 不要修改传入的 `orders`。
- 不要把逻辑写死到测试数据上。

## 验证

在场景目录运行：

```bash
./verify.sh
```

或在 `work/` 中直接运行：

```bash
ruby -Itest test/order_summary_test.rb
```

## 分级提示

### Hint 1

先读测试名和失败信息，确认每个失败对应哪条业务规则。

### Hint 2

检查 `order[:status]` 和 `order["status"]` 是否都被处理了。

### Hint 3

可以写一个小 helper 统一读取 Hash 的 symbol key 和 string key，然后再组合 `Enumerable`。

## 复盘问题

- Ruby 里 `:status` 和 `"status"` 为什么不是同一个 key？
- nil status 和 nil total 分别应该如何处理？为什么？
- 你的实现有没有修改原始订单？如何证明？
- 你用了哪些 `Enumerable` 方法？每个 block 返回值代表什么？
- 如果 AI 给出一个直接修改每个 order 默认值的方案，风险是什么？

## 变体

- 变体 1：订单来自 CSV，所有字段都是字符串，金额需要转换成整数。
- 变体 2：增加退款、折扣和币种，需要把汇总逻辑拆成更清楚的小方法。

