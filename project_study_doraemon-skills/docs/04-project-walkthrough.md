# 04 Skill 深度：project-walkthrough

## 概述

project-walkthrough（v1.6.1）生成项目技术走读文档，支持多深度、多受众、多语言，输出 markdown + 交互式 HTML。

SKILL.md 共 841 行，定义了从分析到交付的完整 5 阶段流程。

## CLI 接口

```text
/ruyi-project-walkthrough /path/to/project --depth deep --audience dev --lang zh
```

| 参数 | 可选值 | 默认 |
|------|--------|------|
| `path` | 任意目录 | 当前目录 |
| `--depth` | brief / medium / deep / all | brief |
| `--audience` | general / dev | general |
| `--lang` | zh / zh-pure / en / bilingual | zh |
| `--no-confirm` | flag | — |

## 五阶段流程

```text
Phase 0: 分析 + 确认（~5%）  → 检测项目类型、确定范围、用户确认
Phase 1: 探索（~15%）         → 读源码、提取创新点、映射架构
Phase 2: 规划（~10%）         → 选择章节模板、规划章节映射
Phase 3: 生成 Markdown（~40%）→ 验证 + 构建清单 + 写章节
Phase 4: 生成 HTML（~30%）    → md_to_html.py 转换
Phase 5: 验证 + 交付（~5%）   → 结构验证 + 内容验证 + 交付门禁
```

## 核心创新点

### 1. Verify-before-write 机制

Phase 3A 强制先验证后写入。每个事实声明（代码示例、目录结构、API 签名、版本号）必须在 `sources-manifest.json` 中有 `verified: true` 条目，否则不得写入章节。

### 2. sources-manifest.json 清单

```text
// Simplified from: skills/ruyi-project-walkthrough/docs/sources-manifest-schema.md
每个条目包含：
- id (claim-001)
- type (code_example / directory_structure / api_signature / ...)
- source_file + source_lines（源文件路径和行范围）
- claim_summary（一句话描述）
- verified (boolean)
- doc_file + doc_line（写入位置）
```

由 `verify_sources.py` 验证清单合法性（JSON Schema 校验 + 源文件存在性检查）。

### 3. HTML 转换器

`md_to_html.py`（573 行）将 markdown 章节转换为自包含交互式 HTML：

- 侧边栏导航
- 暗色/亮色主题切换
- 移动端响应式
- 交互式 Quiz（从 `## Quiz` section 提取）
- i18n 支持（zh / zh-pure / en / bilingual）
- `--verify` 模式验证 HTML 与 markdown 的内容一致性

### 4. import_graph.py

`import_graph.py`（239 行）从源代码中提取实际的 import 依赖图，用于生成准确的架构图，而非从目录结构推断。

## 深度级别

| 深度 | 章节数 | 适用场景 |
|------|--------|----------|
| Brief | 5-8 | 快速了解、是否投入更多时间 |
| Medium | 10-15 | 工程师 onboarding、架构评估 |
| Deep | 无硬上限 | 贡献者、安全审计、参考指南 |
| All | 三个级别依次生成 | 全面了解 |

## 测试夹具

项目包含 3 组测试夹具（bat、fastapi、zod），每组有完整的 docs/ 和 interactive/ 输出，用于端到端验证。

---

[← 上一章](03-github-safe-publish.md) | [下一章 →](05-build-and-release.md)
