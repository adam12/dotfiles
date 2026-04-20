---
name: commit
description: Create a git commit that matches the repo's existing style. Use when the user says /commit, "commit this", "make a commit", "commit the changes", or similar. Stages only files relevant to the task, splits unrelated work into separate commits, and never pushes.
---

# commit

Create a focused git commit (or commits) that match the repository's existing conventions.

## When to use

Fire on any commit-shaped request:
- `/commit`
- "commit this", "commit the changes", "make a commit", "can you commit?"
- Any natural phrasing where the user's intent is to land the current work as a git commit

Do **not** fire for questions about commits ("what did I commit last?"), for PR creation, or for pushing.

## Workflow

Run these in parallel first:
```
git status
git diff
git diff --staged
git log -n 10 --oneline
```

Use the output to answer three questions before writing anything:

1. **What's changed?** — from `status` and `diff`. Note untracked files.
2. **What style does this repo use?** — from `log`. Match subject length, prefix conventions (Conventional Commits, ticket IDs, emoji, etc.), body format. Do not impose a style the repo doesn't already use.
3. **Is this one concern or several?** — if the diff covers unrelated work, plan multiple commits.

### Staging

Stage **only** files relevant to the task being committed. Skip:
- Unrelated WIP in other files
- Editor/OS cruft (`.DS_Store`, swap files) unless intentional
- Local config drift the user didn't ask to commit

**Never** use `git add -A`, `git add .`, or `git add -u`. Always name files explicitly:
```
git add path/to/file1 path/to/file2
```

If the user has already staged something, respect that staging as their intent — don't unstage without asking.

### Splitting

If the diff mixes unrelated concerns, make multiple focused commits in sequence. For each commit: stage that concern's files, commit, then move to the next. Announce the split briefly before the first commit (e.g. "Splitting into 2 commits: auth refactor, then unrelated README fix").

### Writing the message

- Mirror the repo's existing style from `git log`.
- Focus on **why**, not what — the diff shows what.
- Subject in imperative mood if that's the repo convention.
- Pass the message via HEREDOC to preserve formatting:

```
git commit -m "$(cat <<'EOF'
Subject line

Optional body explaining why.
EOF
)"
```

### After committing

Run `git status` to confirm the tree is clean (or shows only the expected remaining unstaged changes if splitting across commits).

Do **not** push. Pushing is a separate action the user must request.

## Handling pre-commit hook failures

If a pre-commit hook fails, the commit did **not** land. Do:

1. Read the hook output. Fix the underlying issue in the code.
2. Re-stage the fixed files (`git add <files>`).
3. Create a **new** commit — do not use `--amend` (there's nothing to amend) and do not use `--no-verify` to bypass the hook.

If the hook's fix is out of scope or unclear, stop and surface the error to the user.

## Guardrails

Stop and confirm with the user before committing if any of these apply:

- **Mass-staging attempt** — if you're tempted to run `git add -A`, `git add .`, or `git add -u`, stop. Name files explicitly instead. This is a hard rule from the user's global config.
- **Large diff** — >500 changed lines or >20 changed files. Summarize what's in it and ask whether to proceed as-is or split.
- **Sensitive files in the diff** — `.env`, `.env.*`, files named `*credentials*`, `*secret*`, `*.pem`, `*.key`, `id_rsa*`, `*.p12`, or anything with obvious API-key-shaped strings. Warn before including them.
- **Lockfile-only or lockfile-dominant commit** — if the commit is just `package-lock.json` / `yarn.lock` / `Gemfile.lock` / `mix.lock` with no matching manifest change, confirm that's intentional.

## Hard rules

- Never `git add -A`, `git add .`, or `git add -u`.
- Never push.
- Never `--amend` a commit you didn't just create in this turn.
- Never `--no-verify` to skip hooks.
- Never commit files the user didn't touch in this session without flagging them first.
