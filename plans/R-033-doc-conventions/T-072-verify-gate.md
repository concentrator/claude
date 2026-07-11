task: T-072
type: feat
depends-on: T-071

# feat/verify-gate - the docs verification gate (R-033)

T-072 of `plans/R-033-doc-conventions/`. Define the independent-agent
verification gate (spec: `requirements.md § Goals`) in the framework
companion and wire it
as the docs completion gate. Settled: artifact-free (VC history is the
record, no committed stamp - R-029); reuse `dispatching-parallel-agents` for
parallel reviewers. Depends on T-071 (the framework companion).

Acceptance criteria: see `requirements.md` (gate defined - independent agent,
per-claim VERIFIED/DOCS/WRONG/UNPROVEN, no self-certify, UNPROVEN handling,
parallel split - and wired as the docs completion gate in the closing
routine, `/dev docs`, and `migrate`).

- [ ] Add the verification gate to `companions/documentation.md`: an independent agent (not the author) verifies every factual claim against ground truth (live system, else authoritative source); per-claim VERIFIED / DOCS / WRONG / UNPROVEN; WRONG corrected before done; UNPROVEN resolved or marked unverified in the doc, never asserted; large docs split across parallel reviewers (`dispatching-parallel-agents`); artifact-free - the branch/PR history is the record.
- [ ] Wire it as the docs completion gate: `branch-plan.md § Closing routine` (a doc branch runs the gate before delivery), `docs.md` (`/dev docs` runs it), and the docs-adoption companion (build/refresh completes through it).
- [ ] Complete the branch: re-review docs, cleanup, mark plan complete, commit.
