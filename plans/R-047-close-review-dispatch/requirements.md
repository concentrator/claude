---
approved: pending
kind: doc
---

# R-047: Close-review dispatch for every task tag

## Current state

`branch-plan.md § Closing routine` step 1 routes the close review by task
tag: refactor → `/simplify`, single feature or single bugfix →
`/code-review`, mixed-purpose or >9 commits → both. The `doc`, `test`,
and `mnt` tags - valid task tags, and admitted as such by R-046 - have no
route, so closing such a branch means asking the user which review to
run.

R-046 ran five branches through this. Four carried tags with no route
and each stopped to ask; the fifth carried `refactor`, whose route
exists, and it was overridden because the branch moved prose between two
files - nothing for `/simplify` to reduce, and nine citations that could
break. Every one of the five ended in `/code-review`.

The same failure had already appeared once: the execution dispatch in
`SKILL.md` enumerated three tags and R-046 added the missing three. That
fix left the enumeration in place, which is why the close-review table
went stale the same way.

## Desired state

The close review dispatches on what the diff contains, not on the task
tag, so no tag can be unrouted:

| The diff changes | Review |
|---|---|
| code, behavior preserved | `/simplify` |
| code, behavior added or fixed | `/code-review` |
| prose, rules, docs, plans | `/code-review` |
| both code and prose | both |

## Invariants

- The size governor is unchanged: `small` = ≤9 commits, and >9 commits or
  mixed-purpose still means both reviews.
- The Tier-2 compliance review runs on every branch regardless, and its
  wording does not move.
- `/simplify` and `/code-review` keep their own scopes; this changes
  which is invoked, never what either checks.
- `branch-plan.md` stays within its 1500-word cap - 14 words of headroom
  at shaping time, so the rewrite trades words rather than adding them.

## Scope

`branch-plan.md § Closing routine` step 1. `delegation.md` names the
fan-out without the routing and `agents/code-reviewer.md` names no tags,
so both are checked and left alone unless the sweep says otherwise.

## Acceptance criteria

- [ ] `branch-plan.md § Closing routine` dispatches on diff content, with
      a route for every kind of change a branch can ship and no task tag
      named as the key.
- [ ] Walking the new table against six real branches - R-046's five and
      this initiative's own - yields exactly one route each, and the four
      that had none now resolve.
- [ ] The size governor and the Tier-2 line are word-for-word unchanged,
      shown by the diff touching neither.
- [ ] Every living doc mentioning the close-review dispatch states this
      one rule or cites it; none restates a competing mapping.
- [ ] `branch-plan.md` passes `check-caps.sh`.

## Constraints

- Rules level: carried by the closing routine, not by a mechanical gate,
  consistent with R-046's doc-sync decision.

## Non-goals

- When an independent doc verifier is required versus the close review
  (`documentation.md § Verification gate`). Adjacent and unshaped; it
  came up once in R-046 and was never settled.
- Changing what `/simplify` or `/code-review` check.
- Reopening the execution dispatch R-046 settled.

## Open questions

None.

## References

R-046 (archived) closed the execution-dispatch analogue; its branch
evidence is summarised in § Current state rather than cited from
`archive/`, per `plan.md § Archival`.
