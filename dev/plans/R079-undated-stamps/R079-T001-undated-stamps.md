---
task: R079-T001
type: mnt
---

# R079-T001: retire the stamp dates

Branch: `mnt/undated-stamps`. Requirements:
`dev/plans/R079-undated-stamps/requirements.md`.

- [ ] Dateless stamps in the rules: `branch-plan.md § Header` example
  and `§ Stamps` definitions drop `YYYY-MM-DD`; `plan.md § Approval
  and closure` states the dateless form and loses the sentence
  defending the date; `auto.md` and `supervise.md` wording checked
  against the dateless form (already presence-only, adjust only if a
  date surfaces).
- [ ] Migrate the live stamp:
  `dev/plans/R-042-planning-pocs/R042-T001-spike-provision.md` carries
  the R's only dated `agentic:` stamp; its header reads
  `agentic: approved`.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine`, `bash scripts/ci/run-all.sh` green, mark the task in
  `tasks.md`, R079 closure check per `plan.md § Approval and closure`
  when this closes the R's last open task (criteria verified with
  one-line evidence, ROADMAP `[x]`, archival in the closing delivery),
  cleanup.
