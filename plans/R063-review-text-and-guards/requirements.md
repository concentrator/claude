---
approved: 2026-08-28
kind: fix
---

# R063: Tier-2 review text and guard fail-closed

Shaped from the findings the fp-remedy R001 close reviews raised
against this repository's review checklist and hook guards.

## Current state

`MAINTENANCE.md § Tier-2 AI review` binds dead prose under Cleanup
while the three-gate test that defines it hangs off Compliance in
`### Prune dead prose`, a subsection after all six bullets, so which
concern owns dead prose is unstated and the gates are easy to miss on
a cold read. The maximal reading of "never restated" (any echo of a
rule's text is a restatement) is ruled but written nowhere the review
is defined. `skills/dev/layout.md` says the file is "seeded from
template", but no script or skill copies it: each project's Tier-2
section is hand-written, and fp-remedy's copy carries eight further
defects of its own wording (an uncheckable "a `feat` or `fix` commit
carries its test", a Doc-sync row 1 that reads a correctly unchanged
target as a miss, a Compliance bullet that counts the plan's own final
unchecked box, rows 2 and 6 and a lead-in sentence restating rules
owned elsewhere).

`scripts/install-dev.sh` registers the project-tier `PreToolUse`
guards by the relative path `.claude/hooks/<name>.sh`; a hook command
runs in the session's current working directory, so after any `cd`
both guards fail with "not found" and the call proceeds unguarded.
`hooks/dev-secrets-guard.sh` sources `secret-patterns.sh` with
`|| exit 0`, so a missing library also passes the call. Neither path
reports its own absence. The relative prefix is installed in every
project-scope install; on this machine fp-remedy, `wallarm_pure/skills`
and `wallarm_pure/sessions-api`.

## Desired state

The review section owns dead prose in one concern with its three gates
beside the bullet, states the maximal reading of "never restated", and
`layout.md` no longer claims a seeding that does not happen. The
installer registers project-tier hooks as
`"$CLAUDE_PROJECT_DIR"/.claude/hooks/<name>.sh`, the documented idiom
(code.claude.com/docs/en/hooks.md), so the guards run from any working
directory; the secrets guard fails closed, with one stderr line, when
its library is missing. fp-remedy alone is re-installed; the other two
projects are left as they are by the user's ruling. fp-remedy's own
review text is fp-remedy's task (its `dev/plans/R002-reduce/tasks.md`
draft).

## Invariants

- The review section keeps its six concerns and the Tier-1 gates pass.
- A guard never blocks a call for a reason it does not print.

## Scope

- `MAINTENANCE.md § Tier-2 AI review`; `skills/dev/layout.md` line 17.
- `scripts/install-dev.sh`, `scripts/test/install-dev.test.sh`;
  `hooks/dev-secrets-guard.sh`, `scripts/test/secrets-guard.test.sh`.
- Re-install into fp-remedy (its `.claude/settings.json` and hook
  copies), delivered by an fp-remedy MR.
- `skills/dev/finish.md § 3`, `skills/dev/SKILL.md` router,
  `README.md`: the Ship delivery routine and `/dev ship`.

## Acceptance criteria

- [x] Dead prose has one owning concern, its three gates beside the
  bullet; `### Prune dead prose` is gone as a separate subsection.
- [x] The section states that any echo of a rule's text is a
  restatement and a concern cites the rule's owner instead.
- [x] `layout.md` states how `MAINTENANCE.md` comes to exist, or drops
  the claim.
- [ ] A project-scope install writes `"$CLAUDE_PROJECT_DIR"/.claude/hooks/<name>.sh`
  for every registered hook (`install-dev.test.sh` asserts it); the
  global path is unchanged.
- [ ] A missing `secret-patterns.sh` denies the call with one stderr
  line (`secrets-guard.test.sh` asserts it); a missing `jq` still fails
  open, and the guard's header names the one closed path.
- [ ] fp-remedy's `.claude/settings.json` carries the new paths and its
  hook copies match `hooks/`.
- [x] `finish.md § 3 Ship` states gate, push, MR/PR, poll to green,
  merge approval (skipped for `plan/`), merge and post-merge in one
  place; `/dev ship` is a router row reading it.

## References

- fp-remedy `dev/plans/archive/R001-foundations/` findings of T002,
  T003 and T008.
