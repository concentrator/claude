task: T-018
type: refactor
depends-on: T-016

# refactor/skills-to-tbd — align DEV skills to the trunk-based model (R-006)

T-018 of `plans/R-006-config-hardening/requirements.md`. T-016 merged the
trunk/PR/batch-as-universal-delivery-unit model into `git-workflow.md`,
`planning.md § Where plans live in git`, and `branch-plan.md § Agentic
execution`. This task aligns the DEV **skills** to that already-defined
rule model — skills reference the rules, never restate them.

Not architecture-changing: re-aligns skill prose to merged rules; DESIGN
enforcement architecture is T-019.

Decision carried from `/dev plan all` review: companion files
(`toolchain.md`, `report-template.md`) keep their MR/PR duality
intentionally (global rules must not hardcode a host) — out of scope
here.

Word caps are the green gate: `dev` ≤ 300w body (R-006 criterion),
`delegating-to-agents` ≤ 400w (at cap — net out), others per
`rules/skills.md`.

- [x] `dev/SKILL.md`: rewrite the opener to describe DEV accurately
      first ("DEV mode — strict, spec-driven; manual + auto"); keep the
      VIBE default as a trailing clause, not the opening subject.
      Touches: skills/dev/SKILL.md.
- [ ] `dev/SKILL.md`: drop the `## Branching` section (duplicates
      `rules/git-workflow.md`); leave only a pointer if one isn't already
      present elsewhere in the file. Touches: skills/dev/SKILL.md.
- [ ] `dev/SKILL.md`: merge the `R` / `R-XXX` plan-target rows into one
      initiative-shaping step (one act, still separate commits per
      artifact); make `/dev code` prose batch-aware (lone task ships as
      its own PR; coupled tasks group into a batch). Verify body `wc -w`
      ≤ 300. Touches: skills/dev/SKILL.md.
- [ ] `finishing-a-branch/SKILL.md`: replace the "merge to local main"
      option with mode-aware CI-gated-PR-to-origin delivery (§2 options,
      §3 execute); reference `rules/git-workflow.md`. Options narrow to
      three (Push+PR / Keep / Discard). Touches:
      skills/finishing-a-branch/SKILL.md.
- [ ] `finishing-a-branch/SKILL.md`: align §4 post-merge bookkeeping to
      PR-merge (defer `[x]` until the PR merges); drop the "commit plan
      updates to the default branch (allowed exception)" framing that
      implies a direct push. Verify body ≤ 300w. Touches:
      skills/finishing-a-branch/SKILL.md.
- [ ] `release/SKILL.md`: convert to tag-on-trunk — remove the
      `release/vX.Y.Z` fork branch + push/PR/merge hand-off; finalize
      CHANGELOG via a short-lived doc PR to origin, then tag `main`
      (`git tag -a vX.Y.Z -m "X.Y.Z"` + `git push origin vX.Y.Z`).
      Reference `rules/git-workflow.md § Releases — tag-on-trunk`. Verify
      ≤ 300w. Touches: skills/release/SKILL.md.
- [ ] `delegating-to-agents/SKILL.md`: align checkpoint-accept wording to
      "push `batch/B-XXX` + open CI-gated PR to origin/main", consistent
      with `branch-plan.md § Agentic execution` (PR is the one delivery,
      never a push to `main`); net words out to stay ≤ 400w. Verify `wc
      -w`. Touches: skills/delegating-to-agents/SKILL.md.
- [ ] `writing-plans/SKILL.md`: reword "commit to `main`" (step 6, bulk
      review pass) to "deliver via a short-lived doc PR to origin per
      `rules/planning.md § Where plans live in git`." Touches:
      skills/writing-plans/SKILL.md.
- [ ] `starting-a-project/SKILL.md` + `migrating-to-dev/SKILL.md`: align
      git/delivery references to TBD (CI-gated PR gate, drop GitLab-only
      hardcoding); preserve the scaffold/bootstrap exception. Verify both
      bodies within cap. Touches: skills/starting-a-project/SKILL.md,
      skills/migrating-to-dev/SKILL.md.
- [ ] Complete the branch: re-review docs across all commits, run the
      green check (every touched SKILL.md `wc -w` within cap; grep sweep
      confirms no git-policy rule duplicated in skills), triage the
      findings file, mark the plan complete, commit; hand off to
      `finishing-a-branch`.
