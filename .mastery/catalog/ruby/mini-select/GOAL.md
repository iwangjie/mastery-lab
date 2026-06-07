# 本关目标

今天只做一件事：自己实现一个小版 `select`。

你需要在 `workspace/lib/enumerable_drill.rb` 中实现：

```ruby
EnumerableDrill.my_select(items) { |item| ... }
```

它应该保留让 block 返回真值的元素，并保持原始顺序。

完成后回到项目根目录运行：

```bash
./mastery check
```

重点不是重写标准库，而是理解 block 如何从调用方进入方法内部。
