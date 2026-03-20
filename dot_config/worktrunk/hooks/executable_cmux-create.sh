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

extract_handle_from_output() {
  local kind="$1"
  local output="$2"

  if [ "$kind" = "surface" ]; then
    if [[ "$output" =~ (surface|tab):[A-Za-z0-9._-]+ ]]; then
      printf '%s\n' "${BASH_REMATCH[0]}"
      return 0
    fi
  elif [[ "$output" =~ ${kind}:[A-Za-z0-9._-]+ ]]; then
    printf '%s\n' "${BASH_REMATCH[0]}"
    return 0
  fi

  if [[ "$output" =~ [0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12} ]]; then
    printf '%s\n' "${BASH_REMATCH[0]}"
    return 0
  fi

  return 1
}

workspace_ref_by_title() {
  cmux_json list-workspaces | jq -r --arg title "$1" '
    [.workspaces[]? | select((.title // "") == $title) | (.workspace_ref // .workspace_id // .id)]
    | .[0] // empty
  '
}

workspace_tree_node() {
  cmux_json tree | jq -c --arg workspace_ref "$1" '
    first(
      .windows[]?.workspaces[]?
      | select((.ref // .workspace_ref // .id) == $workspace_ref)
    ) // empty
  '
}

first_pane_ref() {
  workspace_tree_node "$1" | jq -r '
    [(.panes // [])[]? | (.ref // .pane_ref // .pane_id // .id)]
    | .[0] // empty
  '
}

first_surface_ref() {
  workspace_tree_node "$1" | jq -r '
    [(.panes // [])[]?.surfaces[]? | (.ref // .surface_ref // .surface_id // .id)]
    | .[0] // empty
  '
}

rename_tab() {
  local workspace_ref="$1"
  local handle="$2"
  local title="$3"

  [ -n "$handle" ] || return 1

  if [[ "$handle" == tab:* ]]; then
    cmux rename-tab --workspace "$workspace_ref" --tab "$handle" "$title" >/dev/null 2>&1 && return 0
    cmux rename-tab --workspace "$workspace_ref" --surface "${handle/#tab:/surface:}" "$title" >/dev/null 2>&1 && return 0
    return 1
  fi

  cmux rename-tab --workspace "$workspace_ref" --surface "$handle" "$title" >/dev/null 2>&1 && return 0
  if [[ "$handle" == surface:* ]]; then
    cmux rename-tab --workspace "$workspace_ref" --tab "${handle/#surface:/tab:}" "$title" >/dev/null 2>&1 && return 0
  fi
  return 1
}

existing_workspace="$(workspace_ref_by_title "$TITLE")"
if [ -n "$existing_workspace" ]; then
  cmux select-workspace --workspace "$existing_workspace" >/dev/null
  exit 0
fi

new_workspace_output="$(cmux new-workspace --cwd "$WORKTREE_PATH" --command "nvim")"
new_workspace="$(extract_handle_from_output workspace "$new_workspace_output" || true)"
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

default_surface="$(first_surface_ref "$new_workspace")"
if [ -n "$default_surface" ]; then
  rename_tab "$new_workspace" "$default_surface" "Neovim" || true
fi

cmux new-surface --workspace "$new_workspace" --pane "$default_pane" >/dev/null
cmux new-surface --workspace "$new_workspace" --pane "$default_pane" >/dev/null

cmux select-workspace --workspace "$new_workspace" >/dev/null

if [ -n "$default_surface" ]; then
  cmux focus-panel --workspace "$new_workspace" --panel "$default_surface" >/dev/null 2>&1 || true
fi
