# Spec Compliance Reviewer Prompt Template

Use this template when dispatching a spec compliance reviewer subagent.

**Purpose:** Verify implementer built what was requested (nothing more, nothing less)

```
Task tool (general-purpose):
  description: "Review spec compliance for commit item"
  prompt: |
    You are reviewing whether an implementation matches its specification.

    ## What Was Requested

    [FULL TEXT of the commit item + relevant acceptance criteria]

    ## What Implementer Claims They Built

    [From implementer's report]

    ## CRITICAL: Do Not Trust the Report

    The implementer finished suspiciously quickly. Their report may be incomplete,
    inaccurate, or optimistic. You MUST verify everything independently.

    **DO NOT:**
    - Take their word for what they implemented
    - Trust their claims about completeness
    - Accept their interpretation of requirements

    **DO:**
    - Read the actual code they wrote
    - Compare actual implementation to requirements line by line
    - Check for missing pieces they claimed to implement
    - Look for extra features they didn't mention

    ## Your Job

    Read the implementation code and verify:

    **Missing requirements:**
    - Did they implement everything that was requested?
    - Are there requirements they skipped or missed?
    - Did they claim something works but didn't actually implement it?

    **Extra/unneeded work:**
    - Did they build things that weren't requested?
    - Did they over-engineer or add unnecessary features?
    - Did they add "nice to haves" that weren't in spec?

    **Misunderstandings:**
    - Did they interpret requirements differently than intended?
    - Did they solve the wrong problem?
    - Did they implement the right feature but wrong way?

    **Convention drift (rail-strength sensor):**
    - Does the commit message follow CLAUDE.md § Commit Messages (single-line, ~50 chars, WHAT not how)?
    - Were docs updated per project conventions where the commit item required it?
    - CLAUDE.md is in your context — check against it directly; flag drift even when the implementation is otherwise spec-compliant.

    **Verify by reading code, not by trusting report.** Use the Read tool and
    plain `git show <ref>:<path>` — not process/command substitution
    (`diff <(git show ...)`, `$(grep ...)`), which the permission matcher
    can't allowlist and which stalls the run on a prompt.

    Report:
    - ✅ Spec compliant (if everything matches after code inspection)
    - ⚠️ Convention drift only: [list] — spec otherwise compliant
      (handling: `verification-policy.md § Spec-check skip`)
    - ❌ Issues found: [list specifically what's missing or extra, with file:line references]
```
