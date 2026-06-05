## Shell
- The Bash tool executes under bash/zsh — use POSIX-compatible syntax (`&&`, `||`, `if … ; then … ; fi`, `command -v`). Do NOT use fish-only syntax (`; and`, `; or`, `type -q`, `if … end`).

## Working Style
- When I ask you to implement something, skip the planning/brainstorming phase and go straight to implementation unless I explicitly ask for a plan or design first. Do not enter plan mode for straightforward tasks.
- Sub-agents (code-simplifier, code-reviewer, etc.) must restrict changes to ONLY the files explicitly being worked on. Do not allow out-of-scope changes. If improvements are spotted elsewhere, list them but don't apply them.

## Git Workflow
- For PRs, show me the title and body for approval before creating.
- Confirm before destructive operations (force push, rebase, reset).
- Never use `git add -A` — manually add specific files instead.

## Code
- Test after writing. Never leave code untested.
- Prefer editing over rewriting whole files — keep diffs minimal.
- Use existing variable/method names and conventions. Don't rename things without being asked.
- Simplest working solution. No over-engineering.

## Before Declaring Done
- Run the code one final time to confirm it works.
- Never declare done without a passing test.

## Ruby
- Running tests by name must always use `-n <the name of the test>` and never the format of `test_file::TheNameOfTheTest`
- Test doubles: prefer Substitutes / Nullables over mocks & stubs. Before writing test doubles, read `~/.claude/docs/testing-with-substitutes/testing-with-substitutes.md` (pattern + runnable example files).
