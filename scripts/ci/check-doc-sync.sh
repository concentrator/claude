#!/usr/bin/env bash
# Tier-1 doc-sync gate: a branch that adds, removes or renames a path a
# MAINTENANCE.md § Doc-sync pairs row matches changes each file the row
# names, a renamed path answering to the rows of both its names. A plain
# edit, and every pair no row expresses, stay with the Tier-2 Doc sync
# concern. A glob matches the whole path, `*` matching anything but `/`.
set -uo pipefail
h="$(dirname "${BASH_SOURCE[0]}")/branch-diff.sh"
{ [ -r "$h" ] && . "$h"; } \
  || { echo "check-doc-sync: cannot load branch-diff.sh"; exit 1; }
cd "$(git rev-parse --show-toplevel)"

M=MAINTENANCE.md
base=$(branch_base) || { echo "check-doc-sync: SKIP (no default branch)"; exit 0; }

# One line per row: the glob, then each file the row names, tab-separated.
rows=$(awk '
  /^#/ { on = ($0 ~ /^### Doc-sync pairs[[:space:]]*$/); next }
  on && /^\|/ {
    n = split($0, cell, "|"); if (n < 4) next
    out = ""
    for (c = 2; c <= 3; c++) {
      s = cell[c]; k = 0
      while (match(s, /`[^`]+`/)) {
        t = substr(s, RSTART + 1, RLENGTH - 2); sub(/ .*/, "", t)
        out = out (out == "" ? "" : "\t") t; k++
        s = substr(s, RSTART + RLENGTH)
      }
      if (k == 0) { out = ""; break }
    }
    if (out != "") print out
  }' "$M" 2>/dev/null)
[ -n "$rows" ] || { echo "DOC-SYNC: no rows under $M § Doc-sync pairs"; exit 1; }

changes=$({ branch_git diff --name-status --no-ext-diff -M "$base"
            branch_git ls-files --others --exclude-standard | awk '{ print "A\t" $0 }'; })

hits=$(printf '%s\n' "$changes" | ROWS=$rows awk -F '\t' '
  function rx(g,   r, i, c) {
    r = "^"
    for (i = 1; i <= length(g); i++) {
      c = substr(g, i, 1)
      if (c == "*") r = r "[^/]*"
      else if (c ~ /[A-Za-z0-9_\/-]/) r = r c
      else if (c == "\\" || c == "^") r = r "\\" c
      else r = r "[" c "]"
    }
    return r "$"
  }
  BEGIN {
    nr = split(ENVIRON["ROWS"], line, "\n")
    for (i = 1; i <= nr; i++) {
      split(line[i], f, "\t"); glob[i] = f[1]; re[i] = rx(f[1]); docs[i] = line[i]
      sub(/^[^\t]*\t/, "", docs[i])
    }
  }
  $1 == "" { next }
  {
    s = substr($1, 1, 1)
    touched[$2] = 1; if (NF >= 3) touched[$3] = 1
    if (s == "A") ev[++ne] = $2 "\tadded"
    else if (s == "D") ev[++ne] = $2 "\tremoved"
    else if (s == "R") { ev[++ne] = $2 "\trenamed to " $3; ev[++ne] = $3 "\trenamed from " $2 }
  }
  END {
    for (e = 1; e <= ne; e++) {
      split(ev[e], p, "\t")
      for (i = 1; i <= nr; i++) {
        if (p[1] !~ re[i]) continue
        nd = split(docs[i], d, "\t"); miss = ""
        for (j = 1; j <= nd; j++) if (!(d[j] in touched)) miss = miss (miss == "" ? "" : ", ") d[j]
        if (miss != "") printf "DOC-SYNC: %s %s, matching %s: %s unchanged\n", p[1], p[2], glob[i], miss
      }
    }
  }')

[ -z "$hits" ] || { printf '%s\n' "$hits"; exit 1; }
echo "check-doc-sync: OK"
