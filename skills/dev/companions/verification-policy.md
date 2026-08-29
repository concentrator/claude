# Verification depth policy

Companion to `SKILL.md`, consulted by the `/dev auto` controller when
deciding how much verification each commit and batch warrants. The aim
is to trim agentic verification cost without dropping below the
floor that keeps the default branch safe. Sections below define the
knobs the controller has and when to apply them.

## Effort mechanics

Effort routes per role, not per call: an agent definition's
frontmatter carries an `effort:` key beside `model:`
(`low`/`medium`/`high`/`xhigh`/`max`; `agents/code-reviewer.md` pins
`medium`), while the Agent dispatch surface still overrides `model`
only. A role whose definition pins neither inherits the session
`effortLevel`. Routing therefore encodes a model and, where a role
warrants it, an effort - the session setting is the default, not the
ceiling.

## Mechanical commits

A commit item is **mechanical** if and only if both conditions hold,
evaluated from the plan-item text alone, before dispatch:

1. **File set ≤ 2, explicitly named** - the item text names at most two
   files to touch (by path or filename). Unnamed, implied, or
   wildcard-described files do not count toward the limit and void the
   classification. Convention-mandated doc files (e.g. a per-commit
   `CHANGELOG.md` under `release-routine: yes`) are not exempt: the plan
   item must name them like any other file, and they count toward the
   ≤ 2 limit - a commit that also writes a CHANGELOG entry alongside two
   code files is not mechanical.
2. **Complete spec** - the item states a testable outcome and contains
   no unresolved design choices. A testable outcome means a reader can
   write a failing check before seeing the implementation. An unresolved
   design choice is any decision the implementer must make that the item
   text does not settle.

**Post-implementation guard:** after the implementer reports back, the
controller checks the "Files changed" line in the report. If the set of
files the implementer actually touched exceeds the files named in the
plan item, the mechanical classification is void and the spec check runs
after all - regardless of how the item read before dispatch.

## Spec-check skip

A commit classified mechanical (per the predicate above, guard not
voided) skips the per-commit spec check. Drift from the plan is caught
by the branch-close review instead.

**Recording:** for every skipped spec check the controller records a
line and carries the records verbatim into the report's Cost section:

    <commit-sha or plan-item id>: spec check skipped: mechanical

**Scope of this rule:** only the per-commit spec check is skipped.
Everything else is unchanged:

- Non-mechanical commits keep the full spec-check flow.
- The stop conditions in `skills/dev/branch-plan.md § Stop conditions` are
  untouched.
- "Spec check rejects the same commit twice → halt" still applies
  wherever a spec check runs.

**Convention drift outcome:** a spec-check report of "⚠️ Convention
drift only" is not a rejection - it never counts toward the
two-rejection halt. The controller fixes the drift directly on the
member branch and carries the count into the report's Cost section.
The spec-check sensor is blind on spec-check-skipped (mechanical)
commits, so convention drift surfaced by the branch-close or batch
review is counted in the same Cost-line total (report-template.md
§ Cost) to keep the drift picture complete.

## Close folding

A branch is **small** iff its committed plan file satisfies both conditions,
evaluated by reading the plan file at branch close - no agent judgment:

1. **≤ 3 non-final commit checkboxes** in the plan body.
2. **No `architecture-changing: true` header.**

**Consequence:** a small branch skips the per-branch `code-reviewer` pass.
Its first review is the batch full-diff review at batch close (which
re-covers most of the per-branch pass, saving the bulk of a per-branch
review's tokens per folded branch). The controller passes the list of
folded branches into the batch full-diff review dispatch; the reviewer
covers their diffs against their own plans (first review), not only
cross-branch concerns.

**Invariants** - unaffected, per `branch-plan.md § Agentic execution`:
the final commit and the green gate hold for every branch; branches
above the threshold keep the full per-branch review.

**Scope:** this rule applies to auto mode only. Manual-mode
`skills/dev/branch-plan.md § Closing routine` is unaffected.

## Verification modality

Verification follows the claim, not the artifact: an observable claim's
ground truth is a live run (`documentation.md`'s `VERIFIED`), a claim
about source is checked against source (`DOCS`). A live run does not
relax independence - whoever authored the thing does not also certify
that its run passed, and that holds beyond docs: code, plans, and
gates alike.

**A run must be able to fail.** An execution whose inputs cannot
distinguish the claimed behavior from its fallback is a demonstration,
not a verification, and it certifies nothing. Choose inputs that would
have produced a different result had the claim been wrong: a cell
claiming a cache carries certain keys is not verified by a
hand-written cache containing them, and a default-valued config proves
nothing about a row describing the default. Where the discriminating
run is impossible, say so and mark the claim from-spec rather than
running something easier and calling it verified.

**A check must count the unit it claims to check.** An exemption drawn
per file does not exempt an entry; a count taken per line does not
count occurrences; a grep that skips a file reports the same silence
as a grep that found nothing. Each of those passes its own execution
while answering a question other than the one asked, so state the unit
before trusting a green result, and prove a new check bites by making
it fail on a known instance first.

## Verifier isolation

A verifier probing repo-touching behavior (git, hooks, filesystem
mutation) works in a throwaway repo with a scrubbed git environment -
`GIT_DIR`, `GIT_WORK_TREE`, `GIT_INDEX_FILE` unset - never against the
live repo: those variables override cwd and are inherited, so a
cwd-isolated fixture is not isolated. Destructive git (`reset --hard`,
`clean`, ref deletion) is never a verifier's to run, cleanup of its
own mess included - a verifier that needs cleanup stops and reports.

## Comprehension check

Part of the readiness review (`branch-plan.md § agentic: stamp`). A
stamped plan is implemented by a cold-context agent, so test it on one:
dispatch a fresh subagent with exactly the implementer's inputs - the
commit-item text plus parent-chain context, never the plan file or the
planning conversation - and ask what it would build and what is
ambiguous or assumed. A question the inputs cannot answer is a plan
gap, not a reader fault: fix via `/dev plan <slug>` before stamping.
This catches `NEEDS_CONTEXT` halts at planning time, when the user is
present and the fix is cheap.

## Models

| Role | Model (dispatch value) |
|---|---|
| Default implementers | Opus 4.8 (`opus`) |
| Mechanical-commit implementers | Sonnet 4.6 (`sonnet`) |
| Probes (live API probing work) | Opus 4.8 (`opus`) |
| Judgment-heavy implementers | Fable 5 (`fable`) |
| Spec-compliance checks (per-commit) | Fable 5 (`fable`) |
| Branch-close review and batch full-diff review | Fable 5 (`fable`) |

Effort: a role runs at the session `effortLevel` unless its definition
pins one (§ Effort mechanics).

**Capacity fallback.** A pinned model can be rate-limited, which is not
a fact about the work. When a dispatch fails on capacity, fall back one
row - `fable` roles to `opus`, `opus` roles to `sonnet` - and record the
substitution in the batch report or branch findings: pinned model,
substitute, reason. It is a documented degrade, not a decision to
negotiate per batch, and not grounds to halt delivery.

The record states what the substitution costs, because that differs by
work. Where acceptance is independently pinned by deterministic gates,
a review only has to catch plan-versus-diff divergence and the
substitution is cheap. Where the gates cannot see the claim being made -
authored prose, a documented behaviour, anything a green suite would
pass either way - the reviewer's judgment is the whole check and the
substitution is the larger call. Do not carry a rationale from one to
the other; they are different bets.

**Routing:** the controller picks the implementer row deterministically -
mechanical predicate true → Mechanical-commit row (`sonnet`); plan item
explicitly tagged `(judgment-heavy)` → Judgment-heavy row (`fable`);
otherwise the Default implementers row (`opus`). There is no predicate
for "judgment-heavy": an item reaches that row only by carrying the
explicit `(judgment-heavy)` tag in its plan-item text, mirroring the
task `[type]` tag. Absent the tag, items default to Opus.

**Spec-check disambiguation:** per-commit spec-compliance checks
(pass/fail against the plan item) and the judgment-heavy branch-close /
batch full-diff reviews all run on `fable`. They remain distinct roles -
the per-commit spec check is the only one a mechanical commit may
skip (§ Spec-check skip); the close/batch reviews always run. Do not conflate
them.
