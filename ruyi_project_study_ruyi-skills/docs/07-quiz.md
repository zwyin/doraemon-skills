# 第 7 章：知识测验

通过以下 7 道题检验你对 ruyi-skills 项目的理解。

## Quiz

**Q1:** ruyi-skills 的「Skill 自包含」原则意味着什么？

- A. 每个 skill 必须用 Python 编写
- B. SKILL.md 和 references/ 中的链接不得指向 skill 目录外的文件
- C. 所有 skill 必须放在同一个文件中
- D. 每个 skill 必须有自己的 CI 配置

**Answer: B**

**Explanation:** P1 自包含原则要求每个 skill 能被独立提取和使用。SKILL.md 和 references/ 内的所有链接不得指向 skill 目录外，由 `check_self_contained.py` 在 CI 中自动检查。

---

**Q2:** github-safe-publish 的第一层扫描有多少条确定性规则？

- A. 50 条
- B. 85 条
- C. 135 条
- D. 200 条

**Answer: C**

**Explanation:** 6 大维度共 135 条规则：密钥凭证 100 + 数据库连接 5 + 个人隐私 8 + 内部基础设施 6 + 文件黑名单 12 + Git 历史 4 = 135。

---

**Q3:** project-walkthrough 的「verify-before-write」架构是什么意思？

- A. 先写完所有章节，最后再验证
- B. 只验证代码示例，其他内容不需要验证
- C. 每个技术声明必须先对照源文件验证，通过后才能写入文档
- D. 由用户手动验证所有声明

**Answer: C**

**Explanation:** project-walkthrough 的核心设计是「验证清单是写入许可证」——先构建 sources-manifest.json，只有标记为 verified: true 的声明才能出现在章节内容中。不可验证的声明会被丢弃。

---

**Q4:** convert.sh 支持哪三种目标平台？

- A. GitHub、GitLab、Bitbucket
- B. Cursor、Windsurf、OpenCode
- C. VS Code、IntelliJ、Vim
- D. Docker、Kubernetes、AWS

**Answer: B**

**Explanation:** convert.sh 将 SKILL.md 转换为三种格式：Cursor（.cursor/rules/*.mdc）、Windsurf（.windsurfrules/*.md）、OpenCode（.opencode/skills/*/SKILL.md），输出到 gitignored 的 dist/ 目录。

---

**Q5:** ruyi-skills 的多品牌架构中，有几个品牌仓库？通过什么工具生成？

- A. 2 个品牌，手动复制
- B. 3 个品牌，通过 git subtree
- C. 4 个品牌，通过 brand-sync-tool
- D. 5 个品牌，通过 CI 自动部署

**Answer: C**

**Explanation:** ruyi-skills 是唯一开发仓库，通过独立的 brand-sync-tool 生成 ruyi、paoding、davinci、doraemon 四个品牌仓库。每个品牌有独立的 Git 历史，不作为 remote 添加到本仓库。

---

**Q6:** CI 中 github-safe-publish 的覆盖率门禁是多少？

- A. ≥ 80%
- B. ≥ 90%
- C. ≥ 95%
- D. ≥ 99%

**Answer: C**

**Explanation:** CI 配置中明确设置 `--cov-fail-under=95`，要求测试覆盖率不低于 95%。当前实际覆盖率为 99%，远超门禁线。

---

**Q7:** 双层版本管理中，Skill 版本和合集版本分别存储在哪里？

- A. 都在 package.json 中
- B. 都在 CHANGELOG.md 中
- C. Skill 版本在 SKILL.md frontmatter，合集版本在 marketplace.json
- D. Skill 版本在 README.md，合集版本在 Makefile

**Answer: C**

**Explanation:** P5 双层版本原则：每个 skill 的版本定义在各自 SKILL.md 的 YAML frontmatter 中（如 `version: "0.7.0"`），合集版本定义在 `.claude-plugin/marketplace.json` 中（如 `"version": "0.8.0"`）。release.sh 负责 bump 合集版本。

---

[← 上一章：质量保障](06-quality-gates.md)
