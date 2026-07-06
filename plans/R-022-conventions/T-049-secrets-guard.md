task: T-049
type: feat

# feat/secrets-guard — secrets gatekeeper (R-022)

T-049 of `plans/R-022-conventions/`. A secrets convention companion + a
PreToolUse hook that blocks secret material from entering tracked files or
commits. Ships to adopters via `install-dev.sh`. Local gitignored `.env`
use is unaffected — the guard targets tracked content + staged commits.
Doc homing: `skills/dev/secrets.md` companion (shipped); the hook is the
enforcement (no always-on rule).

Acceptance criteria: see `requirements.md` (secrets doc ships; hook denies
write/commit of secrets, permits gitignored `.env` + clean content, fails
open; installer ships hook + registration; test coverage).

- [x] Write `skills/dev/secrets.md` — the convention: never commit secrets; keep tokens in a gitignored `.env`; commit `.env.example` with placeholders; verify `.env` is gitignored; the secret-pattern set; how the hook enforces + the false-positive override.
- [x] Test-first `scripts/test/secrets-guard.test.sh`: a planted fake key is denied on `Write`/`Edit` to a tracked path and on `git add`/`git commit` of staged content; a gitignored `.env` and clean content pass; fails open on missing `jq` / malformed input. (red)
- [x] Implement `hooks/dev-secrets-guard.sh` — PreToolUse on `Write|Edit|NotebookEdit` + `Bash`; match secret patterns (private keys, cloud keys, tokens, high-entropy `KEY=`/`SECRET=`) in tracked-path content and the staged diff; emit deny JSON naming the match + override note; fail open.
- [x] Register the hook in this repo's `settings.json` (`Write|Edit|NotebookEdit` + `Bash` matchers), mirroring the branch-guard.
- [x] `install-dev.sh`: copy + chmod `dev-secrets-guard.sh`; register it idempotently in the target `settings.json`.
- [x] `install-dev.test.sh`: assert the secrets hook is copied + registered (global + project paths).
- [x] `DESIGN.md` tree-map + § Self-enforcement: add `hooks/dev-secrets-guard.sh`. CLAUDE.md pointer skipped by decision (the hook enforces + `skills/dev/secrets.md` documents; per `claude-md.md` earn-its-place, and the AC allows "at most").
- [x] Close-review hardening, tests first: expand `secrets-guard.test.sh` for the bypasses/gaps (C1 `commit -am`, C2 compound `add && commit`, H1 `github_pat_`, M2 spaced assignment, L4 commit-message, missing-jq fail-open) — red.
- [x] Harden `dev-secrets-guard.sh` — green: `-a`-aware commit scan + independent add/commit scans + scan the command string (C1/C2/L4); add `github_pat_` + widen generic separator to `{1,10}` (H1/M2); untracked add-scan limited to regular non-symlink files, size-capped (H2); path falls back to `notebook_path` (L3).
- [ ] Document accepted detection boundaries in `skills/dev/secrets.md`: override is unauthenticated (M1), arbitrary base64/high-entropy blobs and multi-line/split secrets are out of scope (M3/M4), commit-message scan is best-effort (L4).
- [ ] Reconcile `DESIGN.md § Self-enforcement` "adopter infra is a later initiative" caveat (findings L2); clear the findings file.
- [ ] Complete the branch: re-review docs across commits, cleanup, mark plan complete, commit.
