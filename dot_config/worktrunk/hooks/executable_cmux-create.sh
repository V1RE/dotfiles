#!/usr/bin/env bash
set -euo pipefail

cmux ping &>/dev/null || exit 0
command -v jq >/dev/null 2>&1 || exit 0

REPO="${1:?usage: cmux-create.sh <repo> <branch> <worktree_path>}"
BRANCH="${2:?usage: cmux-create.sh <repo> <branch> <worktree_path>}"
WORKTREE_PATH="${3:?usage: cmux-create.sh <repo> <branch> <worktree_path>}"

TITLE="${REPO}/${BRANCH}"

cmux_json() {
  cmux --json "$@"
}

workspace_ref_by_title() {
  cmux_json list-workspaces | jq -r --arg title "$1" '
    [.workspaces[]? | select((.title // "") == $title) | (.workspace_ref // .workspace_id // .id)]
    | .[0] // empty
  '
}

first_pane_ref() {
  cmux_json list-panes --workspace "$1" | jq -r '
    [.panes[]? | (.pane_ref // .pane_id // .id)]
    | .[0] // empty
  '
}

first_surface_ref() {
  cmux_json list-pane-surfaces --workspace "$1" --pane "$2" | jq -r '
    [.surfaces[]? | (.surface_ref // .surface_id // .id)]
    | .[0] // empty
  '
}

created_surface_ref() {
  jq -r '
    .created_surface_ref
    // .created_tab_ref
    // .surface_ref
    // .tab_ref
    // .created_surface_id
    // .created_tab_id
    // .surface_id
    // .tab_id
    // empty
  '
}

existing_workspace="$(workspace_ref_by_title "$TITLE")"
if [ -n "$existing_workspace" ]; then
  cmux select-workspace --workspace "$existing_workspace" >/dev/null
  exit 0
fi

new_workspace="$(cmux_json new-workspace --cwd "$WORKTREE_PATH" --command "nvim" | jq -r '.workspace_ref // .workspace_id // .id // empty')"
if [ -z "$new_workspace" ]; then
  echo "Failed to parse new workspace ID" >&2
  exit 1
fi

cmux rename-workspace --workspace "$new_workspace" "$TITLE" >/dev/null

default_pane="$(first_pane_ref "$new_workspace")"
if [ -z "$default_pane" ]; then
  echo "Failed to find default pane for workspace $new_workspace" >&2
  exit 1
fi

default_surface="$(first_surface_ref "$new_workspace" "$default_pane")"
if [ -n "$default_surface" ]; then
  cmux rename-tab --workspace "$new_workspace" --surface "$default_surface" "Neovim" >/dev/null
fi

shell_surface="$(cmux_json new-surface --workspace "$new_workspace" --pane "$default_pane" | created_surface_ref)"
if [ -n "$shell_surface" ]; then
  cmux rename-tab --workspace "$new_workspace" --surface "$shell_surface" "Shell" >/dev/null
fi

dev_surface="$(cmux_json new-surface --workspace "$new_workspace" --pane "$default_pane" | created_surface_ref)"
if [ -n "$dev_surface" ]; then
  cmux rename-tab --workspace "$new_workspace" --surface "$dev_surface" "Development Server" >/dev/null
fi

cmux select-workspace --workspace "$new_workspace" >/dev/null
