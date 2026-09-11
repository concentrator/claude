---
task: R080-T011
type: mnt
depends-on: R080-T010
cold-read: passed
---

# R080-T011: who writes `hooks/`

Branch: `mnt/hooks-access`. Requirements:
`dev/plans/R080-seat-model/requirements.md § Desired state` 8 and 10
and `§ Invariants`.

The config paragraph every seat definition carries withholds `hooks/`
beside the settings surface. This branch rules that a seat writes
`hooks/` as tracked source, states the caveat that ruling carries, and
propagates the one wording to the seven definitions.

- [x] The config paragraph of every seat definition names `hooks/` as
  tracked source a seat writes, keeps the settings surface withheld,
  and carries the caveat that this repository's guards are live; the
  paragraph reads byte-identically in all seven files. A seat writes
  `hooks/` because the tree treats it as source by every measure it
  applies to source: each guard has a test under `scripts/test/` that
  `Test (full)` and the PR's CI run (`.github/workflows/ci.yml` runs
  `scripts/test/run-all.sh`), `scripts/install-dev.sh` step 3 ships
  every file of it to adopters - all copied, five hooks also
  registered, the session-state writer and the context-fill helper
  copied alone, as its comments say - `scripts/ci/check-secrets.sh`
  sources `hooks/secret-patterns.sh`, `MAINTENANCE.md § Doc-sync
  pairs` has a row for a guard added or removed, and the R080-T009
  branch carries an edit to `hooks/dev-precompact-state.sh` (its
  commit "Read the session and plans trees from CLAUDE.md"), a hook
  edited on a task branch as any source file is. The
  withholding's stated reason does not reach `hooks/`: the settings
  surface is withheld because its only writer is the user's `--apply`
  run of R080-T007's pre-flight (`R080-T010-seat-definitions.md`, the
  config decision; `requirements.md § Desired state` 8), and `--apply`
  writes allow rules, never a hook. Nor does the hard floor:
  `§ Invariants` names host gates and deny rules, and the guard's own
  header comment and `git-workflow.md § Enforcement` place the
  boundary at host branch protection plus CI, the hook being a local
  tripwire - so a seat editing a hook can weaken a tripwire on its own
  branch, never the floor. The other outcome, the user writing every
  guard change, would put shell code in the user's hands in a model
  whose seats exist so that nobody at the keyboard implements
  (`§ Desired state` 1), for R080-T007's HEAD guard and the backlog's
  edit-class-shell guard both, and would leave a guard's test red
  until the user commits (`R080-T007-perm-preflight.findings.md`, the
  fork's open order). What stays the user's is a hook's registration:
  the `hooks` key of `settings.json` - of a project's
  `.claude/settings.json` under `scripts/install-dev.sh`'s project
  scope - which the surface still withholds. So a seat adds a branch
  to a registered hook, or writes a new hook file with its
  `register_*` or copy line in `scripts/install-dev.sh` for adopters,
  and the user registers a new file in this repository's
  `settings.json`. The caveat is the live guard: this repository's
  `settings.json` registers `~/.claude/hooks/<name>`, the checkout
  itself, so an edit to a guard binds the runner's session from the
  moment it is saved, on whatever branch is checked out; what bounds
  it is that the edit lands as the plan item states it, with the test
  that pins the change, the spec reviewer reading the diff against the
  item and CI running the test before merge. The paragraph names
  `hooks/` as the source the installer ships; an installed project's
  `.claude/hooks/` copy is what a refresh overwrites, not what the
  paragraph admits. In each of the seven files the paragraph reads:

  > **Config.** No edit-class shell - `sed -i`, `tee`, a redirection -
  > against anything under the config directory: that is what the
  > sensitive-file guard fires on. Never the settings surface -
  > `settings.json`, `.claude/settings.json`,
  > `.claude/settings.local.json`, `~/.claude.json`; a hook is
  > registered in the `hooks` key of the first two, so adding or
  > removing one there is the user's. Every other path under the
  > config directory - skills, rules, agent definitions, the docs, the
  > plans, and `hooks/`, the source `scripts/install-dev.sh` ships - is
  > tracked source rather than config: a seat treats it as it treats
  > any file in the checkout, within the tools it holds. This
  > repository's `settings.json` registers `~/.claude/hooks/`, the
  > checkout itself, so an edit to a guard binds the session from the
  > moment it is saved: a guard changes only as the plan item states
  > it, with the test that pins the change.

  The first and third sentences keep their wording but for the list;
  the second loses `hooks/` and gains the registration clause, which
  names the two files a hook is registered in: `scripts/install-dev.sh`
  writes `$target/settings.json` - `~/.claude/settings.json` at global
  scope, a project's `.claude/settings.json` at project scope - and no
  text in the tree registers one in `settings.local.json` or
  `~/.claude.json`; the fourth is new. No sentence outside the seven is
  a casualty: `git grep -n 'hooks/' -- skills rules agents README.md
  DESIGN.md MAINTENANCE.md LAYOUT.md` returns, beyond the seven, cites
  in `layout.md`, `handoff.md`, `companions/secrets.md`,
  `companions/root-migration.md` and `companions/untracked-claude.md`,
  the `hooks/` rows of `LAYOUT.md`, `MAINTENANCE.md § Doc-sync pairs`
  and `README.md § Contents`, and `.githooks/` substring hits in
  `DESIGN.md`, `LAYOUT.md`, `MAINTENANCE.md` and `README.md`; each
  describes a hook and names no writer. `run.md § Pre-flight`'s
  "config is never a seat's to write (`agents/dev-implementer.md`)"
  cites this paragraph and is R080-T007's runner item to reword to the
  surface the paragraph names, that item reading the paragraph as this
  task leaves it. `R080-T007-perm-preflight.md`'s guard item branches
  on this ruling and says the tree at its dispatch settles the arm, so
  it needs no edit here and takes its first arm. The backlog's
  edit-class-shell guard line in `tasks.md` names no writer and needs
  none. For the doc writer: `README.md § Contents`' rows for `agents/`
  and `hooks/` name no writer and no doc states the withholding, so
  the branch likely obliges no doc; the facts, should one be written,
  are the ruling above.
  Approach: in `agents/code-reviewer.md` (lines 77-84),
  `agents/dev-cold-reader.md` (30-37), `agents/dev-doc-writer.md`
  (42-49), `agents/dev-docs-verifier.md` (29-36),
  `agents/dev-implementer.md` (87-94), `agents/dev-planner.md` (45-52)
  and `agents/dev-spec-reviewer.md` (47-54), one `Edit` each replaces
  the paragraph from `**Config.**` through "within the tools it holds."
  with the text above, rewrapped at 72 columns - the width the Config
  paragraph holds in each file, not a whole-file width: the frontmatter
  `description:` lines run past 72 - the blank line above and below it
  kept. The paragraph is retyped whole rather than patched by
  fragment. The blockquote's words are prescriptive and its line
  breaks are not - they are wrapped narrower to sit inside the plan's
  indentation; the 72-column rewrap sets the breaks, identical in the
  seven files, and the identity check next is the only check on them.
  Then confirm identity: `for f in agents/*.md; do awk
  '/^\*\*Config\.\*\*/{p=1} p{print} p&&/^$/{exit}' "$f" | shasum;
  done | sort -u | wc -l` prints 1. No cap binds `agents/`
  (`scripts/ci/check-caps.sh` matches `skills/dev/[^/]+\.md` only).
  Verify with `bash scripts/ci/run-all.sh`.

- [ ] The config paragraph's second sentence attributes a hook's
  registration to `scripts/install-dev.sh`, and its fourth names the
  hazard the task line states - a seat can weaken the guard binding
  it - beside the mechanism; the paragraph still reads byte-identically
  in all seven definitions. The registration sentence is scoped to what
  the tree does: `scripts/install-dev.sh` writes `$target/settings.json`
  (line 81; `~/.claude/settings.json` at global scope, a project's
  `.claude/settings.json` at project scope) and nothing else in the
  tree registers a hook, but the host also honours a `hooks` key in
  `settings.local.json`, so "a hook is registered in the `hooks` key of
  the first two" reads as a claim about the host and lets a seat infer
  that the third file carries none. No permission follows from the
  scope - the whole surface is withheld either way - so the sentence
  names the installer as the registrar rather than stating the host's
  rule. The caveat sentence names the hazard because the task line
  (`tasks.md`, R080-T011: "a seat can weaken the guard binding it")
  frames the caveat so, and the landed sentence leaves the weakening to
  inference from "binds the session from the moment it is saved". The
  first and third sentences are unchanged. No sentence outside the
  seven cites either reworded sentence: `git grep -n 'first
  two\|binds the session' -- skills rules agents README.md DESIGN.md
  MAINTENANCE.md LAYOUT.md CLAUDE.md dev/plans/R080-seat-model`
  returns, beyond the seven, unrelated phrases in
  `R080-T006-seat-duties.md`, `R080-T007-perm-preflight.findings.md`
  and `R080-T010-seat-definitions.md`. In each of the seven files the
  paragraph reads, at the line breaks shown:

  > **Config.** No edit-class shell - `sed -i`, `tee`, a redirection -
  > against anything under the config directory: that is what the
  > sensitive-file guard fires on. Never the settings surface -
  > `settings.json`, `.claude/settings.json`, `.claude/settings.local.json`,
  > `~/.claude.json`; `scripts/install-dev.sh` registers a hook in the
  > `hooks` key of the first two, so adding or removing one there is the
  > user's. Every other path under the config directory - skills, rules,
  > agent definitions, the docs, the plans, and `hooks/`, the source
  > `scripts/install-dev.sh` ships - is tracked source rather than config: a
  > seat treats it as it treats any file in the checkout, within the tools
  > it holds. This repository's `settings.json` registers
  > `~/.claude/hooks/`, the checkout itself, so an edit to a guard binds the
  > session from the moment it is saved and a seat can weaken the guard
  > binding it: a guard changes only as the plan item states it, with the
  > test that pins the change.

  Approach: in `agents/code-reviewer.md` (lines 77-90),
  `agents/dev-cold-reader.md` (30-43), `agents/dev-doc-writer.md`
  (42-55), `agents/dev-docs-verifier.md` (29-42),
  `agents/dev-implementer.md` (87-100), `agents/dev-planner.md` (45-58)
  and `agents/dev-spec-reviewer.md` (47-60), one `Edit` each replaces
  the paragraph from `**Config.**` through "pins the change." with the
  text above, retyped whole rather than patched by sentence, the blank
  line above and below it kept. This time the blockquote's line breaks
  are prescriptive as well as its words: they are the 72-column greedy
  fill that never breaks on a hyphen, the same fill that produces the
  landed paragraph's breaks, so the fifteen lines go in as shown, minus
  the `> ` prefix. Then confirm identity: `for f in agents/*.md; do awk
  '/^\*\*Config\.\*\*/{p=1} p{print} p&&/^$/{exit}' "$f" | shasum;
  done | sort -u | wc -l` prints 1. Verify with `bash
  scripts/ci/run-all.sh`.

- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine`, `bash scripts/ci/run-all.sh` green, cleanup, mark the plan
  complete, mark the task `[x]` in `tasks.md`, commit.
