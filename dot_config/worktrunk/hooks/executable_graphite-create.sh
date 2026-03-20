#!/usr/bin/env bash
set -euo pipefail

BRANCH="${2:?usage: graphite-create.sh <repo> <branch> <worktree_path>}"
WORKTREE_PATH="${3:?usage: graphite-create.sh <repo> <branch> <worktree_path>}"

command -v git >/dev/null 2>&1 || exit 0
command -v gt >/dev/null 2>&1 || exit 0
command -v jq >/dev/null 2>&1 || exit 0

git_common_dir="$(git -C "$WORKTREE_PATH" rev-parse --path-format=absolute --git-common-dir 2>/dev/null || true)"
[ -n "$git_common_dir" ] || exit 0

repo_config_path="$git_common_dir/.graphite_repo_config"
[ -f "$repo_config_path" ] || exit 0

trunk="$(jq -r '.trunk // empty' "$repo_config_path")"
if [ -z "$trunk" ]; then
  trunk="develop"
fi

[ "$BRANCH" != "$trunk" ] || exit 0

pr_info_path="$git_common_dir/.graphite_pr_info"
if [ -f "$pr_info_path" ] && jq -e --arg branch "$BRANCH" '.prInfos[]? | select(.headRefName == $branch)' "$pr_info_path" >/dev/null; then
  exit 0
fi

gt --cwd "$WORKTREE_PATH" --quiet track --parent "$trunk" >/dev/null 2>&1 || true
