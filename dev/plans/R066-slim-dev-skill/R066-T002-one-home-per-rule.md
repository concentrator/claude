task: R066-T002
type: refactor
depends-on: R066-T001

# Every DEV rule is stated once, and the stale and argued text goes

The eight rules the audit found stated in several files keep one home
and a `file § Section` citation everywhere else; the stale sentences
are corrected; nine rationale passages shrink to the rule and at most
one sentence of reason; `secrets.md` becomes a companion with its
pattern list citing the hook; `plan.md` cites `layout.md` for the
artifact locations, which closes R062. Branch:
`refactor/one-home-per-rule`.

## Rule-to-home table

Each rule, the phrase that identifies it, its one home, and the sites
that become citations (R066 acceptance criterion 3).

| Rule | Phrase | Home | Sites that cite |
|---|---|---|---|
| Commit caps | `past 30` | `branch-plan.md § Size cap` | `git-workflow.md § Delivery cadence` (drop the "~20 per branch, ~30 per batch" parenthetical), `branch-plan.md § Batches` (drop "~30 planned commits") |
| Branch-close verify set | `findings file triaged` | `finish.md § 1` | `supervise.md § Scope` (drop the parenthetical list), `declarations.md § Supervisor bounds` (drop the list and the "same bar" sentence) |
| Declared commands, never probe the host | `probing the host` | `declarations.md § Declared commands` | `git-workflow.md` opening (one-line pointer), `toolchain.md` opening (drop the restatement, keep the pointer) |
| The supervisor never merges | `No grant merges` | `declarations.md § Supervisor bounds` | `supervise.md` opening (cite), `supervise.md § Deliver or escalate` ("never a merge" cites), `supervisor-runbook.md` diagram (`declarations.md § Operator modes`) |
| Close folding | `≤ 3 non-final commit checkboxes` | `verification-policy.md § Close folding` | `branch-plan.md § Batches` (drop "smaller branches defer their first review to the batch-close full-diff pass") |
| Plan branch before the first write | `before the first artifact write` | `plan.md § Where plans live in git` | `brainstorm.md` step 5, `write-plan.md` steps 6 and Bulk mode, `branch-plan.md § Batches`, `supervise.md § Scope` (each keeps the act, cites the rule) |
| Layout table | `visual-artifacts` gone; `R<NNN>-<slug>/` tree | `layout.md § Artifacts layout` | `plan.md § Where things live` (table replaced by one citing sentence) |
| Secret patterns | `AKIA` | `hooks/secret-patterns.sh` | `companions/secrets.md § Patterns` (one sentence citing the hook) |

## Stale text

| Site | Change |
|---|---|
| `migrate.md § Stale root` | drop the `resolve-root.sh` clause |
| `report-template.md § Prompt friction` | section removed: nothing writes `permission_prompts.jsonl` |
| `tbd-migration.md:3` | caller is `migrate.md` (and `legacy-migration.md`) |
| `supervisor-runbook.md:70` | `declarations.md § Operator modes` |
| `verification-policy.md § Spec-check disambiguation` | "lever 1" named as the mechanical-commit spec-check skip |
| `finish.md § 3`, `plan.md § Where things live` | CI scripts named by their installed form (`start.md § 4`), one form that resolves in both trees |
| `supervise.md:3`, `:29`, `declarations.md:24`, `verification-policy.md:5`, `tbd-migration.md:37` | the rule without its initiative |

## Rationale trims

| Passage | Keeps |
|---|---|
| `verification-policy.md § Effort mechanics` | the routing rule: effort per role, from the agent definition; session setting is the default |
| `verification-policy.md § Models`, the substitution-cost and Routing paragraphs | the routing predicate and the `(judgment-heavy)` tag rule |
| `supervise.md § Question resolution` | the resolution rule and the escalation pointer |
| `supervise.md § Boundary verification` item 3 and closing paragraph | the check and one sentence on why |
| `supervise.md § Deliver or escalate` | the rule: read the declared bound, name the class |
| `branch-plan.md § Session boundary` | the rule and its table |
| `declarations.md § No grant merges` tail | the rule; one sentence on the reviewer/author split |
| `declarations.md` label-vs-committer paragraph | the audience rule, one sentence |
| `documentation.md § Verification gate` preamble bullet | the instruction: read the preamble first, check its vocabulary against the standard |
| `untracked-claude.md § Tradeoff` | one sentence |

## Commits

- [x] `plan.md § Where things live` cites `layout.md § Artifacts
  layout` in place of its table
- [x] Commit caps and the plan-branch rule each stated once
  (`branch-plan.md § Size cap`, `plan.md § Where plans live in git`);
  the six citing sites repointed
- [x] The verify set and the declared-commands rule each stated once
  (`finish.md § 1`, `declarations.md § Declared commands`); the four
  citing sites repointed
- [x] The no-merge rule and close folding each stated once
  (`declarations.md § Supervisor bounds`, `verification-policy.md
  § Close folding`); the four citing sites repointed
- [x] `secrets.md` moves to `companions/secrets.md`; `§ Patterns` cites
  `hooks/secret-patterns.sh`; `start.md § 1` and the
  `dev-secrets-guard.sh` header cite it; `DESIGN.md` tree-map follows
- [x] Stale text corrected (table above, seven rows)
- [x] Rationale trims in `verification-policy.md` and `supervise.md`
  (five passages)
- [x] Rationale trims in `branch-plan.md`, `declarations.md`,
  `documentation.md`, `untracked-claude.md` (five passages)
- [ ] `R066-T002-one-home-per-rule.findings.md`: byte sizes of the
  `/dev supervise` and `/dev code` read sets at base and close,
  `plan.md` word count, the phrase greps of the rule-to-home table, the
  `git grep` of criterion 4, the initiative-id grep of criterion 5,
  and the `§` citation check script with its output (criterion 6)
- [ ] Mark and commit the task `[x]` in `tasks.md`; R062 marked `[x]`
  superseded by R066 in `ROADMAP.md`; R066 closure check
  (`plan.md § Approval and closure`), R062's directory archiving with
  the closure plan MR/PR (`finish.md § 4`)
- [ ] Complete the branch: re-review docs across all commits, cleanup,
  mark plan complete, commit
