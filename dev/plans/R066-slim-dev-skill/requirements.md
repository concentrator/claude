---
approved: 2026-08-29
kind: refactor
---

# R066: Slim the DEV skill

## Current state

`skills/dev/` is 43 files: 35 Markdown files (154 KB) and 8 scripts
and templates (29 KB). Nothing loads at session start; cost is per
command. `/dev supervise` reads `supervise.md`,
`companions/supervisor-runbook.md`, `companions/verification-policy.md`
and `companions/declarations.md` (36 KB); `/dev code` reads
`branch-plan.md`, `git-workflow.md` and `finish.md` (21 KB). Four kinds
of weight:

- **A foreign companion.** `companions/visual-companion.md` plus
  `companions/scripts/` (38 KB, a fifth of the skill) is reached only
  from `brainstorm.md:16`, has never produced a
  `dev/plans/visual-artifacts/` in this repository, and is written for
  other harnesses (Codex and Gemini CLI sections at
  `visual-companion.md:55-67`, `CODEX_CI` in `start-server.sh`,
  Unsplash at `:252`). `install-dev.sh` ships it to every adopter by
  copying the tree; `scripts/ci/code-size-allow.txt:5` exempts its
  `server.cjs`. `layout.md:80` calls `dev/plans/visual-artifacts/`
  gitignored; `gitignore.template` never ignores it.
- **Measurements inside procedure.** `supervisor-runbook.md § Remote
  Control` (170-197) and `§ Failure modes` (212-243) record pilot
  observations - `pkill -f resmon.sh`, ssh exit 255 (already in
  `R040-T010-worker-host.findings.md`), the usage-reset timezone -
  where the reader expects steps.
- **Rules stated more than once**
  (`rules/writing-artifacts.md § One home per number`):

  | Rule | Stated in | One home |
  |---|---|---|
  | Commit caps 20/30 | `git-workflow.md:97`, `branch-plan.md:137`, `:195` | `branch-plan.md` |
  | Branch-close verify set | `finish.md:8-13`, `supervise.md:70-73`, `declarations.md:41-44` | `finish.md` |
  | Declared commands, never probe the host | `git-workflow.md:9-12`, `declarations.md:8-17`, `toolchain.md:3-9` | `declarations.md` |
  | The supervisor never merges | `supervise.md:5-8`, `:155`, `declarations.md:51`, `supervisor-runbook.md:3-5` | `declarations.md` |
  | Close folding | `verification-policy.md:76-95`, `branch-plan.md:204-206` | `verification-policy.md` |
  | Plan branch before the first write | `brainstorm.md:20`, `write-plan.md:48`, `:61`, `branch-plan.md:189`, `supervise.md:17` | `plan.md` |
  | Layout table | `layout.md:34-48`, `plan.md § Where things live` | `layout.md` |
  | Secret patterns | `secrets.md:27-36`, `hooks/secret-patterns.sh` | the hook |

- **Stale text and explanation.** `migrate.md:38-43` describes
  `resolve-root.sh`, removed by R064; `report-template.md:66` reads a
  `permission_prompts.jsonl` nothing writes; `secrets.md` documents the
  `dev-secrets-guard` hook (its allow marker, its limits) from the
  skill's top level with no inbound reference but the `DESIGN.md`
  tree-map; `tbd-migration.md:3` names `SKILL.md` as its caller
  (callers: `migrate.md:24`, `legacy-migration.md:5`);
  `supervisor-runbook.md:70` cites `§ Operator modes`, which is in
  `declarations.md`; `verification-policy.md:187` cites an undefined
  "lever 1"; `finish.md:40` and `plan.md:97` cite `scripts/ci/`, which
  adopters have at `.claude/scripts/ci/` (`start.md:48`); five
  sentences attribute a rule to the initiative that introduced it
  (`supervise.md:3`, `:29`, `declarations.md:24`,
  `verification-policy.md:5`, `tbd-migration.md:37`). Nine passages
  (about 900 words) argue for a rule the reader has already been given:
  `verification-policy.md` 9-18 and 167-189; `supervise.md` 108-115,
  123-128, 140-153; `branch-plan.md` 142-144; `declarations.md` 53-56,
  84-89; `documentation.md` 115-122; `untracked-claude.md § Tradeoff`.

`plan.md` sits at the 1500-word reference cap (R062): the layout table
it duplicates is the room the next rule needs.

## Desired state

- `skills/dev/` carries no visual companion: `visual-companion.md`,
  `companions/scripts/`, the `brainstorm.md` offer, the `layout.md`
  `visual-artifacts/` entry and the `code-size-allow.txt` line are
  gone.
- `supervisor-runbook.md` is procedure only. Each measurement it drops
  has one home: an existing R-040 findings file where it is already
  recorded, the open task's findings file otherwise, or
  `skills/worker-host` where it is an operating instruction.
- Every rule in the table is stated in its one home; every other site
  cites it as `file § Section`.
- The stale sentences are corrected or removed; the two `scripts/ci/`
  citations resolve in both trees; the five attributions state the
  rule without its origin.
- Each listed rationale passage is reduced to its rule and at most one
  sentence of reason; the removed argument lives in the commit that
  removed it.
- `secrets.md` moves to `companions/secrets.md`, cited from `start.md`
  beside the `.env.example` scaffold and from the
  `dev-secrets-guard.sh` header; its pattern list is one sentence
  citing `hooks/secret-patterns.sh`; the rule, the allow marker and
  `§ Limits` stay as written.
- `plan.md` cites `layout.md` for the artifact locations instead of
  repeating them, which closes R062.

## Invariants

- No rule is lost: every deleted sentence that binds behaviour keeps
  exactly one home, and the branch plan carries a rule-to-home table
  (the R065-T001 form) whose every row resolves.
- Every `/dev` command reads the same mode files; `SKILL.md`'s
  command tables change only where a pointer moves.
- Unchanged rules keep their wording; a trim removes argument, never
  the rule or an example a criterion cites.
- Id-format examples and template placeholders (`R001`, `R008-T001`)
  stay.
- `install-dev.sh --project` installs a working toolset:
  `scripts/test/install-dev.test.sh` green.
- The supervisor declarations stay in `CLAUDE.md § Agent toolchain`;
  their relocation is R-040's backlog line.
- No new gate.

## Scope

`skills/dev/`: `brainstorm.md`, `branch-plan.md`, `finish.md`,
`git-workflow.md`, `layout.md`, `migrate.md`, `plan.md`, `secrets.md`
(moved), `start.md`, `supervise.md`, `write-plan.md`;
`companions/`: `declarations.md`, `documentation.md`,
`gitignore.template`, `report-template.md`, `secrets.md` (new home),
`supervisor-runbook.md`, `tbd-migration.md`, `toolchain.md`,
`untracked-claude.md`, `verification-policy.md`,
`visual-companion.md` (deleted), `scripts/` (deleted). Outside the
skill: `DESIGN.md` tree-map, `README.md` if it names a moved file,
`scripts/ci/code-size-allow.txt`, `scripts/test/install-dev.test.sh`,
`hooks/dev-secrets-guard.sh` header, R-040 findings files that receive
a measurement, `skills/worker-host/` if one is operative,
`dev/plans/ROADMAP.md` (R062 entry).

## Acceptance criteria

- [ ] `git grep -l 'visual-companion\|companions/scripts\|visual-artifacts\|server.cjs'`
  outside `dev/plans/archive/` and the R066 plan directory returns
  nothing, and an
  `install-dev.sh --project` target has no `companions/scripts/`.
- [ ] `supervisor-runbook.md` is under the 1500-word reference cap and
  has no `§ Remote Control` or `§ Failure modes` measurement; the
  branch plan's relocation table names the receiving file per moved
  finding, and each resolves.
- [ ] For each row of the rules table, the branch plan names a
  distinguishing phrase; `git grep` for it under `skills/dev/` hits
  the one home, and every other hit is a `§` citation of that home.
- [ ] `git grep -n 'resolve-root\|permission_prompts\|lever 1\|invoked from .SKILL.md\|§ Operator modes'`
  under `skills/`, `hooks/`, `scripts/` hits only `declarations.md`'s
  own heading; `finish.md` and `plan.md` name the CI scripts in a form
  that resolves from both `~/.claude/` and an adopter's `.claude/`.
- [ ] `grep -nE 'R-?0[0-9]{2}' skills/dev` hits only id-format examples
  and template placeholders; no sentence names an initiative as a
  rule's origin.
- [ ] Every `file § Section` citation inside `skills/dev/` resolves to
  a heading in the named file (checked by a one-off script recorded in
  the task's findings).
- [ ] `companions/secrets.md` exists with at least two inbound
  citations outside `DESIGN.md`; the pattern list appears once, in
  `hooks/secret-patterns.sh`; `skills/dev/secrets.md` does not exist.
- [ ] `plan.md` has headroom under 1500 words; the R062 ROADMAP entry
  reads superseded by this initiative.
- [ ] Before/after byte sizes of every file in the `/dev supervise` and
  `/dev code` read sets are recorded in the task findings.
- [ ] Tier-1 gate green (`bash scripts/ci/run-all.sh`) and
  `bash scripts/test/install-dev.test.sh` green; `DESIGN.md` tree-map
  names no removed file.

## Constraints

- Two `refactor/` branches, one per task; each branch plan carries its
  rule-to-home or relocation table for approval before the first
  commit.
- Trims keep meaning; no rule is reworded beyond removing argument
  (`rules/writing-artifacts.md § State the present`, `§ Bulk edits`:
  one anchor per edit).
- Skill files change only under this approval
  (`rules/skills.md § Approval`).

## Open questions

None.

## References

- R-039 (single-home the /dev system) - the prior dedupe round; this
  one takes what accreted since.
- R-050, R065 - the context-budget line: R-050 bounded the window,
  R065 trimmed the session load, this trims the per-command load.
- R062 - superseded by this initiative.
- R-040 - owns the findings the runbook measurements return to, and
  the declaration relocation backlog line.
