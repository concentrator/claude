task: T-025
type: feat

# feat/writing-quality — global Writing rule + consolidation + Tier-2 gate (R-012)

T-025 of `plans/R-012-writing-quality/requirements.md`. One coherent
branch: add a global `## Writing` rule to CLAUDE.md, consolidate the
`claude-md.md`/`skills.md` anti-transplant bullets into it (no
duplication), and add a Tier-2 review gate. Not architecture-changing.

The CLAUDE.md edit is approval-gated (`rules/claude-md.md § Approval`) —
the executor shows the exact `## Writing` wording and gets explicit
approval before that commit. CLAUDE.md has ~122w free (≤400); the
principle + the one-line before/after example fit, else drop the example
(keep the principle).

- [x] Add a `## Writing` rule to `CLAUDE.md` (writing-rule family, near
      § Verify before stating / § Communication): convey the user's
      intent, not their verbatim phrasing; write in the context's
      conventional terminology; prefer established terms over coined
      jargon; applies to all output. Include a one-line before/after
      example (the Controller case). **Approval-gated** — show the
      wording, get OK before committing. Verify `wc -w` ≤ 400.
- [ ] Consolidate `rules/claude-md.md § Content`: reduce the "Operative
      instructions only … never transplant conversational wording"
      bullet to keep only "rationale belongs in requirements/DESIGN" and
      point to `CLAUDE.md § Writing` (no duplication). Verify ≤ 200 lines.
- [ ] Consolidate `rules/skills.md § Content`: same treatment on the
      matching bullet; point to `CLAUDE.md § Writing`.
- [ ] Add the Tier-2 gate to `MAINTENANCE.md § Tier-2 AI review`
      (`### Prune dead prose`): flag transplanted/verbatim phrasing and
      idiosyncratic/coined terms, proposing the conventional wording;
      cross-reference `CLAUDE.md § Writing`. Domain-neutral (no
      banned-word list).
- [ ] Complete the branch: re-review across commits, confirm
      cross-references resolve (§ Writing ↔ the two bullets ↔ the gate)
      and nothing is duplicated, `run-all` + caps green; mark the plan
      complete; stamp follows per the ledger protocol; hand off to
      `finishing-a-branch` (feat → user review + merge).
