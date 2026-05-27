# 07 知识测验

## Quiz

**Q1:** ruyi-skills 的 skill 自包含原则意味着什么？

- A. 每个 skill 必须是一个独立的 Git 仓库
- B. SKILL.md 和 references/ 内的链接不得指向 skill 目录外的文件
- C. 每个 skill 不能依赖任何外部工具
- D. skill 的测试必须与源码在同一文件中

**Answer: B**

**Explanation:** 自包含原则（P1）要求每个 skill 的所有文档和引用都在自己的目录内，使其可以独立提取和安装。CI 中的 `check_self_contained.py` 强制执行这一规则。skill 可以共享合集级的 scripts/（如 convert.sh），但 SKILL.md 内部不能链接到外部。

---

**Q2:** github-safe-publish 的两层扫描架构中，第 1 层规则扫描覆盖了多少条规则？

- A. 50 条
- B. 100 条
- C. 135 条
- D. 200 条

**Answer: C**

**Explanation:** 第 1 层确定性规则扫描覆盖 6 个维度共 135 条规则：密钥/凭证（KEY）100 条、数据库连接字符串（DB）5 条、PII 8 条、内部基础设施（INF）6 条、文件黑名单（FILE）12 条、Git 历史（GIT）4 条。

---

**Q3:** `make ci` 命令会执行哪些检查？

- A. 只运行 pytest 测试
- B. 测试 + marketplace.json 校验 + 自包含检查 + 合集脚本测试
- C. 只检查 marketplace.json 是否有效
- D. 发布新版本到所有品牌 remote

**Answer: B**

**Explanation:** `make ci` 等价于 `test + check + test-collection`。test 运行所有 skill 测试，check 验证 marketplace.json 有效性 + 自包含校验，test-collection 运行合集级脚本测试 + convert.sh --check。

---

**Q4:** project-walkthrough 的 verify-before-write 机制如何工作？

- A. 先写章节，然后用 AI 检查内容是否正确
- B. 先阅读源文件验证每个事实声明，记录到 sources-manifest.json，然后才允许写入章节
- C. 由用户手动验证所有代码示例
- D. 只在最终交付前做一次全局检查

**Answer: B**

**Explanation:** Phase 3A 要求对每个计划的声明（代码示例、目录结构、API 签名等）先读取源文件验证，将验证结果记录到 sources-manifest.json。只有 manifest 中 `verified: true` 的声明才能在 Phase 3B 中写入章节。manifest 是写入许可，不是审计日志。

---

**Q5:** convert.sh 的 `--check` 模式在 CI 中的作用是什么？

- A. 生成所有平台的转换文件并检查大小
- B. 验证每个 skill 有 SKILL.md 且 frontmatter 包含 name 和 version 字段
- C. 检查 dist/ 目录是否为空
- D. 运行所有 skill 的测试

**Answer: B**

**Explanation:** `_do_check()` 函数遍历 skills/ 下所有 skill 目录，验证：SKILL.md 存在、frontmatter 包含 `name:` 字段、frontmatter 包含 `version:` 字段。缺失任何一项都会报错并 exit 1。

---

**Q6:** ruyi-skills 的双层版本机制中，合集版本存储在哪里？

- A. SKILL.md 的 version 字段
- B. package.json
- C. .claude-plugin/marketplace.json
- D. CHANGELOG.md

**Answer: C**

**Explanation:** 双层版本：skill 版本在各自 SKILL.md 的 frontmatter（随 subtree 同步），合集版本在 `.claude-plugin/marketplace.json` 的 `version` 字段。release.sh bump 时同步更新两处。

---

**Q7:** md_to_html.py 的 `--verify` 模式检查哪些内容？

- A. HTML 中的拼写错误
- B. Section 数量匹配、内容完整性、大小比率、链接完整性、导航一致性
- C. HTML 是否通过 W3C 验证
- D. JavaScript 代码是否有语法错误

**Answer: B**

**Explanation:** `--verify` 检查 5 项：section count = markdown 文件数、每个 section 有 heading + 内容元素、HTML ≥ 80% markdown 大小、0 个 .md href 链接、sidebar 项数 = 章节数。结果写入 verify-result.json。

---

[← 上一章](06-quality-gates.md)
