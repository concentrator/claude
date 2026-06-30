# R-015 tasks

Task index for this initiative. Items:
`T-001 (R-001) [feat|fix|refactor]: description` — format and closure:
`rules/planning.md § Levels`. Cross-R index: `plans/ROADMAP.md`.
Acceptance-criterion numbers (AC#) reference `requirements.md`.

R-015 spans several batches — each task is individually coherent and
sizeable. T-031–T-034 depend on T-030's manifest; their branch plans are
detailed once it lands.

## Open

- [x] T-030 (R-015) [refactor]: Audit & portable-core manifest — classify
  every skill and rule (portable-generic / project-specific / global-only);
  make the source embed-ready (uniform `~/.claude/` cross-refs; lift
  project-specifics into rules so skills stay generic/namespaceable);
  produce the portable-core manifest; record the embedding architecture
  (vendor transform, `dev-*` namespacing, embed-aware `dev` + marker,
  version stamp/drift, CI subset, generic CLAUDE.md backbone) in
  `DESIGN.md`. architecture-changing. (AC9)
- [x] T-031 (R-015) [feat]: Vendor transform — script that copies the
  manifest's portable core from a pinned source into `<target>/.claude/`,
  rewrites `~/.claude/…`→`.claude/…`, applies `dev-*` namespacing, prunes
  the self-hosting layer, emits the generic DEV `CLAUDE.md` backbone with
  `@`-imports, writes the version stamp, and includes the embedded CI
  subset (caps + plan-integrity + references + stray + todos, no ledger).
  (AC2, AC3, AC4, AC6) `depends-on: T-030`
- [x] T-032 (R-015) [feat]: Embed-aware `dev` + clone-time check — the
  global `dev` detects an embedded project (the version-stamp marker),
  dispatches into the `dev-*` skills, and follows the embedded rules; a
  clone-time check warns on a missing or stale global `dev`. Preserves the
  `/dev` command. (AC5) `depends-on: T-031`
- [ ] T-033 (R-015) [feat]: Drift detection + re-vendor sync — compare the
  embedded version stamp against the pinned source, report stale, and
  update the embedded copy in place on re-vendor. (AC6, AC7)
  `depends-on: T-031`
- [ ] T-034 (R-015) [feat]: Opt-in wiring — add the "embed a self-contained
  DEV toolchain" opt-in to `starting-a-project` and `migrating-to-dev`,
  invoking the vendor; default behavior unchanged when not opted in. (AC8)
  `depends-on: T-031`
- [ ] T-035 (R-015) [feat]: Embedded CI subset — adapt the 5 Tier-1 checks
  (caps, plan-integrity, references, stray, todos) + a ledger-free
  `run-all` to the adopter `.claude/`-rooted layout (artifacts under
  `.claude/`, not the repo root), wired into the vendor transform.
  Split from T-031. (AC4) `depends-on: T-031`
