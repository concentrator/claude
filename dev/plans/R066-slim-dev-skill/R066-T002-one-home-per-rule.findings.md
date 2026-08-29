# R066-T002 findings

## Read sets, bytes

Measured with `wc -c` at the branch base and at close (`supervise.md`,
`supervisor-runbook.md`, `verification-policy.md`, `declarations.md`
are the `/dev supervise` set; `branch-plan.md`, `git-workflow.md`,
`finish.md` the `/dev code` set):

| File | Base | Close |
|---|---|---|
| `supervise.md` | 9517 | 8771 |
| `companions/supervisor-runbook.md` | 9877 | 9895 |
| `companions/verification-policy.md` | 9285 | 8662 |
| `companions/declarations.md` | 5889 | 5392 |
| `/dev supervise` set | 34568 | 32720 |
| `branch-plan.md` | 10049 | 9953 |
| `git-workflow.md` | 7407 | 7236 |
| `finish.md` | 3612 | 3652 |
| `/dev code` set | 21068 | 20841 |
| `plan.md` | 10080 (1437 words) | 9687 (1400 words) |
| `secrets.md` → `companions/secrets.md` | 2362 | 2014 |

Across the initiative (T001 base to T002 close): the `/dev supervise`
set 36075 → 32720 bytes, `skills/dev` 264 → 216 KB (`du -sk`), the
runbook 1738 → 1486 words.

## Rule-to-home table, checked

`git grep` of each row's phrase under `skills/dev/` (and the hook for
the last row) hits the one home; no other hit states the rule:

- [x] Commit caps - `past 30`: `branch-plan.md § Size cap` only
- [x] Branch-close verify set - `findings file triaged`: `finish.md § 1` only
- [x] Declared commands, never probe the host - `probing the host`: `declarations.md § Declared commands` only
- [x] The supervisor never merges - `No grant merges`: `declarations.md § Supervisor bounds` only
- [x] Close folding - `3 non-final commit checkboxes`: `verification-policy.md § Close folding` only
- [x] Plan branch before the first write - `before the first`: `plan.md § Where plans live in git` only
- [x] Layout table - `├── <task-id>-<slug>.findings.md`: `layout.md § Artifacts layout` only
- [x] Secret patterns - `AKIA`: `hooks/secret-patterns.sh`; the other hit is the allow-marker example in `companions/secrets.md § False positives`, not a pattern list

`toolchain.md`'s opening was already a pointer to `declarations.md`;
it needed no edit.

## Criteria 1, 4, 5, 6

- Criterion 1 (re-run on this branch): the grep returns 0 files.
- Criterion 4: `git grep -n 'resolve-root\|permission_prompts\|lever 1\|invoked from .SKILL.md\|§ Operator modes' -- skills hooks scripts`
  hits `declarations.md:49` (the heading's own in-file pointer) and
  `supervisor-runbook.md:70` (`declarations.md § Operator modes`, the
  file-qualified citation that replaced the bare one). The other four
  strings have no hit.
- Criterion 5: `grep -nE 'R-?0[0-9]{2}' skills/dev` hits id-format
  examples (`plan.md`, `templates.md`, `write-plan.md`,
  `branch-plan.md`, `auto.md`), the example hand-off note in
  `handoff.md`, and `ADR-001` in `layout.md`; no sentence names an
  initiative as a rule's origin.
- Criterion 6: a one-off checker (below) over every `file § Section`
  citation in `skills/dev/`: 191 citations. Unresolved by heading:
  `CLAUDE.md § Conventions` (10) and `ROADMAP.md § Milestones` (2),
  sections of adopter-project files that `start.md` scaffolds;
  `git-workflow.md § Merge order` and `§ Merge policy`, bold labels
  (the audit's note, no gate); `branch-plan.md § agentic: stamp`, a
  backticked heading the checker misread; and `finish.md § 3 Ship`,
  stale, corrected on this branch.

```python
import re, glob, os, sys
root='skills/dev'
files=glob.glob(root+'/*.md')+glob.glob(root+'/companions/*.md')
heads={}
for f in files+glob.glob('*.md')+glob.glob('rules/*.md')+glob.glob('agents/*.md'):
    heads[f]=[re.sub(r'^#+\s*','',l).strip() for l in open(f) if l.startswith('#')]
pat=re.compile(r'`([\w./-]+\.md)\s*§\s*([^`]+)`')
bad=0; total=0
for f in files:
    s=open(f).read()
    for m in pat.finditer(s):
        total+=1
        fn=m.group(1); sec=re.sub(r'\s+',' ',m.group(2)).strip()
        cands=[os.path.join(root,fn),os.path.join(root,'companions',fn),fn,os.path.join(root,'companions',os.path.basename(fn))]
        tgt=next((c for c in cands if c in heads),None)
        if not tgt: print(f'NOFILE {f}: `{fn} § {sec}`'); bad+=1; continue
        hs=heads[tgt]
        ok=any(h==sec or h.startswith(sec) or h.startswith(sec+' ') or re.match(r'^\d+\.\s*'+re.escape(sec.lstrip("0123456789. ")),h) for h in hs)
        if not ok:
            # bold inline label?
            if re.search(r'\*\*'+re.escape(sec)+r'\b',open(tgt).read()): print(f'LABEL  {f}: `{fn} § {sec}` (bold label, not a heading)')
            else: print(f'MISS   {f}: `{fn} § {sec}`'); bad+=1
print(f'{total} citations, {bad} unresolved')
```

Output:

```
NOFILE skills/dev/templates.md: `ROADMAP.md § Milestones`
MISS   skills/dev/migrate.md: `CLAUDE.md § Conventions`
LABEL  skills/dev/finish.md: `git-workflow.md § Merge order` (bold label, not a heading)
LABEL  skills/dev/finish.md: `git-workflow.md § Merge policy` (bold label, not a heading)
MISS   skills/dev/branch-plan.md: `CLAUDE.md § Conventions`
NOFILE skills/dev/plan.md: `ROADMAP.md § Milestones`
MISS   skills/dev/docs.md: `CLAUDE.md § Conventions`
MISS   skills/dev/start.md: `CLAUDE.md § Conventions`
MISS   skills/dev/start.md: `CLAUDE.md § Conventions`
MISS   skills/dev/layout.md: `CLAUDE.md § Conventions`
MISS   skills/dev/layout.md: `CLAUDE.md § Conventions`
MISS   skills/dev/companions/docs-adoption.md: `CLAUDE.md § Conventions`
MISS   skills/dev/companions/docs-adoption.md: `CLAUDE.md § Conventions`
MISS   skills/dev/companions/verification-policy.md: `branch-plan.md § agentic: stamp`
MISS   skills/dev/companions/untracked-claude.md: `CLAUDE.md § Conventions`
191 citations, 13 unresolved
```
