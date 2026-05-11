# construct-effect-substrate

> Doctrine pack for organizing a TypeScript app around the **ECS ≡ Effect ≡ Hexagonal Architecture** isomorphism.
>
> **Status:** `candidate` · validated in 1 project · needs ≥3 adoptions to move to `active`.

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
- [`construct.yaml`](construct.yaml) — manifest · `status: candidate`
- `patterns/`
  - [`domain-ports-live.md`](patterns/domain-ports-live.md) — the four-folder pattern
  - [`suffix-as-type.md`](patterns/suffix-as-type.md) — `*.port.ts` · `*.live.ts` · `*.mock.ts` · `*.system.ts` discipline
  - [`ecs-effect-isomorphism.md`](patterns/ecs-effect-isomorphism.md) — when to reach for each vocabulary
  - [`delete-heavy-cycle.md`](patterns/delete-heavy-cycle.md) — the six-sprint refactor recipe + FAGAN gates
- `examples/`
  - [`compass-cycle-2026-05-11.md`](examples/compass-cycle-2026-05-11.md) — the first project adoption (−1236 LOC · 128/128 tests)

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
