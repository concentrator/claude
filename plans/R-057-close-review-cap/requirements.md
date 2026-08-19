---
approved: pending
kind: mnt
---

# R-057: Cap the close review

## Current state

Three rows of the close-review table (`branch-plan.md § Closing
routine`) route to the built-in `/code-review`, whose internal
fan-out is not configurable: the review of a small trim branch
dispatched eight verdict agents. `delegation.md § Close-review
fan-out` mandates running that fan-out as designed. The repo already
has `agents/code-reviewer.md` covering the same ground (plan
alignment, prose-diff verification gate, batch mode), but no flow
routes to it, its `model:` is `inherit`, it carries no effort key,
and nothing stops it or any subagent from spawning further agents.
The token cost is disproportionate to most branches (R-053).

## Desired state

The routed close review is the repo's `code-reviewer` agent with a
hard cap: one reviewer, plus one verifier only when the reviewer
reports a Critical finding. Built-in `/code-review` is a manual-only
escalation for genuinely hard cases: the flow may suggest it, never
run it. Subagents never invoke `/code-review` or spawn further
subagents, stated as a delegation rule loaded every session. The
agent definition pins `model: fable` and a reduced effort, and its
prompt forbids dispatching subagents. As a low-priority extension, a
targeted reviewer set exists for later routing by diff content:
security (high-tier model), maintainability/style (Haiku, strict
bounds), performance (critical loops and query logic).

## Invariants

- The `/simplify` row and the Tier-2 compliance review are untouched.
- `verification-policy.md § Models`: branch-close review runs `fable`.
- Findings are still validated against full project context before
  acting (closing routine step 2).

## Scope

`skills/dev/branch-plan.md § Closing routine`, `delegation.md`,
`skills/dev/companions/verification-policy.md § Effort mechanics`,
`agents/code-reviewer.md`, three new `agents/*-reviewer.md`
definitions.

## Acceptance criteria

- [ ] No close-review table row routes to `/code-review`; the routine
  names it only as a manual escalation the session may suggest.
- [ ] The routine states the cap: at most two agents per close review,
  the second dispatched only on a Critical finding.
- [ ] `agents/code-reviewer.md` pins `model: fable`, carries an
  effort key, and its prompt forbids spawning subagents.
- [ ] The delegation rule "subagents never invoke `/code-review` or
  spawn further subagents" is in `delegation.md`, replacing the
  close-review fan-out bullet.
- [ ] `verification-policy.md § Effort mechanics` reflects the
  frontmatter effort key instead of claiming none exists.
- [ ] Three targeted reviewer definitions (security,
  maintainability/style, performance) exist with dispatch criteria
  and model pins, routed by no flow yet.
- [ ] `bash scripts/ci/run-all.sh` green.

## Constraints

- No new gate, hook, or script; the cap is flow text plus agent
  definitions.
- The targeted reviewer set is definition-only in this initiative:
  wiring it into the routing waits for evidence from real branches,
  and the set grows per-project as recurring task shapes appear.

## Open questions

None.

## References

R-053 (proportionality: the observed failure is the eight-agent
review of a small branch); R-056 (session `effortLevel`, the other
half of review cost); `skills/dev/branch-plan.md § Closing routine`;
`delegation.md`; `agents/code-reviewer.md`.
