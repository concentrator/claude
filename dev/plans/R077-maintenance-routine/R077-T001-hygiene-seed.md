---
task: R077-T001
type: feat
---

# R077-T001: seed the hygiene section on --project installs

Branch: `feat/hygiene-seed`. Requirements:
`dev/plans/R077-maintenance-routine/requirements.md`.

- [x] Seeding mechanism: the canonical "Session and planning hygiene"
  section (heading, two intro lines, the four-row targets table) lives
  as a heredoc in `install-dev.sh` following the code-size-allowlist
  idiom, and a project-scope step after the gitignore work writes
  `$target/MAINTENANCE.md` - file absent → created with the section;
  file present without the `## Session and planning hygiene` heading →
  the section appended after a blank line, prior content untouched;
  heading present → no write. `.claude/MAINTENANCE.md` joins the
  step-6 committability allowlist, the summary echo names the file
  when it seeded, and README `§ Installing the toolset elsewhere`
  lists the seeded section. `install-dev.test.sh` gains: a fresh
  target gets the file with the heading and its four targets; a
  `MAINTENANCE.md` lacking the heading is appended to with its
  existing content intact; a re-install over a locally modified
  section leaves the file byte-identical; the global fixture asserts
  no `MAINTENANCE.md` is written; the gitignore fixture covers the
  new allowlist entry; the re-run fixtures stay green (seeding is
  idempotent by the heading check).
- [x] True claim: the `MAINTENANCE.md` sentence "The Routine section
  is generic and each project's `.claude/MAINTENANCE.md` carries it"
  is reworded to name the seeding mechanism (`install-dev.sh
  --project` seeds the hygiene subset when the heading is absent; the
  project owns it afterward). Doc-only commit; the Tier-1 gate is the
  verification.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine`, `bash scripts/ci/run-all.sh` green, mark the task in
  `tasks.md`, R077 closure check per `plan.md § Approval and closure`
  (criteria verified with one-line evidence, ROADMAP `[x]`, archival
  in the closing delivery), cleanup.
