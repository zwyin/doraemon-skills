# 03 Skill 深度：github-safe-publish

## 概述

github-safe-publish（v0.7.0）将本地 Git 项目安全地发布到 GitHub 公开仓库。核心能力：两层脱敏扫描（135 条确定性规则 + AI 语义扫描）、自动修复、备份回滚、仓库创建。

SKILL.md 共 1133 行，是所有逻辑的唯一事实源。

## CLI 接口

```text
// Simplified from: skills/ruyi-github-safe-publish/SKILL.md:33-49
/ruyi-github-safe-publish                    # 核心流程（脱敏+发布）
/ruyi-github-safe-publish --seo              # 核心 + SEO 优化
/ruyi-github-safe-publish --ci               # 核心 + CI 生成
/ruyi-github-safe-publish --scan             # 只做脱敏扫描，输出报告
/ruyi-github-safe-publish --dry-run          # 模拟：扫描 + 修复建议，不执行
```

互斥规则：`--scan` / `--dry-run` 不可与 `--seo` / `--ci` 组合（SEO/CI 只对已推送仓库有意义）。`--scan` 与 `--dry-run` 也不能同时使用。

## 两层扫描架构

### 第 1 层：确定性规则扫描

6 个维度，135 条规则：

| 维度 | 代号 | 规则数 | 说明 |
|------|------|--------|------|
| A. 密钥/凭证 | KEY | 100 | API Key、Token、Secret + Shannon entropy 辅助 |
| A2. 数据库连接字符串 | DB | 5 | PostgreSQL、MySQL、MongoDB、Redis、JDBC |
| B. PII | PII | 8 | 邮箱、手机号、身份证、银行卡、SSN 等 |
| C. 内部基础设施 | INF | 6 | 内网 IP、内部域名、硬编码路径 |
| D. 文件黑名单 | FILE | 12 | .env、.pem、.key、.db 等 |
| E. Git 历史 | GIT | 4 | author email 泄露、历史敏感文件残留 |

**规则来源**：Gitleaks v8.25+ 默认配置 + TruffleHog 800+ 检测器提取 + 中国本地化扩展。

KEY 维度覆盖 50+ 服务商（AWS、Azure、GCP、GitHub、OpenAI、Slack、Stripe 等），通过正则匹配前缀 + 熵值辅助判定。通用规则 `generic-api-key` 使用 Shannon entropy 阈值 4.5 区分真实密钥和误报。

完整正则定义维护在 `docs/scanning-rules.md`（879 行）。

### 第 2 层：AI 语义扫描

通过独立子 agent 执行（不共享主对话上下文），补充规则无法覆盖的语义泄露：

- 业务数据泄露（内部项目代号、真实用户数据）
- 可溯源叙事（"在 XX 公司的 YY 项目中"）
- 间接推断（路径推断组织结构、注释推断技术栈）
- 规则误报排除

收敛策略：最多 2 轮 AI 扫描。第 2 轮聚焦第 1 轮发现项的关联区域。

## 六步流程

```text
// Simplified from: skills/ruyi-github-safe-publish/SKILL.md:53-60
Step 1: 前置检查 + 参数确认（集中交互 #1）
Step 2: 创建备份分支（pre-publish-backup）
Step 3: 两层脱敏扫描
Step 4: 自动修复 + 用户确认（Fix-Verify Loop，最多 3 轮）
Step 5: 仓库决策 + 创建推送（集中交互 #2）
Step 6: 验证 + 输出报告
```

**`--scan` 模式**：只执行 Step 1 + Step 3 + Step 6（扫描报告）。纯只读，不修改文件。

**`--dry-run` 模式**：执行 Step 1 + Step 3 + Step 4（输出修复建议但不执行）+ Step 6。

## 自动修复机制

| 内容类型 | 替换为 |
|----------|--------|
| 真实密钥/Token | `REPLACE_ME_<类型>` |
| 个人邮箱 | `user@example.com` |
| 内部 IP | `192.168.x.x` |
| 本地路径 | `/path/to/project` |

CRITICAL 项阻塞推送，必须处理。WARNING 项由用户判断。SAFE 项（占位符、example.com）自动跳过。

Git 历史中的敏感信息需特殊处理：git filter-repo 重写历史，或新建干净仓库。

## 附加模块

**--seo 模块**（推送后执行）：Description 优化 → Topics 标签（6-20 个）→ shields.io Badges → README 结构检查。

**--ci 模块**（推送后执行）：项目类型检测 → 平台矩阵决策 → 生成 `.github/workflows/test.yml`。

---

[← 上一章](02-architecture.md) | [下一章 →](04-project-walkthrough.md)
