---
description: Create a pull request for the current branch
---

# Create Pull Request

## Context

- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline origin/main..HEAD`
- Diff stats: !`git diff --stat origin/main...HEAD`

## Your Task

Create a pull request for the current branch.

1. First, determine the correct base branch by running `git symbolic-ref refs/remotes/origin/HEAD --short` (fall back to `origin/main` if that fails)
2. Run `git diff <base>...HEAD` to review the full diff (the stats above are just a summary)
3. Review the commits and diff to understand ALL changes on this branch
4. Draft the PR title and body, then **present them to the user for approval before doing anything else**. Do NOT push or create the PR until the user approves.
   - A short, descriptive title (under 70 chars)
   - A body with a `## Summary` section containing 1-3 bullet points describing what changed and why
   - Do NOT include a test plan section
   - If the user asked for a draft, mention you'll use `--draft`
   - If you know the Github issue number this resolves, use 'Closes #NNN' at bottom of body
   - *Never* reference Github issue number in title
5. After user approves: push the branch if not already pushed (`git push -u origin HEAD`), then create the PR using `gh pr create` with a HEREDOC for the body. Include `--draft` if requested.
6. Output the PR URL when done
