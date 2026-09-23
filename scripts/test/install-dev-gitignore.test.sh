#!/usr/bin/env bash
set -uo pipefail
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE
cd "$(git rev-parse --show-toplevel)"

INSTALL="$PWD/scripts/install-dev.sh"
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }

U=$(mktemp -d); git -C "$U" init -q; git -C "$U" checkout -qb work
printf 'dev/session/\ndev/supervisor/\n' > "$U/.gitignore"
bash "$INSTALL" --project "$U" >/dev/null 2>&1 || die "install (slash-less ignore fixture) exits nonzero"
! grep -qxF '/dev/session/' "$U/.gitignore" && ! grep -qxF '/dev/supervisor/' "$U/.gitignore" \
  && pass "an ignore line without the leading slash is not duplicated" || die "duplicated ignore lines: $(tr '\n' ' ' < "$U/.gitignore")"
rm -rf "$U"

(( fail == 0 )) && echo "install-dev-gitignore.test: OK"
exit $fail
