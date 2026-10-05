# R086-T001 report

## Planner

### Probes

#### git diff -U0 from the merge-base to the working tree
Source: git 2.39.5 (Apple Git-154) and bash 3.2.57, the `/usr/bin/env
bash` of this host, in throwaway repos built by the draft probes.
Request: `git -c core.quotePath=false -c diff.mnemonicPrefix=false -c
diff.noprefix=false diff --no-color --no-ext-diff --no-textconv -M -U0
--src-prefix=a/ --dst-prefix=b/ <base> -- <pathspec>`
Response: one `@@ -a,b +c,d @@` hunk per change with only `-` and `+`
lines, the added ones numbered from `c`; a file renamed with one line
appended shows only that line; a deleted file's header is `+++
/dev/null`; a binary file gives no hunk; a staged new file appears, an
untracked one does not; a path with a space and a non-ASCII path come
through verbatim with no trailing tab.
Errors hit: none; `diff.mnemonicPrefix` and `diff.noprefix` set to true
in the repo's config were overridden by the flags above.
Trap: content lines `++ x`, `+++ x` and `--- x` arrive as `+++ x`,
`++++ x` and `+--- x` inside a hunk, so a file header and an added line
look alike: only a state machine tells them apart (header from `diff
--git` to the first `@@`, hunk until the next `diff --git`). A last
line that gains its trailing newline is reported as added.

#### git diff --name-status -M from the merge-base
Request: `git diff --name-status --no-ext-diff -M <base>`
Response: `M<TAB>path`, `A<TAB>path`, `D<TAB>path`,
`R100<TAB>old<TAB>new`.
Trap: tab is IFS whitespace, so `IFS=$'\t' read -r a b c` on
`A<TAB><TAB>path` gives `a=A b=path c=` (observed): an empty middle field
collapses. The draft prints the optional base path last.

#### git merge-base in CI
Source: the log of the CI run for PR 582 (`gh run view <id> --log`).
Response: `actions/checkout` fetched `+refs/heads/*:refs/remotes/origin/*`
at `fetch-depth: 0`, checked out `refs/remotes/pull/582/merge` detached
(`Merge <PR head> into <main tip>`), and printed `check-plan-text: OK`
with no SKIP, so `git merge-base HEAD origin/main` resolved on the runner.

#### No base
Request: `branch_base` in an unborn repo (`git init`, files staged, no
commit) and in a repo whose only branch is `trunk`.
Response: every one of `origin/main`, `origin/master`, `main`, `master`
fails, return 1. `check-accretion.test.sh` and `check-caps.test.sh`
build their fixtures with `git init` and no commit, and
`install-dev.test.sh` runs the copied accretion gate in an unborn repo,
so all of them take this path.

#### On the default branch
Response: on `main` with a clean tree the base is `HEAD` and no line is
added; after `git merge --no-ff feat` into `main` the code-size and
em-dash drafts print OK.

#### git show and pathspec magic
Response: `git show <base>:<old path>` gives a renamed file's base
content; a path absent at the base exits nonzero with nothing on
stdout. `:(literal)we*rd.txt` matched only that file;
`":(exclude)$P/archive/*"` dropped an added archive line; `"$P/*.md"`
matched plan files nested under initiative dirs.

#### awk set difference
Trap: `awk 'NR == FNR { seen[$1]++; next } ...' old new` with an empty
`old` prints nothing, since `NR == FNR` then holds through `new`;
`FILENAME == ARGV[1]` printed the expected line (both observed).

#### This checkout, and a base 60 commits back
Request: every draft run read-only in this checkout on
`plan/r086-detail`, then in a clone with `refs/remotes/origin/main` set to
`HEAD~60` (126 files changed, 11336 insertions).
Response: in the checkout every draft printed OK. In the clone the
plan-text draft reports `R080-seat-model/tasks.md` lines 255, 325 and
497 (backlog line over 1 line); today's gate on the same tree reports
those and lines 174 and 206, which predate the base.
Errors hit: the code-size draft flagged `hooks/dev-branch-guard.sh` (363
lines) in the clone: the allowlist is read beside the script, and the
draft dir had none.

#### Sourcing a file that is absent
Source: bash 3.2.57 (`/bin/bash`, the only bash on this host, so bash 5
on the CI runner was not run).
Request: a gate shaped like the em-dash draft whose first step is
`. "$(dirname "${BASH_SOURCE[0]}")/branch-diff.sh"`, run with no helper
beside it; then `bash -c` one-liners.
Response: under `set -uo pipefail` the unguarded gate printed `No such
file or directory`, `branch_base: command not found`, `branch_added:
command not found`, then `gate: OK`, rc 0. `. /nonexistent/x.sh || echo
caught` prints `caught` without `-e`; under `set -e` it exits rc 1 before
`caught`, and so does `if ! . /nonexistent/x.sh`. `{ [ -r "$f" ] && .
"$f"; } || { echo caught; exit 1; }` prints `caught`, rc 1, under `-e`
and without it.
Trap: under `set -e` a failed `.` exits the shell even inside `||`, so
`check-caps.sh` and `check-todos.sh` would stop with no stdout. Test the
file with `[ -r ]` before sourcing it.

#### Where the helper is loaded
Request: the em-dash draft copied with the helper into a repo's
`scripts/ci/`, run as `bash ../scripts/ci/check-no-em-dash.sh` from
`sub/`, once loading before its `cd` to the top level and once after.
Response: before the `cd`: `check-no-em-dash: OK`, rc 0. After it:
`check-no-em-dash: cannot load branch-diff.sh`, rc 1, since
`BASH_SOURCE` is relative to the directory the gate was started from.

#### A rename under a one-path pathspec
Request: on a branch that runs `git mv m.md n.md` and appends `d` to a
3-line file: `branch_added "$b" ':(literal)n.md'`, then the same with
`':(literal)m.md'` added, then `branch_changed "$b"`.
Response: the new path alone gave all four lines as added; both paths
gave only `n.md<TAB>4<TAB>d`; `branch_changed` gave
`M<TAB>n.md<TAB>m.md`.
Trap: rename detection needs the base path in the pathspec too, so a
per-file call passes `:(literal)$from` beside `:(literal)$f`.

#### set -e in a command substitution
Request: the report's earlier `over()` (last command `(( ... )) &&
echo`) called as `n=$(over f.txt "" 100 lines)` on a 1-line file under
`set -euo pipefail`; then a form ending in `if (( ... )); then echo; fi`
with `git show` of a path absent at `HEAD`.
Response: the first exited rc 1 with no output, since the substitution
returned 1 and the assignment tripped `-e`. The second printed `reached
n=[]`, rc 0: bash 3.2 clears `-e` inside `$(...)`, so only the
function's last status reaches the caller.

### Drafts

Each draft runs under its gate's own shell mode: `set -euo pipefail` for
the caps and todos drafts, `set -uo pipefail` for the rest; the scratch
copies of `check-plan-text.test.sh`, `check-caps.test.sh` and
`check-accretion.test.sh` ran against them.
Each gate draft loads the helper with the form under Item 2.

#### Item 2
Draft: the helper, relying on every probe above.

```bash
branch_base() {
  local ref b
  for ref in origin/main origin/master main master; do
    b=$(git merge-base HEAD "$ref" 2>/dev/null) && { printf '%s\n' "$b"; return 0; }
  done
  return 1
}

branch_git() { git -c core.quotePath=false -c diff.mnemonicPrefix=false -c diff.noprefix=false "$@"; }

branch_whole() {
  local f
  while IFS= read -r -d '' f; do
    [ -f "$f" ] && [ ! -L "$f" ] || continue
    grep -Iq . "$f" 2>/dev/null || continue
    awk -v f="$f" '{ print f "\t" NR "\t" $0 }' "$f"
  done
}

branch_added() {
  local base=$1; shift
  if [ -z "$base" ]; then
    branch_git ls-files -z -- "$@" | branch_whole
    return
  fi
  branch_git diff --no-color --no-ext-diff --no-textconv -M -U0 \
      --src-prefix=a/ --dst-prefix=b/ "$base" -- "$@" | awk '
    /^diff --git / { hunk = 0; f = ""; next }
    !hunk && /^\+\+\+ / { f = substr($0, 5); sub(/\t$/, "", f); if (f == "/dev/null") f = ""; else sub(/^b\//, "", f); next }
    /^@@ / { hunk = 1; match($0, / \+[0-9]+/); n = substr($0, RSTART + 2, RLENGTH - 2) + 0; next }
    hunk && /^\+/ && f != "" { print f "\t" n "\t" substr($0, 2); n++ }'
  branch_git ls-files -z --others --exclude-standard -- "$@" | branch_whole
}

branch_changed() {
  local base=$1; shift
  if [ -z "$base" ]; then
    branch_git ls-files -- "$@" | awk '{ print "A\t" $0 }'
    return
  fi
  branch_git diff --name-status --no-ext-diff -M "$base" -- "$@" | awk -F '\t' '
    $1 ~ /^D/ { next }
    $1 ~ /^[RC]/ { print "M\t" $3 "\t" $2; next }
    $1 ~ /^A/ { print "A\t" $2; next }
    { print "M\t" $2 "\t" $2 }'
  branch_git ls-files --others --exclude-standard -- "$@" | awk '{ print "A\t" $0 }'
}
```

Showed: on a branch that appends to one file, renames another and
appends a line, deletes a third, adds a binary, a staged file, an
untracked file, a path with a space and a non-ASCII path,
`branch_added` printed exactly the added lines with their new-file line
numbers, none from the deleted, binary or renamed-but-unchanged lines;
`branch_changed` printed `M<TAB>moved.txt<TAB>move.txt` for the rename.
With a pathspec it printed only that file's lines.

Draft: the load, ahead of each gate's `cd`, relying on the three loading
probes above.

```bash
h="$(dirname "${BASH_SOURCE[0]}")/branch-diff.sh"
{ [ -r "$h" ] && . "$h"; } \
  || { echo "check-no-em-dash: cannot load branch-diff.sh"; exit 1; }
cd "$(git rev-parse --show-toplevel)"
```

Showed: the em-dash, todos, accretion and caps drafts, and today's
code-size and plan-text gates with this load put before their `cd`, each
copied alone into a bare layout and run in a repo: every one printed
`<gate>: cannot load branch-diff.sh`, rc 1, the two `-e` gates included.

#### Item 3
Draft: in a local clone of this checkout carrying the gate drafts,
`ci/branch-diff.sh` added to the `install-dev.sh` copy loop,
`[ -f "$P/.claude/scripts/ci/branch-diff.sh" ]` asserted in
`install-dev.test.sh`, and `scripts/ci/branch-diff.sh` added to the
keep-list of `install-dev-minimal.test.sh`.
Showed: with the gates on the helper and the loop unchanged,
`install-dev.test.sh` failed `copied accretion gate did not bite:
check-accretion: cannot load branch-diff.sh` and `vendored
check-accretion did not run under a leaked environment (rc=1)`, while
`install-dev-minimal.test.sh` passed, since it runs no copied gate. With
the change both printed OK. A full and a `--minimal` install both put
`branch-diff.sh` in `scripts/ci/`; the installed `scripts/test/` held the
four self-tests it holds today, each naming `BASH_SOURCE`, and the
installed accretion and plan-text self-tests printed OK from there.

#### Item 4
Draft: `check-no-em-dash.sh` and `check-todos.sh` on the helper.

```bash
em=$(printf '\xe2\x80\x94')
base=$(branch_base) || base=
matches=$(branch_added "$base" | awk -F '\t' -v em="$em" '{ line = $0; sub(/^[^\t]*\t[^\t]*\t/, "", line) } index(line, em) { print $1 ":" $2 ":" line }')
```

Showed: an old em dash in an untouched file and in a file the branch
appended to passed; an appended em-dash line was reported as
`old-touched.md:4:<line>` and an untracked one as `untracked.md:1:<line>`,
exit 1; an unborn repo with a staged em dash failed as today.
Trap: matching on the whole record would also match an em dash in a
path, so the text field is cut out first.

```bash
set -euo pipefail
T=$'\t'
base=$(branch_base) || base=
hits=$(branch_added "$base" scripts .githooks ':(exclude)scripts/ci/check-todos.sh' \
  | grep -E "^[^$T]*$T[0-9]+$T.*\b(TODO|FIXME|XXX)\b" \
  | grep -vE "^[^$T]*$T[0-9]+$T.*\b[A-Z]-XXX\b" \
  | awk -F '\t' '{ line = $0; sub(/^[^\t]*\t[^\t]*\t/, "", line); print $1 ":" $2 ":" line }' || true)
```

Showed, under `set -euo pipefail`: an old TODO in a touched script, an
added `R-XXX` placeholder, an added TODO under `docs/`, an added TODO in
the gate's own file and a branch with no marker each printed
`check-todos: OK`, rc 0; an added FIXME in `.githooks/pre-push` failed as
`.githooks/pre-push:2:<line>` and an untracked `scripts/new.sh` as
`scripts/new.sh:1:<line>`, rc 1; an unborn repo with a staged TODO failed
as today. In this checkout it printed OK. Today's gate applies the
`[A-Z]-XXX` exclusion to the joined `file:N:text` output; this draft
applies both patterns to the text field.
Trap: with `|| true` dropped, a branch adding one marker-free line
exited rc 1 with no output: grep's exit 1 fails the pipeline and `-e`
stops the gate.

#### Item 5
Draft: accretion on the helper.

```bash
T=$'\t'
base=$(branch_base) || base=
hits=$(branch_added "$base" "$P/*.md" ":(exclude)$P/archive/*" \
  | grep -iE "^[^$T]*$T[0-9]+$T.*$PAT" \
  | awk -F '\t' '{ line = $0; sub(/^[^\t]*\t[^\t]*\t/, "", line); print $1 ":" $2 ":" line }' || true)
```

Showed: the 21 cases of today's `check-accretion.test.sh` passed; on a
branch, an old dated marker in a touched ROADMAP, an added one in an
archive file and a plain line added to a plan file whose name carries a
dated marker passed; an added one in a live `tasks.md` failed as
`ACCRETION: dev/plans/<initiative>/tasks.md:2:<line>`; the copied gate
with the helper beside it in an install location failed on the
`install-dev.test.sh` unborn-repo ROADMAP as `ACCRETION:
dev/plans/ROADMAP.md:1:<line>`. The draft printed OK in this checkout.
Errors hit: the earlier accretion draft grepped the joined
`path:N:text` record; it failed the plain line in the dated-name plan
file as `ACCRETION: <path>:2:plain`, which the anchored pattern above
passes.

Probe: today's `check-secrets.sh`, unchanged, with
`hooks/secret-patterns.sh` and no `branch-diff.sh` beside it, in a repo
whose `origin/main` holds an AWS key id in `old.txt`, on a branch that
only appends to `touched.txt`.
Showed: run from the top level and from `sub/`, it printed `SECRETS:
...` naming `old.txt`, rc 1: the scan reads every tracked file and needs
no helper. Today's `check-secrets.test.sh` printed `check-secrets.test:
OK` and the gate printed `check-secrets: OK` in this checkout.

#### Item 6
Draft: caps and code-size compare a measure at the base with the same
measure now; mode-file line length runs on added lines only. The caps
draft keeps `set -euo pipefail`, walks `branch_changed "$base"` and
dispatches on the path (`CLAUDE.md`, `DESIGN.md`, `skills/*/SKILL.md`,
`skills/dev/*/*` skipped, `skills/dev/*.md`), each measure printing a
bare number (`wc` output through `tr -d ' '`, mode-file lines as `awk
'END { print NR }'`).

```bash
over() {
  local now was
  now=$("$4" "$1")
  : > "$old"
  if [ -n "$2" ]; then git show "$base:$2" > "$old" 2>/dev/null || : > "$old"; fi
  was=$("$4" "$old")
  if (( now > $3 && was <= $3 )); then echo "$now"; fi
}

long_added() {
  branch_added "$base" ":(literal)$1" ${2:+":(literal)$2"} | while IFS= read -r rec; do
    rec=${rec#*$'\t'}; n=${rec%%$'\t'*}; line=${rec#*$'\t'}
    t="${line#"${line%%[![:space:]]*}"}"
    [ "${t:0:1}" = '|' ] && continue
    (( ${#line} <= 80 )) || { echo "line $n: ${#line} characters > 80"; break; }
  done
}
```

with call sites `n=$(over "$f" "$from" 350 lines); [ -z "$n" ] || report
"$f $n lines > 350"` and `long=$(long_added "$f" "$from")`.
Code-size keys a function by name: a function over the cap now is
reported unless the base copy of the file has one of that name over it.
Showed: caps, under `set -euo pipefail` - the six existing
`check-caps.test.sh` cases passed; on a branch, a 120-line `CLAUDE.md`,
a 360-line mode file and a `SKILL.md` with a 13-word description, all
over at the base, each gained a line and passed; `CLAUDE.md` going from
100 to 101 lines failed (`CLAUDE.md 101 lines > 100`), a description
going from 12 to 13 words failed (`description 13 words > 12`) and a mode
file going from 340 to 360 lines failed (`360 lines > 350`); an old
81-character line passed and an added tab-led one failed as `line 363:
82 characters > 80`; a renamed mode file carrying an old 81-character
line passed; an untracked new 351-line mode file failed; on `main` with
a clean tree, over-cap files passed. In this checkout it printed OK.
Code-size, with the earlier `(( ... )) && echo` form of `over()` under
its own `set -uo pipefail` - a 310-line file grown to 320, a renamed
310-line file and a 60-line function grown to 70 passed; a 290-line file
grown to 310, a new 301-line file and a new 53-line function failed; an
unborn repo with a 301-line file failed as today.
Trap: `IFS=$'\t' read -r p n line` strips a leading tab from `line`
(observed: length 8 against 9); the parameter expansion above keeps it.
Under `-e`, an `over()` whose last command is `(( ... )) && echo` stops
the gate at the first compliant unit (probe "set -e in a command
substitution").

#### Item 7
Draft: each scanner prints `key<TAB>message`; the key is the reason plus
the offending line's text, or for an entry its first line with the mark
read as `[ ]`, or for the 40-line cap the reason alone. The file is
scanned now and at its base path, and a message prints only when its key
occurs more often now.

```bash
judge() {
  local fn=$1 f=$2 from=$3 out; shift 3
  "$fn" "$f" "$f" "$@" > "$new"
  : > "$old"
  [ -n "$from" ] && git show "$base:$from" > "$blob" 2>/dev/null && "$fn" "$blob" "$f" "$@" > "$old"
  out=$(awk -F '\t' 'FILENAME == ARGV[1] { seen[$1]++; next } seen[$1] > 0 { seen[$1]--; next } { print $2 }' "$old" "$new")
  [ -z "$out" ] || { printf '%s\n' "$out"; fail=1; }
}
had() { git cat-file -e "$base:$1" 2>/dev/null; }
```

```bash
    *.md) judge scan "$f" "$from" "$id" plan
      [ -f "${f%.md}.report.md" ] || [ -f "${f%.md}.findings.md" ] \
        || { [ -n "$from" ] && ! had "${from%.md}.report.md" && ! had "${from%.md}.findings.md"; } \
        || { echo "PLAN-TEXT: $f: plan without task report"; fail=1; } ;;
```

The scanners' `bad` takes the key text as a third argument, `close_entry`
passes the entry's first line, `report` and `backlog` print their own
keys, and none of them exits on a hit; `from` is empty for status `A`.
Showed: every existing `check-plan-text.test.sh` case passed except
"changed legacy initiative checked", which now prints OK. In throwaway
fixtures an old link line in a touched `requirements.md`, an old 4-line task
entry marked `[x]`, a legacy plan without a report marked `[x]`, an old
box without Evidence marked `[x]` and a renamed initiative dir all
passed; an added link, a new 4-line entry, a new box without Evidence
and a new plan without a report each failed with its line.
Errors hit: with a key set rather than counts, an added copy of an old
offending line passed; counting the keys made it fail at its own line.

## Implementer

### Divergences
- Item 2: `branch_whole` passes the path to awk through the environment and
  feeds the file on stdin, where the draft used `awk -v f=` and a file
  operand, since `-v` rewrites backslash escapes in the value and an
  operand holding `=` is read as an assignment; the test output is the
  draft's.
- Item 2: `branch-diff.test.sh` also pins the load form with a fixture gate
  under both shell modes, run from a subdirectory with and without the
  helper beside it, and sets `diff.renames false` in its diff fixture, since
  without it a helper that drops `-M` still passed on git's default.
- Item 3: `README.md § Installing the toolset elsewhere` is not edited in
  this commit, since every doc the branch ships is the doc writer's
  (`skills/dev/branch-plan.md § Commit cadence` 2); the listing is left
  for the close.
- Item 3: `install-dev.test.sh` also asserts that
  `scripts/test/branch-diff.test.sh` is absent from the install, pinning
  "no test this branch adds ships" in the same check as the helper's
  presence, which failed before the copy-loop change and passes after it.
- Item 4: the TODO gate now names the path on every hit; today's gate
  printed only `N:text` when one file was in scope, since `xargs grep` with
  a single operand omits the name (observed in the red run of
  `check-todos.test.sh`), and the new test's no-base cases assert the path.
- Item 6: the caps gate's long-line scan reads every added line and keeps
  the first hit, where the draft used `break`, since a `break` in a
  function's pipeline under `set -euo pipefail` exited the gate rc 141 when
  the producer was still writing (observed with `seq 1 200000`).
- Item 6: code-size keys a function by its name with any `()` dropped, so
  `f() {` and `function f {` share a key; the message keeps today's
  `function f() is N lines` form, which the new test asserts.
- Item 6: the caps gate measures `CLAUDE.md` and `DESIGN.md` only as
  changed paths, like every other unit, so a fixture no longer needs a
  compliant pair; the test comment saying it does is removed, and the
  gate's header sentence limiting it to tracked files with it, since
  untracked files the helper yields are now judged.
- Item 7: the plan-text scanners print the message first and the key after
  it, read as the rest of the record, where the draft printed
  `key<TAB>message`, since a key carrying the offending line's text can hold
  a tab; a report box and a backlog line are keyed by their first line, the
  box's mark read as `[ ]`.
- Item 7: `check-plan-text.test.sh` also covers an old long entry checked off
  and grown beside a new long one, an old box without Evidence beside a new
  one, a legacy plan without a report, and a plan whose report the branch
  deletes; the first three failed before the gate change.

## Answers
- Review 1: fix it in branch-diff.sh - a line git removes and re-adds only
  because the file gained a trailing newline is not added - with a test case.
- Review 2: the doc writer adds the README line at close.
- Review 3: delete the stale clauses; add no comment text.
- Review 4: restore those comments to their base wording.
- Review 5: delete the fetch-depth comment.

## Review
- [x] Close review: an old hit on a last line with no trailing newline
  fails once the branch appends to that file (Important) -
  scripts/ci/branch-diff.sh:31
  Evidence: observed check-no-em-dash.sh printed doc.md:2 and exit 1 on a
  branch appending to a file whose old last line held an em dash
- [ ] Close review: README.md § Installing the toolset elsewhere does not
  list branch-diff.sh (Important) - README.md:140
  Evidence: contract MAINTENANCE.md § This environment doc-sync row
- [ ] Close review: header comments still describe a whole-tree scan
  (Suggestion) - scripts/ci/check-no-em-dash.sh:2,
  scripts/ci/check-code-size.sh:3
  Evidence: observed both gates judge only what a branch adds
- [ ] Close review: comment text the branch rewrapped or extended
  (Suggestion) - scripts/ci/check-caps.sh, scripts/ci/check-plan-text.sh:7
  Evidence: contract CLAUDE.md § Code Comments
- [ ] Close review: the fetch-depth comment credits only plan-text
  (Suggestion) - .github/workflows/ci.yml:19
  Evidence: observed six gates call branch_base and fall back to the whole
  tree without a full fetch
