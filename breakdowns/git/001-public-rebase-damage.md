# 问题拆解：公共分支 rebase 后覆盖队友提交

## 对应课题

- 课题：Git 协作
- 能力节点：公共历史保护、事故恢复、远程分支判断
- 目标难度：L3 诊断
- 对应场景：[problems/git/001-public-rebase-damage](../../problems/git/001-public-rebase-damage/README.md)

## 问题一句话

一个已经被多人使用的功能分支被错误 rebase 后强推，导致队友提交从远程分支消失。

## 为什么这个问题值得训练

真实团队里，Git 事故往往不是因为完全不会 Git，而是因为把“本地整理历史”的习惯带到了公共分支。AI 也常会给出 `rebase`、`reset`、`push --force` 之类看似干净的命令，但不一定理解团队协作状态。

掌握不好会造成：

- 覆盖队友提交。
- 让其他 clone 的历史分叉。
- 让代码评审、CI、发布分支失去可信历史。
- 在修复时再次强推，扩大事故。

## 目标能力

这题训练：

- 读懂本地分支、远程分支、同事 clone 之间的提交关系。
- 理解 rebase 会产生新的 commit identity。
- 理解公共历史不能随意改写。
- 从其他 clone 找回被远程覆盖的提交。
- 用普通 push 把修复后的分支发布到远程。

## 不训练什么

这题不重点训练：

- 大规模冲突解决。
- Git hook 或分支保护配置细节。
- 完整事故报告写作。
- Git 内部对象存储的底层实现。

## 关键判断信号

专家会优先看：

- `origin/feature/checkout-flow` 当前指向哪个提交。
- 同事 clone 的 `feature/checkout-flow` 是否还保留消失提交。
- 当前分支是否已经包含 `origin/main`。
- 修复路径是否会再次改写公共历史。
- 最终远程分支是否包含所有必要提交。

## 底层机制

必须理解：

- `rebase` 不是移动原提交，而是基于新 base 复制出新提交。
- commit hash 代表内容、父提交、作者、时间等信息的身份。
- `push --force` 会让远程 ref 指向新提交，从分支视角覆盖旧历史。
- 被覆盖的提交对象可能仍存在于其他 clone、reflog 或未清理对象中。
- `--force-with-lease` 能降低覆盖别人新提交的风险，但不能替代公共历史约定。

## 常见失败路径

| 失败路径 | 为什么看起来合理 | 真正风险 |
| --- | --- | --- |
| 再次 `git push --force` | 以为事故由强推造成，也能由强推修复 | 可能覆盖更多人的新工作 |
| 手工新建 `telemetry.txt` | 文件内容看起来恢复了 | 历史证据没有恢复，无法证明找回队友提交 |
| 只看当前 clone | 当前 clone 看起来一切正常 | 事故线索可能在同事 clone 或 reflog |
| 盲目 reset 到同事分支 | 同事分支包含丢失提交 | 可能丢掉 main 上的新提交 |

## 现场材料

场景生成：

- 一个 bare `origin.git`。
- 一个错误强推后的 `learner` clone。
- 一个仍保留被覆盖提交的 `teammate` clone。
- 一个 main 分支新提交。
- 一个 feature 分支原始功能提交。
- 一个被覆盖的 telemetry 提交。

## 验证证据

验证脚本检查：

- 学习者仍在 `feature/checkout-flow`。
- 工作区干净。
- 当前分支包含 `origin/main`。
- 当前分支保留 checkout route。
- 当前分支包含 fraud screen。
- 当前分支恢复 teammate telemetry 文件。
- Git 历史中包含 teammate commit message。
- `origin/feature/checkout-flow` 指向修复后的 HEAD。

这些证据同时覆盖结果、协作状态和历史恢复，不只是检查文件内容。

## 分级提示设计

- Hint 1：只让学习者画出三个 clone 的提交图。
- Hint 2：指出 remote-tracking branch、commit identity、公共历史和其他 clone。
- Hint 3：建议把同事仓库作为 remote 或从其中取回目标提交。

## 升级变体

- 同事 clone 已经删除，只能从 reflog 或 CI 日志找线索。
- 被覆盖的不止一个提交，还夹杂一个错误提交，需要选择性恢复。
- release 分支被强推，需要保护 hotfix、release tag 和 feature commit。

## 复盘重点

- 为什么“文件恢复了”不等于“协作历史恢复了”？
- 什么情况下 rebase 是安全的，什么情况下不安全？
- 为什么 `--force-with-lease` 是防线，但不是协作规范本身？
- 如果 AI 建议 `reset --hard` 或 `push --force`，应该如何审查？

