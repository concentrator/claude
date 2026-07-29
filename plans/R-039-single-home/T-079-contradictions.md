task: T-079
type: fix

# fix/contradictions - resolve the 15 audit contradictions (R-039)

T-079 of `plans/R-039-single-home/`. Each fix resolves toward the winner
named in `requirements.md § Contradictions to resolve`; numbers below
reference that list. Prose-only; the "test" per slice is a stale-token
grep plus Tier-1.

- [x] Rules + router (items 1, 2, 4): `rules/git-workflow.md` bootstrap cites `start.md`; `SKILL.md` "Planning (doc PRs)" → "plan MR/PRs" and `plan.md:114` "doc branch" → "plan branch"; `rules/js.md` picks "advisory, Tier-2-reviewed" and drops the contradicting clause.
- [x] `MAINTENANCE.md § Repair` (item 3): scope direct fixes to ungoverned files; CLAUDE.md/skills/rules changes become propose-and-await-approval, citing `claude-md.md`/`skills.md § Approval`.
- [x] Release-mark ownership (items 5, 15): `templates.md § Release plan` and `release.md` align to the R-035 rule - the `[x]` rides the closing routine's final commit; `release` verifies marks, never sets; drop the dead `release_notes_template.md` reference.
- [x] `branch-plan.md` + prefix set (items 6, 7): § Scope changes names `/dev plan <slug>` (cite `plan.md § Adjusting existing plans`); add `batch/` to the prefix list in both git-workflow copies (engine-only, no id, auto mode).
- [x] Companions facts (items 8-11): `documentation.md` reconciles DRY vs variant-split duplication in one sentence; `report-template.md` baselines → placeholders; `verification-policy.md` deletes the phantom SKILL.md-pointer claim; `spec-reviewer-prompt.md` drops the "suspiciously quickly" trigger (spec check is unconditional).
- [x] Migration prompts (items 12-14; reviewer-prompt retire gates at close): `plan-document-reviewer-prompt.md` - wire into the auto plan-review path with commit-checkbox vocabulary, or retire (user gate at close); `tbd-migration.md` - agent executes with user approval (migrate wins), `plans/tasks.md` naming, archival optionality restored; `legacy-migration.md` - § ID format pointer, REQ folds into foundational `REQUIREMENTS.md`, canonicalization via branch + MR/PR (no bootstrap exception).
- [ ] Complete the branch: re-review docs across all commits, cleanup, mark plan complete + bookkeeping marks, commit.
