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
fails, return 1. `check-accretion.test.sh`, `check-caps.test.sh` and
`check-secrets.test.sh` build their fixtures with `git init` and no
commit, and `install-dev.test.sh` runs the copied accretion gate in an
unborn repo, so all of them take this path.

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

### Drafts

All drafts run under `set -uo pipefail`; the scratch copies of
`check-plan-text.test.sh` and `check-caps.test.sh` ran against them.

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

#### Item 3
Draft: `check-no-em-dash.sh` on the helper; `check-todos.sh` was not
drafted and takes the same shape with its `scripts .githooks` pathspec
and `:(exclude)scripts/ci/check-todos.sh`.

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

#### Item 4
Draft: accretion and secrets on the helper.

```bash
hits=$(branch_added "$base" "$P/*.md" ":(exclude)$P/archive/*" \
  | awk -F '\t' '{ line = $0; sub(/^[^\t]*\t[^\t]*\t/, "", line); print $1 ":" $2 ":" line }' \
  | grep -iE "$PAT" || true)
```

```bash
while IFS=$'\t' read -r st f from; do
  [ -f "$f" ] && [ ! -L "$f" ] || continue
  [ "$(wc -c < "$f" 2>/dev/null || echo 0)" -le 1000000 ] || continue
  if branch_added "$base" ":(literal)$f" | cut -f3- | has_secret; then
    [ "$fail" -eq 0 ] && echo "SECRETS: added content matches a secret pattern:"
    echo "  $f"
    fail=1
  fi
done < <(branch_changed "$base")
```

Showed: an old dated marker in a touched ROADMAP and an old key in a
touched file passed; an added dated marker in an archive file passed and
one in a live `tasks.md` failed with `file:1:<line>`; an added key line
carrying `secrets-guard: allow` passed; an added key line in a tracked
file and one in an untracked file named `we*rd.txt` failed, both named.
Trap: the accretion draft greps the joined `path:N:text` record, so a
path could match the marker pattern; grep the text alone.

#### Item 5
Draft: caps and code-size compare a measure at the base with the same
measure now; mode-file line length runs on added lines only.

```bash
over() {
  local now was
  now=$("$4" "$1")
  : > "$old"; [ -n "$2" ] && git show "$base:$2" > "$old" 2>/dev/null
  was=$("$4" "$old")
  (( now > $3 && was <= $3 )) && echo "$now"
}
```

```bash
long=$(branch_added "$base" ":(literal)$f" | while IFS= read -r rec; do
  rec=${rec#*$'\t'}; n=${rec%%$'\t'*}; line=${rec#*$'\t'}
  t="${line#"${line%%[![:space:]]*}"}"
  [ "${t:0:1}" = '|' ] && continue
  (( ${#line} <= 80 )) || { echo "line $n: ${#line} characters > 80"; break; }
done)
```

Code-size keys a function by name: a function over the cap now is
reported unless the base copy of the file has one of that name over it.
Showed: caps - a 120-line `CLAUDE.md`, a 360-line mode file and a
`SKILL.md` with a 13-word description, all over at the base, each gained
a line and passed; a mode
file going from 340 to 360 lines failed (`360 lines > 350`); an old
81-character line passed and an added tab-led one failed as `line 363:
82 characters > 80`; the six existing `check-caps.test.sh` cases passed.
Code-size - a 310-line file grown to 320, a renamed 310-line file and a
60-line function grown to 70 passed; a 290-line file grown to 310, a new
301-line file and a new 53-line function failed; an unborn repo with a
301-line file failed as today.
Trap: `IFS=$'\t' read -r p n line` strips a leading tab from `line`
(observed: length 8 against 9); the parameter expansion above keeps it.

#### Item 6
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

## Review
