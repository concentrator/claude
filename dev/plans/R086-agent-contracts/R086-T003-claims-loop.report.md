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
`CLAUDE.md` is 70 lines of 100; `DESIGN.md` 711 words of 1000. The draft
gate is 182 lines of 300, its longest function `scan()` at 44 of 50 and
`claims()` at 33.
Trap: `branch-plan.md` has 8 lines of headroom, which is why the claims
rules live in `documentation.md § Claims` and `branch-plan.md` only cites it.

#### Draft gate on this checkout
Request: `bash <scratch>/ci/check-plan-text.sh` run from the checkout.
Response: `check-plan-text: OK`, rc 0; `git status --short` empty after.

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

## Implementer

## Review
