# 01 项目概览：ruyi-skills

## 定位

ruyi-skills 是一个 Claude Code skill 合集仓库——把复杂的耗时任务变成一条命令。

> 如意（Ruyi）：中国传统文化中的吉祥物，意为「如你心意」。

当前包含两个 skill：

| Skill | 版本 | 功能 |
|-------|------|------|
| github-safe-publish | v0.7.0 | 安全发布到 GitHub——两层脱敏扫描 + 自动修复 + 备份回滚 |
| project-walkthrough | v1.6.1 | 项目技术走读——多深度、多受众、多语言，输出 markdown + 交互式 HTML |

合集版本：v0.1.1（marketplace.json）。

## 设计哲学

核心设计原则（详见 [architecture-design.md](https://github.com/zwyin/ruyi-skills/blob/main/docs/architecture-design.md)）：

1. **Skill 自包含**——每个 skill 的 SKILL.md 和 references/ 不得链接 skill 目录外的文件，可独立提取使用
2. **单一 marketplace**——一个 marketplace.json 列所有 skills，用户一次安装
3. **双层版本**——skill 版本（SKILL.md frontmatter）独立迭代，合集版本（marketplace.json）反映整体发布节奏

## 技术栈

| 层面 | 技术 |
|------|------|
| Skill 定义 | Markdown + YAML frontmatter |
| 构建脚本 | Bash（convert.sh, release.sh） |
| 验证工具 | Python（check_self_contained.py, verify_sources.py, md_to_html.py） |
| 测试 | pytest（每个 skill 独立测试套件） |
| CI | GitHub Actions（2 OS × 2 Python 矩阵 + 结构检查） |
| 多平台输出 | Cursor (.mdc), Windsurf (.windsurfrules), OpenCode (AGENTS.md) |

## 安装方式

支持 6 种安装路径：Browse UI、Direct Install（/plugin marketplace add）、Ask Agent、npx skills add、ClawHub（coming soon）、手动 git clone。

## 仓库数据

| 指标 | 数值 |
|------|------|
| 文件数 | ~177（排除 .git） |
| 总行数 | ~33.5K |
| Skills | 2 |
| 测试文件 | 15（8 + 7） |
| CI jobs | 4 |

---

[下一章：架构设计 →](02-architecture.md)
