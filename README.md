# construct-effect-substrate

> The **agentic game engine**. Doctrine pack + grounding envelope + divining-rod surface. Built on the **ECS ≡ Effect ≡ Hexagonal Architecture ≡ Honeycomb** isomorphism — four vocabularies, same shape. Composes `freeside-*` modules to ship games that deploy on **Freeside** (community infrastructure platform · "Vercel for communities").
>
> **Status:** `candidate` · validated across 4 cycles in 1 project (compass · 2026-05-11 → 2026-05-16) · doctrine depth: 4 (narrative · see [doctrine-evolution.md](doctrine-evolution.md)) · needs ≥3 distinct projects to move to `active`.

> **First-time adopters: start at [`SKILL.md`](SKILL.md).** The `patterns/` docs are the consumable surface. The meta-files (`MEMORY.md`, `cycles/`, `doctrine-evolution.md`) are pack-author surfaces — they help when authoring a cycle distill — skip on first read.

Four architectural vocabularies have been describing the same structure for years. Naming the isomorphism makes the choice between them a vocabulary preference, not an architecture decision.

| ECS (game dev) | Effect (FP) | Hexagonal (Cockburn) | Honeycomb (this pack) | Filesystem |
|---|---|---|---|---|
| Entity | Tag | Application | Cell (hive) | `lib/runtime/runtime.ts` |
| Component | Schema record | DTO / value object | Cell contents | `lib/domain/*.ts` |
| System | Service (capabilities) | Use case | Cell operator | `lib/ports/*.port.ts` |
| World | Layer | Application boot | The full hive | `lib/runtime/runtime.ts` |
| System impl | `Layer.succeed(Tag, ...)` | Adapter | Cell adapter | `lib/live/*.live.ts` · `lib/mock/*.mock.ts` |
| Archetype query | Port interface | Port | Cell-adjacency query | `lib/ports/*.port.ts` |

The four-folder pattern (`domain/ports/live/mock`) is the structure all four converge on. Pick the words you like; keep the filenames.

## What this pack is

Honeycomb is the substrate doctrine + runtime contract + operator-substrate surface for building *agentic-age* games. It carries the **grounding envelope** (every artifact carries tier + epistemic-tristate metadata) and exposes the **divining-rod surface** (`/hakkutsu` listens across accumulated envelopes for latent patterns operator-intuition would recognize). It composes `freeside-*` modules — `mint` · `activities` · `characters` · `storage` · `score` · `sonar` · `identity` — to ship games that deploy on Freeside.

It does NOT ship a real-time/multiplayer/economy/identity *runtime*. Those are `freeside-*` modules (existing and future) that the engine consumes via **port-shaped seams** (`Layer.succeed` slots). The shape is *port-in-engine, runtime-in-module*.

## Contents

- [`SKILL.md`](SKILL.md) — overview and when to fire this pack
- [`construct.yaml`](construct.yaml) — manifest
- [`doctrine-evolution.md`](doctrine-evolution.md) — how the doctrine deepens through cycles (level 1 → 4)
- [`MEMORY.md`](MEMORY.md) — pack-level lineage memory
- `patterns/` — the consumable doctrine surface
  - **Cycle 1 · structural** (2026-05-11): [`domain-ports-live`](patterns/domain-ports-live.md) · [`suffix-as-type`](patterns/suffix-as-type.md) · [`ecs-effect-isomorphism`](patterns/ecs-effect-isomorphism.md) · [`delete-heavy-cycle`](patterns/delete-heavy-cycle.md) · [`single-effect-provide-site`](patterns/single-effect-provide-site.md)
  - **Cycle 2 · positional** (2026-05-12): [`hand-port-with-drift`](patterns/hand-port-with-drift.md) · [`doc-only-then-runtime`](patterns/doc-only-then-runtime.md) · [`lift-pattern-template`](patterns/lift-pattern-template.md) · [`state-ownership-matrix`](patterns/state-ownership-matrix.md)
  - **Cycle 3 · peer-substrates** (2026-05-13): [`peer-substrates-different-shapes`](patterns/peer-substrates-different-shapes.md) — substrate is role, shape serves scope
  - **Cycle 4 · grounding** (2026-05-16): [`grounding-ladder-as-substrate-primitive`](patterns/grounding-ladder-as-substrate-primitive.md) · [`hakkutsu-as-divining-rod`](patterns/hakkutsu-as-divining-rod.md)
- `schemas/` — cycle-4 sealed contracts
  - [`grounding-envelope.schema.json`](schemas/grounding-envelope.schema.json) — the cross-cutting envelope (3-tier × 3-state)
  - [`hakkutsu-shard.schema.json`](schemas/hakkutsu-shard.schema.json) — divining-rod output shape
- `constraints/` — cycle-4 cross-field DSL
  - [`GroundingEnvelope.constraints.json`](constraints/GroundingEnvelope.constraints.json) — 10 rules · mirrors loa-hounfour discipline
- `vectors/` — golden test vectors
  - `grounding-envelope/` — 6 vectors (4 valid + 2 invalid REJECT)
- `scripts/`
  - [`scaffold-system.sh`](scripts/scaffold-system.sh) — 5-command Effect Service lift recipe (cycle-2)
  - [`hakkutsu-sketch.sh`](scripts/hakkutsu-sketch.sh) — cycle-4 divining-rod runtime stub
- `cycles/` — pack-level lineage entries · one per cycle that adopts the pack
- `examples/`
  - [`compass-cycle-2026-05-11.md`](examples/compass-cycle-2026-05-11.md) — first cycle (−1236 LOC · 128/128 tests · level 1)
  - [`compass-cycle-2026-05-12.md`](examples/compass-cycle-2026-05-12.md) — second cycle (+830 LOC · 130/130 tests · level 2)

## Composition (where Honeycomb sits in the stack)

```
🔥 LOA · meta-framework
  workflow gates · planning · skills · constructs registry
        ↓ provides
🛠️ CONSTRUCTS · LLM lens (this pack lives here as the agentic-game-engine doctrine)
        ↓ authors on top
🚇 FREESIDE · community infrastructure platform · "Vercel for communities"
  · modules: mint · activities · characters · storage · score · sonar · identity
  · mediums: discord · telegram · twitter · web
        ↓ deploys
🌍 WORLDS / APPS
  · honeycomb-engine games (compose freeside-* modules · ship the game-world)
  · persona-bots (use freeside-characters + medium-adapter · no honeycomb)
  · dashboards (use freeside-sonar + freeside-score · no honeycomb)
  · any community/brand surface
```

The engine composes freeside-* modules; it doesn't replace them. Multiplayer / economy / identity / indexing all live as freeside-* modules that the engine plugs into via port-shaped seams. `Multiplayer.Service` Tag lives in honeycomb; `Layer.succeed` lives in `freeside-multiplayer` (when/if it ships).

Freeside worlds aren't all games. Personas, dashboards, and community surfaces also deploy on Freeside without involving Honeycomb. Honeycomb is the game-engine application of the platform; it is one thing the platform can ship.

## When to fire

- You're building a game and want the architectural doctrine + grounding envelope + composition surface for freeside-* modules
- You're refactoring an existing TS app where the implementation is half-emergent (singletons · `subscribe(cb)` · same try/catch boilerplate at 3+ sites · element/token tables redeclared per component)
- Test count says the behavior is locked — wrapping a working imperative module is FAGAN-safe; rewriting it during the refactor is not
- You want **agent-readable**, not just human-readable, codebase shape

## What this pack is NOT

- **Not an Effect tutorial.** Read the [Effect docs](https://effect.website/docs/requirements-management/services/).
- **Not a 'rewrite-everything-in-Effect' mandate.** Effect appears at boundaries; inside an adapter, write whatever the domain needs (imperative classes, raw promises, audio nodes). Adoption is incremental.
- **Not ECS-everywhere.** Reach for `*.system.ts` when the domain has per-frame transforms. Document boundaries that look like CRUD don't gain from the System/Component reframe.
- **Not a market pitch.** Let the engine prove itself by being used.

## Promotion criteria · breadth and depth

This pack stays `status: candidate` until adopted by at least three **distinct** projects, one of which is non-Next.js. Each adoption updates `provenance.validated_in` in [`construct.yaml`](construct.yaml) with the net LOC delta and a 1-line lesson.

The `doctrine_depth` field tracks how deep the doctrine has compounded across cycles — single-project compounding doesn't substitute for cross-project breadth, but it does deepen the patterns the pack carries. See [`doctrine-evolution.md`](doctrine-evolution.md) for the level 1 / level 2 / level 3 / level 4 narrative.

## Composes with

- [`construct-the-arcade`](https://github.com/0xHoneyJar/construct-the-arcade) — OSTROM architecture lens · BARTH ship discipline · progressive-disclosure doctrine
- [`construct-artisan`](https://github.com/0xHoneyJar/construct-artisan) — ALEXANDER craft lens · FAGAN-safe refactor
- [`construct-fagan`](https://github.com/0xHoneyJar/construct-fagan) — FAGAN review of refactor commits
- `freeside-*` modules — sealed-schema infrastructure plumbing the engine composes (see Composition above)
- [`loa-hounfour`](https://github.com/0xHoneyJar/loa-hounfour) — envelope discipline parent (UUID · semver · tristate · `additionalProperties: false` + metadata escape hatch)

## License

MIT · © 2026 0xHoneyJar
