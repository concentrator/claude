# TBD migration report

For an already-DEV, pre-TBD project — invoked from `SKILL.md` when
`.claude/plans/ROADMAP.md` is present. Produce a report over the three
areas below. **Advisory throughout:** the skill plans and reports; the
user executes every irreversible / host step (branch deletes,
protection, file moves). Never rewrite `main` history — migrate forward.

## 1. Delivery

Scan recent `main` history for the pre-TBD delivery pattern:

- **Local merges** — `git log --merges --first-parent -30`: a commit
  like `Merge branch '<x>' into '<default>'` is a *local* merge; a PR
  merge instead reads `Merge pull request #N` (GitHub) / `See merge
  request !N` (GitLab).
- **Direct-to-`main`** — `git log --no-merges --first-parent -30`:
  non-scaffold commits made straight on the default branch.

Report the pattern found. Go-forward rule: every change reaches `main`
through a short-lived branch + CI-gated PR — never a local merge or a
direct commit (`git-workflow.md § Trunk`). Enable the host PR gate
(protected branch + required checks, via `gh`/`glab`; `§ Enforcement`).
History is migrated forward, never rewritten.
