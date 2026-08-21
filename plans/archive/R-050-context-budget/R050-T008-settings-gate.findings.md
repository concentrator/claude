# R050-T008 findings

Decision evidence for this branch.

## The gate proves itself, and the first version did not

The plan asked each case to be "proved to bite by running the real check
against a fixture that violates exactly that condition". The first version
passed nine cases and did not meet that bar: deleting three of its five
assertions left the suite fully green.

| Assertion | Why no case proved it |
|---|---|
| `[ -f settings.json ]` | the case grepped `settings.json`, which the parse message also contains |
| `has("autoCompactWindow")` | the case grepped `autoCompactWindow`, which every window message contains; an absent key then reported a range violation, naming the wrong condition |
| `type == "number"` | no case existed; a string value reported "is 200000, outside the range 100000 to 1000000", a message whose printed value sits inside its printed range |

The greps were too loose to distinguish one condition's message from
another's, which is what let them pass while asserting nothing. Keying each
case on the `SETTINGS:` tag plus wording unique to its own condition fixes
the class, not just the three instances.

Two further defects came from the same review: a missing `jq` exited 127
into the parse branch and blamed a valid file, and `jq -e .` conflated
"parses" with "truthy", so a bare `null` reported as unparseable while a
string or array reached the key lookups and misreported there.

## Mutation sweep

Every assertion was deleted in turn, with the mutant checked for valid
syntax first, and the suite re-run:

    nofile  noobject  noenabled  nohas  notype  norange  nojq
    caught    caught     caught  caught caught   caught  caught

The syntax check matters. An earlier sweep of mine deleted single lines from
a two-line `||` construct and from inside a multiline `jq` filter, breaking
the script so it failed on every fixture. That reads as "caught" while
proving nothing, and it is how the first version's gaps stayed hidden from
me after a reviewer had already named them.

## Plan defect

The plan split the check and its test into separate commit items. `feat.md`
holds that a checkbox carries its test and implementation together and that
"write tests" is never its own item, so the split cannot be honoured as
written; both items landed in one commit. Worth fixing in the plan rather
than repeating.

## Scope note

The check is deliberately not shipped to adopters. `install-dev.sh` carries
a curated set of checks with no dependency on this repo's own layout, and
this one asserts this repo's harness config, so not-shipped is the
documented default rather than an omission.
