# effect-substrate · how to organize a TS app around ECS + Effect + Hexagonal

> Status: `candidate` · validated across 2 cycles in 1 project (compass · 2026-05-11 + 2026-05-12) · doctrine depth: 2 (narrative · see doctrine-evolution.md) ·
> needs ≥ 3 distinct projects to promote to `active`.
> See [doctrine-evolution.md](doctrine-evolution.md) for breadth (status) vs depth (narrative).

This pack names the isomorphism between three architectural vocabularies that
keep proposing the same shape:

| ECS (game dev) | Effect (FP) | Hexagonal (Cockburn) |
|---|---|---|
| World | Layer | The application |
| System | Service | Use case |
| Component | Schema record | DTO / value object |
| Archetype query | Port interface | Port |
| Live implementation | Layer.succeed | Adapter |

**The doctrine in one sentence:** name the boundary, type the boundary, and let
implementations move behind it.

## When to fire this pack

- You've shipped enough that the implementation is half-emergent in the code.
  Look for: a `subscribe(cb)` pattern · a singleton with a global state machine
  · the same try/catch boilerplate at 3+ sites · element/token tables
  redeclared per component.
- Test count says the behavior is locked. Wrapping a working imperative module
  is FAGAN-safe; rewriting it during the refactor is not.
- You want **agent-readable**, not just human-readable. Subagents enumerate
  behavior surfaces via grep; they need filenames that say what files are.

## What this pack adopts

### Level 1 · structural isomorphism (cycle 1 · 2026-05-11)

Read these in order — each builds on the previous:

1. **[domain-ports-live](patterns/domain-ports-live.md)** — the four-folder
   pattern. Pure shape → service interface → production adapter → test adapter.

2. **[suffix-as-type](patterns/suffix-as-type.md)** — the filename suffix
   discipline (`*.port.ts`, `*.live.ts`, `*.mock.ts`, `*.system.ts`) that
   makes the behavior surface enumerable in one `find` command.

3. **[ecs-effect-isomorphism](patterns/ecs-effect-isomorphism.md)** — the
   three-vocabulary mapping. Tells you when ECS framing is load-bearing
   vs decorative.

4. **[delete-heavy-cycle](patterns/delete-heavy-cycle.md)** — the refactor
   recipe. Net LOC must go negative.

5. **[single-effect-provide-site](patterns/single-effect-provide-site.md)** —
   the comment-as-spec rule + cross-layer composition. Cycle 1 named the
   rule, cycle 2 added CI enforcement and Layer.provide threading for
   inter-Service deps.

The worked example — [compass-cycle-2026-05-11](examples/compass-cycle-2026-05-11.md)
— shows level-1 adoption end-to-end.

### Level 2 · positional isomorphism · adopt-don't-invent (cycle 2 · 2026-05-12)

Once level-1 is in place, level 2 adds the **adopt-don't-invent** doctrine
for upstream substrate adoption:

6. **[hand-port-with-drift](patterns/hand-port-with-drift.md)** — when an
   upstream schema lives in an incompatible type system (e.g., TypeBox vs
   Effect Schema), don't codegen a converter. Hand-port what you need,
   vendor the JSON, let CI tell you when reality drifts.

7. **[doc-only-then-runtime](patterns/doc-only-then-runtime.md)** — when
   the upstream contract exists but the runtime hasn't shipped, adopt at
   compile time. Document the force chain. Brand the boundary type. Wait
   for runtime. Swap mechanically when it lands.

8. **[lift-pattern-template](patterns/lift-pattern-template.md)** — the
   5-command recipe for adding a new Effect Service. Once the four-folder
   pattern + single-effect-provide-site discipline are in place, every new
   service should be 5 commands or less. Operationalized via
   [`scripts/scaffold-system.sh`](scripts/scaffold-system.sh).

9. **[state-ownership-matrix](patterns/state-ownership-matrix.md)** — when
   3+ Services share a domain, declare per-system Ref/PubSub ownership in
   SKILL.md. CI enforces read-only declarations.

The worked example — [compass-cycle-2026-05-12](examples/compass-cycle-2026-05-12.md)
— shows level-2 adoption on top of cycle 1's level-1 substrate.

## What this pack is NOT

- **Not an Effect tutorial.** Read the [Effect docs](https://effect.website/docs/requirements-management/services/)
  for the framework. This pack covers organization, not language.
- **Not a 'rewrite-everything-in-Effect' mandate.** The Effect surface lives
  at boundaries. Inside an adapter, write whatever the domain needs (imperative
  classes, raw promises, audio nodes). Adoption is incremental.
- **Not ECS-everywhere.** ECS framing is most useful for entity-heavy domains
  (sim · game · streaming). Document boundaries that look like CRUD on records
  don't gain from the System/Component reframe.

## Promotion criteria · breadth and depth

This pack stays `status: candidate` until adopted by at least three **distinct**
projects, one of which is non-Next.js. Each adoption updates
`provenance.validated_in` in [construct.yaml](construct.yaml) with the net LOC
delta and a 1-line lesson.

The `doctrine_depth` field in `construct.yaml` is a separate dimension that
tracks how deep the doctrine has compounded across cycles · single-project
compounding doesn't substitute for cross-project breadth, but it does deepen
the patterns the pack carries. See [doctrine-evolution.md](doctrine-evolution.md)
for the level 1 / level 2 / future-level 3 narrative.

## Composes with

- **the-arcade** (OSTROM lens) for architecture decisions at the seam.
- **artisan** (ALEXANDER lens) for FAGAN-safe refactor discipline.
