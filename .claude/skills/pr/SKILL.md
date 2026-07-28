---
description: Create a pull request for the current branch
---

# Create Pull Request

## Context

- Current branch: !`git branch --show-current`
- Base branch: !`git symbolic-ref -q --short refs/remotes/origin/HEAD 2>/dev/null || git rev-parse -q --verify --abbrev-ref origin/main 2>/dev/null || echo origin/master`
- Recent commits: !`git log --oneline $(git symbolic-ref -q --short refs/remotes/origin/HEAD 2>/dev/null || git rev-parse -q --verify --abbrev-ref origin/main 2>/dev/null || echo origin/master)..HEAD 2>/dev/null || echo "(could not determine base branch)"`
- Diff stats: !`git diff --stat $(git symbolic-ref -q --short refs/remotes/origin/HEAD 2>/dev/null || git rev-parse -q --verify --abbrev-ref origin/main 2>/dev/null || echo origin/master)...HEAD 2>/dev/null || echo "(could not determine base branch)"`

## Your Task

Create a pull request for the current branch.

1. Use the base branch from the Context above. If it could not be determined, run `git symbolic-ref -q --short refs/remotes/origin/HEAD`, falling back to whichever of `origin/main` or `origin/master` exists
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
