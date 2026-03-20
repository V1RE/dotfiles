#!/usr/bin/env bash
set -euo pipefail

cmux ping &>/dev/null || exit 0
command -v jq >/dev/null 2>&1 || exit 0

REPO="${1:?usage: cmux-remove.sh <repo> <branch>}"
BRANCH="${2:?usage: cmux-remove.sh <repo> <branch>}"

TITLE="${REPO}/${BRANCH}"

workspace="$(cmux --json list-workspaces | jq -r --arg title "$TITLE" '
  [.workspaces[]? | select((.title // "") == $title) | (.workspace_ref // .workspace_id // .id)]
  | .[0] // empty
')"

if [ -n "$workspace" ]; then
  cmux close-workspace --workspace "$workspace" >/dev/null 2>&1 || true
fi
