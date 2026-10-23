# install-manifest.sh - what an install owns in its target, sourced by
# install-dev.sh once it has set SRC, target and RETIRED.
#
# An install owns only what it copied. `ship` queues a file, its path the same
# under the repository and the target; `install_shipped` copies the queue and
# records each copy's git blob hash in $target/$MANIFEST. A file already at a
# queued path is the install's to overwrite when it is identical to the
# shipped one, matches its manifest record or, with no record, matches a
# committed version of its path in the repository; any other is the user's,
# left in place and listed. A recorded file the set no longer ships, and a
# retired hook, go when the same test finds them the install's, and are
# listed otherwise.

MANIFEST=dev-install-manifest.txt
WORK=$(mktemp -d); trap 'rm -rf "$WORK"' EXIT
: > "$WORK/ship"; : > "$WORK/kept"

ship() {   # $1 = path; $2 = x for an executable
  printf '%s\t%s\n' "$1" "${2:--}" >> "$WORK/ship"
}

ship_tree() {   # $1 = a directory of the repository: every file under it
  local f
  while IFS= read -r f; do ship "$f"; done < <(cd "$SRC" && find "$1" -type f | LC_ALL=C sort)
}

hash_at() {   # $1 = root; stdin: paths under it; stdout: "<path>\t<hash>" per file present
  local p present=""
  while IFS= read -r p; do
    if [ -f "$1/$p" ]; then present="$present$p"$'\n'; fi
  done
  [ -n "$present" ] || return 0
  paste <(printf '%s' "$present") \
        <(printf '%s' "$present" | awk -v r="$1/" '{ print r $0 }' | git hash-object --no-filters --stdin-paths)
}

committed() {   # $1 = path, $2 = hash: is it a version of the path the repository committed?
  if [ ! -f "$WORK/committed" ]; then
    local p paths=()
    while IFS= read -r p; do paths+=("$p"); done < <({ cut -f1 "$WORK/ship"; cut -f1 "$WORK/rec"; cut -f1 "$WORK/drop"; } | sort -u)
    git --literal-pathspecs -C "$SRC" log --no-renames --raw --no-abbrev --format= HEAD -- "${paths[@]}" 2>/dev/null \
      | awk -F '\t' '/^:/ { split($1, m, " "); print m[3] "\t" $2; print m[4] "\t" $2 }' > "$WORK/committed" || true
  fi
  grep -qxF "$2"$'\t'"$1" "$WORK/committed"
}

owned() {   # $1 = path, $2 = its hash in the target, $3 = its manifest record or -
  if [ "$3" != - ]; then [ "$2" = "$3" ]; else committed "$1" "$2"; fi
}

# The rows of $2 (path first) joined with the target's hash and the manifest
# record of each path: "<row>\t<hash or ->\t<record or ->".
with_target() {   # $1 = the manifest's "<path>\t<hash>" rows, $2 = the rows
  cut -f1 "$2" | hash_at "$target" > "$WORK/cur"
  awk -F '\t' -v OFS='\t' '
    FILENAME == ARGV[1] { rec[$1] = $2; next }
    FILENAME == ARGV[2] { cur[$1] = $2; next }
    { print $0, ($1 in cur ? cur[$1] : "-"), ($1 in rec ? rec[$1] : "-") }' "$1" "$WORK/cur" "$2"
}

copy_shipped() {   # copy each queued file the target holds no file of the user's at
  local p mode src cur rec d
  cut -f1 "$WORK/ship" | hash_at "$SRC" > "$WORK/src"
  awk -F '\t' -v OFS='\t' 'FILENAME == ARGV[1] { h[$1] = $2; next } { print $0, h[$1] }' "$WORK/src" "$WORK/ship" > "$WORK/shiph"
  with_target "$WORK/rec" "$WORK/shiph" > "$WORK/table"
  while IFS=$'\t' read -r p mode src cur rec; do
    if [ "$cur" = - ] || [ "$cur" = "$src" ] || owned "$p" "$cur" "$rec"; then
      d="$target/$p"; d=${d%/*}; [ -d "$d" ] || mkdir -p "$d"
      [ "$cur" = "$src" ] || cp "$SRC/$p" "$target/$p"
      [ "$mode" = - ] || chmod +x "$target/$p"
      printf '%s  %s\n' "$src" "$p" >> "$WORK/new"
    else
      printf '%s\n' "$p" >> "$WORK/kept"
    fi
  done < "$WORK/table"
}

drop_unshipped() {   # remove each recorded file or retired hook the set does not ship
  local p cur rec d
  with_target "$WORK/rec" "$WORK/drop" > "$WORK/table"
  while IFS=$'\t' read -r p cur rec; do
    [ "$cur" != - ] || continue
    if owned "$p" "$cur" "$rec"; then
      rm -f "$target/$p"; d=$(dirname "$p")
      while [ "$d" != . ] && rmdir "$target/$d" 2>/dev/null; do d=$(dirname "$d"); done
    else
      printf '%s\n' "$p" >> "$WORK/kept"
    fi
  done < "$WORK/table"
}

install_shipped() {   # copy the queue, drop what the set no longer ships, rewrite the manifest
  local h
  : > "$WORK/new"
  if [ -f "$target/$MANIFEST" ]; then
    awk '{ h = $1; sub(/^[^ ]+  /, ""); print $0 "\t" h }' "$target/$MANIFEST" > "$WORK/rec"
  else
    : > "$WORK/rec"
  fi
  { cut -f1 "$WORK/rec"; for h in $RETIRED; do printf 'hooks/%s\n' "$h"; done; } | LC_ALL=C sort -u \
    | { grep -vxFf <(cut -f1 "$WORK/ship") || true; } > "$WORK/drop"
  copy_shipped
  drop_unshipped
  LC_ALL=C sort -k2 "$WORK/new" > "$target/$MANIFEST"
}

list_kept() {   # name each file left in place as the user's
  local p
  while IFS= read -r p; do echo "install-dev: left in place, not the install's copy: $target/$p"; done < "$WORK/kept"
}
