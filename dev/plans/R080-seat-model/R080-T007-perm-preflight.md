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

- [ ] `companions/seat-permissions.md` declares the run's permission
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
  character its own header comment claims for the file. Its three
  reason lines carry the predicate and the rule:
  `branch-guard: refusing '<cmd>' - it enters the default branch of
  '<repo>' with uncommitted work; commit or discard first, and a
  dispatched seat stays on the item's branch (run.md § Seats).`,
  `branch-guard: refusing '<cmd>' - it discards work no 'git stash
  pop' and no reflog bring back; commit first, or take a spelling that
  keeps it: 'git reset' without '--hard', 'git stash push'
  (run.md § Seats).` and
  `branch-guard: refusing '<cmd>' - it discards every uncommitted
  change under '<pathspec>'; name the paths to restore, and leave the
  whole-tree revert to the runner's halt (run.md § Question
  resolution).` The guard is a host gate rather than a
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
  with `<default>` the repo's own default branch name, and each entry
  is satisfied only by that exact string in a tracked tier's `deny`.
  The pattern is read from the tiers, never taken from a flag or from
  this text: a tracked `deny` carrying the blanket entry is pattern 2,
  one carrying both narrow entries is pattern 1, one carrying the
  blanket entry among others is pattern 2 (deny beats allow, so the
  blanket one governs), and one carrying neither is the missing-deny
  gap. Extra deny entries beyond the pattern's are never a gap. This
  repository is on pattern 1, its tracked `.claude/settings.json`
  carrying the pair.
  Approach: new companion `skills/dev/companions/seat-permissions.md`,
  sectioned § What enforces what (the split, and the permission-mode /
  supervisor-mode terminology above), § Mode-independent set (a table:
  rule, class, and which of the four sources it traces to, named as
  the file and section),
  § HEAD moves and whole-tree discards (the guard's predicate and its
  three reason lines, why a hook and not a deny, the forms it passes,
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
  cadence`, `git switch|restore|merge|tag` to the `skills/dev/` steps
  that run them, `echo` to `§ Commit cadence` point 4, the `/tmp`
  read and edit rules to `agents/dev-implementer.md § Scratch & Probe
  Scripts`, the `Read(//__HOME__/.claude/...)` rules to the dispatch
  companions that name those trees, and `gh pr view` / `glab mr view`
  to `CLAUDE.md § Agent toolchain`'s State-check line.
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
  or an unresolvable target, the file failing open throughout. The
  dirty-tree test is
  `git -C "$dir" status --porcelain --untracked-files=no`, non-empty
  meaning dirty. The reset/stash branch needs no repo at all, being a
  token read over the segment - `--hard`, `--merge`, `--keep` after
  `reset`; `drop`, `clear` as the word after `stash` - so it sits
  first, ahead of anything that resolves a path. The whole-tree
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
  independently. The file is at 261 lines of `check-code-size.sh`'s
  300-line cap, so 39 lines carry the three branches, the helper, the
  header sentences and the reason strings; each function stays inside
  the 50-line function cap, which binds the helper and not the `Bash)`
  case body. Measure with `wc -l` after writing, and where it
  overruns, the file takes a `scripts/ci/code-size-allow.txt` entry
  reasoned "PreToolUse hook registered by path; one file by
  construction" rather than the reason strings being cut short. Its
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
  `run.md` stays at 300. The runner item's edits are at lines 69-81
  and 117-119, so the two do not touch the same lines.

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
  string match. A deny rule is the one class no coverage rule reaches:
  it is satisfied only by its exact string in a tracked tier's `deny`,
  and which deny strings are declared is the carve-out pattern the
  first item states, read off those same tiers - so a tier on pattern
  1 satisfies the declared set with its narrow pair and is never
  reported as missing the blanket rule, and a tier with neither
  pattern's set is the missing-deny gap. Cannot-apply, each exiting
  non-zero with nothing written: an untrusted workspace, a needed
  allow rule a tracked tier denies, a missing deny rule, pattern 2
  under `Supervisor: AI`, `bypassPermissions` or
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
  step 5, never by the script. Where a stopped run resumes is stated
  with the stop: the halt is `run.md § Pre-flight`'s, before the first
  dispatch, with no branch created and no edit made, so the **user**
  runs the printed `--apply` line and the run resumes by re-entering
  § Pre-flight from its first bullet - the script's own re-run is what
  proves the apply landed and the remaining pre-flight checks have not
  run yet - while § Resolve's scope, supervisor and ledger stand and
  are not redone. That the user runs `--apply` rather than the
  pre-flight applying it is this plan's one deviation from
  `requirements.md § Desired state` 8, and it is a deviation in actor
  only: the adjustment still lands before the first dispatch, but
  `.claude/settings.local.json` is on the settings surface no seat
  writes (`agents/dev-implementer.md`, its config paragraph;
  `run.md § Seats`, the asked-of row), so the runner proposes and the
  user applies. Its test is
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
  environment variables exist for the test's fixture trees. Placeholder
  substitution moves here from `run.md § Pre-flight`, which owns it
  today: `__PROJECT_DIR__` and `__HOME__` become absolute paths without
  their leading slash, the template's rules carrying the `//` prefix
  (`Edit(//__PROJECT_DIR__/**)`, `Read(//__HOME__/.claude/skills/**)`).
  The Bash prefix set is the template's `Bash(` entries plus the
  project's `CLAUDE.md § Agent toolchain` commands. That section is
  prose bullets, so the parse is stated on the text rather than on a
  format: every backticked span inside the section is a candidate, a
  bullet may carry more than one, and prose outside the backticks -
  a parenthetical, a label - is not read. A span holding no space is a
  CLI name rather than a command ("VCS host: GitHub, CLI `gh`") and
  contributes no prefix of its own, the commands that CLI runs
  arriving from the other bullets. Every other span becomes one
  `Bash(<prefix>:*)` rule whose prefix is the span up to its first
  placeholder, trailing space trimmed. On this repository that yields
  `Bash(bash scripts/ci/run-all.sh:*)`,
  `Bash(bash scripts/test/run-all.sh:*)` (the second span of the
  Test (full) bullet), `Bash(gh pr create:*)`, `Bash(gh pr view:*)`
  and `Bash(gh pr merge:*)`. An absent host CLI is the push-only
  fallback of `companions/toolchain.md § Push + MR/PR`, not a gap.
  Check order:
  trust, then the mode assertion and the never-list, then the deny
  rules, then the non-Bash allow rules, then the Bash prefix set, then
  the carve-out pattern. The mode-assertion half the script can decide
  is the tier comparison, and each tier resolves its own repo rather
  than assuming the project's: `top=$(git -C "$(dirname "$tier")"
  rev-parse --show-toplevel)`, then `rel=${tier#"$top"/}`, then
  `git -C "$top" ls-files --error-unmatch "$rel"` to say whether it is
  tracked, then `git -C "$top" show "HEAD:$rel"` for the tracked
  value. That is what lets the user tier be tracked here, where
  `$HOME/.claude/settings.json` is this repository's own
  `settings.json`, and untracked in an adopter. Three verdicts, and
  only the middle one is a defect: `unchanged` passes, `drifted`
  is the failed permission-mode assertion on the cannot-apply list,
  and `untracked` passes with the tier's value printed, there being no
  tracked value to have drifted from. A present `defaultMode` is never
  a defect on its own. Report lines carry one
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
  cannot-apply under `AI`; a tracked tier carrying pattern 1's narrow
  pair satisfies the declared deny and is not reported as missing the
  blanket rule; a tier carrying neither pattern's deny set is
  cannot-apply and `--apply` writes no deny; `--runner-mode unknown`
  is cannot-apply under `AI` and ignored under `human`; a tier whose
  `defaultMode` drifted from its tracked value is cannot-apply while
  an untracked tier passes with its value printed;
  `bypassPermissions` in a tier is
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
  `scripts/ci/check-caps.sh` holds mode files to, so the edit is
  net-zero and budgeted: § Pre-flight's first bullet (lines 69-77) goes
  from 9 lines to 4, naming the script by the one path rule that
  resolves in both readerships - it sits in the config directory the
  toolset is installed into, so `<config>/scripts/`, which is
  `.claude/scripts/` from an adopter's project root and `scripts/`
  in this repository, whose checkout is that directory - then
  `--project .` (the script canonicalizes it), `--supervisor
  <declared>`, `--runner-mode <the runner's launch mode>`, the
  tier-naming report, the `--apply` line for the
  user and the surviving "No `## Agent toolchain` section → halt,
  ask"; the placeholder-substitution clause and the VCS-host-CLI clause
  go with the bullet, the first to the script and the second to
  `companions/toolchain.md § Push + MR/PR`, which already carries the
  absent-host fallback. Of the five lines that frees, the
  settings-surface bullet (lines 78-81) takes two for the
  seat-versus-user split and § Dispatch per item's closing paragraph
  (lines 117-119) the other three, going from 3 lines to 6: the two
  class names with their routes in one sentence each and the
  mode-conditional shaping rule, citing
  `companions/seat-permissions.md § Prompt classes` for the reasoning
  behind the classifier route - why no retry is held, which report
  status carries it, which ledger event records it - since a companion
  is exempt from both caps and `run.md` is not. Measure with `wc -l`
  and `check-caps.sh` after the three passages are written; the file
  lands back at 300 and the wrap may be re-cut across them so long as
  the check passes. The duty
  table's prompt row (`| Clearing a permission prompt | nobody: a
  prompt is a pre-flight defect | the same |`) reads "nobody: a
  pre-flight defect halts the item; a classifier denial reaches the
  user as the seat's BLOCKED report (§ Dispatch per item)" in its
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
