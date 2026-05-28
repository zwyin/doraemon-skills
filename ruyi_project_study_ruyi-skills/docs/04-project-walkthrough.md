# 第 4 章：project-walkthrough — 项目走读 Skill

## 这个 Skill 做什么？

> **类比理解：** 想象你刚加入一家公司，面对一个有 10 万行代码的项目。通常你需要找同事给你讲解、自己翻代码、画架构图……project-walkthrough 就像一个「自动讲解员」——它能读懂整个项目，然后生成一份带导航、测验和交互动画的「项目说明书」。

project-walkthrough 自动分析任何项目（代码库、研究报告、文档集合），然后生成结构化的走读文档。

核心能力：
1. **智能分析**：自动检测项目类型、规模、技术密度
2. **多深度输出**：brief / medium / deep / all 四种深度
3. **多受众适配**：普通读者（含类比卡片）或开发者（直接技术分析）
4. **多语言支持**：中文 / 纯中文 / 英文 / 中英对照
5. **交互式 HTML**：侧边栏导航、明暗主题切换、知识测验

## 工作流程

整个流程分为 6 个阶段：

```
Phase 0: 分析确认 → 了解项目范围，确认输出方案
Phase 1: 探索     → 深入阅读源代码和文档
Phase 2: 规划     → 设计章节结构
Phase 3: 生成     → 验证声明 → 写入内容（verify-before-write）
Phase 4: 转换     → Markdown → 交互式 HTML
Phase 5: 验证交付 → 自动化质量检查 + 交付
```

### 关键设计：Verify-before-write

> **类比理解：** 新闻报道最忌讳「先发再核实」。project-walkthrough 的原则是「先核实再写」——每个技术声明（代码示例、版本号、目录结构）必须先对照源文件验证，通过验证后才允许写入文档。

具体执行：
1. 列出每个章节要写的技术声明
2. 逐条读取源文件验证
3. 构建验证清单（sources-manifest.json）
4. 只有清单中的已验证声明才能写入章节

## 使用方式

```bash
# 自动分析当前目录，推荐深度
/ruyi-project-walkthrough

# 指定项目路径和深度
/ruyi-project-walkthrough /path/to/project --depth medium

# 面向开发者，深度走读
/ruyi-project-walkthrough --depth deep --audience dev

# 纯英文输出
/ruyi-project-walkthrough --lang en

# 中英对照
/ruyi-project-walkthrough --lang bilingual

# 跳过确认，使用推荐默认值
/ruyi-project-walkthrough --no-confirm
```

> Simplified from: `skills/ruyi-project-walkthrough/skills/ruyi-project-walkthrough/SKILL.md`

## 工具链

project-walkthrough 包含一套自研工具链：

| 工具 | 用途 |
|------|------|
| **md_to_html.py** (635 行) | Markdown → 交互式 HTML 转换器，支持侧边栏、主题切换、测验 |
| **verify_sources.py** | 验证 sources-manifest.json 中的声明是否准确 |
| **import_graph.py** | 提取源代码的 import 依赖图，生成准确的架构图 |
| **convert.sh** | 多平台格式转换（Cursor/Windsurf/OpenCode） |
| **check_update.sh** | 检查是否有新版本可用 |

> Simplified from: `skills/ruyi-project-walkthrough/scripts/`

## 输出结构

每次走读生成一套完整的文档包：

```
ruyi_project_study_<project-name>/
├── analysis.md              # 项目分析报告
├── docs/
│   ├── 01-overview.md       # 各章节 Markdown
│   ├── 02-*.md
│   ├── ...
│   └── sources-manifest.json # 验证声明清单
└── interactive/
    ├── walkthrough-*.html    # 交互式 HTML（含测验）
    └── verify-result.json    # 自动化验证结果
```

## 测试覆盖

8 个测试文件覆盖了 skill 的各个维度：

| 测试文件 | 验证什么 |
|----------|----------|
| test_adaptive_scope | 自适应范围选择 |
| test_release_sh | 发布脚本 |
| test_verify_sources | 声明验证 |
| test_lang_output | 多语言输出 |
| test_convert | 格式转换 |
| test_walkthrough_output | 走读输出完整性 |
| test_watermark | 水印生成 |
| test_import_graph | 依赖图提取 |

> Simplified from: `skills/ruyi-project-walkthrough/tests/`

---

[← 上一章：安全发布 Skill](03-github-safe-publish.md) | [下一章：构建与发布 →](05-build-and-release.md)
