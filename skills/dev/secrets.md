# Secrets

Never commit secrets. This convention, plus the `dev-secrets-guard` hook,
keeps credentials out of tracked files and out of history.

## The rule

- Keep tokens, keys, and passwords in a local `.env` - never in a tracked
  file.
- `.env` must be gitignored; commit a `.env.example` with placeholder
  values instead.
- Never hardcode credentials in source, and never print them in logs or
  error messages.

## What the hook blocks

`dev-secrets-guard` is a PreToolUse hook. It denies:

- a `Write` / `Edit` / `NotebookEdit` that puts secret-shaped content into a
  tracked path, and
- a `git add` / `git commit` whose content carries secret-shaped strings.

A local, gitignored `.env` is never flagged - the guard only inspects
tracked paths and staged content. The hook fails open: on any internal
error it allows the action rather than blocking legitimate work.

### Patterns

- PEM private keys (`-----BEGIN ... PRIVATE KEY-----`)
- AWS access key ids (`AKIA` followed by 16 uppercase/digit chars)
- GitHub tokens (`ghp_` / `gho_` / `ghs_` / `ghr_` + 36 chars; and
  `github_pat_` fine-grained)
- Slack tokens (`xox[baprs]-...`)
- Google API keys (`AIza` followed by 35 chars)
- Generic high-entropy assignments: a `key` / `secret` / `token` /
  `password` name set to a 16+ character value

This set is a baseline; extend it in the hook as new formats appear.

## False positives

Content that matches but is genuinely not a live secret (an example, a test
fixture, documentation) can be allowed with an inline marker on the same
line:

    example_key = "AKIA................"   # secrets-guard: allow

Use it sparingly, only for content that is provably not a real credential.

## Limits

The hook is a pre-emptive guard, not a complete scanner. Known boundaries:

- The `secrets-guard: allow` marker is unauthenticated - anyone can add it,
  so use it only for content that is provably not a live credential.
- Arbitrary high-entropy or base64 blobs with no recognized prefix and no
  `secret` / `token` / `key` name are not detected; name your secret fields.
- A secret split across an existing file and an edit's new value is not seen
  in isolation; the git commit scan is the backstop.
- The commit-message scan is best-effort (a substring check on the command).

For defence in depth, pair this with a CI secrets scan over the full diff.
