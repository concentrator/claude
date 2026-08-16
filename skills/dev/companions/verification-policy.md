# Verification depth policy

Companion to `SKILL.md`, consulted by the `/dev auto` controller when
deciding how much verification each commit and batch warrants. The aim
is to trim agentic verification cost (R-005) without dropping below the
floor that keeps the default branch safe. Sections below define the
knobs the controller has and when to apply them.

## Effort mechanics

Reasoning effort is **session-level only; per-dispatch routing degrades
to model choice.** No surface in this repo exposes a per-subagent effort
field: an agent definition's frontmatter carries `model:` (and `name:`,
`description:`) but no effort key, and the Task/Agent dispatch surface
exposes a `model` override (`sonnet`/`opus`/`haiku`/`fable`) with no
effort parameter. Effort is fixed for the whole session by the
`effortLevel` setting; the high-effort intent for Opus implementers is
met when the session runs at `high` or above - below that, routing
degrades to model choice only. So when the controller wants a cheaper or deeper
check for a given dispatch, the only lever it actually controls is which
model that subagent runs - routing encodes a model per role and inherits
the session effort.

Evidence:

- `agents/code-reviewer.md` frontmatter - keys present: `name`,
  `description`, `model` (value `inherit`). No effort key.
- `settings.json` - `effortLevel: "high"`: a top-level session/global
  setting, not scoped to any dispatch.
- `implementer-prompt.md` - the Task-tool
  dispatch template passes `description` and `prompt` only; no effort
  field. The Agent tool's sole per-dispatch override is `model`.

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

Effort: every role runs at the session `effortLevel` (§ Effort mechanics).

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
the per-commit spec check is the only one lever 1 may skip on a
mechanical commit; the close/batch reviews always run. Do not conflate
them.
