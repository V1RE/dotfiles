#!/usr/bin/env bash
set -euo pipefail

cmux ping &>/dev/null || exit 0

REPO="${1:?usage: cmux-remove.sh <repo> <branch>}"
BRANCH="${2:?usage: cmux-remove.sh <repo> <branch>}"

TITLE="${REPO}/${BRANCH}"

ws=$(cmux list-workspaces | awk -v t="$TITLE" '$0 ~ t {print $1; exit}')
if [ -n "$ws" ]; then
  cmux close-workspace --workspace "$ws" 2>/dev/null || true
fi
