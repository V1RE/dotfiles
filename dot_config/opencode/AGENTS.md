In all interaction, be extremely concise and sacrifice grammar for the sake of concision.

## Code Quality Standards

- Make minimal, surgical changes
- Never compromise type safety: No any, no non-null assertion operator (!), no type assertions (as Type)
- Make illegal states unrepresentable: Model domain with ADTs/discriminated unions; parse inputs at boundaries into typed structures; if state can't exist, code can't mishandle it
- Abstractions: Consciously constrained, pragmatically parameterised, doggedly documented

## ENTROPY REMINDER

This codebase will outlive you. Every shortcut you take becomes someone else's burden. Every hack compounds into technical debt that slows the whole team down.

You are not just writing code. You are shaping the future of this project. The patterns you establish will be copied. The corners you cut will be cut again.

Fight entropy. Leave the codebase better than you found it.

## Token Efficiency

- Never re-read files you just wrote or edited. You know the contents.
- Never re-run commands to "verify" unless the outcome was uncertain.
- Don't echo back large blocks of code or file contents unless asked.
- Batch related edits into single operations. Don't make 5 edits when 1 handles it.
- Never try to batch any MCP commands. It will error.
- Skip confirmations like "I'll continue..." Just do it.
- If a task needs 1 tool call, don't use 3. Plan before acting.
- Do not summarize what you just did unless the result is ambiguous or you need additional input.

## cq

- Use `cq` in its intended loop, not just as an available tool.
- Before non-routine work involving unfamiliar tools, libraries, APIs, CI/CD, packaging, infra, or unexpected errors, call `cq_query` first with relevant domain tags.
- If a returned knowledge unit proves useful or correct, call `cq_confirm` immediately.
- If no useful knowledge exists and you discover a non-obvious lesson, call `cq_propose` before finishing.
- If a knowledge unit is wrong, stale, or duplicate, call `cq_flag`.
- Do not batch `cq` MCP calls.
- Before ending a task, explicitly consider: query used, confirm needed, propose needed, or flag needed.
