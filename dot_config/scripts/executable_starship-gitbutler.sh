#!/usr/bin/env bash
set -euo pipefail

# Fail silently if but or jq not available
command -v but >/dev/null 2>&1 || exit 1
command -v jq >/dev/null 2>&1 || exit 1

json=$(but branch list -j --no-check 2>/dev/null) || exit 1

# Parse applied stacks from JSON
# Schema: { appliedStacks: [{ id, heads: [{ name, commitsAhead }] }] }
# - Heads within a stack joined with " -> " (stacked branches)
# - Separate stacks joined with ", " (parallel branches)
echo "$json" | jq -r '
  .appliedStacks | map(
    .heads | map(
      .name + (
        if (.commitsAhead // 0) > 0 then " \u2191" + (.commitsAhead | tostring)
        else ""
        end
      )
    ) | join(" \u2192 ")
  ) | join(", ")
'
