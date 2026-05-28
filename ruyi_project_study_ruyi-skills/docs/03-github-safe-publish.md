# 第 3 章：github-safe-publish — 安全发布 Skill

## 这个 Skill 做什么？

> **类比理解：** 把代码发布到 GitHub，就像把一封邮件发到公开论坛——你永远不知道里面是不是不小心夹带了密码、私钥或内网地址。github-safe-publish 就像一个「安全检查员」，在发送前把信封里的敏感信息全部找出来、替换掉，确认安全后才发出。

github-safe-publish 是一个端到端的安全发布工具，核心能力：

1. **两层扫描**：第一层用 135 条确定性正则规则，第二层用 AI 语义分析
2. **自动修复**：发现敏感信息后自动替换（如 `AKIA...` → `[REDACTED_AWS_KEY]`）
3. **备份回滚**：修复前创建备份，出问题可以一键回退
4. **一键发布**：扫描→修复→创建仓库→推送，全程自动化

## 两层扫描机制

### 第一层：确定性规则扫描（135 条）

按 6 大维度组织：

| 维度 | 规则数 | 检测什么 | 示例 |
|------|--------|----------|------|
| **密钥与凭证** | 100 | API Key、Token、Secret | AWS Key 以 `AKIA` 开头，16 位字母数字 |
| **数据库连接** | 5 | 含密码的连接字符串 | `mysql://user:pass@host` |
| **个人隐私** | 8 | 邮箱、手机号、身份证 | 中国手机号 1[3-9]\d{9} |
| **内部基础设施** | 6 | 内网 IP、内部域名 | `10.x.x.x`、`192.168.x.x` |
| **文件黑名单** | 12 | 不应公开的文件 | `.env`、`id_rsa`、`.npmrc` |
| **Git 历史** | 4 | Git 中的密钥痕迹 | 大文件、二进制密钥 |

> Simplified from: `skills/ruyi-github-safe-publish/docs/scanning-rules.md`

每条规则包含：
- **正则表达式**：精确匹配敏感信息的模式
- **严重级别**：CRITICAL / HIGH / MEDIUM / LOW
- **熵值阈值**：通用规则（如 `generic-api-key`）使用 Shannon 熵 ≥ 4.5 辅助判定

### 第二层：AI 语义扫描

第一层用正则能抓住「长得像密钥」的字符串，但有些敏感信息「长得不像密钥」——比如一段注释中写着「我们的生产环境数据库地址是...」。AI 语义扫描能理解上下文，抓住正则遗漏的信息。

## 使用方式

```bash
# 完整流程：脱敏扫描 → 修复 → 发布到 GitHub
/ruyi-github-safe-publish

# 只扫描不修复，输出报告
/ruyi-github-safe-publish --scan

# 模拟运行：扫描 + 修复建议，不做实际修改
/ruyi-github-safe-publish --dry-run

# 附加 SEO 优化（描述、Topics、Badges）
/ruyi-github-safe-publish --seo

# 附加 CI 生成（自动生成 .github/workflows/test.yml）
/ruyi-github-safe-publish --ci
```

> Simplified from: `skills/ruyi-github-safe-publish/skills/ruyi-github-safe-publish/SKILL.md`

## 测试体系

github-safe-publish 的测试覆盖率达到了 **99%**，7 个测试文件各有侧重：

| 测试文件 | 验证什么 | 覆盖率 |
|----------|----------|--------|
| test_detection | 正则匹配准确性 | 100% |
| test_scanning_rules | 规则文档与实际扫描一致 | 97% |
| test_skill_structure | SKILL.md 结构完整性 | 100% |
| test_convert | 多平台转换正确性 | 100% |
| test_plugin_metadata | plugin.json 格式验证 | 100% |
| test_entropy | Shannon 熵计算 | 100% |
| test_conftest | 测试基础设施 | 100% |

> Simplified from: `skills/ruyi-github-safe-publish/CLAUDE.md`

**134/135 条规则有端到端检测测试**——唯一未覆盖的是 `large-file-in-history`（基于文件大小阈值，无正则可测）。

### 测试如何工作

测试框架从 `docs/scanning-rules.md` 提取正则表达式，然后用构造的测试数据验证每条规则都能正确匹配：

```python
# Simplified from: skills/ruyi-github-safe-publish/tests/conftest.py
SKILL_MD = pathlib.Path(__file__).parent.parent / "skills" / "ruyi-github-safe-publish" / "SKILL.md"
SCANNING_RULES_MD = pathlib.Path(__file__).parent.parent / "docs" / "scanning-rules.md"
```

这意味着：**规则文档本身就是测试的数据源**。如果规则文档改了但测试没跟着改，测试就会失败——实现了规则与测试的强绑定。

---

[← 上一章：架构设计](02-architecture.md) | [下一章：项目走读 Skill →](04-project-walkthrough.md)
