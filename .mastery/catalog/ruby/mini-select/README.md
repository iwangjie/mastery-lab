# 任务：自己实现 select

上一关你用 Ruby 的集合方法处理订单。这一关往下走一步：不要只会调用 `select`，要理解它为什么能接收一个 block。

你需要实现一个小方法，让它像 `select` 一样工作。这个任务很小，但它会逼你理解 Ruby 里 block、`yield`、返回值和数组构造之间的关系。

## 你要完成什么

请修改：

```text
workspace/lib/enumerable_drill.rb
```

实现：

```ruby
EnumerableDrill.my_select(items) { |item| ... }
```

它应该返回所有让 block 结果为真的元素，并保持原始顺序。

## 约束

- 不要使用内置的 `select`、`filter`、`find_all`。
- 不要修改传入数组。
- 可以使用 `each`。
- 没有传入 block 时，抛出 `ArgumentError`。

## 验证

回到项目根目录运行：

```bash
./mastery check
```

通过后，重点复盘一个问题：block 是如何从调用方进入 `my_select` 方法内部的？
