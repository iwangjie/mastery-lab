# 问题拆解：订单汇总函数漏算外部输入

## 对应课题

- 课题：Ruby 语言与工程基础
- 能力节点：集合处理、Hash 和键、nil 边界、对象可变性、测试反馈
- 目标难度：L2 修复
- 对应场景：[problems/ruby/001-order-summary-enumerable](../../problems/ruby/001-order-summary-enumerable/README.md)

## 问题一句话

一个订单汇总函数在内部 symbol key 数据上看起来正常，但遇到外部 JSON 风格 string key、nil 字段和空集合时会漏算或报错。

## 为什么这个问题值得训练

Ruby 业务代码经常处理来自 API、数据库、队列、CSV 或 JSON 的数据。这些数据可能不是统一的 symbol key，也可能缺字段。初学者和 AI 都容易写出一段看起来很 Ruby 的链式调用，但只覆盖正常输入。

掌握不好会造成：

- 统计结果漏算。
- 缺失字段导致线上异常。
- 为了“修复”而修改调用方传入的原始数据。
- 只会背 `map/select/reduce`，不能根据业务规则组合它们。

## 目标能力

这题训练：

- 用 `Enumerable` 组合筛选、映射、累计。
- 兼容 symbol key 和 string key。
- 明确处理 nil 和缺失字段。
- 保持输入数据不被修改。
- 用测试失败信息定位真实规则。

## 不训练什么

这题不训练：

- Rails。
- ActiveSupport。
- Bundler 和 gem 管理。
- 数据库查询。
- 性能优化。

## 关键判断信号

专家会优先看：

- 测试期望的是业务规则，不只是语法。
- 输入里同时有 symbol key 和 string key。
- `nil` 状态要归到 `"unknown"`。
- `nil` 金额不能让求和崩掉。
- 汇总函数不能修改传入的 orders。

## 底层机制

必须理解：

- Ruby 的 `:status` 和 `"status"` 是两个不同的 Hash key。
- 除了 `false` 和 `nil`，Ruby 中大多数对象都是真值。
- `Enumerable#map`、`#select`、`#each_with_object`、`#reduce` 的 block 返回值语义不同。
- `Hash.new([])`、共享默认对象等写法可能制造隐藏 mutation 风险。
- 方法最后一个表达式会成为返回值。

## 常见失败路径

| 失败路径 | 为什么看起来合理 | 真正风险 |
| --- | --- | --- |
| 只读 `order[:status]` | 内部 Ruby 代码常用 symbol key | 外部 JSON 风格 string key 会漏算 |
| 直接 `sum { |o| o[:total_cents] }` | happy path 很简洁 | nil 金额会导致异常或错误结果 |
| 修改每个 order 来补默认值 | 处理起来方便 | 调用方输入被污染 |
| 用很多 if 硬编码 | 能快速通过部分测试 | 不能迁移到其他汇总问题 |

## 现场材料

场景生成：

- `lib/order_summary.rb`：有缺陷的实现。
- `test/order_summary_test.rb`：描述业务规则的 Minitest。
- `verify.sh`：运行测试。

## 验证证据

验证脚本检查：

- 空输入返回稳定结构。
- symbol key 和 string key 都能被统计。
- nil status 归到 `"unknown"`。
- paid 金额只统计 paid 订单，nil 金额按 0 处理。
- 高价值订单只包含 paid 且金额达标的订单。
- 客户列表去重、保序、排除 nil。
- 调用前后输入没有被修改。

## 分级提示设计

- Hint 1：先看失败测试名，不要先改代码。
- Hint 2：检查 Hash key 类型和 nil 字段。
- Hint 3：写一个小 helper 统一读取 `:key` 和 `"key"`。

## 升级变体

- 变体 1：订单来自 CSV，字段都是字符串，需要转换金额和状态。
- 变体 2：增加退款、折扣和多币种，要求把业务规则拆成小方法。

## 复盘重点

- 为什么“代码很 Ruby”不等于“业务规则正确”？
- 什么时候应该用 `map/select/reduce`，什么时候 `each_with_object` 更清楚？
- 如何判断一个修复有没有污染输入对象？

