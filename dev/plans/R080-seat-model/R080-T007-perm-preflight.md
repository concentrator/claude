---
task: R080-T007
type: mnt
depends-on: R080-T004, R080-T010, R080-T011
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

- [x] `companions/seat-permissions.md` declares the run's permission
  set split by what enforces it, each rule traced to one of four
  sources: a seat definition under `agents/`, a dispatch companion
  under `companions/`, the project's `CLAUDE.md § Agent toolchain`
  line, or a `skills/dev/` flow step the runner runs itself - that
  fourth source being what puts the runner's own commands in the
  declared set, no seat issuing them. An entry naming none of the four
  is dropped rather than carried unexplained, and a need the drop
  turns out to cover returns through the pre-flight's report and
  `--apply` (the script item below), never as an untraced template
  entry. An entry one conduct section bars in one context and a
  definition needs in another stays, traced to the need, the bar
  standing where it is written: `sed`, `awk`, `cat`, `head`, `tail`,
  `wc` and `grep` are what the seats read and search with, no
  definition declaring `Glob` or `Grep`, while
  `agents/dev-implementer.md § Plan & Findings Files` keeps them off
  the plan and findings files and its config paragraph keeps
  edit-class shell off the config directory. The mode-independent set
  gates under both supervisor modes, is applyable, and a gap in it
  stops the run: the declared push deny, which is whichever carve-out
  pattern's deny set the tiers are on (below); the non-Bash allow
  rules, being the
  Edit-class rule over the checkout root, the Read rules for paths
  outside it, the `WebSearch` rule the definitions naming that tool
  need, and the WebFetch domains a seat's dispatch names; the mode
  assertion; and never `bypassPermissions`, never `dontAsk`. The mode
  assertion is narrow - `--permission-mode auto` on the runner's launch
  command, and each tier's mode key unchanged from its tracked value -
  and never asserts that `defaultMode` is absent: the user tier's
  `defaultMode: acceptEdits` is an approved standing decision
  (R056-T002, archived), and the concern is a mode key drifting after a
  run has started. What holds a seat off HEAD is a branch in
  `hooks/dev-branch-guard.sh` rather than a settings deny on the
  HEAD-moving and work-discarding verbs (`git checkout`, `switch`,
  `reset`, `restore`, `stash`): every one of the four shapes below is
  told from the command's arguments, and a settings deny reads none of
  them, so a deny wide enough to catch a shape also stops the flow's
  own moves in that verb - `Bash(git checkout:*)` stops `finish.md`'s
  discard and post-merge entries into the default branch and the
  branch `run.md § Pre-flight` and `release.md` step 5 create along
  with a dirty-tree trunk entry, and `Bash(git reset:*)` stops a
  seat's unstaging along with `reset --hard`. The guard reads those
  arguments and tells them apart, and it already fires on the `Bash`
  matcher of the tracked `settings.json` and of every project
  `scripts/install-dev.sh` writes, for a dispatched seat's call as for
  the session's (the R080-T010 probe, R080's backlog in `tasks.md`).
  The predicate, judged per command segment against the repo that
  segment targets as the push scan's is, denies four shapes: a
  `checkout` or `switch` entering that repo's default branch while its
  tracked tree is dirty; a `checkout -b|-B` or `switch -c|-C` whose new
  branch is named as the default branch; an irrecoverable discard
  through `reset` or `stash`, which is `git reset` carrying `--hard`,
  `--merge` or `--keep`, and `git stash drop` or `git stash clear`,
  each of them dropping work no `pop` and no reflog brings back; and a
  whole-tree path restore, which is a
  `checkout` or `restore` one of whose pathspecs names a whole tree -
  `.`, `./`, `:/`, `:/.`, or a relative or absolute path resolving to
  the repo's top level. That last shape is denied in every spelling
  that carries such a pathspec, with or without a `--` separator and
  with or without a tree-ish before it, so `git checkout -- .`,
  `git checkout .`, `git restore .`, `git restore -- :/` and
  `git checkout HEAD -- <repo root>` are all refused; `.` is refused
  whatever directory the segment runs from, a subtree-wide discard
  being the same hazard one level down and the segment's working
  directory not always readable. It passes `checkout -b` and
  `switch -c` on any other name; an entry into the default branch from
  a clean tree; a plain `git reset` and its `--soft` and `--mixed`
  spellings, which move HEAD and the index and take nothing out of the
  working tree; `git stash`, `git stash push` and `git stash save`,
  whose work `git stash pop` brings back, with `stash list`,
  `stash show`, `stash pop` and `stash apply` beside them; and a
  restore of explicitly named paths - `git checkout -- <paths>` and
  `git restore <paths>` - which is what a seat undoing one file uses,
  naming it, so unstaging keeps both its routes,
  `git restore --staged <paths>` and a plain `git reset`. A command
  whose pathspecs
  the guard cannot read passes, the file failing open here as it does
  on an unreadable repo. The one carve-out is stated where it lands:
  `finish.md`'s two entries run on a clean tree, and on the default
  branch the guard's own write and commit branches already refuse
  every mutation, so an entry that loses nothing is not the hazard.
  The one flow site the whole-tree deny reaches is the halt revert at
  `run.md § Question resolution`, and this branch re-forms it:
  `run.md:127`'s `git checkout -- .` becomes
  `git read-tree --reset -u HEAD`, whose verb is `read-tree` and so is
  reached by no deny here, and which restores the index and the
  tracked tree to HEAD, taking the seat's staged edits with its
  unstaged ones as the halt intends; the removal of the untracked
  files the seat created, stated beside it, is unchanged. The Bash
  prefix set gains `Bash(git read-tree:*)` for it, traced to that step
  under the fourth source above, so the command the halt runs is a
  declared one rather than a prompt in the one place the plan calls a
  prompt a defect; the runner's other commands enter the same way,
  `Bash(git merge:*)` traced to `run.md § Close` 5 and `finish.md` and
  `Bash(git tag:*)` to `run.md § Pre-flight`'s batch tag. The guard is
  a tripwire on the moves that lose work, not a boundary - the
  character its own header comment claims for the file. Its four
  reason lines carry the predicate and the rule, one per shape. The
  second shape has a line of its own because the first line's
  predicate is false for it: a `-b|-B` or `-c|-C` naming the default
  branch is refused from a clean tree too, `-B` and `-C` re-pointing
  an existing local trunk at HEAD and `-b` and `-c` putting the seat
  on a name the guard's own write and commit branches then treat as
  the trunk. The lines are
  `branch-guard: refusing '<cmd>' - it enters the default branch of
  '<repo>' with uncommitted work; commit or discard first - work
  reaches the trunk through a working branch and an MR/PR, never
  carried onto it (git-workflow § Trunk).`,
  `branch-guard: refusing '<cmd>' - it creates a branch named as the
  default branch of '<repo>'; a working branch is named
  '<prefix>/<slug>' (git-workflow § Trunk).`,
  `branch-guard: refusing '<cmd>' - it discards work no 'git stash
  pop' and no reflog bring back; commit first, or take a spelling that
  keeps it: 'git reset' without '--hard', 'git stash push'
  (seat-permissions § HEAD moves and whole-tree discards).` and
  `branch-guard: refusing '<cmd>' - it discards every uncommitted
  change under '<pathspec>'; name the paths to restore, and leave the
  whole-tree revert to the runner's halt (run.md § Question
  resolution).` Each cite lands on text that states the rule: the
  first line's on `git-workflow.md § Trunk`'s "every change reaches
  `main` through a short-lived branch and a CI-gated MR/PR", the
  third's on the companion section this item creates, which is where
  the discard rule is written, `run.md § Seats` stating neither. In
  those strings `<cmd>`, `<repo>` and `<pathspec>` are the guard's to
  fill at runtime, and `<prefix>/<slug>` prints as written, being
  `git-workflow.md § Trunk`'s own notation for a branch name rather
  than a value the guard holds. The guard is a host gate rather than a
  rule, as workspace trust below is, so its proof is its own test
  rather than a pre-flight check, and who
  applies it is R080-T011's to settle rather than this plan's
  to assume: where T011 lets a seat write `hooks/` as tracked source
  the item's implementer writes the branch; where the withholding
  stands the implementer writes the companion and the test, the branch
  is the **user**'s to apply, and the item halts to the user when it
  is reached and resumes on their commit. That halt is the item-level
  gate, and naming the **user** as the writer is what keeps the
  scope-level one off this plan: `run.md § Pre-flight`'s plan check
  refuses an item that hands a *seat* a withheld-surface target, not
  one that names the user as its writer (the runner item below), so a
  withheld `hooks/` does not refuse this plan, or the backlog's
  edit-class-shell guard, before the first dispatch.
  T011 lands first (`depends-on`), so which of the two holds stands in
  the tree at dispatch.
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
  cannot-apply gap under `Supervisor: AI`, where nobody can. So the
  declared push deny is the pattern's deny set rather than one fixed
  rule, a narrowed deny being deliberately weaker than the blanket one
  and neither covering the other: pattern 2 declares
  `Bash(git push:*)`, pattern 1 declares the pair
  `Bash(git push origin <default>:*)` and `Bash(git push --force:*)`
  with `<default>` the repo's own default branch name, resolved as the
  script item states. The pattern is read from the tiers, never taken
  from a flag or from this text: it is read off the union of the
  `deny` sets of every tier the session reads - user, project and
  local - because deny beats allow across all tiers
  (`toolchain.md § Permission carve-out`) and the tiers can disagree.
  An entry is satisfied by its exact string in the `deny` of any one
  of those same tiers, and one content answers both questions: the
  tier's working-tree file, which is what the session's own permission
  check reads and so what binds the run. No git state enters either
  read - a deny in an untracked local tier binds the session as a
  committed project-tier one does, and a deny added to a tracked tier
  binds it before it is committed - so the pattern the report names
  and the entries that pattern declares are never read from two
  different contents of one file. The word "tracked" carries no rule
  here: `run.md § Pre-flight`'s "carried by a tracked tier" names the
  user and project tiers against the local one, and the runner item
  below rewrites that bullet. Where a deny lives for the next clone is
  `toolchain.md § Permission carve-out`'s placement rule, which puts
  the project's declaration in the tracked project tier; the
  pre-flight names the tier carrying each entry and gates on nothing
  else, a run being protected by the file the session reads rather
  than by that file's git history. So a blanket entry in any of the
  three makes the session pattern 2, the report naming the tier that
  carries it and that same tier satisfying pattern 2's one declared
  entry: a user tier's `Bash(git push:*)` beside a project tier's
  narrow pair is pattern 2, `present (user)`, accepted under
  `Supervisor: human` and cannot-apply under `Supervisor: AI`, the
  project tier's pair notwithstanding. A union carrying no blanket
  entry is pattern 1 whatever it carries of the pair - both entries,
  one, or neither - the declared set being the pair and each entry
  reported on its own line, so one narrow entry alone is pattern 1
  with the other entry missing, and a union carrying neither is the
  missing-deny gap, which is pattern 1 with both lines missing. The
  pair's two entries are satisfied from two tiers as readily as from
  one, each line naming its own, and a pair carried by the local tier
  alone is pattern 1 with both entries `present (local)` - the shape a
  provisioned worker arrives in, its seeded local tier the carve-out
  it runs under (the shipping item below). The missing-deny report
  prints each missing string and names the tracked project tier's
  `deny` as its home, never an `--apply` line, `--apply` writing no
  deny; that file edit is the whole remedy, with no commit and no
  branch, which is what lets the user run it at the halt
  `run.md § Pre-flight` takes with no branch created and no edit made.
  A remedy asking for a commit would ask for one on the default branch
  the halted run stands on, where `git-workflow.md § Trunk` routes
  every change through a working branch and an MR/PR and this branch's
  own guard refuses a seat's `git commit`. Committing the tier so a
  fresh clone keeps it is the project's own change on a branch of its
  own, not a step the stopped run waits for.
  `toolchain.md § Permission carve-out` is where a `Supervisor: human`
  project takes pattern 2 instead. Extra deny entries beyond the
  pattern's are never a gap. This repository is on pattern 1, its
  `.claude/settings.json` carrying the pair and its user tier, the
  `settings.json` at the checkout root, carrying no `deny` key.
  Approach: new companion `skills/dev/companions/seat-permissions.md`,
  sectioned § What enforces what (the split, and the permission-mode /
  supervisor-mode terminology above), § Mode-independent set (a table:
  rule, class, and which of the four sources it traces to, named as
  the file and section),
  § HEAD moves and whole-tree discards (the guard's predicate and its
  four reason lines, why a hook and not a deny, the forms it passes,
  and the halt revert's re-formed command),
  § Bash prefix set (the `Bash(<prefix>:*)` derivation, the prefix
  being the declared command up to its first placeholder; inert under
  `auto`), § Workspace trust, § Prompt classes (the pre-flight defect
  and the classifier event, each with its route, the reasoning
  `run.md § Dispatch per item` cites rather than restates),
  § Seat tool sets (what a tool set gates
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
  `agents/dev-docs-verifier.md` holding that tool. Its `deny` keeps
  `Bash(git push:*)` alone, the template being what a fresh adopter
  starts from and pattern 2 that starting point; pattern 1 is a tier
  edit `toolchain.md § Permission carve-out` shows, never a template
  one. Its `allow` keeps `Bash(git switch:*)` and
  `Bash(git restore:*)`: the bar on a seat's HEAD moves is the guard,
  so no *deny* rule of the declared set names a HEAD-moving verb, and
  the allow rules that do are what the flow's own moves need. The
  allow list is walked once against the four sources and settles as:
  `Bash(git read-tree:*)` added (the halt revert, `run.md § Question
  resolution`); `Bash(cd:*)` dropped, a bare `cd` changing nothing
  that outlives its segment and a `cd` inside a compound command being
  what no prefix rule matches; every other entry kept with its source
  named - `git status|diff|log|show|branch|rev-parse` and the search
  and read commands to the seats' `tools:` keys and the absent
  `Glob`/`Grep`, `git add|commit` to `branch-plan.md § Commit
  cadence`, `git switch|merge|tag` to the `skills/dev/` steps
  that run them and `git restore` to the named-path restore § HEAD
  moves and whole-tree discards keeps open, `echo` to `§ Commit
  cadence` point 4, the `/tmp`
  read and edit rules to `agents/dev-implementer.md § Scratch & Probe
  Scripts`, the `skills/**` and `rules/**` read rules to the seat
  definitions that send a seat to those trees (`agents/dev-planner.md`,
  `agents/dev-doc-writer.md`, `agents/dev-implementer.md`), and
  `gh pr view` / `glab mr view`
  to `CLAUDE.md § Agent toolchain`'s State-check line.
  `Read(//__HOME__/.claude/settings.json)` is the entry the walk drops
  beside `Bash(cd:*)`, no source naming a seat that reads a settings
  tier, and `WebSearch` is the entry it adds beside
  `Bash(git read-tree:*)`, for the two definitions holding that tool.
  `toolchain.md § Permission carve-out`'s closing paragraph ("The
  pre-flight permission gate checks which pattern is in place and
  reports it; it never weakens a deny rule on its own") gains the
  supervisor-mode split and the `seat-permissions.md` pointer, and
  pattern 2's "Zero config; one prompt per batch by design" gains
  "under `Supervisor: human`; under `Supervisor: AI` nobody can answer
  that prompt, so the pre-flight reports it cannot apply".
  The guard branch sits in `hooks/dev-branch-guard.sh`'s `Bash)` case
  between the push scan's closing `done` and the commit detector, whose
  `[[ "$cmd" =~ $crx ]] || exit 0` returns for every command that does
  not commit, so a branch placed after that line would never see a
  checkout. It reuses what the case already holds: `opt` to skip global
  options, the command-head anchoring of `Prx` so text inside an `echo`
  never triggers, `resolve_target` for the repo, `is_trunk` for the
  destination, `deny` for the exit, and `exit 0` for an unreadable repo
  or an unresolvable target, the file failing open throughout. What
  fills the reason lines: `<cmd>` is the offending command segment -
  the text from its command-head `git` to the segment's end at the
  next `;`, `&`, `|` or newline, whitespace-trimmed, which is the slice
  the predicate judged - neither the verb alone (the push lines print
  the literal `'git push'` because their predicate is the verb) nor
  the whole `$cmd`; `<repo>` is `$top`, which the entry check resolves
  itself as the restore helper does - `resolve_target` gives it a
  `-C`/`cd` argument, not a top level - through
  `rev-parse --show-toplevel` and `cd "$top" && pwd -P`; `<pathspec>` is
  the offending pathspec as the
  segment spells it. The
  dirty-tree test is
  `git -C "$dir" status --porcelain --untracked-files=no`, non-empty
  meaning dirty. The reset/stash branch needs no repo at all, being a
  token read over the segment - `--hard`, `--merge`, `--keep` after
  `reset`; `drop`, `clear` as the word after `stash` - so it sits
  first, ahead of anything that resolves a path. Inside the entry
  branch the create test runs before the dirty-tree test: a
  `checkout`/`switch` segment carrying `-b|-B|-c|-C` is judged by its
  new name alone and never by the tree, so a dirty-tree
  `checkout -B main` gets the second reason line, the one that names
  its hazard, and the entry line is reached only by a segment naming
  an existing branch. The whole-tree
  restore reads the segment's pathspecs in a helper beside it: skip
  the global options and the verb, drop a tree-ish that a `--`
  separator marks off, and judge each remaining non-option argument in
  two stages. First the literal set `.`, `./`, `:/`, `:/.`, matched as
  text with nothing resolved, which is why `.` is refused whatever
  directory the segment runs from. Then, for anything else, a physical
  comparison against the repo's top level: `dir=$(resolve_target ...)`
  gives the `-C`/`cd` argument or `.`, the top level is
  `top=$(git -C "$dir" rev-parse --show-toplevel)` re-resolved through
  `cd "$top" && pwd -P`, and the pathspec resolves through
  `(cd "$dir" && cd "$p" && pwd -P)`, equal paths denying. Every
  failure passes: an unresolvable `dir`, a `git` that prints no top
  level, a pathspec that is not a readable directory (a file cannot be
  the top level), and a word carrying a shell metacharacter or a
  variable, the file failing open as it does on an unreadable repo.
  Only `checkout` and `restore` reach the helper - `switch` takes no
  pathspec - and a `checkout` naming a branch rather than a pathspec
  is the entry check's, the three branches judging a command
  independently. The three branches, the helper, the header sentences
  and the reason strings carry the file past `check-code-size.sh`'s
  300-line cap, so it takes a `scripts/ci/code-size-allow.txt` entry
  reasoned "PreToolUse hook registered by path; one file by
  construction" rather than the reason strings being cut short; the
  helper stays inside the 50-line function cap, which binds it and not
  the `Bash)` case body. Its
  header comment gains a sentence for each of the three new branches
  beside the write, commit and push ones. The
  cases go in a new `scripts/test/dev-head-guard.test.sh`,
  `scripts/test/dev-branch-guard.test.sh` standing at 285 of the same
  cap - the split `dev-push-guard.test.sh` already made, whose header,
  isolation lines and `run`/`pass`/`die` helpers it copies: an entry
  into the default branch denied on a dirty tree and allowed on a clean
  one; `switch -c feat/x` allowed from the default branch;
  `checkout -b main` denied; `git reset --hard` and `git reset --keep`
  denied with a bare `git reset` and `git reset --soft HEAD~1`
  allowed; `git stash drop` and `git stash clear` denied with
  `git stash`, `git stash push -m x`, `git stash pop` and
  `git stash list` allowed; `git checkout -- .`, `git checkout .`,
  `git restore .` and
  `git restore -- :/` denied, with `git checkout -- docs/x.md` and
  `git restore a b` allowed and `git restore --staged a` allowed; a
  `.` denied from a subdirectory through a leading `cd`;
  `git restore -- <absolute repo top>` denied and
  `git restore -- <absolute subdirectory>` allowed, which is the
  physical comparison's own pair;
  `git read-tree --reset -u HEAD`, the halt revert's own command,
  allowed; an entry judged through `git -C <path>` and through a
  leading `cd`; and an `echo` naming
  `git checkout main` allowed. `scripts/test/run-all.sh` picks the file
  up by its glob, and `scripts/install-dev.sh` already ships and
  registers the hook (`register_hook dev-branch-guard.sh`), so neither
  needs an edit.
  `run.md`'s halt revert is one sentence at line 127, edited in place
  rather than budgeted against the § Pre-flight lines the runner item
  below frees: the paragraph at lines 123-144 wraps between 72 and 80
  columns and closes on an 8-column line, so the twelve characters
  `git read-tree --reset -u HEAD` (29) adds over `git checkout -- .`
  (17) reflow
  inside `check-caps.sh`'s 80-column limit with no line added and
  `run.md` stays at 300, the re-wrap breaking the
  `companions/declarations.md § Supervisor bounds` cite across two
  lines at its inner space, as `run.md:75` already breaks one that long.
  The runner item's edits are at lines 69-81
  and 117-119, so the two do not touch the same lines.

- [x] `scripts/preflight-permissions.sh` resolves the declared set
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
  it: a Bash prefix rule by a prefix in any tier that covers it, a path
  rule by a rule of the same tool whose literal prefix before its first
  wildcard contains the declared path (so an
  `Edit(//<root>/**)` in any tier satisfies a declared
  `Edit(//<root>/dev/plans/**)`
  rather than reporting a false gap), a WebFetch rule by an exact
  domain match, and a bare tool rule such as `WebSearch` by an exact
  string match. A deny rule is the one class no coverage rule reaches:
  it is satisfied only by its exact string in the `deny` of a tier the
  session reads, and which deny strings are declared is the carve-out
  pattern the first item states, read off the tiers as that item says
  - so a tier on pattern 1 satisfies the declared set with its narrow
  pair and is never reported as missing the blanket rule, and a tier
  with neither pattern's set is the missing-deny gap. Every class
  resolves against one content, the same one the pattern read takes:
  each tier's working-tree file, which is what the session's own
  permission check reads and what `--apply` writes into, so an applied
  rule reads back as present (convergence below) and no two checks
  disagree about what a tier holds. Git state enters one check and
  decides no rule - the mode-key comparison below, which needs a
  tier's committed value to compare the working-tree one against.
  Cannot-apply, each exiting non-zero with
  nothing written: an untrusted workspace, a needed allow rule any
  tier denies, a missing deny rule, a default branch the
  script cannot resolve and so no pattern-1 string to check, pattern 2
  under `Supervisor: AI`, `bypassPermissions` or
  `dontAsk` in any tier, a missing `.claude/` directory, an unwritable
  local tier, a failed permission-mode assertion, and `jq` absent - a
  pre-flight that cannot read the tiers stops the run rather than
  failing open as a CI gate does. `--apply` merges the missing allow
  rules into `.claude/settings.local.json`, preserving its other keys,
  and writes no deny rule, no mode key and nothing in `~/.claude.json`.
  Convergence is named: the resolver reads the local tier as a
  satisfying tier, so an applied rule reads back as present in it and a
  re-run exits zero. The script writes the local tier and no other, and
  a rule that proves durable moves into the tracked project tier as the
  project's own change under `companions/toolchain.md § Permission
  carve-out`'s placement rule, which puts a declaration a fresh clone
  keeps in the tracked tier and leaves the local one to what is
  deliberately machine-local; the shadowed local copy then goes at the
  weekly `MAINTENANCE.md § Generalize allow rules` step 5, which keeps
  the broader tier's rule and deletes the shadowed one. Nothing the
  script does turns on that route. Where a stopped run resumes is stated
  with the stop: the halt is `run.md § Pre-flight`'s, before the first
  dispatch, with no branch created and no edit made, so the **user**
  runs the printed `--apply` line and the run resumes by re-entering
  § Pre-flight from its first bullet - the script's own re-run is what
  proves the apply landed and the remaining pre-flight checks have not
  run yet - while § Resolve's scope, supervisor and ledger stand and
  are not redone. A missing deny stops the run at the same halt and
  resumes the same way on a different remedy: no `--apply` line, the
  script writing no deny, but the missing string and the tracked
  project tier's `deny` as its home for the **user** to edit before
  re-entering § Pre-flight. That edit alone clears the gap, the
  resolver reading the tier's working-tree file, so the resume waits
  on no commit and the halt asks for none on the default branch it is
  standing on (`git-workflow.md § Trunk`). That the **user** runs
  `--apply` is what
  `requirements.md § Desired state` 8 asks: the printed line is the
  command that closes the gap, and `.claude/settings.local.json` is on
  the settings surface no seat clears (`agents/dev-implementer.md`, its
  config paragraph; `run.md § Seats`, the asked-of row). Its test is
  `scripts/test/preflight-permissions.test.sh`.
  Approach: the script sits flat at `scripts/preflight-permissions.sh`,
  where every script outside `ci/` and `test/` sits, rather than in a
  `scripts/dev/` created for one file; `LAYOUT.md` gains its node line
  in the shipping item below. Usage:
  `preflight-permissions.sh --project <path> --supervisor <human|AI>
  --runner-mode <auto|acceptEdits|default|unknown> [--apply]`.
  `--project` is canonicalized before any check reads it -
  `project=$(cd "$1" && pwd -P)`, a failure exiting non-zero - because
  `~/.claude.json`'s `projects` keys are absolute physical paths
  (`/Users/skywalker/.claude` for this repository, a worktree under
  its own key), so an uncanonicalized `--project .` would miss every
  trust lookup and report every workspace untrusted, which is a hard
  stop with nothing written. `--runner-mode` is self-attested: a
  script cannot read another process's launch flags and nothing in
  these inputs says a session can read its own, so what the runner
  passes is the value `companions/supervisor-runbook.md § Modes by
  seat` declares for the supervisor mode in force - `auto` under
  `Supervisor: AI`, which is the launch its § Variant A step 1 and
  § Variant B step 3 give. A runner that cannot state its launch mode
  passes `unknown`: under `--supervisor AI` that is a failed
  permission-mode assertion and so cannot-apply, the assertion being
  what an autonomous run rests on; under `--supervisor human` it is
  ignored, the assertion being dropped there anyway. Tier paths:
  `PREFLIGHT_USER_SETTINGS` (production default
  `$HOME/.claude/settings.json`), `<project>/.claude/settings.json`,
  `<project>/.claude/settings.local.json`, and `PREFLIGHT_CLAUDE_JSON`
  (default `$HOME/.claude.json`) for the trust read; the two
  environment variables exist for the test's fixture trees. The
  template is reached from the script's own directory,
  `<script dir>/../skills/dev/companions/`, which holds in this
  checkout and in the `.claude/` an adopter's `install-dev.sh` writes,
  and an unreadable one is a stop. Placeholder
  substitution moves here from `run.md § Pre-flight`, which owns it
  today: `__PROJECT_DIR__` and `__HOME__` become absolute paths without
  their leading slash, the template's rules carrying the `//` prefix
  (`Edit(//__PROJECT_DIR__/**)`, `Read(//__HOME__/.claude/skills/**)`).
  The Bash prefix set is the template's `Bash(` entries plus the
  project's `CLAUDE.md § Agent toolchain` commands. That section is
  prose bullets, so the parse is stated on the text rather than on a
  format: a candidate is a backticked span inside one of the section's
  bullets - the bullet line and the indented lines wrapping it, a
  bullet carrying more than one - and the section's own prose is not
  read, backticks and all, this repository's opening sentence citing
  `## Agent toolchain` itself in them; prose outside the backticks, a
  parenthetical or a label, is not read either. A span holding no
  space is a CLI name rather than a command ("VCS host: GitHub, CLI
  `gh`") and
  contributes no prefix of its own, the commands that CLI runs
  arriving from the other bullets; the same rule drops a one-word
  command, which no reading of the text tells from a CLI name, so a
  project declaring one states it with an argument or carries the rule
  in its tier. Every other span becomes one
  `Bash(<prefix>:*)` rule whose prefix is the span up to its first
  placeholder, trailing space trimmed. On this repository that yields
  `Bash(bash scripts/ci/run-all.sh:*)`,
  `Bash(bash scripts/test/run-all.sh:*)`, `Bash(gh pr create:*)`,
  `Bash(gh pr view:*)`
  and `Bash(gh pr merge:*)`. An absent host CLI is the push-only
  fallback of `companions/toolchain.md § Push + MR/PR`, not a gap.
  Check order: the preconditions first - `jq`, `--project`, trust, the
  `.claude/` directory, a writable local tier, a tier that parses -
  each stopping at once with no rule resolved, nothing written and its
  own remedy printed, a pre-flight that cannot read the tiers or write
  the file `--apply` targets having no report to give. Then the mode
  assertion and the never-list, then the
  carve-out pattern read and, in the same step, the deny rules it
  declares, then the non-Bash allow rules, then the Bash prefix set,
  these accumulating into the one report and the one exit. A tier's
  deny bars a needed allow rule where the deny string covers that rule
  under the same relation the allow classes use - its exact string, or
  a broader one that swallows it - so a `Bash(git:*)` deny bars the
  declared `Bash(git log:*)` while the narrow push pair, which no
  declared allow rule sits under, bars nothing; the other direction is
  no conflict, a deny narrower than a declared allow rule being the
  deliberate narrowing `toolchain.md § Permission carve-out`
  prescribes.
  Pattern 1's pair needs `<default>` and pattern 2 never asks for it,
  so the resolution sits inside the pattern-1 branch and an
  unresolvable default branch stops no pattern-2 session. It resolves
  in the project's repo as `is_trunk` in
  `hooks/dev-branch-guard.sh` resolves it up to its
  literal fallback: `git -C "$project" symbolic-ref --short
  refs/remotes/origin/HEAD` with its `origin/` stripped, else
  `git -C "$project" config init.defaultBranch`, and neither
  resolving is the cannot-apply above with the remedy
  `git remote set-head origin --auto` printed - the guard's
  `main`/`master` fallback stays the guard's, a tripwire that fails
  open being free to guess where a gate that must name one string is
  not. This checkout resolves through the second step (`origin/HEAD`
  is not a symbolic ref here; `init.defaultBranch` is `main`), and
  every fixture pins the first with
  `git -C <fixture> symbolic-ref refs/remotes/origin/HEAD
  refs/remotes/origin/main`, which resolves with no remote configured
  and keeps the test host's `init.defaultBranch` out of the expected
  string. The assertion's launch-mode half is `--supervisor AI`'s
  alone; its tier comparison runs under both supervisor modes, a key
  drifting mid-run being no less a defect where a human supervises.
  That comparison is the half the script can decide, the one check
  that reads anything but the
  working-tree files, and each tier resolves its own repo rather than
  assuming the project's. It runs only for a tier whose file exists -
  a tier that does not exist has no value to print and takes no line -
  so the canonicalization's `cd` always has a directory to reach; the
  script runs under `set -uo pipefail` and never `set -e`, every stop
  being an explicit exit. The tier path is canonicalized first,
  `tier="$(cd "$(dirname "$tier")" && pwd -P)/$(basename "$tier")"`,
  because the strip below is textual while `--show-toplevel` returns a
  physical path, so a symlinked `$HOME` would otherwise leave `rel`
  absolute; then `top=$(git -C "$(dirname "$tier")"
  rev-parse --show-toplevel)`, then `rel=${tier#"$top"/}`, then
  `git -C "$top" ls-files --error-unmatch "$rel"` to say whether it is
  tracked, then `git -C "$top" show "HEAD:$rel"` for the tracked
  value. That is what lets the user tier be tracked here, where
  `$HOME/.claude/settings.json` is this repository's own
  `settings.json`, and untracked in an adopter. Three verdicts, and
  only the middle one is a defect: `unchanged` passes, `drifted`
  is the failed permission-mode assertion on the cannot-apply list,
  and `untracked` passes with the tier's value printed, there being no
  tracked value to have drifted from. Every failure in that sequence
  lands on `untracked` - none on `drifted`, and none on the
  cannot-apply list's "cannot read the tiers", which is about the tier
  files the rest of the script reads: a tier under no repository,
  whose `rev-parse` fails; a tier `ls-files` calls untracked; and a
  tier staged but never committed, which `ls-files` calls tracked
  while `show "HEAD:$rel"` exits 128 (`exists on disk, but not in
  'HEAD'`, or `invalid object name 'HEAD'` where the repository has no
  commit yet), so the verdict keys on the non-zero exit and not on the
  message. A tier already in `HEAD` carrying a staged edit is not that
  case: `show` returns its committed value and the comparison runs
  against it as always. A present `defaultMode` is never
  a defect on its own. Every report line is one status in a padded
  first column and one subject. The statuses are
  `present (user|project|local)`, `missing`, `inert (auto)`,
  `applied (local)`, `unchanged`, `untracked`, `ok` and
  `cannot apply: <reason>`; the subject is the declared rule where the
  line resolves one, and otherwise the check's own name - `workspace
  trust`, `permission mode`, `mode key (<tier>): <value>`,
  `never-list`, `carve-out pattern <n>`, `local tier`, `tier read` -
  which is what gives a check that resolves no rule its line. A remedy
  is no status: the remedies print after the report under one
  `remedy:` header, which is where the `--apply` line and the
  missing-deny tier edit land. So pattern 2 under `Supervisor: AI` is
  two lines rather than one overloaded status - the entry's own
  `present (<tier>)` and the pattern's `cannot apply:` - and the test
  pins both. Where a cannot-apply verdict stands nothing is written
  and only its remedies print, the `--apply` line waiting on the
  re-run the user's tier edit precedes; where `--apply` does write,
  the lines it closed read `applied (local)` and the run exits zero.
  The tiers are searched in the order `user`, `project`, `local` and the
  status names the first that carries the rule, so a rule two tiers
  carry is one line naming one tier; `missing` is the whole of the gap
  status, no tier being named for a string no tier holds. Test
  cases, fixture trees under `mktemp -d` (untrusted by construction,
  which is what makes case 1 free): an untrusted tree reports
  cannot-apply, stops and writes nothing; a full set exits zero with
  every line naming its tier, which is the toolchain parse's case too,
  its fixture `CLAUDE.md` carrying a plain bullet span, a placeholder
  span, a lone CLI name, a backticked section cite in the section's
  own prose and a span in the section after it, of which only the
  first two become rules; a missing non-Bash rule is reported and
  then written by `--apply` with the file's other keys intact; a re-run
  after `--apply` exits zero; a tier's `Edit(//<root>/**)` covers a
  declared child path and is not rewritten; an absent Bash prefix is
  inert and exits zero under `--supervisor AI` and missing and non-zero
  under `--supervisor human`; pattern 2 is accepted under `human` and
  cannot-apply under `AI`; a project tier carrying pattern 1's narrow
  pair satisfies the declared deny and is not reported as missing the
  blanket rule; a tier carrying neither pattern's deny set is
  cannot-apply and `--apply` writes no deny; the untracked local tier
  carrying the pair alone satisfies it, both lines reading
  `present (local)` and the run exiting zero, which is the shape a
  provisioned worker arrives in (the shipping item); a tracked project
  tier whose working-tree `deny` carries the pair while its committed
  content carries none satisfies it too, no rule reading git state; a
  tier staged and never committed passes, its `deny` satisfying and
  its `defaultMode` printed as untracked, which pins the `show`
  exit-128 route; a user tier carrying `Bash(git push:*)` beside a
  project tier carrying the narrow pair is pattern 2 satisfied from
  the user tier, accepted under `human` and cannot-apply under `AI`; a
  rule two tiers carry is one line reading `present (user)`;
  `--runner-mode unknown`
  is cannot-apply under `AI` and ignored under `human`; a tier whose
  `defaultMode` drifted from its tracked value is cannot-apply while
  an untracked tier passes with its value printed;
  `bypassPermissions` in a tier is
  cannot-apply; an unwritable local tier is cannot-apply. Both files
  stay within `scripts/ci/check-code-size.sh`'s 300-line file cap and
  50-line function cap; `scripts/test/run-all.sh` picks the test up by
  its glob, so `Test (full)` runs it with no wiring.

- [x] The runner runs the script and routes what it cannot predict:
  `run.md § Pre-flight`'s permission bullet becomes the script's
  invocation in report mode before the first dispatch, its report the
  pre-flight's, a gap stopping the run and printing the `--apply` line
  for the **user** to run, since workspace trust and the settings
  surface are host gates no seat clears (`run.md § Seats`, the asked-of
  row). The same section's plan check names that surface instead of the
  config directory: "No plan in scope names a target under `.claude/`"
  reads as the settings files, `~/.claude.json` and whatever of
  `hooks/` R080-T011 leaves withheld, citing the config paragraph of
  `agents/dev-implementer.md` as that task leaves it rather than
  restating it, every other path under the config directory being
  tracked source a plan may name. What the check refuses is a plan
  item that hands a **seat** a target on that surface; an item naming
  the **user** as the target's writer is admitted and halts to the
  user when it is reached, resuming on the user's commit - so the
  scope-level refusal and the item-level halt divide by who the item
  says writes the file, and this plan's own guard item, which names
  the user for a withheld `hooks/`, is admitted.
  `§ Dispatch per item`'s prompt paragraph carries the two classes the
  ledger needs (`§ Ledger`): a pre-flight defect, which is a gap in the
  mode-independent set, halts the item, is fixed in
  `companions/seat-permissions.md` and is cleared by nobody; and a
  classifier event under `auto`, which no seat but the one it happened
  to can see - the denial lands inside a dispatched seat's own `Bash`
  call and the seat's only channel is its report, whose statuses
  (`companions/implementer-prompt.md § Report Format`) carry no
  classifier class - so no retry is the runner's to hold. The seat
  reshapes the command per `companions/supervisor-runbook.md
  § Failure modes` and re-runs it itself; where it cannot, it reports
  BLOCKED with the classifier's text, which halts the item to the user
  as any blocker does (`branch-plan.md § Stop conditions`), and the
  runner ledgers it as a `prompt` event (`§ Ledger`). Nobody clears
  it, and no count of events is kept anywhere. The compound-command rule
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
  `scripts/ci/check-caps.sh` holds mode files to, so the edit is net-zero
  and budgeted: § Pre-flight's first bullet goes from 9 lines to 4, naming
  the script by the one path rule that resolves in both readerships -
  `<config>/scripts/`, the directory the toolset is installed into, which
  is `scripts/` in this repository and `.claude/scripts/` from an
  adopter's project root, glossed once in `companions/seat-permissions.md`
  where `run.md` has no room for it - then `--project .` (the script
  canonicalizes it), `--supervisor <declared>`, `--runner-mode <the
  runner's launch mode>`, the tier-naming report, the `--apply` line for
  the user and the surviving "No toolchain section → halt, ask"; the
  placeholder-substitution clause and the VCS-host-CLI clause go with the
  bullet, the first to the script and the second to
  `companions/toolchain.md § Push + MR/PR`, which already carries the
  absent-host fallback and gains the sentence that an absent CLI is that
  fallback rather than a permission gap. Of the five lines that frees, the
  settings-surface bullet takes two for the seat-versus-user split and
  § Dispatch per item's closing paragraph the other three, going from 3
  lines to 6: the two class names with their routes in one sentence each
  and the mode-conditional shaping rule, citing
  `companions/seat-permissions.md § Prompt classes` for the reasoning
  behind the classifier route, since a companion is exempt from both caps
  and `run.md` is not. The settings surface is named and never restated:
  `agents/dev-implementer.md`'s config paragraph, as R080-T011 left it,
  withholds the four settings files and `~/.claude.json` alone, so
  `hooks/` is tracked source a plan may name. Measured with `wc -l` and
  `check-caps.sh` after the three passages: the file lands back at 300.
  The findings' three notes on this item settle as one route. (a) The seat
  follows `§ Failure modes` as it stands rather than a reshape written
  over it: a denial proper is retried once, identical, per its third
  entry, and only a "could not evaluate" is answered by rewriting the
  call, per its first. So `run.md` reads "the seat's to handle" rather
  than "reshapes"; the third entry stays and gains its exit, a seat's
  second denial being its BLOCKED report and the runner's own denied
  command halting the run; and "no count of events is kept anywhere" is
  the run's tally, the one retry sitting inside the call the seat is
  already in. (b) That instruction reaches the seat through a file the
  seat does read: `companions/implementer-prompt.md` gains § A Denied
  Call, the dispatch companion being this branch's to change. The other
  seats' companions are left alone - an untold seat's route is the same
  BLOCKED report, one retry poorer. (c) A classifier BLOCKED is neither of
  `branch-plan.md § Stop conditions`' two blocker rows, so the table gains
  its own: halt and report, the item's work standing and no planner
  dispatched, which is what `run.md`'s "the work intact (§ Checkpoint)"
  points at. A denial of the runner's own command takes the same route,
  stated in `companions/seat-permissions.md § Prompt classes`, whose class
  also widens from a seat's `Bash` call to any call of the seat's - a
  classifier denial of an `Edit` is what this branch's own dispatch met.
  The duty table's prompt row reads "nobody: a pre-flight defect halts the
  item; a classifier denial reaches the user as the seat's BLOCKED report
  (§ Dispatch per item)" in its `Supervisor: human` cell and keeps `the
  same` in the other, table rows being exempt from the column limit. In
  the runbook, a companion and so exempt from both caps: § Modes by seat's
  auto-mode paragraph gains the `companions/seat-permissions.md` cite and
  the sentence that the mode-independent set, not the suspended Bash
  rules, is what a promptless run rests on, its `bypassPermissions` /
  `dontAsk` and "Deny rules survive auto mode" paragraphs kept as that
  set's own never-list and cited to the declaration; § Failure modes'
  transcript-overflow entry gains "under `Supervisor: AI` nobody in the
  pane can answer it: escalate to the user over Remote Control", and its
  `defaultMode` entry reads as a mode key drifting from its tracked value
  after a run starts, a key that is part of the tracked value not being a
  defect. `Keystroke authority` stays the bolded paragraph closing § tmux
  recipes: its no-key-past-a-permission-prompt sentence reads as the two
  classes above with the manual-approval fallback beside them, and its
  other two rules - the user must not type instructions into the runner's
  box, and a keystroke is not the fix for a deadlock - stand unchanged.
  § Two variants and § tmux recipes are otherwise untouched: the variants
  table has no who-clears-prompts row and the recipes hold three code
  blocks, capture-pane and two until-loops, with no send-keys recipe to
  drop.

- [x] The script ships to adopters, so an adopter's `run.md` does not
  name a script its checkout lacks: `scripts/install-dev.sh` copies
  `preflight-permissions.sh` and its self-test alongside the four
  checks and two self-tests it already copies, `LAYOUT.md` gains the
  script's node, and `scripts/worker-workspace.sh` records why its
  wholesale write of `.claude/settings.local.json` and the pre-flight's
  merge into the same file do not collide, and what a provisioned
  worker's pre-flight reads in it. `settings()` does not ship the
  template's `deny` as it stands: its `jq` filter replaces it with
  pattern 1's pair, `.permissions.deny = ["Bash(git push origin
  main:*)", "Bash(git push --force:*)"]`, so a worker's session is on
  pattern 1 rather than the template's pattern 2 and its seeded local
  tier satisfies both entries - `present (local)` under the first
  item's rule, which reads the tier's working-tree file and asks
  nothing of git - which is how a worker passes the gate under
  `Supervisor: AI` with nothing committed and no user at the keyboard.
  The seed spells that default branch as the literal `main`, so a
  project whose default branch is something else has the pair's first
  entry reported missing against the `<default>` the script resolves,
  and the seed's string is that project's to change. A project whose
  own tracked tier carries the blanket `Bash(git push:*)` is pattern 2
  on the worker all the same, the seeded pair adding to that deny
  rather than replacing it, and that is a true cannot-apply under
  `Supervisor: AI`: the project narrows its tracked deny
  (`toolchain.md § Permission carve-out`) before a worker runs.
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
  every node in the file puts at 34 characters and the 24-character name
  reaches with two spaces; the test needs no
  line, the
  `scripts/test/*.test.sh` pattern line covering it, and
  `check-stray.sh` matches first-level nodes only, so the fast tier is
  green before and after. `worker-workspace.sh`'s `settings()` comment
  (lines 133-138) gains two sentences: the wholesale `>` write is the
  seed, written once on a fresh VM checkout before any run, and the
  pre-flight's `--apply` merges into the same file afterwards, so the
  two never race; and the pair the `jq` filter writes into `deny` is
  the worker's carve-out, the strings the pre-flight resolves pattern
  1's declared entries against, which a project whose default branch
  is not `main` changes here. The second sentence states the tier order
  rather than the acceptance's `present (local)`: each entry is reported
  against the first tier that carries it, so a project whose own tracked
  tier already carries the pair - as this repository's does - is answered
  from there and the shipped comment does not claim otherwise (findings,
  the item-4 note). The template's name and shape are unchanged by this
  branch - only its entries move (first item) - so line 143's read and
  case 13 of
  `scripts/test/worker-workspace.test.sh` keep passing untouched.

- [ ] The declared set names the verbs the run runs, so no step of a
  `/dev run` raises a prompt under `Supervisor: human` that the set does
  not predict - "the run" of `requirements.md § Desired state` 8, which
  is the bound: `run.md` from § Pre-flight through § Merge or ask,
  `finish.md`, which `run.md § Close` invokes, the note
  `handoff.md § Writing the note` has the runner append at § Monitor,
  and the companions those steps and the seat dispatches send a command
  to. Inside that bound the Bash prefix set and the template's `allow`
  gain `Bash(git checkout:*)` and `Bash(git pull:*)`, traced to
  `finish.md § 4` step 1's "Sync the default branch (`git checkout
  <default>`, `git pull`)" and `finish.md § 3`'s discard entry into the
  default branch; `Bash(git check-ignore:*)`, traced to
  `companions/untracked-claude.md § Detection`, which `finish.md § 1`'s
  bookkeeping line reaches; `Bash(git grep:*)`, traced to
  `companions/verification-policy.md`'s negative-search rule, the
  instrument the spec reviewer and the docs verifier are sent to
  (`companions/spec-reviewer-prompt.md`, `agents/dev-docs-verifier.md`);
  and `Bash(mkdir:*)`, `Bash(date:*)` and `Bash(printf:*)` for the
  ledger the runner keeps itself (`run.md § Ledger`: `mkdir -p` at
  § Resolve, the timestamp read from `date -u` at write time, the
  append through `printf '%s\n' ... >>`) and for the stamp
  `handoff.md § Writing the note` spells,
  `date -u +%Y-%m-%dT%H:%M:%SZ`. No flow step is respelled to match a
  rule. `Bash(printf:*)` is a write-capable verb in a run-wide set, as
  `Bash(echo:*)` already is: both are declared for the runner's own
  appends, the bar on edit-class shell against the plan files and the
  config directory standing where `agents/dev-implementer.md` writes
  it, so the row widens the class `echo` opened rather than opening
  one, and § Bash prefix set's closing paragraph names the pair beside
  the read and search verbs. Declaring the HEAD-moving verbs is safe by
  this plan's own argument: no deny entry of the declared set names
  one, and a deny decision from `hooks/dev-branch-guard.sh` overrides
  an allow rule, so the four shapes § HEAD moves and whole-tree
  discards refuses stay refused. The `Bash(git switch:*)` row stays,
  traced to `run.md § Pre-flight`'s branch cut off the default: that
  step spells no verb, so both verbs that cut a branch are declared,
  `git checkout -b` and `git switch -c`, the step's need being the
  trace and the guard's second shape judging the two spellings alike.
  So § Bash prefix set and § HEAD moves and whole-tree discards stop
  disagreeing about which verb `finish.md` runs.
  The checkpoint push is declared where a declaration can bind it:
  pattern 1 declares, beside its narrow deny pair, the allow block
  `toolchain.md § Permission carve-out` 1 prints - one
  `Bash(git push -u origin <prefix>/*)` per prefix of
  `git-workflow.md § Trunk` except `release`, eight strings - that
  block being the list's one home, which `scripts/worker-workspace.sh`'s
  seed already copies and this repository's `.claude/settings.json`
  carries with a ninth, `release/*`, an extra allow no declared set
  reads. `release/` is absent because its branch is pushed by
  `release.md` step 10, outside a run and under `release.md § Rules`'
  bar on auto-push: the user's own keystroke, no rule needed. The
  block's `Bash(glab mr create:*)` is no push string: it is the
  change-request command's rule, which enters the set through
  `CLAUDE.md § Agent toolchain` (the script item). The strings trace to
  `finish.md § 3` step 2's `git push -u origin <branch>` at
  `run.md § Checkpoint`'s accept. Each carries a `<prefix>/`, so it
  reaches neither a push to the default branch, whose name carries no
  prefix, nor a force push, and the guard's push scan refuses both in
  any spelling besides. Pattern 2 declares none of them: its blanket
  deny beats every allow across all tiers, so its checkpoint push stays
  the one manual push per batch that pattern is
  (`toolchain.md § Permission carve-out` 2), and a declared allow every
  pattern-2 tier denies would turn every pattern-2 session into a
  cannot-apply. These are Bash prefix rules like the rest, binding
  under `Supervisor: human` and inert under `auto`, and no seat
  definition and no § Seat tool sets row changes: the push is the
  runner's own step under the fourth source, so `branch-plan.md
  § Rails`' "Seats never push" stands as written.
  Two commands inside the bound stay undeclared, each named with its
  reason, a named exclusion being a prompt the set predicts. The
  removal of the untracked files at `run.md § Question resolution`
  spells no verb, and the verb that would do it, `git clean`, discards
  untracked work with no guard branch reading its arguments: the step
  stays undeclared until the verb is chosen with its guard (the final
  item's backlog line), and under `Supervisor: human` its prompt is the
  user's to answer. The remote half of the branch deletion at
  `finish.md § 4` step 4, `run.md § Checkpoint` and `branch-plan.md
  § Rails` rides the declared merge command where that command carries
  `--delete-branch`, as this repository's `CLAUDE.md § Agent toolchain`
  Merge line does; a project whose merge command lacks the flag deletes
  the ref by a push (`git push origin --delete <branch>`) that no
  `<prefix>/` string matches and that this plan declares no string
  for, a push string being a carve-out entry `toolchain.md § Permission
  carve-out` states or does not (the final item's backlog line). The
  local half is `git branch -d|-D`, which `Bash(git branch:*)` covers,
  and the tag deletion at accept is `Bash(git tag:*)`'s. Outside the
  bound are the flows a run never enters - `release.md`, `migrate.md`
  and the companions only they reach (`root-migration.md`,
  `legacy-migration.md`) - user-attended by their own text:
  `release.md § Rules` bars auto-tag and auto-push, and a migration
  blocks on the user at each section. Their `git describe`, tag push,
  `release/` branch cut, `git ls-files` and `git mv` prompt where no
  tier carries them, and the user at the keyboard answers. § Bash
  prefix set states the bound and how the set stays whole within it:
  it is walked in both directions, every declared rule traced to a
  step or a dispatch companion and every command a step in the bound
  runs traced to a rule or to the exclusion list, the one-directional
  walk being what left the run's own verbs undeclared.
  Approach: `skills/dev/companions/auto-permissions.template.json` gains
  `Bash(git checkout:*)` and `Bash(git pull:*)` beside
  `Bash(git switch:*)`, `Bash(git check-ignore:*)` and
  `Bash(git grep:*)` beside `Bash(git rev-parse:*)`, and `Bash(mkdir:*)`,
  `Bash(date:*)` and `Bash(printf:*)` in the shell-command group beside
  `Bash(echo:*)`; its `deny` is untouched, and the push allow is no
  template entry, being pattern 1's alone and pattern 2 the template's
  starting point (the script item below resolves it).
  `seat-permissions.md § Bash prefix set` gains one table row per new
  rule with its source named as file and section, one row for the push
  block naming `toolchain.md § Permission carve-out` 1 as the strings'
  home rather than listing them, with `finish.md § 3` step 2 at
  `run.md § Checkpoint`'s accept as its source; rewrites the
  `Bash(git switch:*)` row's source to the ruling above; takes the
  bound, the both-directions sentence and the exclusion list with its
  reasons as paragraphs after the table's closing paragraph; and that
  closing paragraph names `echo` and `printf` as the write-capable pair
  beside the read and search verbs. § Mode-independent set's carve-out
  paragraphs gain the sentence that pattern 1 declares the
  checkpoint-push allow block beside its deny pair while pattern 2
  declares neither, pointing at the § Bash prefix set row rather than
  repeating the strings. § HEAD moves and whole-tree discards is
  untouched, its `Bash(git checkout:*)` sentence being about the deny
  that stays absent; § Machine-readable form's sentence "Its `allow`
  keeps `Bash(git switch:*)` and `Bash(git restore:*)`" is rewritten to
  name `Bash(git checkout:*)` with them, the reasoning after the colon
  standing. `toolchain.md § Permission carve-out` 1's "Cover the
  prefixes the project actually uses" paragraph gains one sentence: the
  block is the run's push prefixes, one per prefix of
  `git-workflow.md § Trunk` except `release`, whose branch `release.md`
  step 10 pushes by hand. `worker-workspace.sh`'s seed (lines 179-182)
  is unchanged, already those eight. The template stays a valid
  settings object (`jq -e .`), and the three files are the one
  declaration in its prose and machine-readable forms
  (§ Machine-readable form), so they land in one commit rather than a
  template entry standing untraced or a traced row with no machine
  form.

- [ ] § What enforces what says what the pre-flight reports: under
  `Supervisor: AI` an absent Bash prefix rule reports `inert (auto)` and
  never stops the run, while a rule a tier carries still reports
  `present (<tier>)` naming that tier, so the file no longer reads as
  the whole Bash prefix set being reported inert. The script is
  unchanged, `resolve` reaching its `inert` line only after no tier
  answered; the test pins the half it does not yet: its inert case
  asserts an absent prefix under `--supervisor AI`, and no case asserts
  a carried one reading `present (<tier>)` there, so case 6 gains that
  assertion.
  Approach: the Bash prefix set bullet in § What enforces what of
  `skills/dev/companions/seat-permissions.md` is one sentence carrying
  both the over-strong wording ("the pre-flight reports it inert") and
  the clause that stands (its absence never stops a run, a user tier's
  Bash entries being the human-supervised path), so the sentence is
  rewritten, not extended by a clause: an absent rule is reported inert
  and a carried one present with its tier, the standing clause kept. In
  `scripts/test/preflight-permissions.test.sh` case 6, after the
  `--supervisor AI` run, one
  `want "present (project) Bash(git status:*)"` line beside the
  `inert (auto)` assertion.

- [ ] The pre-flight resolves the rules the template declares for every
  project path, one carrying `&` or `|` included: a project at
  `.../fx2/a&b` yields `Edit(//private/tmp/.../fx2/a&b/**)`. Today's
  `sed -e "s|__PROJECT_DIR__|...|g"` expands `&` to the whole match and
  yields `Edit(//.../fx2/a__PROJECT_DIR__b/**)`, which `--apply` writes
  into the local tier and then reads back `present`, so the gate passes
  with the real `Edit` grant never made, and a `|` in the path or in
  `$HOME` breaks the delimiter outright - the opposite of the
  convergence item 2 states. The case is pinned before it is fixed: the
  test gains a fixture whose project path carries `&` in a segment,
  asserting the reported `Edit` rule spells that fixture's own path and
  that `--apply` then a re-run exits zero, and it is observed failing
  first.
  Approach: in `scripts/preflight-permissions.sh` the two-line read at
  lines 243-244 becomes the `jq -r` read on its own line and the two
  substitutions on the next,
  `declared=${declared//__PROJECT_DIR__/${project#/}};
  declared=${declared//__HOME__/${HOME#/}}` - bash leaves `&` inert in a
  replacement and has no delimiter to break (probed on this host,
  including `/bin/bash` 3.2). Net-zero against
  `scripts/ci/check-code-size.sh`'s 300-line file cap, which the script
  stands short of, and no `code-size-allow.txt` entry is taken. In
  `scripts/test/preflight-permissions.test.sh` `newfix` hardcodes
  `PROJ="$FIX/proj"` (line 30), so it takes an optional project
  directory name, `PROJ="$FIX/${1:-proj}"`, its other callers
  unchanged, and the case calls `newfix 'a&b'`, reusing the existing
  full-set assertions rather than a new shape.
  Measured with `wc -l` and `bash scripts/ci/run-all.sh`.

- [ ] Under carve-out pattern 1 the pre-flight resolves the
  checkpoint-push allow block the declaration item states, so the push
  `finish.md § 3` step 2 makes at `run.md § Checkpoint`'s accept is
  settled before the first dispatch like every other declared command
  (`requirements.md § Desired state` 8). Under `Supervisor: human` the
  report says whether that push runs on a declared rule or prompts;
  the prompt there is answerable, the accept being the user's own
  choice (`run.md § Checkpoint`), but a rule left to be discovered at
  accept is the pre-flight defect § Prompt classes names, so a missing
  string halts and prints its remedy as any missing Bash prefix rule
  does. Under `Supervisor: AI` the strings are inert, `auto` suspending
  Bash allow rules and the classifier judging the push, and their lines
  stand in the report for the record. Each string reports per tier
  like every other Bash rule: `present (user)` in this repository,
  whose user tier - the tracked `settings.json` at the checkout root -
  carries `Bash(git push:*)` in `allow` and so covers every string
  under `covers()` ahead of the project tier's own copies;
  `present (project)` in a fixture whose user tier is empty; `missing`
  with the `--apply` line where a pattern-1 project lacks one; and
  `inert (auto)` under `Supervisor: AI`. The allow half's remedy is the
  `--apply` line, writing the local tier as for every missing allow
  rule: the tracked project tier is where the strings belong for the
  next clone (`toolchain.md § Permission carve-out` 1's placement), and
  that move is the route the script item states for a rule that proves
  durable - the project's own change, the shadowed local copy then
  deleted at `MAINTENANCE.md § Generalize allow rules` step 5 - rather
  than a second remedy shape; the deny half keeps its tracked-tier
  remedy, `--apply` writing no deny. A pattern-2 session declares none
  of them and its report is unchanged.
  Approach: `carve_out`'s pattern-1 branch in
  `scripts/preflight-permissions.sh`, after its `say ok`, appends one
  `Bash(git push -u origin <p>/*)` for each of the eight prefixes
  `toolchain.md § Permission carve-out` 1 lists
  (`batch doc feat fix refactor mnt test plan`) to the global `declared`
  in a single-line `for` loop; `carve_out` runs at line 275, before the
  Bash prefix loop reads `declared` at lines 282-285, and pattern 2
  returns at line 128 ahead of the append. The list's home is that
  section, which the function's existing header comment already names,
  so the file takes one line and stays inside the 300-line cap after
  the item above. In `scripts/test/preflight-permissions.test.sh`,
  `sat()` (lines 49-54) appends the same eight strings to the `allow`
  it builds: every satisfying tier is built from the template, which
  does not carry them, so without that case 2's `nowant "missing"`,
  case 5's `[ ! -f "$LT" ]`, case 6b's second half and case 15's human
  run fail once the strings are declared; under a pattern-2 fixture
  they are extra allow entries no declared set reads, so case 7's
  `nowant` holds. Then three assertions on the existing fixtures rather
  than new trees: case 2's full set reads
  `present (project) Bash(git push -u origin batch/*)`; a pattern-1
  fixture with the strings deleted from its project tier
  (`edit "$PT" 'del(.permissions.allow[] |
  select(startswith("Bash(git push -u origin")))'`) reports
  `missing Bash(git push -u origin batch/*)` with the `--apply` line
  under `--supervisor human` and `inert (auto)` under `AI`; and case
  7's pattern-2 report carries no `git push -u origin` line.

- [ ] The shipped self-test runs where it ships: it resolves its
  subject and the template from `${BASH_SOURCE[0]}` rather than from
  `git rev-parse --show-toplevel`, so under
  `<project>/.claude/scripts/test/` it finds
  `<project>/.claude/scripts/preflight-permissions.sh` and
  `<project>/.claude/skills/dev/companions/auto-permissions.template.json`
  - `install-dev.sh` copies `skills/dev` wholesale, so the companion
  tree is there - while in this checkout the same two levels up from
  `scripts/test/` stay the repository root. Today the copy fails where
  item 4 ships it, its `git rev-parse` answering the adopter's
  repository root instead of their `.claude/`. The pin holds it there:
  `install-dev.test.sh`'s BASH_SOURCE assertion covers every copied
  self-test rather than the two it names, and that file stays within
  `check-code-size.sh`'s 300-line cap, which it currently sits on.
  Approach: `ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)`
  replaces line 14 of `scripts/test/preflight-permissions.test.sh`,
  `SCRIPT` and `TPL` below it unchanged, matching
  `scripts/test/check-accretion.test.sh:11` and
  `check-batch-tags.test.sh:12`. In `scripts/test/install-dev.test.sh`
  the two chained `grep -q 'BASH_SOURCE'` lines at 43-44 become one
  condition over the copied directory,
  `[ -z "$(grep -L BASH_SOURCE "$P"/.claude/scripts/test/*.test.sh)" ]`,
  keeping the `pass`/`die` pair below it and leaving the file one line
  shorter than it is today, so the pin is afforded with room to spare
  (`grep -L` prints the files without the match; probed empty when all
  match). Measured with `wc -l` and `bash scripts/ci/run-all.sh`, and
  the shipped copy is exercised by running the installed test from a
  `--project` install tree.

- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine`, `bash scripts/ci/run-all.sh` green, cleanup, mark the plan
  complete, mark the task `[x]` in `tasks.md`, commit. The same commit
  adds five lines to R080's backlog in `tasks.md`, this close's
  leavings, each naming what and why. `hooks/dev-branch-guard.sh`'s
  HEAD-move scan splits a command textually
  (`hscan="${cmd//$'\n'/;}"`), so a
  `git commit -m "...git reset --hard..."` or a heredoc whose body
  carries a reset line is refused though nothing destructive runs, and
  the header promises fail-open; the push scan has the same class, so
  the fix is a shared segment splitter rather than a patch here.
  `git clean -fd` discards untracked work the way the four denied
  shapes discard tracked work and is reached by no declared rule and no
  guard branch, which is why the halt's untracked-file removal at
  `run.md § Question resolution` stays undeclared (the declaration
  item's exclusion list) until the verb lands with its guard branch.
  The remote half of a branch deletion outside the merge command's
  `--delete-branch` (`finish.md § 4` step 4) is a push no declared
  string reaches, a delete-push string being a carve-out entry
  `toolchain.md § Permission carve-out` does not state; the same list
  names it. `scripts/preflight-permissions.sh` chmods the local
  tier 644 unconditionally after the `mv` from a 0600 `mktemp`,
  relaxing a deliberately restrictive mode where it should capture the
  existing file's mode and restore it, defaulting to 644 where the file
  did not exist. `branch-plan.md § Commit cadence` 3 cites
  `git-workflow.md § Commit messages`; `companions/implementer-prompt.md`
  does not, and that companion is the seat's own instruction sheet, the
  one file an implementer certainly reads, so an implementer seat
  invents the body convention: four messages drifted in this run while
  `branch-plan.md` carried the cite, and none once a dispatch named the
  rule.
