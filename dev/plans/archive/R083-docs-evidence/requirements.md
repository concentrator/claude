---
approved: yes
kind: mnt
---

# R083: Evidence references replace provenance marks

## Goal

A feature doc shows how it knows what it states. A claim's provenance
is the evidence attached to it - a report of a live probe, or the
source read - shown as a reference the reader can follow, never as a
word that asserts a strength nobody can check.

## Outcomes

1. A § Parameters row carries an `evidence` column holding references:
   a report doc for a probed claim, a source location, spec or vendor
   page, or adapted reference for a read one. Two references cover a
   row with both. An empty cell is the no-evidence state. No provenance
   vocabulary remains anywhere in the rules.
2. A report doc is the evidence for a probed claim; the rules say what
   it records so it can serve as one, on the terms the verification
   policy already sets for a run that could have failed.
3. Evidence does not chain: the rules name what a doc may cite as
   evidence, and a citation of a citation is none.
4. Verifier verdicts stay the verifier's; the rules bar writing one into
   a doc. An empty evidence cell reads as unproven.
5. The doc-writer seat, its prompt and the verification policy use the
   same words as the rules: reference, empty cell, no mark.
6. The evidence definition has one home, in the docs layout rule;
   every other rule cites it.

## Constraints

- Simplification only: each change removes a vocabulary, a rule or a
  step; no new artifact type, seat, gate or script.
- Source references name a path and symbol or heading, not a line;
  references in prose outside § Parameters are optional.
- A probed claim with no report doc has no evidence; accepted, not phased.
