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

- [ ] Write `skills/dev/secrets.md` — the convention: never commit secrets; keep tokens in a gitignored `.env`; commit `.env.example` with placeholders; verify `.env` is gitignored; the secret-pattern set; how the hook enforces + the false-positive override.
- [ ] Test-first `scripts/test/secrets-guard.test.sh`: a planted fake key is denied on `Write`/`Edit` to a tracked path and on `git add`/`git commit` of staged content; a gitignored `.env` and clean content pass; fails open on missing `jq` / malformed input. (red)
- [ ] Implement `hooks/dev-secrets-guard.sh` — PreToolUse on `Write|Edit|NotebookEdit` + `Bash`; match secret patterns (private keys, cloud keys, tokens, high-entropy `KEY=`/`SECRET=`) in tracked-path content and the staged diff; emit deny JSON naming the match + override note; fail open.
- [ ] Register the hook in this repo's `settings.json` (`Write|Edit|NotebookEdit` + `Bash` matchers), mirroring the branch-guard.
- [ ] `install-dev.sh`: copy + chmod `dev-secrets-guard.sh`; register it idempotently in the target `settings.json`.
- [ ] `install-dev.test.sh`: assert the secrets hook is copied + registered (global + project paths).
- [ ] `DESIGN.md` tree-map + § Self-enforcement: add `hooks/dev-secrets-guard.sh`; add a one-line security pointer to `CLAUDE.md` (never commit secrets → `skills/dev/secrets.md`).
- [ ] Complete the branch: re-review docs across commits, cleanup, mark plan complete, commit.
