# 第 2 章：架构设计

## 项目结构总览

> **类比理解：** ruyi-skills 的结构像一个购物中心——有一栋主楼（合集仓库），里面有多个独立店铺（skills）。每个店铺自己管理自己的货物（自包含），但购物中心统一收银（单一 marketplace）和管理品牌（多品牌分发）。

```
ruyi-skills/
├── .claude-plugin/
│   └── marketplace.json            # 唯一安装入口，列所有 skills
├── skills/                         # 各 skill（独立仓库通过 git subtree 导入）
│   ├── ruyi-github-safe-publish/   #   安全发布 skill
│   │   ├── skills/.../SKILL.md     #     唯一事实源
│   │   ├── docs/                   #     规则参考
│   │   ├── scripts/                #     专属脚本
│   │   └── tests/                  #     专属测试
│   └── ruyi-project-walkthrough/   #   走读文档 skill
│       ├── skills/.../SKILL.md
│       ├── docs/
│       ├── scripts/
│       └── tests/
├── scripts/                        # 合集级工具（不属于任何 skill）
│   ├── check_self_contained.py     #   自包含检查
│   ├── convert.sh                  #   多平台转换
│   └── release.sh                  #   版本发布
├── tests/                          # 合集级测试
├── dist/                           # 转换输出（gitignored）
├── Makefile                        # 构建命令
└── docs/                           # 仓库级文档
```

> Simplified from: `docs/architecture-design.md`

## 8 条设计原则

### P1：Skill 自包含

> **类比理解：** 每个 skill 像一个独立的手机 App——它不依赖手机上其他 App 的数据。即使你只安装了一个 skill，它也能独立运行。

**做法**：SKILL.md 及 references/ 内的所有链接不得指向 skill 目录外的文件。

**执行保障**：CI 中运行 `check_self_contained.py`，扫描所有 `.md` 文件中的跨目录链接，发现违规立即报错。

```python
# Simplified from: scripts/check_self_contained.py:12-13
# 检测跨 skill 链接的正则表达式
CROSS_LINK = re.compile(r'\[.*?\]\((?!https?://)(?!#)(?!`)(?!\./)(\.\./.+?)\)')
```

### P2：渐进展示

SKILL.md 控制在 500 行以内，详细规则放在 `references/` 子目录。就像一篇文章有摘要和正文——先看摘要抓住重点，需要细节时再深入。

### P3：单一 Marketplace

一个 `marketplace.json` 列出所有 skills，用户一次安装获得全部。新增 skill 只需在 marketplace.json 加一行。

```json
// Simplified from: .claude-plugin/marketplace.json
{
  "name": "ruyi-skills",
  "version": "0.8.0",
  "skills": [
    "./skills/ruyi-github-safe-publish/skills/ruyi-github-safe-publish",
    "./skills/ruyi-project-walkthrough/skills/ruyi-project-walkthrough"
  ]
}
```

### P4：Subtree 双向同步

> **类比理解：** 想象一个连锁餐厅——总部（合集仓库）和各分店（独立仓库）之间可以双向同步菜品（代码）。分店研发了新菜（更新），总部拉取后分发给所有分店。

各 skill 有独立仓库用于日常迭代，合集仓库通过 `git subtree` 导入，保持双向同步：

```bash
# Simplified from: docs/architecture-design.md:72-78
# 从独立仓库拉取更新
git subtree pull --prefix=skills/ruyi-github-safe-publish \
  https://github.com/zwyin/github-safe-publish.git master --squash

# 推回独立仓库
git subtree push --prefix=skills/ruyi-github-safe-publish \
  https://github.com/zwyin/github-safe-publish.git master
```

### P5：双层版本

| 层级 | 定义位置 | 管理方式 |
|------|----------|----------|
| Skill 版本 | SKILL.md frontmatter | 随 subtree 同步 |
| 合集版本 | marketplace.json | release.sh 统一 bump |

> Simplified from: `docs/architecture-design.md:82-84`

### P6：多品牌推送

ruyi-skills 是唯一开发仓库。通过独立的 brand-sync-tool 自动生成 4 个品牌仓库：

| 品牌 | 受众 | README 语言 |
|------|------|------------|
| ruyi | 中文用户 | 中文默认 |
| paoding | 中文用户 | 中文默认 |
| davinci | 海外用户 | 英文默认 |
| doraemon | 海外用户 | 英文默认 |

每个品牌有独立的 Git 历史，用户从任一品牌名找到都能用。

> Simplified from: `docs/architecture-design.md:88-98`

### P7：生成文件隔离

多平台转换文件输出到 gitignored 的 `dist/` 目录，不污染 Git 历史。

### P8：质量门禁

CI 包含测试数量下限 + 覆盖率门禁（≥ 95%）+ 结构验证。

## 开发流程

```
日常迭代 → 独立仓库（github-safe-publish / project-walkthrough-skill）
    ↓ 完成版本
subtree pull → 合集仓库（ruyi-skills）
    ↓ 更新 marketplace / README / CHANGELOG
brand-sync-tool → 4 个品牌仓库各自推送
```

> Simplified from: `docs/architecture-design.md:112-119`

---

[← 上一章：项目概览](01-overview.md) | [下一章：安全发布 Skill →](03-github-safe-publish.md)
