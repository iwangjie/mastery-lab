# 掌握场景：公共分支 rebase 后覆盖队友提交

## 对应课题

- 课题：Git 协作
- 能力节点：公共历史保护、事故恢复、远程分支判断
- 难度等级：L3 诊断

## 背景

你加入了一个正在做 checkout 功能的团队。功能分支 `feature/checkout-flow` 已经推到远程，另一个同事也在这个分支上提交了代码。

有人为了“让历史更干净”，在没有确认分支是否公共的情况下，把本地旧版本的 `feature/checkout-flow` rebase 到 `origin/main`，然后 `git push --force`。现在同事说自己的提交消失了。

这不是考“rebase 命令怎么用”，而是考：

- 你能不能判断哪些历史是公共历史。
- 你能不能找回被覆盖的提交。
- 你能不能把分支恢复到同时包含 main 更新、自己的功能、同事提交的状态。
- 你能不能解释为什么公共分支随意 rebase/force push 有风险。

## 初始化现场

```bash
./setup.sh
cd work/learner
```

`setup.sh` 会创建：

- `work/origin.git`：远程仓库。
- `work/learner`：你当前操作的工作副本，已经处于错误 force push 之后。
- `work/teammate`：同事的工作副本，里面可能保留了被覆盖的提交线索。
- `work/dev-a`：构造现场用的历史副本。

## 任务

在 `work/learner` 中恢复 `feature/checkout-flow`，最终要求：

- 分支包含 `origin/main` 的最新提交。
- 分支保留 checkout route 的功能提交。
- 分支恢复同事的 checkout telemetry 提交。
- 远程 `origin/feature/checkout-flow` 指向修复后的结果。
- 你能解释错误发生的机制和避免方式。

## 限制条件

- 不要直接删除 `work/` 重新跑 `setup.sh` 当作解决。
- 不要手工重写文件来伪造恢复；目标是恢复协作历史。
- 不要再次用不受控的 `push --force` 覆盖远程。
- 可以把 `work/teammate` 当作事故调查线索。

## 验证

在场景目录运行：

```bash
./verify.sh
```

验证脚本只证明关键结果，不证明你完全理解。通过后还需要写复盘。

## 分级提示

### Hint 1

先画出 `learner`、`origin`、`teammate` 三个位置的 `feature/checkout-flow` 分别指向哪里。

### Hint 2

关注 remote-tracking branch、公共历史、commit identity，以及“提交对象可能仍存在于另一个 clone 中”。

### Hint 3

可以把同事的仓库临时加为一个 remote，或直接从同事仓库拿到目标提交，再把它安全地引入当前分支。

## 复盘问题

- 错误 force push 覆盖了什么？
- 为什么 rebase 后 commit hash 会变化？
- `--force-with-lease` 比 `--force` 多保护了什么？它是否能解决所有问题？
- 如果没有 `work/teammate`，还有哪些恢复线索？
- 团队应该如何配置分支保护或工作流避免这种事故？

## 变体

- 变体 1：同事提交只存在于 CI 日志或某个人的 reflog 中。
- 变体 2：错误覆盖发生在 release 分支，需要同时保留 hotfix 和 feature commit。

