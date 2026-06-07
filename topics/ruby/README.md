# 课题：Ruby 语言与工程基础

## 为什么值得掌握

Ruby 的难点不在于语法看起来难，而在于它太容易写出“像英文一样顺”的代码。AI 也很容易生成能跑的 Ruby，但这些代码可能在 nil、Hash 默认值、符号/字符串键、block 返回值、对象可变性和测试边界上埋风险。

如果目标是掌握 Ruby，第一阶段不要直接跳到 Rails。先掌握 Ruby 本身如何表达业务规则、如何处理集合、如何写测试、如何读错误信息。

## 目标表现

完成这个课题后，人应该能：

- 读懂并修复 Ruby 业务代码。
- 用 `Enumerable` 表达集合转换、筛选、分组和累计。
- 区分 symbol key、string key、nil、false、空字符串等边界。
- 理解 block、方法返回值、对象可变性和异常。
- 用标准库测试证明行为。
- 审查 AI 生成的 Ruby 代码是否只是在“看起来优雅”。

## 能力图谱

| 能力节点 | 真实任务 | 底层概念 | 常见错误 | 验证方式 |
| --- | --- | --- | --- | --- |
| 集合处理 | 汇总订单、日志、配置、用户输入 | `Enumerable`、block、Hash 累计 | 只处理 happy path，漏掉 nil 和空集合 | Minitest 覆盖边界输入 |
| Hash 和键 | 兼容外部 JSON 与内部 symbol 数据 | symbol、string、fetch、默认值 | 混用 `:status` 和 `"status"` 导致数据丢失 | 同时测试两种 key |
| nil 边界 | 处理缺失字段和可选值 | `nil`、truthiness、安全转换 | 把 nil 当成 0 或字符串导致异常 | 缺失字段测试 |
| 对象可变性 | 不破坏调用方输入 | 引用、mutation、dup/freeze | 在汇总时修改原始订单 | 调用前后输入相等 |
| 测试反馈 | 用测试描述业务规则 | Minitest、assertion、失败信息 | 只手动打印结果 | `ruby -Itest test/...` |

## 难度路线

| 等级 | 场景类型 | 目标 |
| --- | --- | --- |
| L1 | 跟做和观察 | 看懂 Ruby 测试失败信息 |
| L2 | 单点修复 | 修复一个集合汇总函数 |
| L3 | 混合诊断 | 同时处理 key 类型、nil、mutation、业务规则 |
| L4 | 设计防线 | 写出测试覆盖外部输入边界 |
| L5 | 迁移出题 | 设计一个日志解析或配置归并场景考别人 |

## 关联掌握场景

- [订单汇总函数漏算外部输入](../../problems/ruby/001-order-summary-enumerable/README.md)

## 推荐资料

- Ruby 官方文档：`Enumerable`、`Hash`、`Minitest`
- 只在解题需要时查资料，不要先从完整语法书开始。

