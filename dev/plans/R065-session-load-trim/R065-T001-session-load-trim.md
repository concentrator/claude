task: R065-T001
type: refactor

# The session-loaded prose shrinks to what every session needs

`CLAUDE.md` keeps importing `writing.md`, now the four universal
sections; the five artifact sections become the path-scoped rule
`rules/writing-artifacts.md`, shipped by the installer; `delegation.md`
and `rules/git-workflow.md` fold into one line each in `CLAUDE.md`,
with the two DEV-only pre-authorisations moving to the mode files that
run them. Every rule keeps a home that loads in every situation it
governed before (table below), and `CLAUDE.md` stays under its cap.

## Rule-to-trigger table

Each moved rule, the situations it governed, and the file that loads
it after the branch (R065 acceptance criterion 5).

| Rule | Situation governed | Loaded by |
|---|---|---|
| State the present | editing a living Markdown doc | `rules/writing-artifacts.md` (`**/*.md`); CI: `check-accretion.sh` |
| One home per finding | plan, findings, docs edits | `rules/writing-artifacts.md` |
| One home per finding | annotation or history fields in code and data files | `CLAUDE.md § Code Comments` (one clause) |
| One home per number | prose citing a measured value | `rules/writing-artifacts.md` |
| Name things by their durable id | Markdown citing work | `rules/writing-artifacts.md` |
| Name things by their durable id | commit and MR/PR text | `CLAUDE.md` (one sentence) |
| Bulk edits | multi-occurrence Markdown rewrites | `rules/writing-artifacts.md` |
| Verification-gate pre-authorisation | closing a doc in DEV | `companions/documentation.md § Verification gate` |
| Close-review pre-authorisation and its bounds (never `/code-review`, no nested subagents) | closing a branch in DEV | `branch-plan.md § Closing routine` |
| Wide-search pre-authorisation and its limit (no grep-sized fan-out) | any session | `CLAUDE.md` (one line) |
| GitHub/PR pin for this repository | git decisions here | `CLAUDE.md § Session Workflow` (one line) |

## `CLAUDE.md` changes, for approval

Added (about 50 words): the durable-id sentence, the code/data
annotation clause under § Code Comments, the wide-search line, the PR
pin; `@delegation.md` removed. Trims proposed to pay for them, applied
in the order listed until `check-caps.sh` passes:

1. § Agent toolchain: drop the batch-push carve-out line
   (`README.md § Contents` describes `.claude/settings.json`).
2. § Scope: drop the parenthetical examples down to "tests, reviews,
   tuning, hardening for a hazard that has not fired" and the "while
   I'm here" sentence.
3. § Verify before stating: fold the two sentences on sources into one
   ("confirm it against a source you can point to; otherwise verify
   or say you're unsure").

## Plan

- [x] Split `writing.md`: `rules/writing-artifacts.md` with
  `paths: ["**/*.md"]` takes the five artifact sections verbatim
  (State the present, One home per finding, One home per number,
  Name things by their durable id, Bulk edits) and a one-line intro;
  `writing.md` keeps the four universal sections and its intro
  reworded to say so. Citations repointed to
  `rules/writing-artifacts.md § <section>`:
  `companions/documentation.md` (two), `skills/dev/git-workflow.md`
  (two), `handoff.md`, `migrate.md`, `scripts/ci/check-accretion.sh`
  header.
- [ ] `CLAUDE.md` under the cap: the trims above, then the durable-id
  sentence and the annotation clause; `check-caps.sh` green.
- [ ] Fold `delegation.md`: the verification-gate pre-authorisation
  becomes a sentence in `companions/documentation.md § Verification
  gate`, the close-review one (with its no-`/code-review`,
  no-nested-subagents bound) a sentence in `branch-plan.md § Closing
  routine`; `CLAUDE.md` gets the wide-search line where
  `@delegation.md` was; `delegation.md` deleted; `DESIGN.md` tree-map
  and `README.md § Contents` row updated.
- [ ] Inline the PR pin: one line in `CLAUDE.md § Session Workflow`
  replaces `rules/git-workflow.md`, which is deleted; `DESIGN.md`
  § components `rules/` bullet and the `git-workflow.md` reference
  under § Self-hosting drop the pin; `install-dev.test.sh`'s
  not-shipped assertion targets `rules/claude-md.md`.
- [ ] Installer ships the rule: `install-dev.sh` copies
  `rules/writing-artifacts.md` into `<target>/rules/` beside step 5
  and allowlists `.claude/rules/writing-artifacts.md` in step 6;
  `install-dev.test.sh` asserts the copy and that no other rule
  ships; `README.md § Installing` and `§ Contents` (`rules/` row),
  `DESIGN.md` tree-map (`rules/` node), `MAINTENANCE.md § Tier-2`
  Writing concern name both files.
- [ ] Findings: `R065-T001-session-load-trim.findings.md` records the
  words loaded unconditionally (`CLAUDE.md` + imports) before and
  after, and the table above checked row by row.
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine` (prose and config rows: `code-reviewer`), Tier-2 compliance
  review, `bash scripts/ci/run-all.sh` green, cleanup; R065 closure
  check per `plan.md § Approval and closure` - each acceptance
  criterion verified with one-line evidence, `status: done` stamped in
  `requirements.md`, the R `[x]` in `ROADMAP.md`; mark plan complete,
  commit. Archival rides a `plan/r065-close` PR after the merge.
