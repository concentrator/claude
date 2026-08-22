#!/usr/bin/env bash
# secret-patterns.sh - the one home of the secret predicate (R-022,
# extracted R-058). Sourced by dev-secrets-guard.sh, which sits beside it;
# every consumer judges content through this same function.

# Reads content on stdin; returns 0 if it carries a secret, after dropping
# any line that opts out with the `secrets-guard: allow` marker.
has_secret() {
  local body
  body=$(grep -v 'secrets-guard: allow')
  printf '%s' "$body" | grep -Eq '(-----BEGIN [A-Z ]*PRIVATE KEY-----|AKIA[0-9A-Z]{16}|gh[posr]_[A-Za-z0-9]{36}|github_pat_[A-Za-z0-9_]{22,}|xox[baprs]-[0-9A-Za-z-]{10,}|AIza[0-9A-Za-z_-]{35})' && return 0
  # Generic: a secret-name word next to a 16+ char value. Require a digit in
  # the match to exclude low-entropy word-slugs (e.g. `wallarm-api-token`) -
  # a digit can only come from the value, since the name words and the
  # `[^a-z0-9]` separator carry none. Real tokens/keys/passwords have digits.
  printf '%s' "$body" | grep -Eio '(secret|token|passwd|password|api[_-]?key)[^a-z0-9]{1,10}[a-z0-9/+_-]{16,}' | grep -q '[0-9]' && return 0
  return 1
}
