task: T-021
type: feat

# feat/protected-trunk — establish protected trunk + PR gate in starting-a-project (R-009)

T-021 of `plans/R-009-adopter-tbd/requirements.md`. After scaffolding,
`starting-a-project` establishes `main` as the protected trunk and instructs
the PR gate (host-neutral), so a new project is TBD-shaped from commit one.
The scaffold/bootstrap exception (initial commits to the default branch) is
preserved — protection is established after those land. SKILL.md is at 285w
(cap 300), so the addition is netted by trimming prose fat.

- [ ] Add the protected-trunk + PR-gate step at the end of `§ 4 Quality
      infrastructure` (the gate's required checks depend on the CI defined
      there): name the concept (protected branch + required PR + status
      checks), point to `gh`/`glab`, reference `git-workflow.md § Trunk`/
      `§ Enforcement`; preserve the scaffold exception. Trim prose to keep
      the body ≤ 300w (`wc -w`). Touches: starting-a-project/SKILL.md.
- [ ] Complete the branch: re-review, confirm `wc -w` ≤ 300,
      `bash scripts/ci/run-all.sh` green, mark plan complete, commit.
