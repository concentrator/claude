---
task: R080-T007
type: mnt
depends-on: R080-T004, R080-T010
supervised: approved
---

# R080-T007: deterministic permission pre-flight

Branch: `mnt/perm-preflight`. Requirements:
`dev/plans/R080-seat-model/requirements.md § Desired state` 7 and 8 and
`§ Invariants`.

The run's permission set is declared once, split by what enforces it,
and settled before the first dispatch. Two words read "mode" in this
tree and every sentence below qualifies which: the **permission mode**
is the runner's launch mode (`auto`, `acceptEdits`, `default`), and the
**supervisor mode** is the `Supervisor: human | AI` line
(`companions/declarations.md § Supervisor bounds`).

Under `--permission-mode auto` the only deterministic enforcement is
deny rules, non-Bash allow rules and the mode assertion: auto suspends
Bash allow rules and routes every shell command to a classifier
(`companions/supervisor-runbook.md § Modes by seat`). So the declared
set splits by enforcement rather than by seat - a mode-independent set
binding under both supervisor modes, and a Bash prefix set binding
under `Supervisor: human` alone - and no declaration makes an
autonomous run promptless on its own: a classifier denial is
nondeterministic and a long transcript can fall back to manual
approval, both of them runbook-recorded events rather than gaps in a
declared set.

- [ ] `companions/seat-permissions.md` declares the run's permission
  set split by what enforces it, each rule traced to the seat
  definition, the dispatch companion or the `CLAUDE.md § Agent
  toolchain` line that needs it. The mode-independent set gates under
  both supervisor modes, is applyable, and a gap in it stops the run:
  the deny floor below; the non-Bash allow rules, being the Edit-class
  rule over the checkout root, the Read rules for paths outside it, the
  `WebSearch` rule the definitions naming that tool need, and the
  WebFetch domains a seat's dispatch names; the mode assertion; and
  never `bypassPermissions`, never `dontAsk`. The mode assertion is narrow -
  `--permission-mode auto` on the runner's launch command, and each
  tier's mode key unchanged from its tracked value - and never asserts
  that `defaultMode` is absent: the user tier's
  `defaultMode: acceptEdits` is an approved standing decision
  (R056-T002, archived), and the concern is a mode key drifting after a
  run has started. The deny floor is the tracked tiers' push denies
  plus five HEAD-moving verbs - `git checkout`, `switch`, `reset`,
  `restore`, `stash` - the one bar that reaches a dispatched seat (the
  R080-T007 task line in `tasks.md`): a deny survives `auto`, which
  suspends Bash allow rules, and binds a subagent, which inherits the
  runner's permission mode and the same tiers (`run.md § Seats`) and
  which a tool set cannot hold off git, `Bash` being one tool. Its price
  is stated where it lands: a deny binds every context in the session,
  the runner included, so the flow's own HEAD moves take the forms the
  floor leaves (the next item), and the floor stops the verbs a seat
  reaches for rather than proving no route exists - a command's intent
  is the guard hook's to judge (`hooks/dev-branch-guard.sh`). No seat
  writes the floor in: it enters a tracked tier by the user's hand, the
  settings surface being what `agents/dev-implementer.md` withholds
  from a seat, and until it is there the pre-flight reports it missing
  and the run stops. The same user edit drops what the floor kills in
  the tracked `settings.json` - its `Bash(git checkout:*)`,
  `Bash(git reset:*)`, `Bash(git restore:*)`, `Bash(git stash:*)` and
  `Bash(git switch:*)` allows, dead once a deny covers them.
  The Bash prefix set stays declared and traced but
  binds under `Supervisor: human` alone; under `Supervisor: AI` it is
  reported inert and its absence never stops a run, so a user tier's
  Bash entries are the human-supervised path, not what makes an
  autonomous run promptless. Workspace trust is declared as a host
  gate rather than a rule (the script item below). A seat's tool set is
  its definition's `tools:` key and every seat has one, the roster
  being `run.md § Seats`, so the tool set is the per-seat scope
  boundary - no seat holds a tool its definition omits - and the
  declared set gates the tools the definitions do name: the Edit-class
  rule reaches only the seats whose definitions carry an edit tool, the
  cold reader and the spec reviewer holding `Read, Bash` alone, and the
  non-Bash allow class covers `WebSearch` and the WebFetch domains for
  the two seats holding those tools (`agents/code-reviewer.md`,
  `agents/dev-docs-verifier.md`) plus `Skill(<name>)` where a dispatch
  names a skill (`agents/dev-implementer.md`). No `Bash` allow rule is
  derived per seat under either supervisor mode: an allow rule lives in
  a settings tier the whole session reads and a definition carries
  `tools:` and no permission key, so the Bash prefix set is one
  run-wide set, suspended under `auto` and binding under
  `Supervisor: human`. Every seat holds `Bash` and none holds `Glob` or
  `Grep` - a `tools:` name this client's registry does not provide is
  dropped silently (R080's backlog in `tasks.md`) - so the seats search
  through `Bash` and the prefix set carries the search commands.
  Both push carve-out patterns stay and
  `companions/toolchain.md § Permission carve-out` makes them
  conditional on the supervisor mode rather than retiring one: pattern
  1, the narrow deny, is required wherever a seat pushes, which the
  runner does at `run.md § Checkpoint`'s accept; pattern 2, the blanket
  deny with one manual approval per batch, is valid under
  `Supervisor: human`, which can answer its prompt, and is a
  cannot-apply gap under `Supervisor: AI`, where nobody can. This
  repository is on pattern 1.
  Approach: new companion `skills/dev/companions/seat-permissions.md`,
  sectioned § What enforces what (the split, and the permission-mode /
  supervisor-mode terminology above), § Mode-independent set (a table:
  rule, class, the definition or toolchain line it traces to),
  § Deny floor (the five verbs, why a deny is the bar that reaches a
  seat, and the forms the flow uses instead - the next item's three),
  § Bash prefix set (the `Bash(<prefix>:*)` derivation, the prefix
  being the declared command up to its first placeholder; inert under
  `auto`), § Workspace trust, § Seat tool sets (what a tool set gates
  and what it leaves to the rules, each seat's own set cited to its
  file under `agents/` rather than copied, a copy drifting from the
  definition), § Machine-readable form. That form stays
  `companions/auto-permissions.template.json` under its current name
  and shape, a settings object with
  `permissions.allow` and `permissions.deny`:
  `scripts/worker-workspace.sh:143` reads it by absolute path,
  hard-fails if it is absent and consumes those two keys, and
  `scripts/test/worker-workspace.test.sh:248` asserts the filename, so
  neither a rename nor a reshape is taken and the file stays a valid
  settings object. The split is computed, not stored: an allow entry
  beginning `Bash(` belongs to the Bash prefix set and every other
  entry to the mode-independent allow set. The template ships no
  `WebFetch(domain:...)` entry - the class exists with no default
  member and a domain enters it when a seat's dispatch names one -
  while `WebSearch` ships, `agents/code-reviewer.md` and
  `agents/dev-docs-verifier.md` holding that tool. Its `deny` gains the
  five floor verbs; its `allow` drops `Bash(git switch:*)` and
  `Bash(git restore:*)`, which the floor makes dead - deny beats allow
  across tiers (`toolchain.md § Permission carve-out`) - and gains the
  prefixes the surviving forms need: `Bash(git symbolic-ref:*)`,
  `Bash(git read-tree:*)`, `Bash(git fetch:*)`.
  `toolchain.md § Permission carve-out`'s closing paragraph ("The
  pre-flight permission gate checks which pattern is in place and
  reports it; it never weakens a deny rule on its own") gains the
  supervisor-mode split and the `seat-permissions.md` pointer, and
  pattern 2's "Zero config; one prompt per batch by design" gains
  "under `Supervisor: human`; under `Supervisor: AI` nobody can answer
  that prompt, so the pre-flight reports it cannot apply".

- [ ] The flow's own HEAD moves survive the deny floor, so the bar that
  holds a seat off HEAD does not stop the run: every `git checkout`,
  `switch`, `reset`, `restore` or `stash` the flow files name is
  replaced by a form the floor leaves, each keeping the effect it has
  today - a branch created at the current commit and entered, a working
  tree returned to HEAD, a ref advanced without being entered. The
  forms are stated once in
  `companions/seat-permissions.md § Deny floor` and used, not
  re-explained, at the sites: `run.md § Question resolution`'s halt
  revert, `run.md § Pre-flight`'s branch creation, `finish.md`'s
  discard path and its post-merge sync, and `release.md`'s release
  branch.
  Approach: the three forms first, in the companion - `git branch
  <name>` then `git symbolic-ref HEAD refs/heads/<name>` to enter a
  branch created at the current commit, sound because § Pre-flight has
  already checked a clean tree on the default branch, so the new branch
  is at HEAD and no file has to move; `git read-tree --reset -u HEAD`
  to return the index and the tracked tree to HEAD; `git fetch origin
  <ref>:<ref>` to advance a ref the session is not on. Then the sites.
  `run.md` is at 300 of the 300-line cap `scripts/ci/check-caps.sh`
  holds mode files to, so its two edits are in-place: line 127's
  "`git checkout -- .`" becomes the read-tree form and the paragraph
  (lines 123-144) is re-wrapped to absorb the 13 extra characters
  without gaining a line; § Pre-flight's last bullet ("Batch scope:
  tag ... create `batch/R<NNN>-B<NNN>` off default") names no command
  today and gains none, the companion carrying the branch-creation
  form. `finish.md` (88 lines) and `release.md` (47) have room: the
  discard line's "Then checkout default, `git branch -D`" and § 4 step
  1's "Sync the default branch (`git checkout <default>`, `git pull`)"
  become the fetch form for the ref and the symbolic-ref pair for
  entering it - the branch delete needs the session off the branch -
  and `release.md` step 5's `git checkout -b release/vX.Y.Z` becomes
  the branch-creation form. Keep every rewritten line inside 80
  columns. These are the whole inventory:
  `git grep -nE 'git (checkout|switch|reset|restore|stash)'` returns,
  outside `dev/plans/` and the branch-guard test's command fixtures,
  only these lines and the allow entries the first item handles, and
  the discard line, which says "checkout default" in prose, is the one
  site that grep misses. Prove each form once in a throwaway repo under
  the scratch directory before the swap.

- [ ] `scripts/preflight-permissions.sh` resolves the declared set
  against the tiers and prints one report whose every line names the
  tier that satisfied the rule, so a report that read one tier cannot
  pass as a full answer. Workspace trust is its first check and never
  its to write: `~/.claude.json`'s
  `projects[<project path>].hasTrustDialogAccepted` is a host gate on
  the same footing as the `.claude/` guard, an untrusted workspace has
  its project-tier allow entries ignored wholesale, and `--apply`
  writes `.claude/settings.local.json`, project-scoped too, so trust
  nullifies exactly the tier the script writes to; untrusted means
  cannot-apply, a non-zero exit, a printed remedy for the user, and no
  rule resolved and nothing written. What `--supervisor` selects is
  which classes bind: `AI` binds the mode-independent set, prints the
  Bash prefix set inert, asserts the runner's permission mode is
  `auto`, and makes carve-out pattern 2 a cannot-apply; `human`
  additionally binds the Bash prefix set, accepts pattern 2, and drops
  the permission-mode assertion, the runner then being the user's own
  session in its own mode. A rule is satisfied by any tier that covers
  it: a Bash prefix rule by a tracked prefix that covers it, a path
  rule by a rule of the same tool whose literal prefix before its first
  wildcard contains the declared path (so a tracked
  `Edit(//<root>/**)` satisfies a declared `Edit(//<root>/dev/plans/**)`
  rather than reporting a false gap), a WebFetch rule by an exact
  domain match, and a bare tool rule such as `WebSearch` by an exact
  string match. Cannot-apply, each exiting non-zero with nothing
  written: an untrusted workspace, a needed allow rule a tracked tier
  denies, pattern 2 under `Supervisor: AI`, `bypassPermissions` or
  `dontAsk` in any tier, a missing `.claude/` directory, an unwritable
  local tier, a failed permission-mode assertion, and `jq` absent - a
  pre-flight that cannot read the tiers stops the run rather than
  failing open as a CI gate does. `--apply` merges the missing allow
  rules into `.claude/settings.local.json`, preserving its other keys,
  and writes no deny rule, no mode key and nothing in `~/.claude.json`.
  Convergence is named: the resolver reads the local tier as a
  satisfying tier, so an applied rule reads back as present in it and a
  re-run exits zero, and a rule that proves durable is promoted into
  the tracked project tier by `MAINTENANCE.md § Generalize allow rules`
  step 5, never by the script. Its test is
  `scripts/test/preflight-permissions.test.sh`.
  Approach: the script sits flat at `scripts/preflight-permissions.sh`,
  where every script outside `ci/` and `test/` sits, rather than in a
  `scripts/dev/` created for one file; `LAYOUT.md` gains its node line
  in the shipping item below. Usage:
  `preflight-permissions.sh --project <path> --supervisor <human|AI>
  --runner-mode <mode> [--apply]`. The permission mode arrives as an
  argument because a script cannot read another process's launch flags:
  the runner supplies its own launch mode and the script refuses the
  run when it is not `auto` under `--supervisor AI`. Tier paths:
  `PREFLIGHT_USER_SETTINGS` (production default
  `$HOME/.claude/settings.json`), `<project>/.claude/settings.json`,
  `<project>/.claude/settings.local.json`, and `PREFLIGHT_CLAUDE_JSON`
  (default `$HOME/.claude.json`) for the trust read; the two
  environment variables exist for the test's fixture trees. Placeholder
  substitution moves here from `run.md § Pre-flight`, which owns it
  today: `__PROJECT_DIR__` and `__HOME__` become absolute paths without
  their leading slash, the template's rules carrying the `//` prefix
  (`Edit(//__PROJECT_DIR__/**)`, `Read(//__HOME__/.claude/skills/**)`).
  The Bash prefix set is the template's `Bash(` entries plus the
  project's `CLAUDE.md § Agent toolchain` commands, the VCS-host CLI
  among them; an absent host CLI is the push-only fallback of
  `companions/toolchain.md § Push + MR/PR`, not a gap. Check order:
  trust, then the mode assertion and the never-list, then the deny
  rules, then the non-Bash allow rules, then the Bash prefix set, then
  the carve-out pattern. The mode-assertion half the script can decide
  is the tier comparison - each tier's `permissions.defaultMode` against
  `git show HEAD:<path>` where the tier is git-tracked, reported as
  unchanged, drifted, or untracked with its value - and it never
  reports a present `defaultMode` as a defect. Report lines carry one
  status each: `present (user|project|local)`, `missing`,
  `inert (auto)`, `applied (local)`, `cannot apply: <reason>`. Test
  cases, fixture trees under `mktemp -d` (untrusted by construction,
  which is what makes case 1 free): an untrusted tree reports
  cannot-apply, stops and writes nothing; a full set exits zero with
  every line naming its tier; a missing non-Bash rule is reported and
  then written by `--apply` with the file's other keys intact; a re-run
  after `--apply` exits zero; a tracked `Edit(//<root>/**)` covers a
  declared child path and is not rewritten; an absent Bash prefix is
  inert and exits zero under `--supervisor AI` and missing and non-zero
  under `--supervisor human`; pattern 2 is accepted under `human` and
  cannot-apply under `AI`; a missing deny rule is cannot-apply and
  `--apply` writes no deny; `bypassPermissions` in a tier is
  cannot-apply; an unwritable local tier is cannot-apply. Both files
  stay within `scripts/ci/check-code-size.sh`'s 300-line file cap and
  50-line function cap; `scripts/test/run-all.sh` picks the test up by
  its glob, so `Test (full)` runs it with no wiring.

- [ ] The runner runs the script and routes what it cannot predict:
  `run.md § Pre-flight`'s permission bullet becomes the script's
  invocation in report mode before the first dispatch, its report the
  pre-flight's, a gap stopping the run and printing the `--apply` line
  for the **user** to run, since workspace trust and the settings
  surface are host gates no seat clears (`run.md § Seats`, the asked-of
  row). The same section's plan check names that surface instead of the
  config directory: "No plan in scope names a target under `.claude/`"
  reads as the settings files, `hooks/` and `~/.claude.json`
  (`agents/dev-implementer.md`), which no seat writes, every other path
  under the config directory being tracked source a plan may name -
  this plan among them.
  `§ Dispatch per item`'s prompt paragraph carries the two classes the
  ledger needs (`§ Ledger`): a pre-flight defect, which is a gap in the
  mode-independent set, halts the item, is fixed in
  `companions/seat-permissions.md` and is cleared by nobody; a
  classifier event under `auto` is retried once, and a second is an
  answer that halts the item to the user. The compound-command rule
  keeps its invariant and flips predicate by permission mode: outside
  `auto` a seat's commands are shaped to match a declared prefix; under
  `auto` they are shaped to be classifier-readable, no base64 into a
  shell and no script copied to a host and executed. The runbook is
  re-read against the same split: `§ Modes by seat` cites the
  declaration and says the mode-independent set is what makes an
  autonomous run promptless, `§ Failure modes` keeps its classifier
  entries and states that a manual-approval fallback under
  `Supervisor: AI` escalates to the user rather than being keyed past,
  and `Keystroke authority` keeps its two rules that have nothing to do
  with permission prompts.
  Approach: `run.md` stands at 300 of the 300-line, 80-column cap
  `scripts/ci/check-caps.sh` holds mode files to, so the edit is
  net-zero and budgeted: § Pre-flight's first bullet (lines 69-77) goes
  from 9 lines to 4, naming `.claude/scripts/preflight-permissions.sh
  --project . --supervisor <declared> --runner-mode <the runner's
  launch mode>`, the tier-naming report, the `--apply` line for the
  user and the surviving "No `## Agent toolchain` section → halt,
  ask"; the placeholder-substitution clause and the VCS-host-CLI clause
  go with the bullet, the first to the script and the second to
  `companions/toolchain.md § Push + MR/PR`, which already carries the
  absent-host fallback. Of the five lines that frees, the
  settings-surface bullet (lines 78-81) takes one and § Dispatch per
  item's closing paragraph (lines 117-119) the other four, going from 3
  lines to 7 with the two classes and the mode-conditional shaping
  rule; the file lands back at 300 and the wrap may be re-cut across
  the three passages so long as `check-caps.sh` passes. The duty
  table's prompt row (`| Clearing a permission prompt | nobody: a
  prompt is a pre-flight defect | the same |`) reads "nobody: a
  pre-flight defect halts the item, a classifier event retries once
  then reaches the user (§ Dispatch per item)" in its
  `Supervisor: human` cell and keeps `the same` in the other, table
  rows being exempt from the column limit. In the runbook, a
  companion and so exempt from both caps: § Modes by seat's
  auto-mode paragraph gains the `companions/seat-permissions.md` cite
  and the sentence that the mode-independent set, not the suspended
  Bash rules, is what a promptless run rests on, its
  `bypassPermissions` / `dontAsk` and "Deny rules survive auto mode"
  paragraphs kept as that set's own never-list and cited to the
  declaration; § Failure modes' transcript-overflow entry gains "under
  `Supervisor: AI` nobody in the pane can answer it: escalate to the
  user over Remote Control", and its `defaultMode` entry reads as a
  mode key drifting from its tracked value after a run starts, a key
  that is part of the tracked value not being a defect. `Keystroke
  authority` stays the bolded paragraph closing § tmux recipes: its
  no-key-past-a-permission-prompt sentence reads as the two classes
  above, and its other two rules - the user must not type instructions
  into the runner's box, and a keystroke is not the fix for a deadlock
  - stand unchanged. § Two variants and § tmux recipes are otherwise
  untouched: the variants table has no who-clears-prompts row and the
  recipes hold three code blocks, capture-pane and two until-loops,
  with no send-keys recipe to drop.

- [ ] The script ships to adopters, so an adopter's `run.md` does not
  name a script its checkout lacks: `scripts/install-dev.sh` copies
  `preflight-permissions.sh` and its self-test alongside the four
  checks and two self-tests it already copies, `LAYOUT.md` gains the
  script's node, and `scripts/worker-workspace.sh` records why its
  wholesale write of `.claude/settings.local.json` and the pre-flight's
  merge into the same file do not collide.
  Approach: `install-dev.sh` step 4's copy loop (lines 181-185) gains
  `preflight-permissions.sh` and `test/preflight-permissions.test.sh`,
  a `chmod +x "$target/scripts/preflight-permissions.sh"` follows the
  existing `chmod +x` line, the step's comment gains one sentence
  saying the pre-flight ships because `run.md § Pre-flight` names it,
  and the closing `echo` about self-tests names it too.
  `scripts/test/install-dev.test.sh` stands at 299 of
  `check-code-size.sh`'s 300-line cap, so it gains exactly one line
  beside the copy assertions at lines 35-41, asserting the script is
  executable and its self-test present in one condition, and lands at
  300. `LAYOUT.md` gains a `preflight-permissions.sh` node commented
  "the /dev run permission pre-flight" between `model-quota.sh` and
  `provision-worker.sh`, the `#` on the column its siblings use, which
  the 24-character name reaches with six spaces; the test needs no
  line, the
  `scripts/test/*.test.sh` pattern line covering it, and
  `check-stray.sh` matches first-level nodes only, so the fast tier is
  green before and after. `worker-workspace.sh`'s `settings()` comment
  (lines 133-138) gains one sentence: the wholesale `>` write is the
  seed, written once on a fresh VM checkout before any run, and the
  pre-flight's `--apply` merges into the same file afterwards, so the
  two never race. The template's name and shape are unchanged by this
  branch - only its entries move (first item) - so line 143's read and
  case 13 of
  `scripts/test/worker-workspace.test.sh` keep passing untouched.

- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine`, `bash scripts/ci/run-all.sh` green, cleanup, mark the plan
  complete, mark the task `[x]` in `tasks.md`, commit.
