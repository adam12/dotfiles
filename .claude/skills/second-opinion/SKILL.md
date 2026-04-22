---
description: Get second opinions from multiple AI models on the current problem
allowed-tools: Bash, Read
---

# Second Opinion Skill

Query three AI models in parallel for diverse perspectives on the current problem.

## Default models

Use these three unless they fail (current as of 2026-04-21):

- `gpt-5.4` — OpenAI's top general model
- `gpt-5.3-codex` — OpenAI's code-specialized variant
- `claude-sonnet-4.6` — different Claude family from the running Opus

If a model returns an error like "unknown model", re-discover with:

```fish
copilot help config 2>&1 | sed -n '/^  "model":/,/^$/p'
```

Then pick replacements: prefer different providers, prefer flagship over mini/haiku, and never pick an Opus variant (that's the running model).

## Steps

### 1. Write the prompt

2–4 sentences framing the current problem as a question. Include the language/framework and the specific decision point. Keep it identical across all three models for a fair comparison.

### 2. Query all three in parallel

Run the three `copilot -p` calls in a single message (parallel Bash tool calls):

```fish
copilot -p "<prompt>" --model gpt-5.4 --available-tools view,grep,glob
copilot -p "<prompt>" --model gpt-5.3-codex --available-tools view,grep,glob
copilot -p "<prompt>" --model claude-sonnet-4.6 --available-tools view,grep,glob
```

`--available-tools view,grep,glob` restricts them to read-only tools.

### 3. Present and synthesize

```
## <Model>'s take
[response]
```

Then a synthesis:
- **Agree on:** …
- **Disagree on:** …
- **Recommendation:** …

If a model fails, note it in one line and continue with the rest.
