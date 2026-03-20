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

extract_handle() {
  local kind="$1"

  python3 - "$kind" <<'PY'
import json
import re
import sys

kind = sys.argv[1]
text = sys.stdin.read().strip()

if not text:
    raise SystemExit(0)

aliases = {
    "surface": ("surface", "tab"),
}
kinds = aliases.get(kind, (kind,))

if text[:1] in "[{":
    try:
        payload = json.loads(text)
    except json.JSONDecodeError:
        payload = None
    if isinstance(payload, dict):
        for candidate in kinds:
            for key in (
                f"created_{candidate}_ref",
                f"{candidate}_ref",
                f"created_{candidate}_id",
                f"{candidate}_id",
            ):
                value = payload.get(key)
                if isinstance(value, str) and value.strip():
                    print(value.strip())
                    raise SystemExit(0)
        value = payload.get("id")
        if isinstance(value, str) and value.strip():
            print(value.strip())
            raise SystemExit(0)

for candidate in kinds:
    match = re.search(rf"\b{re.escape(candidate)}:[A-Za-z0-9._-]+\b", text)
    if match:
        print(match.group(0))
        raise SystemExit(0)

match = re.search(r"\b[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}\b", text)
if match:
    print(match.group(0))
PY
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

new_workspace="$(cmux_json new-workspace --cwd "$WORKTREE_PATH" --command "nvim" | extract_handle workspace)"
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
  rename_tab "$new_workspace" "$default_surface" "Neovim" || true
fi

shell_surface="$(cmux_json new-surface --workspace "$new_workspace" --pane "$default_pane" | extract_handle surface)"
:

dev_surface="$(cmux_json new-surface --workspace "$new_workspace" --pane "$default_pane" | extract_handle surface)"
:

cmux select-workspace --workspace "$new_workspace" >/dev/null

if [ -n "$default_surface" ]; then
  cmux focus-panel --workspace "$new_workspace" --panel "$default_surface" >/dev/null 2>&1 || true
fi
