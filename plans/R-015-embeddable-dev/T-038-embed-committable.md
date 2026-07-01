task: T-038
type: fix
depends-on: T-031

# fix/embed-committable — vendored output is trackable (R-015)

T-038 of `plans/R-015-embeddable-dev/requirements.md` (AC1). An adopter's
restrictive `.claude/*` gitignore allowlist excludes the vendored
`skills/`/`scripts/`/`CLAUDE.md`/stamp, so they are untracked and a fresh
clone lacks them. The vendor must make its output committable.

**Fix:** after vendoring, for each vendored `.claude/` path that
`git check-ignore` flags in the target repo, append an allowlist negation
to the target's **root `.gitignore`** — `!.claude/rules/`,
`!.claude/skills/`, `!.claude/scripts/`, `!.claude/CLAUDE.md`,
`!.claude/.dev-toolchain.json`. Only for currently-ignored paths;
idempotent (skip if already allowlisted) so `--update` stays clean. (Git
permits re-inclusion because `.claude` itself isn't excluded — only its
contents by `.claude/*`.)

- [x] Reproduce + fix (TDD): test vendors into a git fixture whose
  `.gitignore` is `.claude/*` (like the skills repo) and asserts no
  vendored path is `git check-ignore`d after vendoring (red); implement
  the vendor to append the needed `!` allowlist entries (green). Verify
  `vendor-toolchain.test` + `bash scripts/ci/run-all.sh`. (closes the
  T-031 test gap: committability was never checked)
- [x] Complete the branch: re-review, confirm the gate green, triage the
  findings file, mark the plan complete, commit.
