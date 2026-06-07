# 课题：Git 协作

## 为什么值得掌握

Git 的危险不在于命令难背，而在于协作状态复杂。真实工作里，错误合并、覆盖队友提交、公共分支 rebase、误删远程分支、错误解决冲突都会造成团队损失。

AI 可以很快给出 Git 命令，但如果人不理解 refs、commit identity、merge base、reflog、remote-tracking branch，就很难判断命令是否安全。

## 能力图谱

| 能力节点 | 真实任务 | 底层概念 | 常见错误 | 验证方式 |
| --- | --- | --- | --- | --- |
| 分支关系判断 | 看懂本地、远程、队友分支的关系 | refs、HEAD、upstream、remote-tracking branch | 把本地分支和远程分支混为一谈 | 能画出提交图并解释 |
| 冲突解决 | 合并两边语义而不是选一边 | merge base、三方合并 | 用 ours/theirs 覆盖别人代码 | 测试通过且语义保留 |
| 公共历史保护 | 判断何时不能 rebase/force push | commit identity、public history | rebase 公共分支后强推 | 能恢复丢失提交并解释风险 |
| 事故恢复 | 找回被删或覆盖的提交 | reflog、fsck、alternate clone | 不知道从哪里找对象 | 能恢复并推回安全状态 |
| 团队防线 | 设计避免事故的流程 | protected branch、review、lease | 只靠个人记忆 | 能给出仓库策略 |

## 难度路线

| 等级 | 场景 |
| --- | --- |
| L1 | 给提交图，解释每个 ref 指向 |
| L2 | 解决一个文件冲突，保留双方语义 |
| L3 | 从错误 force push 中恢复队友提交 |
| L4 | 为团队设计分支保护和合并规范 |
| L5 | 设计一个 Git 事故训练场考别人 |

## 当前掌握场景

- [公共分支 rebase 后覆盖队友提交](../../problems/git/001-public-rebase-damage/README.md)

