# 第 1 章：项目概览

## 如意是什么？

> **类比理解：** 想象你有一把瑞士军刀——平时各种工具散落各处，要用的时候找不到。ruyi-skills 就是一把「数字瑞士军刀」，把常用的复杂操作打包成一条命令。比如「把代码安全地发布到 GitHub」或者「自动生成项目文档」，原本需要几十个步骤，现在一个指令搞定。

ruyi-skills 是一个 **Claude Code skill 合集**。它为 AI 编程助手 Claude Code 提供了两个核心能力：

| Skill | 版本 | 一句话说明 |
|-------|------|-----------|
| **github-safe-publish** | 0.7.0 | 安全发布代码到 GitHub——两层脱敏扫描 + 自动修复 + 一键发布 |
| **project-walkthrough** | 1.6.1 | 项目技术走读——自动分析项目、生成文档和交互式 HTML |

合集版本：**0.8.0**（`marketplace.json`）

> Simplified from: `.claude-plugin/marketplace.json`

## 这两个 Skill 解决什么问题？

### github-safe-publish

把本地项目公开发布到 GitHub 听起来简单，但隐藏着大量风险：API 密钥泄露、内部 IP 暴露、个人邮箱混入代码……github-safe-publish 在发布前做**两层安全扫描**，找出敏感信息，自动修复，然后安全推送。

**6 大扫描维度，135 条规则：**

| 维度 | 规则数 | 举例 |
|------|--------|------|
| 密钥与凭证 | 100 | AWS Key、GitHub Token、Google API Key |
| 数据库连接 | 5 | 含密码的数据库连接字符串 |
| 个人隐私 | 8 | 邮箱、手机号、身份证号 |
| 内部基础设施 | 6 | 内网 IP、域名 |
| 文件黑名单 | 12 | .env、id_rsa 等不应公开的文件 |
| Git 历史 | 4 | Git 中的二进制密钥痕迹 |

> Simplified from: `skills/ruyi-github-safe-publish/docs/scanning-rules.md`

### project-walkthrough

面对一个陌生的代码库，通常需要花几天时间阅读代码、画架构图、写文档。project-walkthrough 自动完成这个过程：分析项目结构、提取关键设计决策、生成带测验的交互式文档。

支持多种输出模式：
- **深度**：brief（快速概览）、medium（详细分析）、deep（全面走读）、all（全部）
- **受众**：general（普通读者，含类比卡片）或 dev（开发者）
- **语言**：中文 / 纯中文 / 英文 / 中英对照

## 怎么安装？

> **类比理解：** 安装 ruyi-skills 就像给手机装一个 App——最简单的方式是在「应用商店」里搜到它，点一下安装。Claude Code 的「应用商店」叫做 marketplace。

最简单的安装方式：

```bash
# 添加 marketplace
/plugin marketplace add zwyin/ruyi-skills

# 安装
/plugin install ruyi-skills@ruyi-skills

# 重新加载
/reload-plugins
```

安装后，两个 skill 就可以在 Claude Code 中直接使用了：

```bash
/ruyi-github-safe-publish        # 安全发布到 GitHub
/ruyi-project-walkthrough        # 生成项目走读文档
```

## 项目规模

| 指标 | 数值 |
|------|------|
| 核心文件 | ~128 个 |
| 核心代码行数 | ~20,000 行 |
| Skills 数量 | 2 个 |
| 测试文件 | 18 个（7 + 8 + 3） |
| CI 覆盖率门禁 | ≥ 95% |

> Simplified from: 项目文件扫描统计

---

[下一章：架构设计 →](02-architecture.md)
