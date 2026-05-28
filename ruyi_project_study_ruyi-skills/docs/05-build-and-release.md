# 第 5 章：构建与发布

## 版本管理

> **类比理解：** ruyi-skills 的版本管理像一个「主从同步」系统——每个 skill 有自己的版本号（像手机 App 的版本），合集也有一个总版本号（像手机系统版本）。两者独立更新，但通过发布脚本自动同步。

### 双层版本架构

| 层级 | 存储位置 | 更新方式 |
|------|----------|----------|
| Skill 版本 | SKILL.md frontmatter `version: "X.Y.Z"` | 随独立仓库迭代 |
| 合集版本 | marketplace.json `"version": "X.Y.Z"` | release.sh 统一 bump |

### release.sh 发布流程

发布一条新版本只需一个命令：

```bash
./scripts/release.sh patch    # 0.8.0 → 0.8.1（bug 修复）
./scripts/release.sh minor    # 0.8.0 → 0.9.0（新功能）
./scripts/release.sh major    # 0.8.0 → 1.0.0（重大更新）
```

> Simplified from: `scripts/release.sh`

release.sh 自动完成以下步骤：

```
读取当前版本 → 计算新版本 → 更新 marketplace.json
→ 更新 CHANGELOG.md → 更新 README 版本徽章
→ git commit + tag → 推送到所有 remote
```

## 多平台转换

> **类比理解：** 同一部电影要适配不同播放平台——Netflix 用一种格式，Disney+ 用另一种。convert.sh 就像视频转码器，把 SKILL.md 转换成不同 AI 编程工具能识别的格式。

convert.sh 支持三种目标平台：

| 平台 | 输出格式 | 说明 |
|------|----------|------|
| **Cursor** | `.cursor/rules/*.mdc` | 按 `## Step` 拆分为独立规则文件 |
| **Windsurf** | `.windsurfrules/*.md` | 完整 SKILL.md body 输出 |
| **OpenCode** | `.opencode/skills/*/SKILL.md` | 原样复制 |

```bash
./scripts/convert.sh --cursor     # 只生成 Cursor 格式
./scripts/convert.sh --windsurf   # 只生成 Windsurf 格式
./scripts/convert.sh --opencode   # 只生成 OpenCode 格式
./scripts/convert.sh --all        # 生成所有格式
./scripts/convert.sh --check      # CI 中验证可转换性
```

> Simplified from: `scripts/convert.sh`

所有转换输出到 gitignored 的 `dist/` 目录，不污染 Git 历史。

## CI/CD 流水线

> **类比理解：** CI/CD 就像一个「自动化质检流水线」——每次代码变更都会自动跑一轮检查，确认没有引入问题。

GitHub Actions 配置了 4 个并行 job：

| Job | 运行环境 | 检查内容 |
|-----|----------|----------|
| test-github-safe-publish | Ubuntu + macOS, Python 3.10 & 3.12 | pytest + 覆盖率 ≥ 95% |
| test-project-walkthrough | Ubuntu, Python 3.12 | pytest |
| structure-check | Ubuntu, Python 3.12 | marketplace.json 格式 + 自包含检查 |
| collection-scripts | Ubuntu, Python 3.12 | 合集级测试 + convert.sh --check |

```yaml
# Simplified from: .github/workflows/test.yml
# github-safe-publish 的覆盖率门禁
- run: python -m pytest tests/ -v --tb=short --cov=tests --cov-report=term-missing --cov-fail-under=95
```

## Makefile 命令一览

| 命令 | 作用 |
|------|------|
| `make test` | 运行所有 skill 测试 |
| `make ci` | test + 结构验证 + 合集测试 |
| `make check` | marketplace.json 格式 + 自包含检查 |
| `make release` | 版本 bump + 同步 + tag + push |
| `make convert` | 生成 dist/ 多平台文件 |
| `make clean` | 清理 dist/ |

> Simplified from: `Makefile`

---

[← 上一章：项目走读 Skill](04-project-walkthrough.md) | [下一章：质量保障 →](06-quality-gates.md)
