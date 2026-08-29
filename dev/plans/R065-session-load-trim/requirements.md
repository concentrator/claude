---
approved: 2026-08-29
kind: refactor
---

# R065: Trim the session-loaded prose

## Current state

`CLAUDE.md` (392 words, cap 400) `@import`s `writing.md` (637 words)
and `delegation.md` (149 words), so both load in every session of
every project, VIBE included; `rules/git-workflow.md` (90 words) loads
in this repository as well. Most of that prose binds only DEV
artifacts:

- `writing.md`: five of its nine sections - State the present, One
  home per finding, One home per number, Name things by their durable
  id, Bulk edits - govern plans, docs, findings and commit text. The
  other four (Convey intent, No em dashes, Write like a human, No
  repetition) apply to any prose.
- `delegation.md`: two of its three pre-authorisations - the
  documentation verification gate and the capped close review - are
  DEV mechanics already described by `companions/documentation.md`
  and `branch-plan.md § Closing routine`; only the wide-search case
  is universal.
- `rules/git-workflow.md` carries one fact, the GitHub/PR pin for this
  repository, wrapped in a pointer back to `CLAUDE.md`.

Six skill and script files cite `writing.md § <section>` for the
artifact sections, and `install-dev.sh` ships `writing.md` (with the
`@writing.md` import) but never `rules/`, so an adopter today gets the
artifact rules only through that import.

## Desired state

- `writing.md` keeps the four universal sections; `CLAUDE.md` keeps
  its `@writing.md` import.
- The five artifact sections move verbatim to `rules/writing-artifacts.md`
  with `paths: ["**/*.md"]`, so they load when Markdown is read or
  edited. The one clause a path rule cannot trigger - durable ids in
  commit text - stays as a single sentence in `CLAUDE.md`.
- `delegation.md` is deleted: the wide-search pre-authorisation becomes
  one line in `CLAUDE.md`; the verification-gate and close-review
  pre-authorisations move into the DEV skill file that owns each
  mechanic, and `verification-policy.md § Verifier isolation` keeps
  bounding verifier conduct.
- `rules/git-workflow.md` is deleted; the PR pin becomes one line in
  `CLAUDE.md § Session Workflow`.
- `install-dev.sh` copies `rules/writing-artifacts.md` into the target
  `.claude/rules/`, so adopters keep every artifact rule and the skill
  citations resolve for them.
- Every citation of a moved section (State the present and the
  others, in skills and script headers) points at
  `rules/writing-artifacts.md § <section>`.
- `CLAUDE.md`'s cap is 100 lines (`scripts/ci/check-caps.sh`); the
  400-word cap is retired. `CLAUDE.md § Code Comments` states that a
  comment explains what the code cannot show, and the supervisor
  declarations take their declared two-line form.

## Invariants

- Behaviour is preserved: every situation a moved rule governed
  before still loads that rule after - Markdown edits through the
  path rule, commit text and subagent dispatch through `CLAUDE.md`,
  DEV mechanics through the mode file that runs them. A situation no
  path rule covers (a history field in a code or data file, under
  One home per finding) keeps its sentence in `CLAUDE.md` rather than
  losing it.
- No rule is lost or duplicated: each moved sentence has exactly one
  home (`rules/claude-md.md § No duplication`).
- `CLAUDE.md` stays within its cap (`scripts/ci/check-caps.sh`).
- The em-dash gate and the accretion check keep citing the section
  that owns their rule.
- The personal rules (`claude-md.md`, `js.md`, `skills.md`) stay
  unshipped.

## Scope

`CLAUDE.md`, `writing.md`, `delegation.md` (deleted),
`rules/git-workflow.md` (deleted), `rules/writing-artifacts.md` (new);
`scripts/install-dev.sh`, `scripts/test/install-dev.test.sh`,
`README.md § Contents` and `§ Installing`, `DESIGN.md` tree-map,
`MAINTENANCE.md § Tier-2` Writing concern; the citing files
(`skills/dev/companions/documentation.md`, `skills/dev/git-workflow.md`,
`skills/dev/handoff.md`, `skills/dev/migrate.md`,
`scripts/ci/check-accretion.sh`); the DEV files that take the two
pre-authorisations (`companions/documentation.md`,
`branch-plan.md § Closing routine`).

## Acceptance criteria

- [ ] `writing.md` has exactly the four universal sections and
  `rules/writing-artifacts.md` (`paths: ["**/*.md"]`) exactly the
  five artifact sections; `git grep 'writing.md § '` outside
  `dev/plans/archive/` names only surviving `writing.md` sections.
- [ ] `delegation.md` and `rules/git-workflow.md` do not exist and no
  tracked file outside `dev/plans/archive/` cites either; `CLAUDE.md`
  states the commit-text durable-id sentence, the wide-search
  pre-authorisation and the PR pin, each once.
- [ ] `install-dev.sh --project` places `.claude/rules/writing-artifacts.md`
  and nothing else under `rules/`; `install-dev.test.sh` asserts both.
- [ ] The branch plan carries a rule-to-trigger table - each moved rule,
  the situations it governed, the file that loads it afterwards - and
  every row resolves to a loading file; no row reads "not loaded".
- [ ] No file loaded unconditionally in every session (`CLAUDE.md`
  and its imports) carries a rule that binds only DEV artifacts; the
  before/after word counts of that set are recorded in the task's
  findings.
- [ ] Tier-1 gate green (`bash scripts/ci/run-all.sh`, caps included).

## Constraints

- One `refactor/` branch; sections move verbatim and keep their
  meaning; rewording is out of scope (`rules/writing-artifacts.md
  § State the present` applies to the moved text as it stands).
- Changes to `CLAUDE.md` and `rules/` are approved by this initiative;
  the branch plan lists the exact `CLAUDE.md` trims for approval.

## Open questions

None.

## References

- R-050 (context budget) - the closed initiative that bounded the
  working window; this one trims the unconditional load.
- R062 - headroom in `plan.md`, the same cap pressure on the DEV side.
- `rules/claude-md.md` - the CLAUDE.md content and size limits.
