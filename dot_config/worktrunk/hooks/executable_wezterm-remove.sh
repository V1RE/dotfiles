#!/usr/bin/env bash
set -euo pipefail

command -v wezterm >/dev/null 2>&1 || exit 0
command -v jq >/dev/null 2>&1 || exit 0
wezterm cli list --format json >/dev/null 2>&1 || exit 0

REPO="${1:?usage: wezterm-remove.sh <repo> <branch>}"
BRANCH="${2:?usage: wezterm-remove.sh <repo> <branch>}"

TITLE="${REPO}/${BRANCH}"

while IFS= read -r pane_id; do
  [ -n "$pane_id" ] || continue
  wezterm cli kill-pane --pane-id "$pane_id" >/dev/null 2>&1 || true
done < <(
  wezterm cli list --format json | jq -r --arg workspace "$TITLE" '
    [.[] | select(.workspace == $workspace) | .pane_id]
    | unique
    | .[]?
  '
)
