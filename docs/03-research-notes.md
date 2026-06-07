# 研究依据

这份笔记把外部研究转成项目设计规则。它不是完整文献综述，只记录和本仓库结构直接相关的依据。

## 1. 问题式学习

Problem-Based Learning 强调学习者在有指导的问题解决中学习，而不是先按章节吸收知识。Hmelo-Silver 的综述把 PBL 描述为通过问题解决发展灵活知识、问题解决能力、自主学习和协作能力。

项目落地：

- 课题不按教材目录组织，而按真实问题组织。
- 每个掌握场景必须有背景、约束和复盘。
- AI 的重点是制造问题现场，而不是先讲完整理论。

参考：

- Hmelo-Silver, "Problem-Based Learning: What and How Do Students Learn?" https://link.springer.com/article/10.1023/B:EDPR.0000034022.16470.f3

## 2. 刻意练习

刻意练习不是“多做”，而是围绕具体表现目标、即时反馈和持续修正进行训练。只积累经验不一定产生专家能力。

项目落地：

- 每个场景必须写清楚目标能力。
- 验证不能只看完成，要看是否命中目标能力。
- 同一能力要有递进变体，而不是做一次就结束。

参考：

- Ericsson, Krampe, Tesch-Romer, "The Role of Deliberate Practice in the Acquisition of Expert Performance" https://psycnet.apa.org/record/1993-40718-001

## 3. 认知学徒制

认知学徒制强调专家把隐性的思考过程显性化，再通过 coaching、scaffolding 和 fading 逐步减少帮助。

项目落地：

- AI 可以先示范如何观察问题，但要逐步撤离。
- 提示分级，避免一上来给答案。
- 复盘要记录判断过程，而不只是最终命令。

参考：

- Collins, Brown, Newman, "Cognitive Apprenticeship: Teaching the Crafts of Reading, Writing, and Mathematics" https://eric.ed.gov/?id=ED284181

## 4. 专家知识结构和迁移

How People Learn 总结了专家和新手的差异：专家不是只知道更多事实，而是把知识围绕核心概念组织起来，并能在合适情境中调用。迁移能力需要在多样场景中练习。

项目落地：

- 能力图谱必须写底层概念和可迁移边界。
- 一个场景解决后要生成变体，检查是否只记住表面。
- 复盘要问“换一个场景还能不能解决”。

参考：

- National Academies, "How People Learn: Brain, Mind, Experience, and School" https://www.nationalacademies.org/publications/9853/how-people-learn-brain-mind-experience-and-school-expanded-edition
- Chapter 2, "How Experts Differ from Novices" https://www.nationalacademies.org/read/9853/chapter/5
- Chapter 3, "Learning and Transfer" https://www.nationalacademies.org/read/9853/chapter/6

## 5. 检索练习和反馈

检索练习研究显示，主动回忆和测试比重复阅读更有利于长期保持。对这个项目来说，“做题并解释”比“再看一遍文章”更接近掌握。

项目落地：

- 每个场景之后必须写复盘，而不是只通过验证脚本。
- 下一轮用相似变体测试迁移。
- 笔记应该记录判断线索，而不是摘抄资料。

参考：

- Roediger and Karpicke, "Test-Enhanced Learning" https://journals.sagepub.com/doi/10.1111/j.1467-9280.2006.01693.x

## 6. 生产性失败

生产性失败强调：在直接教学前先尝试解决复杂问题，失败本身可以暴露先验模型，帮助后续学习更有意义。

项目落地：

- 一些场景应该允许学习者先卡住，再给分级提示。
- 失败路径要被记录，因为它暴露了错误心智模型。
- 不要把所有材料都整理成顺滑教程，否则会降低真实诊断能力。

参考：

- Kapur, "Productive Failure" https://www.tandfonline.com/doi/abs/10.1080/10508406.2011.591717

## 7. 真实训练场的启发

安全、Git、逆向等领域已经有一些接近本项目思路的训练场：故意有漏洞的应用、CTF、Git kata、crackme。它们说明“制造问题”比单纯讲理论更适合训练判断。

项目落地：

- 掌握场景应尽量可运行、可破坏、可恢复。
- 问题材料可以是代码库、仓库历史、日志、二进制、需求文档、生产事故报告。
- 通过脚本和测试提供客观验证。

参考：

- Git book, rebasing and collaboration: https://git-scm.com/book/en/v2/Git-Branching-Rebasing
- OWASP WebGoat: https://owasp.org/www-project-webgoat/
- Git Katas: https://github.com/praqma-training/git-katas
- microcorruption: https://microcorruption.com/

