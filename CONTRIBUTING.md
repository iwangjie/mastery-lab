# Contributing

Mastery Lab 的贡献重点不是“多加资料”，而是增加能验证掌握的任务。

用户最终只会运行：

```bash
./mastery start "继续学习 Ruby"
./mastery start "学点 shell"
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
  "aliases": ["ruby", "rails", "rb"],
  "start_hint": "继续学习 Ruby",
  "env_check": "ruby --version",
  "install_hint": "请先安装 Ruby。",
  "verify_template": "ruby -I\"$ROOT/workspace/test\" \"$ROOT/workspace/test\"/*_test.rb",
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

最小字段：

- `id`：路线唯一标识，必须和目录名一致。
- `title`：路线图显示名称。
- `aliases`：用户意图匹配关键词。
- `start_hint`：帮助信息和路线图里的启动提示。
- `verify_template`：默认验证命令。`mastery` 会生成 `current_task/verify.sh`，并提供 `$ROOT` 指向当前任务目录。
- `tasks`：任务列表。

可选字段：

- `env_check`：启动前的环境检查命令。
- `install_hint`：环境检查失败时显示的提示。
- `tasks[].verify`：任务级验证命令，覆盖路线默认 `verify_template`。

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
./.mastery/tools/smoke-shell.sh
```

如果新增了其他路线，请补对应的 smoke 脚本。
