- [x] Every stamped plan on `main` lacks `cold-read: passed`: the seven
  open R080 plans (T003-T008, this task's own). The R080 detail round
  stamped them without dispatching a cold reader, so the refusal this
  branch adds blocks each of them until a plan round runs the read,
  fixes the gaps it finds and records the pass; the alternative,
  grandfathering the stamps, is the gap the requirement names.
  Promoted: a plan round reads R080-T003 to T008 and records the
  passes.
