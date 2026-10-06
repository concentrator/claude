# R086-T003 report

## Planner

### Probes

#### Host tools
Source: `bash --version`, `awk --version` on this host.
Response: GNU bash 3.2.57 and BWK awk 20200816; bash 5 on the CI runner
was not run.

#### Today's plan-text gate on `## Claims` sections
Source: `scripts/ci/check-plan-text.sh` at this branch's tip, copied with
`branch-diff.sh` into a scratch `ci/` and run by the scratch test below.
Request: the nine claim cases of the draft test, against the unchanged gate.
Response: five pass and four fail (`G1`, `G2`, `report-only`, `probe`),
each printing `check-plan-text: OK`: today's gate accepts a plan ending on
`## Claims` and `## Proven` and a report with `## Claims` entries, neither
counting as an oversize item nor as a finding without `Evidence:`, and it
catches none of the new failures.
Trap: a claim line opens no plan entry, since the plan scan opens one only
on `- [`; a `## ` heading closes the last item, so a claim never adds to an
item's 6-line count.

#### Claims in the tree today
Request: `git grep -c '^## Claims' -- dev/plans` and `git grep -n '^- Item
[0-9]* (' -- dev/plans`.
Response: both empty, so no existing plan or report changes verdict.

#### Size caps on the files the items touch
Source: `scripts/ci/check-caps.sh`, `scripts/ci/check-code-size.sh`;
`wc -l`, `wc -w`.
Response: `skills/dev/branch-plan.md` is 342 lines against the 350-line
cap on `skills/dev/*.md`, whose added lines are also held to 80
characters; `skills/dev/companions/` files are exempt from both.
`CLAUDE.md` is 62 lines of 100 (re-measured after R086-T002 merged);
`DESIGN.md` 711 words of 1000. The draft gate is 185 lines of 300 with
the cold-read changes, its longest function `scan()` at 44 of 50 and
`claims()` at 33. `run.md` is 299 lines and `layout.md` 197 of 350.
Trap: `branch-plan.md` has 8 lines of headroom, which is why the claims
rules live in `documentation.md § Claims` and `branch-plan.md` only cites it.
Its edits drafted below take it to 347.

#### Draft gate on this checkout
Request: `bash <scratch>/ci/check-plan-text.sh` run from the checkout,
before and after the cold-read changes below.
Response: `check-plan-text: OK`, rc 0 both times; `git status --short`
empty after. This branch changes nothing against `main`: the plans of
R086-T003 to T006 are already there, so the gate reads them as changed,
never added, and none needs `## Claims`.

### Drafts

#### Item 1 and Item 2: the claims check in `check-plan-text.sh`
Relies on: Host tools, Today's plan-text gate, Draft gate on this checkout.
Draft: a `claims plan report name` function, with `judge` split so its
subtraction is a shared `added`:

    claims() {
      awk -v fp="$3" -v fr="${3%.md}.report.md" '
        function bad(f, n, why, c) { printf "PLAN-TEXT: %s:%d: %s\t%s\t%s\n", f, n, why, why, c }
        function flush(  x) {
          if (k != "" && inplan) { kind[k] = kd; item[k] = it; pl[k] = at }
          else if (k != "") { got[k] = 1; rl[k] = at; for (x in fv) val[k, x] = fv[x] }
          k = ""; fld = ""; split("", fv)
        }
        FNR == 1 { flush(); sec = ""; inplan = FILENAME == ARGV[1] }
        /^## / { flush(); sec = $0; next }
        inplan && sec == "" && /^- \[[ x]\]/ { done[++boxes] = /^- \[x\]/; next }
        sec != "## Claims" { next }
        /^- Item [0-9]+ \((source|probe|drop)\): / {
          flush(); at = FNR; k = $0; it = $3 + 0; kd = $4; gsub(/[():]/, "", kd); next
        }
        k != "" && !inplan && match($0, /^  (Source|Call|Output|Environment):/) {
          fld = substr($0, 3, RLENGTH - 3); v = substr($0, RLENGTH + 1); gsub(/[ \t]/, "", v)
          fv[fld] = v != ""; next
        }
        k != "" && fld != "" && /^   +[^ ]/ { fv[fld] = 1; next }
        k != "" && fld == "" && /^  +[^ ]/ { t = $0; sub(/^ +/, "", t); k = k " " t; next }
        { flush() }
        END {
          flush()
          need["source"] = "Source"; need["drop"] = "Source"; need["probe"] = "Call Output Environment"
          for (c in kind) {
            if (!(c in got)) { bad(fp, pl[c], "claim without report entry", c); continue }
            if (!done[item[c]]) continue
            n = split(need[kind[c]], fs, " ")
            for (i = 1; i <= n; i++) if (!val[c, fs[i]]) { bad(fr, rl[c], "claim of a done item without evidence", c); break }
          }
        }' "$1" "$2"
    }

    pair() {
      local f=$1 from=$2
      [ -f "${f%.md}.report.md" ] || return 0
      claims "$f" "${f%.md}.report.md" "$f" > "$new"
      : > "$old"
      if [ -n "$from" ] && git show "$base:$from" > "$blob" 2>/dev/null \
        && git show "$base:${from%.md}.report.md" > "$blob2" 2>/dev/null; then
        claims "$blob" "$blob2" "$f" > "$old"
      fi
      added
    }

The main loop's `*.report.md)` case appends
`"${f%.report.md}.md"$'\t'"${from%.report.md}"${from:+.md}$'\n'` to
`pairs`, its `*.md)` case `"$f"$'\t'"$from"$'\n'`; after the loop:

    while IFS=$'\t' read -r f from; do
      [ -f "$f" ] && pair "$f" "$from"
    done < <(printf '%s' "$pairs" | awk -F '\t' '!($1 in m) || m[$1] == "" { m[$1] = $2 } END { for (k in m) print k "\t" m[k] }')

`blob2=$(mktemp)` joins the `mktemp` line and the `trap`.

The fixture it ran on, a plan:

    - [x] Item one does a thing.
      Approach: a.
    - [ ] Item two.
    - [x] Item three.

    ## Claims
    - Item 1 (source): `check-x` exits 1 on a missing file.
    - Item 1 (probe): A page holds at most 100 rows,
      even when `limit` asks for more.
    - Item 2 (source): not done yet, so blank is fine.
    - Item 3 (drop): the `--legacy` flag.
    - Item 3 (source): missing from the report.

    ## Proven
    - `GET /rows` takes `limit` up to 500: docs/reports/rows-api.md

and its report:

    ## Claims
    - Item 1 (source): `check-x` exits 1 on a missing file.
      Source: scripts/check-x.sh main
    - Item 1 (probe): A page holds at most 100 rows,
      even when `limit` asks for more.
      Call: curl -s 'https://api.test/rows?limit=500'
      Output:
        {"rows": [...100 items], "next": "c2"}
      Environment:
    - Item 2 (source): not done yet, so blank is fine.
      Source:
    - Item 3 (drop): the `--legacy` flag.
      Source:

Showed: three lines - the Item 1 probe entry (report line 6, empty
`Environment:`), the Item 3 drop entry (report line 14) as `claim of a
done item without evidence`, and the Item 3 source claim (plan line 18)
as `claim without report entry`; the filled Item 1 source entry, the
indented `Output:` value and the open Item 2's blank entry pass.
Scratch test, built on the head of `check-plan-text.test.sh` (`mkrepo`,
`run_in`, `commit_in`) plus its `on_main`: nine cases pass on the draft -
claim without entry caught (plan line 4), blank entry of an open item
passes, blank entry of a done item caught (report line 4), filled entry
passes, a violation already at the base passes when the branch changes
only another line, a report-only change emptying a done entry caught, a
renamed plan and report pair with an open blank entry passes, a probe
entry missing `Environment:` caught, a filled probe entry passes. The
existing `check-plan-text.test.sh` passes unchanged on the draft.
Errors hit: the first draft flushed a plan's last claim at the switch to
the report, so a plan ending on a claim line with no trailing heading
recorded it as a report entry and reported nothing; keying the flush on
`inplan`, set at `FNR == 1`, fixed it. A legacy plan changed by the
branch while the branch adds its report gave two `pairs` lines (`f<TAB>f`
and `f<TAB>`) and printed the violation twice; keeping one line per plan
path, a non-empty base path preferred, printed it once.
Trap: a claim matches its entry on the joined text - continuation lines
stripped of leading spaces and joined with one space - so trailing
spaces or changed words break the match. A report field must sit at
exactly two spaces; a value's own lines at three or more. "Item <n>" is
the nth checkbox above the plan's first `## ` heading. The script's
header comment lists what the gate fails on.

#### Item 1 and Item 2: the cold-read changes to the draft gate
Relies on: the draft above, Draft gate on this checkout.
Draft: two changes. The field match in `claims()` gains `Test`:

    match($0, /^  (Source|Call|Output|Environment|Test):/)

and the main loop's `*.md)` case, after its `pairs+=` line, fails a plan
the branch adds without either section (G1):

    [[ $st == A ]] && for s in Claims Proven; do
      grep -qx "## $s" "$f" || { echo "PLAN-TEXT: $f: plan without ## $s"; fail=1; }
    done

`need[]` is unchanged: `Test:` is never required.
Showed: the scratch claims test, now fourteen cases, passes on this
draft: the nine above, plus a filled probe entry with `Test:` between
`Output:` and `Environment:` passes, an empty `Output:` after `Test:` is
caught, an added plan lacking both sections prints one line per section,
an added plan with `- none` under each passes, and an older plan without
either section, marked `[x]` on the branch, passes. On the earlier
draft, without `Test` in the match, the `Test:` case fails as `claim of a
done item without evidence`: a two-space line that is no known field
closes the entry, so the `Environment:` after it is never recorded.
Errors hit: the existing `check-plan-text.test.sh` then failed two
cases, the 6-line plan item and the plan with its legacy findings file,
each adding a plan without the sections. A `none()` helper beside
`item()` - `printf '\n## Claims\n- none\n\n## Proven\n- none\n'` - is
appended to both fixtures, after which all 37 of its cases pass. The
claims test's `plan()` and its two probe fixtures gain `## Proven` and
`- none` the same way.
Trap: the gate checks the headings only, never a `## Proven` line's
form, and only on an added plan (status `A`); a renamed plan is not
added.

#### G9: `branch-plan.md` within its cap
Relies on: Size caps on the files the items touch.
Draft: on a scratch copy of `branch-plan.md`, edited with the Edit tool:
`§ Body` opens "The header, a checkbox list, then `## Claims` and
`## Proven` (`companions/documentation.md § Claims`), nothing else, in
either mode:"; `§ Commit cadence` 1 reads "the plan `[x]`, the item's
`## Claims` entries and the task report's `## Implementer` section
written first", and 3 "the mark, the claim entries and the report
section ride it"; `§ Task report` reads "as a skeleton: the title,
`## Claims` with a blank entry per claim the plan lists
(`companions/documentation.md § Claims`), and the `## Implementer` and
`## Review` headings; a strict plan's report opens with the planner's
filled `## Planner` (§ Modes), `## Claims` after it. The seats fill the
rest in this form:", and its implementer sentence "The implementer
appends its section and fills its item's `## Claims` entries in the
commit that carries the code".
Showed: 347 lines of 350, no added line over 80 characters, after two
reflows of the implementer sentence that first ran past 80.

### Cold-read gaps

Each gap the cold read raised, with the user's ruling (G1-G8) or the
planner's settlement (G9-G11). Where a ruling or settlement departs from
an item's wording, it governs.

#### G1: every new plan carries `## Claims`
Ruling: every plan written after this change carries `## Claims`;
`- none` is allowed, and then the doc writer does not run. Only a plan
written before the change keeps today's behavior: diff input, doc
writer as today.
Settled: `## Proven` follows the same rule, `- none` when nothing is
proven, since Item 1 has every plan end on both. A plan whose
`## Claims` is `- none` has no `## Claims` in its report.
Affects: Items 1, 5, 7. Item 1's gate fails an added plan without either
heading (draft above); `documentation.md § Claims` states the rule and
`run.md § Close` 3 the trigger.

#### G2: a `## Proven` line
Ruling: `- <statement>: <evidence>`, the evidence a source path, a test,
or a `docs/reports/` report, never a task report, which lives only as
long as the R (`branch-plan.md § Task report`).
Affects: Item 1, written in `documentation.md § Claims`. The gate does
not check the line's form.

#### G3: a `drop` entry's `Source:`
Ruling: the file and line, or the test, showing the behavior is gone.
Affects: Items 1, 2, 5; written in `documentation.md § Claims`.

#### G4: which probe fills the entry
Ruling: the second probe, the one confirming the values the test pins:
its call, output and environment fill `Call:`, `Output:` and
`Environment:`.
Affects: Items 3, 4; written in `documentation.md § Claims` and cited
from `agents/dev-implementer.md § Steps`.

#### G5: the claim's link
Ruling: an entry may carry an optional `Test:` field naming the test
that pins it; a doc's link targets the file, with the symbol named in
the link text; a `§ Parameters` row carries its link in its last column.
Affects: Items 1, 2, 5; the gate accepts `Test:` (draft above);
`documentation.md § Claims` gives the field, `§ Sources` the link form,
`layout.md § Docs` the table's last column.

#### G6: CHANGELOG and `README.md`
Ruling: the CHANGELOG `## [Unreleased]` entry and new public surface in
`README.md` are claims, listed in `## Claims` like any other; the doc
writer derives neither from the diff on a plan with `## Claims`.
Affects: Item 5, `agents/dev-doc-writer.md § Steps` 2.

#### G7: the verifier on a plan without `## Claims`
Ruling: as today - the writer's report and the source - but probing
nothing: it checks against the source only. Its tools become `Read,
Bash` for every dispatch.
Affects: Item 6. `run.md § Close` 3's "passing it the writer's report"
becomes: the plan and its report for a plan with `## Claims`, the
writer's report for a plan without.

#### G8: the reviewer does not probe
Ruling: the spec review checks the report against the plan and the
code, probing nothing.
Affects: Item 4, `agents/code-reviewer.md`. The ruling does not touch
the reviewer's tool list, so `WebFetch` and `WebSearch` stay for its
other reviews.

#### G9: the report skeleton
Settled: `branch-plan.md § Task report`'s skeleton gains `## Claims`,
with a blank entry per claim, placed after `## Planner` when the plan is
strict, else after the title, and before `## Implementer`. The gate
reads `## Claims` wherever it sits. `§ Commit cadence` 1 and 3 and
`agents/dev-implementer.md § Outputs` name the claim entries beside the
`## Implementer` section, so they ride the item's commit.
Affects: Item 1 (`§ Body`, `§ Task report`), Item 2 (`§ Commit cadence`,
`dev-implementer.md § Outputs`). Wording and line count: the draft above.

#### G10: test client, and the loop for every type
Settled: a test client is an account, tenant or environment of the
external system that the plan's item or a `## Answers` entry names for
tests, by name, never its credentials. A probe that writes runs only on
one; a probe claim needing a write with none named is a NEEDS_CONTEXT
report. The probe loop's one home is `agents/dev-implementer.md
§ Steps` 2, which runs for every type, so a `mnt`, `refactor` or `test`
item with a probe claim runs it too; `feat.md § Pass` and `fix.md § Pass`
cite it. The planner gives a probe claim only to an item whose code calls
the external system, so a `doc` plan's claims are `source` or `drop`
(R086 outcome 11).
Affects: Item 3; Item 1 for the planner's rule in `documentation.md
§ Claims`.

#### G11: the unconfirmed-row rule
Settled: on a plan with `## Claims` each `§ Parameters` row the doc
writer writes, changes or removes is a listed claim, and an input the
code neither takes nor sends gets no row. Rows no claim names stay as
they are. `layout.md § Docs` loses "every input - wired through the code
or not" and limits "An input no source confirms keeps its row" to a
plan without `## Claims`; `agents/dev-doc-writer.md § Steps` 3's last
sentence is limited the same way.
Affects: Item 7 (`layout.md § Docs`), Item 5 (`dev-doc-writer.md`).

## Answers
- Cold read G1: `## Proven` is required on every new plan too, `- none`
  allowed, and the gate fails an added plan lacking either heading.
- Cold read G5 and G6: a CHANGELOG claim line is listed and checked
  against its entry like any claim, but ends in no link.

## Implementer
### Divergences
- Item 1: the gate takes the planner's `claims()` without its done-item
  half - the checkbox marks, the field values and `need[]` - which is
  Item 2's; it still recognizes the five fields so a field line never
  joins the claim text. The `pairs` dedup keeps the order plans were
  seen in rather than `for (k in m)` order. The `dev-planner.md` rule
  joins `§ Steps` 3 instead of a new step, keeping the step numbers
  cited elsewhere. The `§ Task report` implementer sentence of G9 is
  left to Item 2, which owns filling the entries. Result:
  `check-plan-text.test.sh` passes, its new cases included.

## Review
