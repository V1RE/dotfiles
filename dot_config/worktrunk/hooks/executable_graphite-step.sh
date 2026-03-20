#!/usr/bin/env bash
set -euo pipefail

command -v git >/dev/null 2>&1 || {
  printf 'git is required for Graphite aliases\n' >&2
  exit 1
}

command -v gt >/dev/null 2>&1 || {
  printf 'gt is required for Graphite aliases\n' >&2
  exit 1
}

git_common_dir="$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null || true)"
[ -n "$git_common_dir" ] || {
  printf 'Not in a git repository\n' >&2
  exit 1
}

[ -f "$git_common_dir/.graphite_repo_config" ] || {
  printf 'Current repository is not configured for Graphite\n' >&2
  exit 1
}

exec gt "$@"
