# 06 质量保障

## 测试架构

两层测试结构：

| 层 | 位置 | 覆盖范围 |
|----|------|----------|
| 合集级 | `tests/` | convert.sh、release.sh、check_self_contained.py |
| Skill 级 | `skills/*/tests/` | 各 skill 的脚本、逻辑、结构 |

### github-safe-publish 测试（8 个测试文件）

| 测试文件 | 覆盖率 | 说明 |
|----------|--------|------|
| test_skill_structure | 100% | SKILL.md 结构完整性 |
| test_scanning_rules | 97% | 134/135 规则端到端检测 |
| test_detection | 100% | 检测逻辑 |
| test_convert | 100% | 多平台转换 |
| test_plugin_metadata | 100% | 插件元数据 |
| test_conftest | 100% | 测试辅助函数 |
| test_entropy | 100% | Shannon entropy 计算 |

总体覆盖率：99%，门禁：≥95%。

唯一未覆盖的规则：`large-file-in-history`（基于文件大小阈值，无正则可匹配）。

### project-walkthrough 测试（7 个测试文件）

| 测试文件 | 说明 |
|----------|------|
| test_adaptive_scope | 自适应范围检测 |
| test_convert | 平台转换验证 |
| test_import_graph | import 依赖图提取 |
| test_lang_output | 多语言输出 |
| test_release_sh | 发布脚本 |
| test_verify_sources | sources-manifest 验证 |
| test_walkthrough_output | 端到端走读输出 |

3 组测试夹具（bat、fastapi、zod）提供端到端验证数据。

## 自包含校验

```python
// Simplified from: scripts/check_self_contained.py:11-40
CROSS_LINK = re.compile(r'\[.*?\]\((?!https?://)(?!#)(?!`)(?!\./)(\.\./.+?)\)')

for root, dirs, files in os.walk(skill_dir):
    for fname in files:
        if not fname.endswith('.md'):
            continue
        for m in CROSS_LINK.finditer(line):
            # 检查目标路径是否超出 skill 目录
            resolved = os.path.normpath(os.path.join(file_dir, target))
            if not resolved.startswith(skill_dir + os.sep):
                errors.append(f"{relpath}:{lineno}: cross-skill link: {target}")
```

检测所有 markdown 文件中的相对路径链接，确保不跨越 skill 目录边界。在 CI 的 structure-check job 中执行。

## Sources Manifest 验证

`verify_sources.py`（315 行）验证 walkthrough 产出的 sources-manifest.json：

1. **JSON Schema 校验**：清单结构符合 schema（使用 jsonschema 库）
2. **字段完整性**：每个 claim 有必需字段（id, type, source_file, claim_summary, verified）
3. **源文件存在性**：manifest 中引用的源文件真实存在
4. **行范围校验**：source_lines 在文件行数范围内
5. **Claim type 校验**：type 必须是预定义的 9 种之一

## HTML 验证

`md_to_html.py --verify` 模式检查转换质量：

| 检查项 | 规则 |
|--------|------|
| Section count | = markdown 文件数 |
| 内容完整性 | 每个 section 有 heading + 内容元素 |
| 大小比率 | HTML ≥ 80% markdown 大小 |
| 链接完整性 | 0 个 `.md` href 链接 |
| 导航一致性 | sidebar 项数 = 章节数 |

验证结果写入 `verify-result.json`，Phase 5 交付门禁必须读取此文件。

## CI 门禁总结

```text
make ci = test + check + test-collection
  ├── test:                    每个 skill 的 pytest（含覆盖率门禁）
  ├── check:                   marketplace.json 有效性 + 自包含校验
  └── test-collection:         合集级脚本测试 + convert.sh --check
```

---

[← 上一章](05-build-and-release.md) | [下一章 →](07-quiz.md)
