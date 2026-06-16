# Git workflow

## Trunk

- `main` is the single trunk: protected and always releasable. No other
  long-lived branches.
- Every change reaches `main` through a short-lived branch and a
  **CI-gated PR**. Never push to `main`; never merge to `main` locally.
- Branch name `<prefix>/<slug>`, prefix ∈ {feat, fix, refactor, release,
  chore, plan}, slug ≤ 20 chars. `plan/` is for planning/doc branches
  (initiative create/close, plan edits); the others match the task type.
- Branches are short-lived and single-owner: merge within a day, two
  days absolute max; keep ≤ 3 active. PR review and merge stay the
  user's call.

## Coherent delivery

Every PR leaves `main` releasable (builds, checks pass, nothing
half-wired). Keep incomplete work coherent without a long-lived branch:

- **Feature flag** — land dormant code, switch on when complete.
- **Branch by abstraction** — migrate behind an abstraction, drop the
  old path last.
- **Small batches** — each PR is one increment, shippable as-is.

The delivery unit — one or more coupled tasks shipped as one PR — is the
**batch** (`branch-plan.md § Agentic execution`).

## Commit messages

Single-line, ~50 chars / 6-8 words, subject only. No semicolons joining
clauses, no body, no multi-line descriptions, no Co-Authored-By tags.
Convey the WHAT, not the HOW or rationale.

Examples:
- GOOD: `Fix period chrome over logo`
- GOOD: `Collapse multi-xxl into multi with dense modifier`
- BAD: `Fix period chrome shadowing the logo; anchor via .container::before`
- BAD: `Add slide--st03-multi--dense modifier toggled by tenant count for 9+ tenants`

## MR / PR messages

Unlike commits, an MR carries a body. **Title**: commit-subject style
(imperative, ~50 chars, WHAT not how). **Body**: a short summary (what
changed and why — prose or bullets) and a test plan (what was run, or
how to verify). Scannable, not a wall of text.

- No agent attribution, "Generated with…", or Co-Authored-By trailers.
- Per `CLAUDE.md § Audience visibility`: no gitignored paths, internal
  ticket IDs, or references to the working conversation. Link issues
  only if the reader can open them.

## Releases — tag-on-trunk

`main` is always releasable; a release tags `main` at the release commit
with an annotated semver tag (`git tag -a vX.Y.Z -m "X.Y.Z"`), pushed
explicitly (`git push origin vX.Y.Z`). No release branch — fixes roll
forward on `main`.

## Enforcement

`main` protection is enforced by the host (require PR, require passing
status checks, require up-to-date branch, restrict direct push) plus
CI; a local pre-push hook gives fast feedback but is advisory and
bypassable — never the gate. Host-specific setup lives with the
project's CI infra.

## Anti-patterns

No code freezes; no "unmerge" to back out not-ready work; no fixing on a
release branch then down-merging; no big-bang merges; integrate at least
daily.
