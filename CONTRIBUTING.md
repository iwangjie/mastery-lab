# Contributing

Mastery Lab 的贡献重点不是“多加资料”，而是增加能验证掌握的任务。

用户最终只会运行：

```bash
./mastery start "继续学习 Ruby"
./mastery check
./mastery next
```

所以贡献时请保持一个原则：复杂度留在 `.mastery/`，用户只面对 `current_task/`。

## 新增一条学习路线

新增语言或技术方向时，创建：

```text
.mastery/catalog/<track>/
  track.json
  <task-id>/
    GOAL.md
    README.md
    workspace/
      lib/...
      test/...
```

`track.json` 描述路线和任务顺序：

```json
{
  "id": "ruby",
  "title": "Ruby 后端工程基础",
  "tasks": [
    {
      "id": "order-summary",
      "title": "订单汇总",
      "focus": "Enumerable、Hash 键类型、nil 边界、输入不可变性",
      "level": "L1",
      "evidence": "能在真实订单数据中完成汇总，并通过边界测试。"
    }
  ],
  "planned": ["异常处理与输入管道"]
}
```

## 新增一个任务

每个任务至少包含：

- `GOAL.md`：当前关卡的目标，越短越好。
- `README.md`：场景、任务要求、约束、验证方式。
- `workspace/`：用户要修改的代码和测试。

任务应该满足：

- 初始代码必须失败。
- 正确修复后必须通过。
- 测试要覆盖真实边界，而不只是 happy path。
- 不要泄露答案。
- 不要让用户安装不必要的依赖。

## 本地验证

提交前运行：

```bash
node .mastery/tools/check-links.mjs
./.mastery/tools/smoke-ruby.sh
```

如果新增了其他路线，请补对应的 smoke 脚本。
