# 第 6 章：质量保障

## 测试体系

> **类比理解：** 质量保障就像汽车的刹车系统——平时你可能感觉不到它的存在，但没有它你绝对不敢上路。ruyi-skills 的测试体系从三个层面保证每次变更都不会引入问题。

### 三层测试结构

```
合集级测试（tests/）
├── test_check_self_contained.py   # 自包含原则验证
├── test_convert.py                # 多平台转换正确性
└── test_release_sh.py             # 发布脚本逻辑

github-safe-publish 测试（7 个文件）
├── conftest.py                    # 测试基础设施（fixture 定义）
├── test_detection.py              # 正则匹配准确性
├── test_scanning_rules.py         # 规则文档与实际扫描一致
├── test_skill_structure.py        # SKILL.md 结构完整性
├── test_convert.py                # 格式转换
├── test_entropy.py                # Shannon 熵计算
├── test_plugin_metadata.py        # plugin.json 格式
└── test_conftest.py               # 测试基础设施自身测试

project-walkthrough 测试（8 个文件）
├── test_adaptive_scope.py         # 自适应范围
├── test_release_sh.py             # 发布脚本
├── test_verify_sources.py         # 声明验证
├── test_lang_output.py            # 多语言输出
├── test_convert.py                # 格式转换
├── test_walkthrough_output.py     # 走读输出完整性
├── test_watermark.py              # 水印生成
└── test_import_graph.py           # 依赖图提取
```

> Simplified from: 各 tests/ 目录文件列表

**总计 18 个测试文件**，覆盖合集级 + 两个 skill 的全部功能。

## 覆盖率门禁

> **类比理解：** 覆盖率就像体检的检查项目清单——覆盖率 95% 意味着你的代码中有 95% 的行在测试中被「走了一遍」。如果新增代码没有对应的测试，覆盖率就会下降，CI 就会报错——提醒你「这个新功能还没测试」。

github-safe-publish 在 CI 中设置了 **≥ 95% 的覆盖率门禁**：

```yaml
# Simplified from: .github/workflows/test.yml:29
- run: python -m pytest tests/ --cov=tests --cov-report=term-missing --cov-fail-under=95
```

当前实际覆盖率为 **99%**，远超门禁线。

各测试模块覆盖率：

| 模块 | 覆盖率 |
|------|--------|
| test_detection | 100% |
| test_skill_structure | 100% |
| test_convert | 100% |
| test_plugin_metadata | 100% |
| test_conftest | 100% |
| test_entropy | 100% |
| test_scanning_rules | 97% |

> Simplified from: `skills/ruyi-github-safe-publish/CLAUDE.md`

## 规则与测试的强绑定

> **类比理解：** 想象一家餐厅的菜单和质检报告——如果菜单上写了一道菜但质检没测过，或者质检测了一道菜单上没有的菜，都是问题。ruyi-skills 的规则和测试实现了这种强绑定。

github-safe-publish 的测试直接从 `docs/scanning-rules.md` 提取正则表达式来验证。这意味着：

1. **新增规则**必须在 scanning-rules.md 中有正确定义
2. **测试自动覆盖**新增的规则
3. 如果规则文档改了但扫描逻辑没跟上，测试就会失败

134/135 条规则有端到端检测测试（唯一例外：`large-file-in-history`，基于文件大小阈值而非正则）。

## 结构验证

CI 中还运行两项结构验证：

### 自包含检查

```bash
python3 scripts/check_self_contained.py
```

扫描所有 SKILL.md 和 references/ 文件，确保没有跨 skill 的链接。

### Marketplace 格式验证

```bash
python3 -c "import json; json.load(open('.claude-plugin/marketplace.json'))"
```

确保 marketplace.json 是合法的 JSON 格式。

## 质量保障总结

| 维度 | 标准 | 现状 |
|------|------|------|
| 测试文件数 | ≥ 15 | 18 |
| 代码覆盖率 | ≥ 95% | 99% |
| 规则测试覆盖 | 100% | 134/135 (99.3%) |
| 自包含检查 | 100% 通过 | ✓ |
| CI 平台覆盖 | Ubuntu + macOS | ✓ |
| Python 版本覆盖 | 3.10 + 3.12 | ✓ |

---

[← 上一章：构建与发布](05-build-and-release.md) | [下一章：知识测验 →](07-quiz.md)
