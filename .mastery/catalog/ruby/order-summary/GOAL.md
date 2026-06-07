# 本关目标

今天只做一件事：修好 Ruby 订单汇总。

你需要在 `workspace/lib/order_summary.rb` 中实现 `OrderSummary.call(orders)`，让它能处理真实订单数据里的几个麻烦点：

- symbol key 和 string key 混用。
- nil 或缺失状态。
- nil 或缺失金额。
- 空订单数组。
- 不能修改传入的原始订单。

完成后回到项目根目录运行：

```bash
./mastery check
```

不要先追求“优雅”。先让业务规则稳定通过，再考虑 Ruby 写法是否自然。
