# construct-effect-substrate

> Doctrine pack for organizing a TypeScript app around the **ECS ≡ Effect ≡ Hexagonal Architecture** isomorphism · plus the **adopt-don't-invent** positional doctrine for upstream substrate.
>
> **Status:** `candidate · doctrine_depth: 2` · validated across 2 cycles in 1 project (compass) · needs ≥3 distinct projects (one non-Next.js) to move to `active`. See [doctrine-evolution.md](doctrine-evolution.md) for the depth/breadth split.

Three architectural vocabularies have been describing the same structure for years.
Naming the isomorphism makes the choice between them a vocabulary preference, not
an architecture decision.

| ECS (game dev) | Effect (FP) | Hexagonal (Cockburn) | Filesystem |
|---|---|---|---|
| World | Layer | Application | `lib/runtime/runtime.ts` |
| System | Service (with capabilities) | Use case | `lib/ports/*.port.ts` |
| System impl | `Layer.succeed(Tag, ...)` | Adapter | `lib/live/*.live.ts` · `lib/mock/*.mock.ts` |
| Component | Schema record | DTO / value object | `lib/domain/*.ts` |
| Archetype query | Port interface | Port | `lib/ports/*.port.ts` |

The four-folder pattern (`domain/ports/live/mock`) is the structure all three converge on.
Pick the words you like; keep the filenames.

## Contents

- [`SKILL.md`](SKILL.md) — overview and when to fire this pack
- [`construct.yaml`](construct.yaml) — manifest · `status: candidate · doctrine_depth: 2`
- [`doctrine-evolution.md`](doctrine-evolution.md) — how the doctrine deepens through cycles · level 1 vs level 2
- [`MEMORY.md`](MEMORY.md) — pack-level lineage memory
- `patterns/` (cycle-1 = structural · cycle-2 = positional)
  - [`domain-ports-live.md`](patterns/domain-ports-live.md) — the four-folder pattern · cycle 1
  - [`suffix-as-type.md`](patterns/suffix-as-type.md) — filename discipline · cycle 1
  - [`ecs-effect-isomorphism.md`](patterns/ecs-effect-isomorphism.md) — when to reach for each vocabulary · cycle 1
  - [`delete-heavy-cycle.md`](patterns/delete-heavy-cycle.md) — the six-sprint refactor recipe + FAGAN gates · cycle 1
  - [`single-effect-provide-site.md`](patterns/single-effect-provide-site.md) — comment-as-spec + cross-layer composition · cycle 1+2
  - [`hand-port-with-drift.md`](patterns/hand-port-with-drift.md) — Effect Schema mirrors of upstream types + drift CI · cycle 2
  - [`doc-only-then-runtime.md`](patterns/doc-only-then-runtime.md) — adopt contract before runtime ships · brand-type fence · cycle 2
  - [`lift-pattern-template.md`](patterns/lift-pattern-template.md) — 5-command recipe for new Effect Services · cycle 2
  - [`state-ownership-matrix.md`](patterns/state-ownership-matrix.md) — per-system Ref/PubSub ownership · CI-enforced · cycle 2
- `examples/`
  - [`compass-cycle-2026-05-11.md`](examples/compass-cycle-2026-05-11.md) — first cycle (−1236 LOC · 128/128 tests · level 1)
  - [`compass-cycle-2026-05-12.md`](examples/compass-cycle-2026-05-12.md) — second cycle (+830 LOC · 130/130 tests · level 2)
- `cycles/` — pack-level lineage entries · one per cycle that adopts the pack
- `scripts/`
  - [`scaffold-system.sh`](scripts/scaffold-system.sh) — operationalized 5-command lift-pattern

## When to fire

- Implementation is half-emergent in the code (a `subscribe(cb)` pattern · a module singleton with global state · the same try/catch boilerplate at 3+ sites · element/token tables redeclared per component).
- Test count says the behavior is locked.
- You want **agent-readable**, not just human-readable.

## What this is NOT

- **Not an Effect tutorial.** Read the [Effect docs](https://effect.website/docs/requirements-management/services/).
- **Not a 'rewrite-everything-in-Effect' mandate.** Effect appears at boundaries; inside an adapter, write whatever the domain needs.
- **Not ECS-everywhere.** Reach for `*.system.ts` when the domain has per-frame transforms.

## Composes with

- [`construct-the-arcade`](https://github.com/0xHoneyJar/construct-the-arcade) — OSTROM architecture lens
- [`construct-artisan`](https://github.com/0xHoneyJar/construct-artisan) — ALEXANDER craft lens
- [`construct-fagan`](https://github.com/0xHoneyJar/construct-fagan) — FAGAN review of refactor commits

## License

MIT · © 2026 0xHoneyJar
