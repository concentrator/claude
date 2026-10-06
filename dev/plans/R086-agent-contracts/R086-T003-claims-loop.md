---
task: R086-T003
type: feat
architecture-changing: true
depends-on: R086-T002
mode: strict
cold-read: passed
---

- [x] A plan ends on `## Claims`, a `- Item <n> (source|probe|drop): <claim>`
  line per claim its docs make or drop, and `## Proven`, each statement already
  proven with its evidence; the report repeats each claim under `## Claims`, a
  blank `Source:` below, or `Call:`, `Output:`, `Environment:` for a probe, and
  the plan-text gate fails an added claim it lacks. Approach: the gate, its test;
  new `documentation.md § Claims`, `branch-plan.md § Body`, `dev-planner.md`.
- [x] The implementer fills its item's entries in the commit marking it `[x]`;
  the plan-text gate fails a done item's entry with an empty field, an
  `Output:` value counting when its lines sit indented under it.
  Approach: the gate and its test, then `documentation.md § Claims` and
  `agents/dev-implementer.md § Steps`.
- [x] The implementer probes read-only or on a test client, never a `## Proven`
  statement; an item with a probe claim runs probe, failing test, a second
  probe confirming the values the test pins, then code; `CLAUDE.md § Scope`
  counts a probe claim as a request to probe a remote. Approach: `feat.md
  § Pass`, `fix.md § Pass` citing it, `agents/dev-implementer.md § Steps`,
  `CLAUDE.md § Scope`.
- [x] The close review is the spec review: the code reviewer checks each
  report entry against its plan claim - present, of its kind, confirming the
  claim - and reports a gap as Critical; a branch with a probe claim never
  folds, so its spec review runs before the docs and the docs gate.
  Approach: `agents/code-reviewer.md`, then `verification-policy.md § Close
  folding` (a third condition), `run.md § Close` 1.
- [x] The doc writer's inputs are the plan, its report and the docs: it writes
  each claim, removes each `drop` claim's text and probes nothing; a claim
  ends in a link to its source or test, or to a `<docs>/reports/` report it
  copies from the probe entry and that is never archived. A plan without
  `## Claims` keeps the diff input. Approach: `documentation.md § Sources`,
  `§ Diataxis typing`, `agents/dev-doc-writer.md`, `run.md § Close` 3.
- [x] The docs verifier works from the plan and its report: check 1 takes each
  claim the plan lists against its entry and the doc's link, reading the
  linked file and probing nothing, so its definition drops the probing
  paragraph and the Write, WebFetch and WebSearch tools.
  Approach: `documentation.md § Verification gate`, then
  `agents/dev-docs-verifier.md`.
- [x] A doc explains an existing piece of the app's code or the part of an
  external system the app uses, a `§ Parameters` row per input that code
  takes or sends; the doc writer runs when the plan lists a claim, or, for a
  plan without `## Claims`, as today. Adoption grades docs against source,
  probing nothing. Approach: `layout.md § Docs`, `documentation.md § Detail
  bar`, `run.md § Seats` and `§ Close` 3, `docs-adoption.md § Audit`.
- [x] `DESIGN.md § Git & delivery model` says a plan lists the claims its docs
  make, the implementer records each claim's evidence in the task report,
  and the doc writer and verifier work from those two, so an external
  system's claim is probed in the task that relies on it.
  Approach: one paragraph after that section's seats paragraph.
- [ ] Complete the branch: cleanup (stale/temp data), mark plan complete,
  mark the task `[x]` in the R's `tasks.md` plus any release-plan entry,
  commit, the resolved task report included. (Batch members: the task
  mark rides the batch branch.)
