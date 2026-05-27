# 05 构建与发布

## Makefile

```makefile
// Simplified from: Makefile:1-37
.PHONY: test ci release sync convert clean check test-collection

test:          # 运行所有 skill 测试
ci:            # test + check + test-collection（完整 CI）
check:         # marketplace.json 有效性 + 自包含校验
test-collection: # 合集级脚本测试
release:       # 版本 bump + 同步 + tag + push
sync:          # subtree pull 所有 skill
convert:       # 生成 dist/ 多平台文件
clean:         # 清理 dist/
```

Makefile 是 37 行的轻量编排层，实际逻辑在 scripts/ 下的 bash 脚本中。

## 多平台转换：convert.sh

convert.sh（186 行）将 SKILL.md 转换为三种平台格式：

```text
// Simplified from: scripts/convert.sh:39-130
SKILL.md → Cursor (.mdc)     # 按 ## Step 拆分为独立 .mdc 文件
         → Windsurf (.md)     # 完整 body 输出
         → OpenCode (SKILL.md) # 原样复制
```

关键实现细节：
- `_find_skill_md()`：递归查找 SKILL.md，兼容 subtree 导入的嵌套结构
- `_skill_body()`：用 awk 跳过 YAML frontmatter（`/^---/{n++; next} n>=2`）
- `--check` 模式：CI 中验证所有 skill 有 SKILL.md 且 frontmatter 包含 name + version

输出到 gitignored 的 `dist/`，不污染仓库。

## 版本发布：release.sh

```bash
// Simplified from: scripts/release.sh:18-30
# 读取当前版本
CURRENT=$(python3 -c "import json; print(json.load(open('$MARKETPLACE'))['version'])")

# 计算 next 版本
case "$BUMP" in
    patch) PATCH=$((PATCH + 1)) ;;
    minor) MINOR=$((MINOR + 1)); PATCH=0 ;;
    major) MAJOR=$((MAJOR + 1)); MINOR=0; PATCH=0 ;;
esac

# 同步更新
perl -pi -e "s/\"version\": \"$CURRENT\"/\"version\": \"$NEXT\"/" "$MARKETPLACE"
perl -pi -e "s/## \\[$CURRENT\\]/## [$NEXT] - $(date +%Y-%m-%d)/" "$CHANGELOG"
perl -pi -e "s/version-$CURRENT/version-$NEXT/g" README.md README.en.md
```

发布流程：bump → commit → tag → push。

## CI/CD

```yaml
// Simplified from: .github/workflows/test.yml:1-68
4 个并行 job：
1. test-github-safe-publish  # 2 OS (ubuntu + macos) × 2 Python (3.10 + 3.12)
2. test-project-walkthrough  # ubuntu + Python 3.12
3. structure-check           # marketplace.json + 自包含校验
4. collection-scripts        # 合集级测试 + convert.sh --check
```

github-safe-publish job 使用 `--cov-fail-under=95` 覆盖率门禁。

## 开发流程

```text
日常迭代 → 独立仓库（独立 CI、测试、版本管理）
    ↓ subtree pull
合集仓库（ruyi-skills）
    ↓ 更新 marketplace / README / CHANGELOG
brand-sync-tool → 品牌仓库（各自独立 git 历史）
```

---

[← 上一章](04-project-walkthrough.md) | [下一章 →](06-quality-gates.md)
