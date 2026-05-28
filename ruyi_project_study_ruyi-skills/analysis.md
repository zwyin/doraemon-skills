---
project: ruyi-skills
content_type: software-project
scope: overview
depth: standard
audience: general
language: zh
format: html+markdown
chapters: 5-7
technical_density: medium-high
file_count: 128
line_count: 20477
previous_walkthrough: project_study_ruyi-skills (May 27, overview/dev/zh)
generated: 2026-05-28
---

# Content Analysis: ruyi-skills

## Type
Software project — Claude Code skill collection monorepo.

## Scope
- ~128 core files, ~20K lines (excluding examples, dist, cache)
- 2 self-contained skills: ruyi-github-safe-publish v0.7.0, ruyi-project-walkthrough v1.6.1
- Collection version: 0.8.0 (marketplace.json)
- Shell scripts (convert.sh, release.sh, validate_skill.sh)
- Python tests + scripts (pytest)
- Markdown documentation + JSON schemas
- CI/CD (GitHub Actions)

## Content Structure
- Core skill definitions (SKILL.md + references/)
- Build/release scripts (shell)
- Multi-platform conversion (Cursor .mdc, Windsurf .md, OpenCode SKILL.md)
- Test suites (Python/pytest)
- Architecture docs + design docs
- CI/CD configuration
- Examples for walkthrough testing (zod, fastapi, bat projects)

## Technical Density
Medium-high. Mix of shell scripting, Python testing, markdown-as-code (SKILL.md), and CI/CD config.

## User Selections
- Scope: overview (5-7 thematic chapters)
- Depth: standard (key points + important data + selected examples)
- Audience: general (with analogy cards and plain-language summaries)
- Language: zh (Chinese body + English technical terms)
- Format: HTML + Markdown
- Review outline: yes
