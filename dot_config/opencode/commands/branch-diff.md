---
description: Compare current branch against upstream default
model: github-copilot/claude-haiku-4.5
---

Figure out the correct base ref, then review the full branch diff without changing anything.

Run, in order:

```bash
git remote -v
```

If `upstream` exists, use its default branch. Otherwise use `origin`.

```bash
DEFAULT_BRANCH=$(gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name')
BASE_REF="origin/$DEFAULT_BRANCH"
```

If `upstream` exists:

```bash
DEFAULT_BRANCH=$(gh repo view $(git remote get-url upstream) --json defaultBranchRef --jq '.defaultBranchRef.name')
BASE_REF="upstream/$DEFAULT_BRANCH"
```

Then run:

```bash
git fetch ${BASE_REF%%/*}
git log --oneline $BASE_REF...HEAD
git diff $BASE_REF...HEAD --stat
git diff $BASE_REF...HEAD -U20 -- ':!*.lock' ':!package-lock.json' ':!pnpm-lock.yaml'
```

Summarize:

- what changed
- risky areas
- files worth extra review
- likely missing tests or validation

Do not edit files or run mutating git commands.
