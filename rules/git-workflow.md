# Git workflow

**Terminology** - a change request is a **PR** on GitHub, an **MR** on
GitLab; before git init, default to PR. One term per repo (this repo:
GitHub → PR). Host-neutral docs reused across repos (skills, shared
rules) write the dual form **MR/PR**; the agent resolves it to the active
repo's term per its host.

## Trunk

- `main` is the single trunk: protected and always releasable. No other
  long-lived branches.
- Every change reaches `main` through a short-lived branch and a
  **CI-gated PR**. Never push to `main`; never merge to `main` locally.
- **Bootstrap exception:** the single initial commit that *creates* `main`
  in a new repo, before protection is set, is the one permitted direct
  commit (`starting-a-project`); every commit after it goes via a branch +
  CI-gated PR.
- Branch name `<prefix>/<slug>`, kebab-case, slug ≤ 20 chars. Prefix ∈
  {feat, fix, refactor, release, doc, test, mnt, plan}:
  - `feat` / `fix` / `refactor` / `release` - code, matching the change
    type.
  - `doc` - documentation and operative prose (README, CHANGELOG,
    comments, `rules/`, `skills/`, `CLAUDE.md`); not planning artifacts.
  - `test` - test additions or changes (automated or manual harness).
  - `mnt` - repo maintenance (CI, scripts, hooks, settings, dependencies).
  - `plan` - planning artifacts (ROADMAP, requirements, tasks, branch
    plans). Does not apply when `.claude/` is gitignored - the artifacts
    never enter git, so plan edits happen in the working tree, no branch
    (DEV `companions/untracked-claude.md`).
- Slug: code / `doc` / `test` / `mnt` branches carry no id (it lives in
  the plan file + PR); `plan/` branches reference the initiative -
  `plan/r<NNN>-<action>` (R-id, full three digits: `r014`, never `r12`;
  action e.g. `open` / `tasks` / `close`). A task's branch-plan uses the
  task id: `plan/t<NNN>-plan`. Multiple initiatives list ids:
  `plan/r014-r015-tasks`.
- Branches are short-lived and single-owner: merge within a day, two
  days absolute max; keep ≤ 3 active.
- **Merge policy.** Only `plan/` PRs (planning artifacts) auto-merge;
  every other prefix - `feat`/`fix`/`refactor`/`release`/`doc`/`test`/
  `mnt` - keeps review and merge as the user's call. Auto-merge runs on a
  green gate: native host auto-merge where available
  (`gh pr merge --auto`, GitLab merge-when-pipeline-succeeds); where the
  host can't gate (no branch protection), the operator merges once the
  required checks pass.

## Coherent delivery

Every PR leaves `main` releasable (builds, checks pass, nothing
half-wired). Keep incomplete work coherent without a long-lived branch:

- **Feature flag** - land dormant code, switch on when complete.
- **Branch by abstraction** - migrate behind an abstraction, drop the
  old path last.
- **Small batches** - each PR is one increment, shippable as-is.

The delivery unit - one or more coupled tasks shipped as one PR - is the
**batch** - the DEV delivery grouping.

## Delivery cadence

One branch = one coherent unit of work (a topic or work-session), never
one atomic edit. Don't open or merge a PR per change.

VIBE: apply the change, then wait - no reflexive branch → PR → merge.
Related edits accumulate on the working branch; deliver (open the PR +
merge) at a work boundary - when the user moves to unrelated work or says
to wrap up - confirming the merge first. An edit unrelated to the current
branch's topic → flag it and ask whether to deliver the current branch
before starting fresh.

DEV inherits the principle: a branch carries its task/batch, and delivery
timing follows the DEV branch-plan and branch-close routine.
Always within the short-lived / ≤ 3 active / merge-within-a-day bounds
above.

**Size is governed by this time bound, not a commit count.**
The DEV branch/batch caps (~20 per branch, ~30 per batch) are subordinate
proxies - the hard limit is merging within the short-lived window with no
big-bang merge (§ Anti-patterns).

## Commit messages

Single-line, ~50 chars / 6-8 words, subject only. No semicolons joining
clauses, no body, no multi-line descriptions, no Co-Authored-By tags.
Convey the WHAT, not the HOW or rationale.

Examples:
- GOOD: `Fix period chrome over logo`
- GOOD: `Collapse multi-xxl into multi with dense modifier`
- BAD: `Fix period chrome shadowing the logo; anchor via .container::before`
- BAD: `Add slide--st03-multi--dense modifier toggled by tenant count for 9+ tenants`

## PR messages

**Title** - commit-subject style (imperative, ~50 chars, WHAT not how).
**Body** - a short summary (what changed + why) + a test plan: the
checks that matter to verify (manual / non-obvious), not a paste of CI
output; the standard pipeline (tests + lint) is one line - CI reports the
detail. Scannable, not a wall of text.

- No agent attribution, "Generated with…", or Co-Authored-By trailers.
- Audience visibility (`CLAUDE.md`): no gitignored paths, internal ticket
  IDs, or conversation references; link issues only if openable.

## Releases - tag-on-trunk

`main` is always releasable; a release tags `main` at the release commit
with an annotated semver tag (`git tag -a vX.Y.Z -m "X.Y.Z"`), pushed
explicitly (`git push origin vX.Y.Z`). No release branch - fixes roll
forward on `main`.

## Enforcement

`main` protection is enforced by the host (require PR, require passing
status checks, require up-to-date branch, restrict direct push) plus
CI; a local pre-push hook gives fast feedback but is advisory and
bypassable - never the gate. Host-specific setup lives with the
project's CI infra.

## Anti-patterns

No code freezes; no "unmerge" to back out not-ready work; no fixing on a
release branch then down-merging; no big-bang merges; integrate at least
daily.
