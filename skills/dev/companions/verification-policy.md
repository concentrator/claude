# Verification depth policy

Companion to `SKILL.md`, consulted by the runner (`run.md`) when
deciding how much verification each commit and batch warrants. The aim
is to trim agentic verification cost without dropping below the
floor that keeps the default branch safe. Sections below define the
knobs the runner has and when to apply them.

## Effort mechanics

Model and effort route per seat: each definition's frontmatter carries
`model:` and, where the seat pins one, `effort:`
(`low`/`medium`/`high`/`xhigh`/`max`; `agents/code-reviewer.md` pins
`medium`), the roster being `run.md § Seats`. A dispatch overrides
`model` only, which is why the implementer's tier is the dispatch's
(§ Models) and its definition's value the default; a key a definition
omits inherits the session's - `effortLevel` the default rather than
the ceiling.

## Mechanical commits

A commit item is **mechanical** if and only if both conditions hold,
evaluated from the plan-item text alone, before dispatch:

1. **File set ≤ 2, explicitly named** - the item text names at most two
   files to touch (by path or filename). Unnamed, implied, or
   wildcard-described files do not count toward the limit and void the
   classification.
2. **Complete spec** - the item states a testable outcome and contains
   no unresolved design choices. A testable outcome means a reader can
   write a failing check before seeing the implementation. An unresolved
   design choice is any decision the implementer must make that the item
   text does not settle.

**Post-implementation guard:** after the implementer reports back, the
runner checks the "Files changed" line in the report. If the set of
files the implementer actually touched exceeds the files named in the
plan item, the mechanical classification is void and the spec check runs
after all - regardless of how the item read before dispatch.

## Spec-check skip

Two classes of commit skip the per-commit spec check: a commit
classified mechanical (per the predicate above, guard not voided), and
a commit superseded by a plan change (`run.md § Dispatch per item` 2),
whose redo the planner adds as a new checkbox, leaving the spec check
to read the fresh implementer's commit. Drift from the plan is caught
by the branch-close review instead.

**Recording:** for every skipped spec check the runner records a
line and carries the records verbatim into the report's Cost section:

    <commit-sha or plan-item id>: spec check skipped: mechanical
    <commit-sha or plan-item id>: spec check skipped: superseded by plan change

**Scope of this rule:** only the per-commit spec check is skipped.
Everything else is unchanged:

- Non-mechanical commits keep the full spec-check flow.
- The stop conditions in `skills/dev/branch-plan.md § Stop conditions` are
  untouched.
- "Spec check rejects the same commit twice → halt" still applies
  wherever a spec check runs.

**Convention drift outcome:** a spec-check report of "⚠️ Convention
drift only" is not a rejection - it never counts toward the
two-rejection halt. The runner fixes the drift directly on the
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
review's tokens per folded branch). The runner passes the list of
folded branches into the batch full-diff review dispatch; the reviewer
covers their diffs against their own plans (first review), not only
cross-branch concerns.

**Invariants** - unaffected, per `branch-plan.md § Agentic execution`:
the doc-writer pass and its gate (`run.md § Close` 3), the final commit
and the green gate hold for every branch; branches above the threshold
keep the full per-branch review.

**Scope:** this rule applies to a batch-scoped run only; a task-scoped
run closes in full (`skills/dev/branch-plan.md § Closing routine`).

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
count occurrences. Both pass their own execution
while answering a question other than the one asked, so state the unit
before trusting a green result, and prove a new check bites by making
it fail on a known instance first.

**A negative search is evidence only from an instrument whose failure
differs from its no-match.** The `grep` these sessions invoke wraps
`ugrep -I`: on a file it judges binary it prints nothing and exits 1,
byte-identical to a genuine no-match, so an empty result proves
nothing about that file. A search whose empty result is the claim
runs as `git grep`, which reports a binary match instead of hiding
it, or as `grep -a`; a recursive search over untracked paths adds
`--no-ignore-files`, since the same wrapper also skips gitignored
files and `git grep` never reads them.

## Verifier isolation

A verifier probing repo-touching behavior (git, hooks, filesystem
mutation) works in a throwaway repo with a scrubbed git environment -
`GIT_DIR`, `GIT_WORK_TREE`, `GIT_INDEX_FILE` unset - never against the
live repo: those variables override cwd and are inherited, so a
cwd-isolated fixture is not isolated. Destructive git (`reset --hard`,
`clean`, ref deletion) is never a verifier's to run, cleanup of its
own mess included - a verifier that needs cleanup stops and reports.

## Comprehension check

The dispatcher's read of the plan (`write-plan.md` step 6). Dispatch
the cold reader (`agents/dev-cold-reader.md`, the `dev-cold-reader`
type) with exactly the implementer's inputs - the plan, the docs and
the code (`companions/implementer-prompt.md`), never the planning
conversation; the two questions it answers and the gap rule are its
definition's. A gap is a planner's to fix - an acceptance gap re-runs
the read once, over the change, per `write-plan.md` step 6, which
sends what the second read still finds to the findings file; an
approach gap is fixed once and re-runs no read, the approach being the
implementer's to change in flight (`run.md § Seats`) - and the header
then records `cold-read: passed` (`branch-plan.md § Header`). This
catches `NEEDS_CONTEXT` halts before
an implementer meets them, while the fix is cheap; nothing dispatches a
plan without the record, and a plan chained on an unmerged task earns
it at its start.

## Models

A seat's model is its definition's (`run.md § Seats`); the two rules a
definition cannot hold stay here.

**Implementer tier.** The runner picks the implementer's model
deterministically - mechanical predicate true (§ Mechanical commits) →
`sonnet`; plan item explicitly tagged `(judgment-heavy)` → `fable`;
otherwise the model `agents/dev-implementer.md` pins. No predicate
infers `(judgment-heavy)`; only the tag in the plan-item text does.

**Capacity fallback.** A pinned model can be rate-limited, which is not
a fact about the work. Before dispatching a seat whose definition pins
`fable`, read the gate:
`bash ~/.claude/scripts/model-quota.sh "Fable"` (the endpoint's
display name for Fable 5) exits 0 while the weekly window has headroom,
1 at or over its ceiling, 2 when it cannot tell; dispatch `fable` on 0
only, `opus` otherwise, a missing script included - a wrong `fable`
stalls the review on a consent dialog, a wrong `opus` costs a weaker
review. A dispatch that still fails on capacity below the ceiling falls
back one row - a `fable` seat to `opus`, an `opus` seat to `sonnet`.
Either way, record the substitution in the batch report or branch
findings: pinned model, substitute, reason. It is a documented
degrade, not a decision to negotiate per batch, and not grounds to halt
delivery.

The record states what the substitution costs: cheap where
deterministic gates pin acceptance, the larger call where the
reviewer's judgment is the whole check (authored prose, documented
behaviour).
