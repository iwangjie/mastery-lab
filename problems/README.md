# 掌握场景索引

`problems/` 存放可运行或可交付的训练现场。

每个目录应该尽量包含：

- `README.md`：场景说明、任务、限制、提示、复盘。
- `setup.sh` 或等价初始化方式：制造问题现场。
- `verify.sh` 或等价验证方式：检查结果。

当前场景：

| 课题 | 场景 | 难度 | 验证 |
| --- | --- | --- | --- |
| Git 协作 | [公共分支 rebase 后覆盖队友提交](git/001-public-rebase-damage/README.md) | L3 | `./verify.sh` |
| Ruby 语言与工程基础 | [订单汇总函数漏算外部输入](ruby/001-order-summary-enumerable/README.md) | L2 | `./verify.sh` |
