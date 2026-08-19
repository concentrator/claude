# R052-T002 findings - injection point and per-turn cost

## Measurement

User prompts per session, counted across the 65 local transcripts
(`~/.claude/projects/*/*.jsonl`, records of type `user` with string
content): median 5, p90 115, max 802. A one-line injection of ~15
tokens therefore adds ~75 tokens to the median session and ~1.7k at
p90 - well under R-050's concern threshold, and less than a single
guard-misfire turn (denial plus retry) costs.

## Decision (approved)

- **`UserPromptSubmit`.** Its stdout reaches context on every user
  prompt, so the state is fresh at exactly the moments a stale branch
  assumption produces a trunk write. `SessionStart` injects once and is
  stale after the first checkout; keeping it fresh would need a second
  refresh mechanism (a PostToolUse matcher over git commands) - more
  machinery and more per-call cost than the misfires it prevents.
- **Payload: one line, git-prompt style** - branch name plus
  working-tree counts, silent outside a git repo, fail-open on any
  error. Ambient display only, no advice text: the requirements'
  `__git_ps1` reference, and no new rule for VIBE to remember.
