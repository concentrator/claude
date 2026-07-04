# TBD migration report

For an already-DEV, pre-TBD project — invoked from `SKILL.md` when
`.claude/plans/ROADMAP.md` is present. Produce a report over the three
areas below. **Advisory throughout:** the skill plans and reports; the
user executes every irreversible / host step (branch deletes,
protection, file moves). Never rewrite `main` history — migrate forward.

## 1. Delivery

Scan recent `main` history for the pre-TBD delivery pattern:

- **Local merges** — `git log --merges --first-parent -30`: a commit
  like `Merge branch '<x>' into '<default>'` is a *local* merge; an
  MR/PR merge instead reads `Merge pull request #N` (GitHub) / `See merge
  request !N` (GitLab).
- **Direct-to-`main`** — `git log --no-merges --first-parent -30`:
  non-scaffold commits made straight on the default branch.

Report the pattern found. Go-forward rule: every change reaches `main`
through a short-lived branch + CI-gated MR/PR — never a local merge or a
direct commit (`git-workflow.md § Trunk`). Enable the host MR/PR gate
(protected branch + required checks, via `gh`/`glab`; `§ Enforcement`).
History is migrated forward, never rewritten.

## 2. Structure

Diff tracked `.claude/` against `skills/dev/layout.md`:

- **Non-canonical files** — e.g. a `source-spec.md` inside an R-dir.
  Recommend moving spec/input material to `references/` (its canonical
  home); the user may instead keep it in place as a recorded exception.
- **Missing expected files** — e.g. `MAINTENANCE.md`.
- **Strays** — tracked files outside the canonical layout.
- **Flat `TASKS.md`** — a pre-R-014 single `plans/TASKS.md` task index.
  Recommend splitting it into per-R `tasks.md` (each task moved to its
  owning `R-XXX-<slug>/tasks.md`, status preserved), then removing the
  flat file; T-ids stay global.

Propose the moves; the user executes them — delivered as one coherent MR/PR
(not one per file), per `git-workflow.md § Delivery cadence`.

## 3. Close/release

- **Closes** — task / batch / R-closure bookkeeping rides PRs going
  forward (`branch-plan.md`, `finish`), not direct commits
  to `main`.
- **Releases** — convert to tag-on-trunk: no fork-release-branch; tag
  `main` at the release commit (`git-workflow.md § Releases —
  tag-on-trunk`; the `release` skill). Flag any fork-release leftovers.
- **Archive** — move superseded release plans to `plans/archive/`
  (`plan.md § Archival`).
