#!/usr/bin/env bash
set -euo pipefail

cmux ping &>/dev/null || exit 0

REPO="${1:?usage: cmux-create.sh <repo> <branch> <worktree_path>}"
BRANCH="${2:?usage: cmux-create.sh <repo> <branch> <worktree_path>}"
WORKTREE_PATH="${3:?usage: cmux-create.sh <repo> <branch> <worktree_path>}"

TITLE="${REPO}/${BRANCH}"

existing=$(cmux list-workspaces | awk -v t="$TITLE" '$0 ~ t {print $1; exit}')
if [ -n "$existing" ]; then
  cmux close-workspace --workspace "$existing" 2>/dev/null || true
  sleep 0.5
fi

new_workspace=$(cmux new-workspace --cwd "$WORKTREE_PATH" | awk '{print $2}')
if [ -z "$new_workspace" ]; then
  echo "Failed to parse new workspace ID" >&2
  exit 1
fi

cmux select-workspace --workspace "$new_workspace"
cmux rename-workspace --workspace "$new_workspace" "$TITLE"

cmux send "nvim\n"

ref=$(cmux identify --json | jq -r '.focused.surface_ref')
cmux rename-tab --surface "$ref" "Neovim"

cmux new-surface
ref=$(cmux identify --json | jq -r '.focused.surface_ref')
cmux rename-tab --surface "$ref" ""

cmux new-surface
ref=$(cmux identify --json | jq -r '.focused.surface_ref')
cmux rename-tab --surface "$ref" "Development Server"
