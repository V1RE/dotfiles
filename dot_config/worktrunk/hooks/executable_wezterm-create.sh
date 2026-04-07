#!/usr/bin/env bash
set -euo pipefail

command -v wezterm >/dev/null 2>&1 || exit 0
command -v jq >/dev/null 2>&1 || exit 0
wezterm cli list --format json >/dev/null 2>&1 || exit 0

REPO="${1:?usage: wezterm-create.sh <repo> <branch> <worktree_path>}"
BRANCH="${2:?usage: wezterm-create.sh <repo> <branch> <worktree_path>}"
WORKTREE_PATH="${3:?usage: wezterm-create.sh <repo> <branch> <worktree_path>}"

TITLE="${REPO}/${BRANCH}"

first_pane_id_for_workspace() {
  wezterm cli list --format json | jq -r --arg workspace "$1" '
    [.[] | select(.workspace == $workspace) | .pane_id]
    | .[0] // empty
  '
}

window_id_for_pane() {
  wezterm cli list --format json | jq -r --argjson pane_id "$1" '
    [.[] | select(.pane_id == $pane_id) | .window_id]
    | .[0] // empty
  '
}

existing_pane="$(first_pane_id_for_workspace "$TITLE")"
if [ -n "$existing_pane" ]; then
  wezterm cli activate-pane --pane-id "$existing_pane" >/dev/null
  exit 0
fi

editor_pane="$(wezterm cli spawn --new-window --workspace "$TITLE" --cwd "$WORKTREE_PATH" -- nvim)"
window_id="$(window_id_for_pane "$editor_pane")"

if [ -z "$window_id" ]; then
  echo "Failed to locate WezTerm window for pane $editor_pane" >&2
  exit 1
fi

wezterm cli rename-workspace --pane-id "$editor_pane" "$TITLE" >/dev/null
wezterm cli set-window-title --window-id "$window_id" "$TITLE" >/dev/null
wezterm cli set-tab-title --pane-id "$editor_pane" "Neovim" >/dev/null

wezterm cli spawn --window-id "$window_id" --cwd "$WORKTREE_PATH" >/dev/null
wezterm cli spawn --window-id "$window_id" --cwd "$WORKTREE_PATH" >/dev/null

wezterm cli activate-pane --pane-id "$editor_pane" >/dev/null
