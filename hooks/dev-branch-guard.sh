#!/usr/bin/env bash
# dev-branch-guard.sh - PreToolUse hook (R-021, refined R-024/R-034/R-036/
# R-052).
# Refuses repo-mutating tool calls that would land on the trunk - the repo's
# default branch, resolved per is_trunk() below -
# so all work goes through a branch (git-workflow trunk rule). Reads the
# tool-call JSON on stdin; emits a PreToolUse "deny" decision when the write
# or commit actually targets a trunk. Silent (allow) otherwise. Judges the
# real target, never the session cwd: a write is judged by the repo owning
# the (physically resolved) target path - tracked-side on a trunk denies
# from any cwd; gitignored, repo-less, or working-branch targets allow. A
# commit is judged by the repo it targets - the last literal `cd` or
# `git -C <path>` before it, else the cwd; a repo the same command creates
# (`git init`) and a compound `checkout -b && commit` are allowed. Fails
# open.
#
# This is a best-effort local tripwire against an accidental trunk mutation,
# not a boundary against a crafted evasion - the real gate is host branch
# protection + CI (git-workflow.md § Enforcement). It reads an arbitrary
# shell command by heuristic, so residual gaps (e.g. a quoted `-C "a b"`
# path) fail open toward that gate.
set -uo pipefail

input=$(cat)

deny() {
  # permissionDecisionReason must be JSON-encoded (handles quotes/newlines).
  local reason
  reason=$(printf '%s' "$1" | jq -Rs .)
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":%s}}\n' "$reason"
  exit 0
}

# is_trunk <repo> <branch> - the trunk is the repo's default branch:
# origin/HEAD, then init.defaultBranch, then the main/master literals
# when neither resolves.
is_trunk() {
  local def
  def=$(git -C "$1" symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null)
  def=${def#origin/}
  [ -n "$def" ] || def=$(git -C "$1" config init.defaultBranch 2>/dev/null)
  if [ -n "$def" ]; then
    [ "$2" = "$def" ]
  else
    case "$2" in main | master) return 0 ;; *) return 1 ;; esac
  fi
}

tool=$(printf '%s' "$input" | jq -r '.tool_name // ""')
case "$tool" in
  Write | Edit | NotebookEdit)
    # A file mutation is judged by the repo that OWNS the target path -
    # the session cwd is irrelevant (R-036). Resolve the target
    # physically (symlinks and dots; nearest existing ancestor +
    # not-yet-existing tail), find the owning repo from that ancestor,
    # and deny only what can land on a trunk: the owner's HEAD is a
    # trunk and the path is tracked-side there (check-ignore exit 1).
    # Ignored paths, a working-branch owner, no owner, and errors all
    # allow (fail open).
    path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // .tool_input.notebook_path // ""')
    if [ -n "$path" ]; then
      case "$path" in /*) ;; *) path=$PWD/$path ;; esac
      # Physical target: walk to the nearest existing ancestor, resolve it
      # (pwd -P), keep the not-yet-existing tail. A ./.. component left in
      # the tail is folded lexically - nonexistent components cannot be
      # symlinks - and the walk re-runs on the folded path, so
      # `ghost/../repo/file` is judged by where it really lands.
      pass=0
      while :; do
        p=$path tail=
        while [ ! -d "$p" ] && [ "$p" != / ]; do
          tail=/$(basename -- "$p")$tail
          p=$(dirname -- "$p")
        done
        anc=$(cd "$p" 2>/dev/null && pwd -P)
        [ -n "$anc" ] || exit 0                     # unresolvable → fail open
        [ "$anc" = / ] && anc=
        target=$anc$tail
        [ -n "$target" ] || target=/
        case "${tail}/" in
          */../*|*/./*)
            folded= rest=$target/
            while [ -n "$rest" ]; do
              comp=${rest%%/*}; rest=${rest#*/}
              case "$comp" in ''|'.') ;; '..') folded=${folded%/*} ;; *) folded=$folded/$comp ;; esac
            done
            path=${folded:-/}
            pass=$((pass+1)); [ "$pass" -lt 3 ] || exit 0
            continue ;;
        esac
        break
      done
      # Follow a final-component symlink (bounded) - the write lands at
      # its destination, not at the link's name.
      hops=0
      while [ -L "$target" ] && [ "$hops" -lt 8 ]; do
        link=$(readlink -- "$target") || break
        case "$link" in /*) t=$link ;; *) t=${target%/*}/$link ;; esac
        d=$(cd "$(dirname -- "$t")" 2>/dev/null && pwd -P) || d=
        [ -n "$d" ] || break
        target=$d/$(basename -- "$t")
        hops=$((hops+1))
      done
      # Owning repo of the target; an owner with an unborn HEAD (fresh
      # `git init`, no commits) climbs to the enclosing repo - an
      # accidental nested init must not disable the guard for
      # outer-tracked files.
      jdir=$(dirname -- "$target")
      [ -d "$jdir" ] || jdir=${anc:-/}
      while :; do
        top=$(git -C "$jdir" rev-parse --show-toplevel 2>/dev/null)
        [ -n "$top" ] || exit 0                     # no owning repo → allow
        top=$(cd "$top" 2>/dev/null && pwd -P)
        [ -n "$top" ] || exit 0
        branch=$(git -C "$top" rev-parse --abbrev-ref HEAD 2>/dev/null) && break
        [ "$top" != / ] || exit 0
        jdir=$(dirname -- "$top")                   # unborn → climb
      done
      is_trunk "$top" "$branch" || exit 0           # owner on a working branch → allow
      git -C "$top" check-ignore -q -- "$target" 2>/dev/null
      [ $? -eq 1 ] || exit 0                        # ignored or error → allow
      deny "branch-guard: refusing $tool into '$top' on '$branch'. Create a working branch there first - never edit the trunk (git-workflow)."
    fi
    # No path in the call: keep the conservative cwd-repo judgment.
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || exit 0
    [ -n "$branch" ] || exit 0
    is_trunk . "$branch" || exit 0
    deny "branch-guard: refusing $tool on '$branch'. Create a working branch first - never edit the trunk (git-workflow)." ;;
  Bash)
    cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // ""')
    # Global-option skipper (-c key=val, -C path, --flag) shared by the
    # commit detector and the branch-create exemption. Quote characters
    # end the match, so a quoted value cannot smuggle tokens into either
    # pattern.
    opt="([[:space:]]+-[^[:space:]\"']+([[:space:]]+[^[:space:]\"'-][^[:space:]\"']*)?)*"

    # Push rules (R-058). A push is judged from its own command segment -
    # command-head anchored, so echo text never triggers - covering the
    # spellings the settings deny pair misses.
    Prx="^(.*)(^|[;&|])[[:space:]]*git${opt}[[:space:]]+push([[:space:]]|\$)"
    pnorm="${cmd//$'\n'/;}"
    if [[ "$pnorm" =~ $Prx ]]; then
      pseg="${pnorm:${#BASH_REMATCH[0]}}"
      pseg="${pseg%%[;&|]*}"
      set -f
      for tok in $pseg; do
        case "$tok" in
          -f | --force | --force-with-lease | --force-with-lease=*)
            deny "branch-guard: refusing 'git push' carrying '$tok' - a force push in any spelling is denied (git-workflow § Enforcement)." ;;
          +*)
            deny "branch-guard: refusing 'git push' carrying the forced refspec '$tok' - a force push in any spelling is denied (git-workflow § Enforcement)." ;;
        esac
      done
      set +f
    fi

    # Only guard commands that actually commit. The boundary after
    # `commit` leaves plumbing (git commit-tree / commit-graph) alone.
    crx="(^|[^[:alnum:]-])git${opt}[[:space:]]+commit([[:space:]]|\$)"
    [[ "$cmd" =~ $crx ]] || exit 0

    # Everything up to the first `commit` - a branch created/switched here
    # first means the commit lands off the trunk.
    before="${cmd%%commit*}"
    before="${before//$'\n'/;}"   # newlines separate commands too, like ;&|

    # A repo this same command creates is not project work: a command-head
    # `git init` before the commit allows (R-052). It is the only signal
    # readable from the call text when the fixture path is a runtime
    # variable.
    irx="(^|[;&|]+)[[:space:]]*git${opt}[[:space:]]+init([[:space:];&|]|\$)"
    [[ "$before" =~ $irx ]] && exit 0

    # Judge the repo the commit targets: the later of the last `git -C
    # <path>` and the last command-head `cd <path>` before it (both via a
    # greedy prefix), else the cwd repo. A cd target with expansion
    # characters cannot be read from the call text - fail open.
    Crx="^(.*)git[[:space:]]+-C[[:space:]]+([^[:space:]]+)"
    cdrx="^(.*)(^|[;&|])[[:space:]]*cd[[:space:]]+([^;&|[:space:]]+)"
    dir="." cpos=-1 dpos=-1 cval= dval=
    if [[ "$before" =~ $Crx ]]; then cpos=${#BASH_REMATCH[1]} cval="${BASH_REMATCH[2]}"; fi
    if [[ "$before" =~ $cdrx ]]; then dpos=${#BASH_REMATCH[1]} dval="${BASH_REMATCH[3]}"; fi
    if (( dpos > cpos )); then
      case "$dval" in *[\$\`\"\']*) exit 0 ;; esac
      dir="$dval"
    elif (( cpos >= 0 )); then
      dir="$cval"
    fi

    # Treat `checkout -b` / `switch -c` as a branch-create only when it is
    # an actual command head (start, or after a shell separator), names a
    # non-trunk branch, and happened in the SAME repo the commit targets -
    # a branch created elsewhere does not cover this commit. The checkout's
    # own repo comes from its `-C`, else the last cd before it, else the
    # cwd; a cd target only expansion could resolve forfeits the exemption
    # rather than guessing.
    xrx="^(.*)(^|[;&|]+)[[:space:]]*git${opt}[[:space:]]+(checkout|switch)([[:space:]]+-[^[:space:]]+)*[[:space:]]+(-b|-c)[[:space:]]+([^[:space:]]+)"
    if [[ "$before" =~ $xrx ]]; then
      xpre="${BASH_REMATCH[1]}"
      xseg="${BASH_REMATCH[0]:${#xpre}}"
      xbr="${BASH_REMATCH[8]}"
      codir=
      if [[ "$xseg" =~ -C[[:space:]]+([^[:space:]]+) ]]; then
        codir="${BASH_REMATCH[1]}"
      elif [[ "$xpre" =~ $cdrx ]]; then
        case "${BASH_REMATCH[3]}" in *[\$\`\"\']*) ;; *) codir="${BASH_REMATCH[3]}" ;; esac
      else
        codir="."
      fi
      if [ -n "$codir" ]; then
        cotop=$(git -C "$codir" rev-parse --show-toplevel 2>/dev/null)
        citop=$(git -C "$dir" rev-parse --show-toplevel 2>/dev/null)
        [ -n "$cotop" ] && [ "$cotop" = "$citop" ] && ! is_trunk "$cotop" "$xbr" && exit 0
      fi
    fi

    branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null) || exit 0
    is_trunk "$dir" "$branch" && deny "branch-guard: refusing 'git commit' on '$branch'. Create a working branch first (git-workflow)." ;;
esac

exit 0
