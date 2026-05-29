#!/usr/bin/env bash
# get_output_dir.sh — Compute output directory name for project-walkthrough
#
# Usage: bash scripts/get_output_dir.sh --prefix ruyi --project my-codebase --depth medium --lang en --audience dev
# Output: ruyi_project_study_my-codebase-medium-en-dev
#
# All flags are optional and fall back to defaults.
set -euo pipefail

PREFIX=""
PROJECT=""
DEPTH="brief"
LANG="zh"
AUDIENCE="general"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --prefix)   PREFIX="$2";   shift 2 ;;
    --project)  PROJECT="$2";  shift 2 ;;
    --depth)    DEPTH="$2";    shift 2 ;;
    --lang)     LANG="$2";     shift 2 ;;
    --audience) AUDIENCE="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if [ -z "$PREFIX" ] || [ -z "$PROJECT" ]; then
  echo "Error: --prefix and --project are required" >&2
  exit 1
fi

echo "${PREFIX}_project_study_${PROJECT}-${DEPTH}-${LANG}-${AUDIENCE}"
