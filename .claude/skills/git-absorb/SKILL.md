---
name: git-absorb
description: Use when the user has adjustments (small fixes, typos, review feedback, follow-up tweaks) that belong in prior commits rather than as a new commit. Runs `git absorb --and-rebase` to automatically fold staged changes into their appropriate commits. Never use on main/master.
---

# git absorb

Use `git absorb --and-rebase` to automatically fold staged changes into the appropriate prior commits instead of creating a new commit.

## When to use

Trigger when the user has made adjustments after-the-fact that aren't suitable for a new commit:
- Typo fixes in code from an earlier commit on the branch
- Small corrections after review feedback
- Follow-up tweaks that logically belong to an existing commit
- Any "this should have been in the original commit" situation

## How to use

1. Verify the current branch is **not** `main` or `master`:
   ```
   git rev-parse --abbrev-ref HEAD
   ```
2. Stage the specific changes to absorb:
   ```
   git add <files>
   ```
3. Run:
   ```
   git absorb --and-rebase
   ```

Always use the `--and-rebase` flag — it automatically runs the rebase after identifying the target commits.

## Hard rules

- **Never run on `main` or `master`.** Only use on feature branches.
- If the current branch is `main`/`master`, stop and tell the user. Do not proceed.
- If `git absorb` can't identify a target commit for some staged changes, surface that to the user rather than guessing.
