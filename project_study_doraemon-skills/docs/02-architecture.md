# 02 架构设计

## 目录结构

```text
// Simplified from: docs/architecture-design.md:3-40
ruyi-skills/
├── .claude-plugin/
│   └── marketplace.json            # 单一 plugin，列所有 skills
├── .github/
│   └── workflows/test.yml          # CI: 各 skill 测试 + 结构验证
├── scripts/                        # 合集级工具
│   ├── convert.sh                  # 多平台转换（输出到 dist/）
│   ├── release.sh                  # 版本 bump + 同步 + tag
│   └── check_self_contained.py     # 自包含校验
├── skills/                         # 各 skill（git subtree 管理）
│   ├── ruyi-github-safe-publish/
│   │   ├── SKILL.md                # skill 唯一事实源
│   │   ├── docs/                   # 规则参考、设计文档
│   │   ├── scripts/                # skill 专属脚本
│   │   └── tests/                  # skill 专属测试
│   └── ruyi-project-walkthrough/
│       ├── SKILL.md
│       ├── docs/
│       ├── scripts/
│       └── tests/
├── dist/                           # gitignored，convert.sh 输出
├── Makefile
└── README.md
```

## 八大设计原则

### P1. Skill 自包含

SKILL.md 及 references/ 内的所有链接，不得指向 skill 目录外的文件。由 `check_self_contained.py` 在 CI 中强制执行。

### P2. 渐进展示

SKILL.md 控制在合理长度内（当前：github-safe-publish 1133 行，project-walkthrough 841 行），详细规则和配置放在 references/ 或 docs/ 子目录。

### P3. 单一 marketplace

```json
// Simplified from: .claude-plugin/marketplace.json:1-28
{
  "name": "ruyi-skills",
  "version": "0.1.1",
  "plugins": [{
    "skills": [
      "./skills/ruyi-github-safe-publish/skills/ruyi-github-safe-publish",
      "./skills/ruyi-project-walkthrough/skills/ruyi-project-walkthrough"
    ]
  }]
}
```

### P4. Subtree 双向同步

每个 skill 有独立仓库用于日常迭代，合集仓库通过 `git subtree` 导入，保持双向同步。

```bash
# Simplified from: docs/architecture-design.md:71-78
# 拉取更新
git subtree pull --prefix=skills/github-safe-publish \
  https://github.com/zwyin/github-safe-publish.git master --squash

# 推回独立仓库
git subtree push --prefix=skills/github-safe-publish \
  https://github.com/zwyin/github-safe-publish.git master
```

### P5. 双层版本

- Skill 版本：各自 SKILL.md frontmatter（随 subtree 同步）
- 合集版本：marketplace.json

release.sh 读取当前版本，根据 bump 类型（patch/minor/major）计算下一版本号，同步更新所有位置。

### P6. 多品牌推送

ruyi-skills 是唯一开发仓库。通过独立的 brand-sync-tool 生成各品牌仓库（paoding/davinci/doraemon），每个品牌拥有独立的 git 历史（单 orphan commit）。

| 品牌 | GitHub 仓库 | 受众 | README |
|------|-----------|------|--------|
| ruyi | zwyin/ruyi-skills | 中文用户 | 中文默认 + 英文链接 |
| paoding | zwyin/paoding-skills | 中文用户 | 中文默认 + 英文链接 |
| davinci | zwyin/davinci-skills | 海外用户 | 英文默认 + 中文链接 |
| doraemon | zwyin/doraemon-skills | 海外用户 | 英文默认 + 中文链接 |

brand-sync-tool 自动替换：SKILL.md name、目录名、marketplace.json、README、CI 路径、测试文件、版本检查脚本、平台输出文件等。各品牌仓库由工具生成后手动推送，不作为 remote 添加到本仓库。

### P7. 生成文件隔离

平台转换文件输出到 gitignored 的 `dist/`，不污染 git history。

### P8. 质量门禁

CI 包含测试 + 覆盖率门禁 + 结构验证（详见 [06 质量保障](06-quality-gates.md)）。

## 数据流

```text
日常迭代 → 独立仓库
    ↓ subtree pull
合集仓库（ruyi-skills）
    ↓ release.sh + sync
多个品牌仓库（ruyi / paoding / davinci / doraemon）
```

---

[← 上一章](01-overview.md) | [下一章 →](03-github-safe-publish.md)
