# doraemon-skills

[![license](https://img.shields.io/badge/license-MIT-green)](LICENSE) [![platform](https://img.shields.io/badge/platform-Claude%20Code-purple)](https://claude.ai/code)

Claude Code skills that simplify complex tasks — one command to rule them all.

[中文](README.md)

> **Doraemon** — Claude Code skills that simplify complex tasks into single commands.

## Install Skills

### Option 1: Via Browse UI

Select **Browse and install plugins** → Select **doraemon-skills** → Select **Install now**

### Option 2: Direct Install

```bash
# 1. Add marketplace
/plugin marketplace add zwyin/doraemon-skills

# 2. Install the plugin
/plugin install doraemon-skills@doraemon-skills

# 3. Reload plugins
/reload-plugins
```

### Option 3: Ask the Agent

Simply tell the Agent:

```
Please install Skills from github.com/zwyin/doraemon-skills
```

### Option 4: Quick Install (npx)

```bash
npx skills add zwyin/doraemon-skills
```

### Option 5: ClawHub (coming soon)

> Not yet published to ClawHub registry. Track progress at [github.com/zwyin/doraemon-skills](https://github.com/zwyin/doraemon-skills).

```bash
clawhub install github-safe-publish
clawhub install project-walkthrough
```

### Option 6: Manual Install

```bash
git clone https://github.com/zwyin/doraemon-skills.git
claude --plugin-dir ./doraemon-skills
```

---

## Skills

### github-safe-publish

Safely publish to GitHub — two-layer desensitization scanning (135 rules + AI), auto-fix, backup & rollback, end-to-end workflow.

[![version](https://img.shields.io/badge/version-0.7.0-blue)](skills/doraemon-github-safe-publish/skills/doraemon-github-safe-publish/SKILL.md)

**Covers 6 dimensions**: Secrets & Credentials (100 rules), Database Connections (5 rules), PII (8 rules), Internal Infrastructure (6 rules), File Blacklist (12 rules), Git History (4 rules).

```bash
# Full workflow: scan → fix → publish to GitHub
/doraemon-github-safe-publish

# Core + SEO optimization (description, topics, badges)
/doraemon-github-safe-publish --seo

# Core + CI generation (auto-detect project type, generate .github/workflows/test.yml)
/doraemon-github-safe-publish --ci

# Full: core + SEO + CI
/doraemon-github-safe-publish --seo --ci

# Scan only — output report, no fix, no publish
/doraemon-github-safe-publish --scan-only

# Dry run — scan + fix suggestions, but no actual changes
/doraemon-github-safe-publish --dry-run
```

| Flag | Description | Mutual Exclusion |
|------|-------------|------------------|
| (none) | Core workflow: scan + publish | — |
| `--seo` | Add SEO optimization (description, topics, badges, README) | Cannot combine with `--scan-only` / `--dry-run` |
| `--ci` | Add CI generation (auto-detect and generate workflow) | Cannot combine with `--scan-only` / `--dry-run` |
| `--scan-only` | Scan only, output report | Cannot combine with `--seo` / `--ci` / `--dry-run` |
| `--dry-run` | Dry run: scan + suggestions, no changes | Cannot combine with `--seo` / `--ci` / `--scan-only` |

---

### project-walkthrough

Project walkthrough generator — multi-depth, multi-audience, multi-language, outputs markdown + interactive HTML.

[![version](https://img.shields.io/badge/version-1.6.1-blue)](skills/doraemon-project-walkthrough/skills/doraemon-project-walkthrough/SKILL.md)

```bash
# Auto-analyze current directory, recommend depth
/doraemon-project-walkthrough

# Specify project path
/doraemon-project-walkthrough /path/to/project

# Quick overview (small projects or first-time review)
/doraemon-project-walkthrough --depth brief

# Deep walkthrough (comprehensive analysis)
/doraemon-project-walkthrough --depth deep

# Full walkthrough (all details, large projects)
/doraemon-project-walkthrough --depth all

# For developer audience
/doraemon-project-walkthrough --audience dev

# Pure English output
/doraemon-project-walkthrough --lang en

# Bilingual output (Chinese + English side by side)
/doraemon-project-walkthrough --lang bilingual

# Skip confirmation, use recommended defaults (automation-friendly)
/doraemon-project-walkthrough --no-confirm

# Combine: deep walkthrough + dev audience + English
/doraemon-project-walkthrough --depth deep --audience dev --lang en

# Print version
/doraemon-project-walkthrough --version
```

| Flag | Description | Values | Default |
|------|-------------|--------|---------|
| `path` | Project path | any directory path | current directory |
| `--depth` | Walkthrough depth | `brief` / `medium` / `deep` / `all` | auto-recommended |
| `--audience` | Target audience | `general` / `dev` | `general` |
| `--lang` | Output language | `zh` / `zh-pure` / `en` / `bilingual` | `zh` |
| `--no-confirm` | Skip confirmation | (flag, no value) | — |
| `--version` | Print version | (flag, no value) | — |

---

## License

[MIT](LICENSE)
