---
task: R084-T002
type: mnt
architecture-changing: true
mode: normal
---

- [x] A project's declarations sit in its own instructions, the root
  `CLAUDE.md` or `.claude/CLAUDE.md`, each key once; the global
  instructions hold none, and every script and hook reads both files,
  the first line found. Prose naming the root file as the home follows.
  Approach: `companions/declarations.md` intro, then `plan.md § Where
  things live`, the Docs input of `doc-writer-prompt.md`, `migrate.md`.
- [x] The Tier-1 checks read `Plans:` and `Layout:` from `CLAUDE.md` and
  `.claude/CLAUDE.md`, first line found, the default the fallback; each
  self-test that declares the tree gains the case declared in `.claude/`.
  Approach: the one `sed` read in `scripts/ci/check-plan-text.sh`,
  `check-accretion`, `check-batch-tags`, `check-archival`,
  `check-plan-integrity` and `check-stray`, then `scripts/test/`.
- [ ] The PreCompact state hook reads `Session:` and `Plans:`, the
  permission pre-flight the `## Agent toolchain` commands, and the
  worker workspace `Session:` from both instruction files the same way,
  each change pinned by its test.
  Approach: `hooks/dev-precompact-state.sh`, `preflight-permissions.sh`,
  `worker-workspace.sh`, each with its file in `scripts/test/`.
- [ ] A `--project` install reads `Session:` from both instruction files
  and appends the plan-text gate to the `Test (fast):` or `Test:` line
  in whichever file holds it; with neither, its message names both.
  Approach: step 7 of `scripts/install-dev.sh`, then
  `install-dev-fast-tier.test.sh` and `install-dev-gitignore.test.sh`.
- [ ] This repository's declarations move, values unchanged and without
  preamble, to a tracked `.claude/CLAUDE.md` that a session here loads;
  the global `CLAUDE.md` keeps conventions only, and `writing.md` drops
  its Tier-1 enforcement sentence, true only here.
  Approach: `.gitignore` allowlist, `LAYOUT.md` node, then a `git grep`
  finding no precedence sentence outside the plans tree and `README.md`.
- [ ] `DESIGN.md § Self-hosting layout` states that the nested `.claude/`
  holds Claude Code's project settings and this repository's
  instructions with its declarations, the root `CLAUDE.md` being the
  global instructions.
  Approach: that section alone; the README's precedence sentence is the
  doc writer's to drop at close.
- [ ] Complete the branch: cleanup (stale/temp data), mark plan complete,
  mark the task `[x]` in the R's `tasks.md` plus any release-plan entry,
  commit, the resolved task report included. (Batch members: the task
  mark rides the batch branch.)
