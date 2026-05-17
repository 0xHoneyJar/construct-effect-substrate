---
pattern_id: single-effect-provide-site
introduced_in_cycle: compass-substrate-ecs-2026-05-11
status: candidate
---

# Pattern · single Effect.provide site (the comment-as-spec)

> Compounded cycle 2 (compass-substrate-agentic-2026-05-12). Cycle 1 named the rule. Cycle 2 enforced it via CI grep + made the canonical file's own comment the spec.

## The rule

```typescript
// lib/runtime/runtime.ts
import { Layer, ManagedRuntime } from "effect";
import { /* every Live Layer */ } from "@/lib/live/...";
import { /* and every world-substrate Live Layer */ } from "@/lib/world/...";

// THE single Effect.provide site for the app. Lint check: a grep for
// `ManagedRuntime.make` in lib/ or app/ should return exactly one match
// — this file. A second site would fragment the service graph and
// fork the Layer scope.
export const AppLayer = Layer.mergeAll(/* ... */);
export const runtime = ManagedRuntime.make(AppLayer);
```

The comment IS the spec. CI greps for it.

## CI gate (5 lines · zero deps)

```bash
#!/usr/bin/env bash
# scripts/check-single-runtime.sh
set -euo pipefail
COUNT=$(grep -rEc "ManagedRuntime\.make\(" --include="*.ts" --include="*.tsx" lib/ app/ 2>/dev/null | grep -v ":0$" | awk -F: '{sum += $2} END {print sum+0}')
if [ "${COUNT:-0}" != "1" ]; then
  echo "FAIL: $COUNT ManagedRuntime.make sites (expected exactly 1)"
  grep -rn "ManagedRuntime\.make(" --include="*.ts" --include="*.tsx" lib/ app/
  exit 1
fi
echo "OK: 1 ManagedRuntime.make site"
```

Note the `\(` — without it, the grep matches the comment that names the discipline (which is itself a `ManagedRuntime.make` mention) and fails on its own evidence. Cycle 2 footgun, learned.

## When the rule bends · Layer composition with cross-deps

Cycle 1 had only flat composition: every Live Layer was independent. Cycle 2 introduced systems with inter-layer dependencies:

- `AwarenessLive` needs `Population` + `Activity` services
- `ObservatoryLive` needs `Awareness` service
- `InvocationLive` is independent

The naive `Layer.mergeAll(WeatherLive, ..., AwarenessLive, ObservatoryLive)` fails because Awareness's required environment isn't satisfied by mergeAll (which assumes all layers are independent at the requirement level).

The correct shape — still ONE `ManagedRuntime.make` site:

```typescript
const PrimitivesLayer = Layer.mergeAll(
  WeatherLive, SonifierLive, ActivityLive, PopulationLive, InvocationLive,
);
const AwarenessOnPrimitives = Layer.provide(AwarenessLive, PrimitivesLayer);
const ObservatoryOnAwareness = Layer.provide(ObservatoryLive, AwarenessOnPrimitives);

export const AppLayer = Layer.mergeAll(
  PrimitivesLayer,
  AwarenessOnPrimitives,
  ObservatoryOnAwareness,
);
export const runtime = ManagedRuntime.make(AppLayer);
```

Three tiers · `Layer.provide` threads requirements explicitly · final mergeAll surfaces all 7 services with `R = never`. The CI gate still passes (1 `ManagedRuntime.make` site) and the dependency story is now self-documenting at the runtime composition level.

## The Service-method-requirement closure

The other half of the discipline · in `*.live.ts` files, capture deps at Layer setup time so Service methods have `R = never`:

```typescript
export const AwarenessLive = Layer.effect(
  Awareness,
  Effect.gen(function* () {
    const ref = yield* Ref.make<AwarenessState>(initial);
    // Capture deps in Layer setup · the Service methods close over them.
    const population = yield* Population;
    const activity = yield* Activity;

    return Awareness.of({
      current: Effect.gen(function* () {
        // No `yield* Population` here · uses captured `population`.
        const dist = yield* population.distribution;
        // ...
      }),
    });
  }),
);
```

Without this closure pattern, the Service method has `R = Population | Activity`, which then propagates to every consumer. With it, `R = never` and the Service is a clean primitive.

## Anti-patterns (cycle 2 catches)

- ❌ Inventing a NEW file in `lib/runtime/` to host an "alternate runtime" — the existing file's comment forbids it. Compose into the canonical AppLayer.
- ❌ Using `Layer.mergeAll` when there are inter-layer deps · use `Layer.provide` to thread requirements first
- ❌ Greping for `ManagedRuntime.make` without `\(` (matches the doc-comment about itself · perpetual false positive)
- ❌ Yielding deps inside Service methods (instead of capturing in Layer setup) · pollutes consumer environment with dep tags

## Cross-references

- [`domain-ports-live`](domain-ports-live.md) — the four-folder home of the discipline
- Worked example: [`examples/compass-cycle-2026-05-12.md`](../examples/compass-cycle-2026-05-12.md) §S1 + §S4 single-runtime composition
