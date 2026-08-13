---
approved: pending
kind: doc
---

# R-047: Branch-close routing

## Current state

Closing a branch still requires improvisation at four points, each
observed repeatedly while executing R-046 - this initiative is the final
round over that theme, not another partial pass.

- `branch-plan.md § Closing routine` step 1 routes the close review by
  task tag: refactor → `/simplify`, single feature or single bugfix →
  `/code-review`, mixed-purpose or >9 commits → both. The `doc`, `test`,
  and `mnt` tags have no route. R-046 ran five branches through it: four
  had no route and stopped to ask; the fifth carried `refactor`, whose
  route exists, and was overridden because the branch moved prose - the
  risk was broken citations, not code to simplify. All five ended in
  `/code-review`. The execution dispatch failed the same way earlier and
  R-046 fixed it by extending the enumeration, which is why this table
  went stale the same way.
- `documentation.md § Verification gate` requires an independent
  verifier for every touched doc and never says when the close review
  satisfies it. The question was asked once and improvised four times.
- `finish.md § 2` defines the verify step for data tasks only ("always
  offer a live run"); every other branch class improvises what
  verification means.
- `toolchain.md`'s header scopes § Push to checkpoint **accept** while
  `finish.md § 3` pushes outside any batch - flagged by a close review
  in R-046, ruled pre-existing, and never routed anywhere.
- `delegation.md § Close-review fan-out` says "run them as written",
  implying the tag mapping this initiative replaces.

## Desired state

- The close review dispatches on what the diff contains, not the task
  tag, so no tag can be unrouted:

  | The diff changes | Review |
  |---|---|
  | code, behavior preserved | `/simplify` |
  | code, behavior added or fixed | `/code-review` |
  | prose, rules, docs, plans | `/code-review` |
  | both code and prose | both |

- The verification gate states what clears it: for rules, skills, and
  planning prose, an independent close review - a non-author agent
  checking the changed claims against their sources - satisfies the
  gate; `docs/` feature docs keep the dedicated per-claim pass with
  VERIFIED/DOCS verdicts.
- `finish.md § 2` defines the verify step per diff content: code → run
  it; rules or process prose → dry-run the rule against a real case;
  tests → the suite run is the verification; data → unchanged.
- `toolchain.md`'s scoping sentence and `finish.md § 3` read without
  contradiction: the batch-accept restriction binds the auto-mode
  engine, and manual `finish` pushes its own branch.
- `delegation.md`'s fan-out clause cites the content-keyed rule.

## Invariants

- The size governor is unchanged: `small` = ≤9 commits, and >9 commits
  or mixed-purpose still means both reviews.
- The Tier-2 compliance review runs on every branch regardless, and its
  wording does not move.
- `/simplify` and `/code-review` keep their own scopes; this changes
  which is invoked and what clears the gate, never what either checks.
- `docs/` feature docs keep the per-claim verdict pass - the gate
  relaxes only for prose whose review already checks claims.
- `branch-plan.md` stays within its 1500-word cap (14 words of headroom
  at shaping time).

## Scope

`branch-plan.md § Closing routine` step 1, `documentation.md
§ Verification gate`, `finish.md § 2`, `companions/toolchain.md`'s
header, `delegation.md § Close-review fan-out`, and the sweep for any
other doc restating the dispatch. `delegation.md` loads every session,
so its edit is proposed before writing even though no rule file governs
it by name.

## Acceptance criteria

- [ ] `branch-plan.md § Closing routine` dispatches on diff content,
      with a route for every kind of change a branch can ship and no
      task tag named as the key.
- [ ] Walking the new table against six real branches - R-046's five
      and this initiative's own - yields exactly one route each, and
      the four that had none now resolve.
- [ ] `documentation.md § Verification gate` names what clears it for
      each prose class; the practice R-046's branches ran - an
      independent close review checking claims against sources - reads
      as satisfying it for rules and planning prose, and `docs/` docs
      still require the per-claim verdicts.
- [ ] `finish.md § 2` names a verify action for code, prose, test, and
      data diffs; no branch class is left to improvise.
- [ ] `toolchain.md`'s push-scoping sentence and `finish.md § 3` are
      both true at once, each naming whom its restriction binds.
- [ ] Every living doc mentioning the close-review dispatch states the
      content rule or cites it; none restates a competing mapping -
      `delegation.md § Close-review fan-out` included.
- [ ] The size governor and the Tier-2 line are word-for-word
      unchanged, shown by the diff touching neither.
- [ ] `branch-plan.md` passes `check-caps.sh`.

## Constraints

- Rules level: carried by the closing routine, not by a mechanical
  gate, consistent with R-046's doc-sync decision.

## Non-goals

- Changing what `/simplify` or `/code-review` check.
- Reopening the execution dispatch R-046 settled.
- Merge policy: which branches auto-merge stays as written.

## Open questions

None.

## References

R-046 (archived) closed the execution-dispatch analogue and produced
the branch evidence summarised in § Current state - summarised rather
than cited from `archive/`, per `plan.md § Archival`.
