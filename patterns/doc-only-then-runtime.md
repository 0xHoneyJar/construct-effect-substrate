# Pattern · doc-only-then-runtime adoption

> Discovered cycle 2 (compass-substrate-agentic-2026-05-12). When upstream substrate's CONTRACT exists but its RUNTIME doesn't, you can still adopt — at compile time. Document the force chain. Brand the boundary type. Wait for runtime to land. Then swap implementation mechanically.

## The shape of the problem

Upstream publishes a contract spec — a doctrine, a schema-contract draft, a type signature. The runtime that enforces it isn't shipped yet (blocked on a delta in another upstream, in active design, gated on a phase that hasn't opened).

You have two bad choices and one good one:

1. ❌ **Wait for runtime** — your project stalls on someone else's clock
2. ❌ **Reimplement runtime locally** — you fork the substrate, drift becomes inevitable
3. ✅ **Adopt the contract at compile time** — document the shape, brand the boundary, prove the discipline holds, commit zero runtime imports until upstream is ready

When upstream ships, the swap is mechanical: `Verified<T>` becomes `RecallReceipt<T>` (or whatever the canonical name lands at) with grep-replace + a single conformance test.

## The pattern

### 1 · Document the force chain

If the upstream substrate is governance-shaped (loa-straylight's continuity-under-authorization · capability-scoped-trust · signed-assertion patterns), document the chain explicitly. Map each step to a project surface:

```markdown
| # | Step | Project surface | Gate location | Status |
|---|---|---|---|---|
| 1 | observation | activity stream events | lib/activity/index.ts | ✅ exists |
| 2 | memory | activity stream history | lib/activity/index.ts:84 | ✅ exists |
| 3 | belief | KEEPER aggregation | NOT YET — placeholder for puruhani-aware | 🟡 doc-only |
| ...
```

Each step's status flag is one of:
- ✅ exists (project has this surface today)
- 🟡 doc-only (placeholder · future cycle implements)
- ⏳ deferred (no compass surface yet · post-cycle)

This document is the contract you're adopting. When upstream runtime ships, it tells you exactly which steps need wiring.

### 2 · Brand the boundary type

Adopt the verify⊥judge separation at the type level. ZERO runtime imports from upstream:

```typescript
// lib/domain/verify-fence.ts (no upstream-runtime import)
declare const VerifiedBrand: unique symbol;

export type Verified<T> = T & { readonly [VerifiedBrand]: true };

export const verify = <T>(
  schema: Schema<T>,
  input: unknown,
): Effect.Effect<Verified<T>, VerifyError> =>
  Schema.decodeUnknown(schema)(input).pipe(
    Effect.map(d => d as Verified<T>),
    Effect.mapError(c => new VerifyError({ reason: String(c) })),
  );

export const judge = <T, R>(
  e: Verified<T>,
  judgmentFn: (v: T) => Effect.Effect<R, JudgeError>,
): Effect.Effect<R, JudgeError> => judgmentFn(e);
```

The `unique symbol` brand is the load-bearing detail:
- It's constructable ONLY through `verify()`
- `judge()` accepts ONLY `Verified<T>` at the type level
- A future refactor that loses the brand will break `tsc`

### 3 · Assert the fence holds

```typescript
// lib/test/judge-fence.test.ts
import { expectTypeOf } from "expect-type";

describe("verify⊥judge fence · compile-time", () => {
  it("judge returns Effect with brand-preserved type", () => {
    const verified = {} as Verified<Test>;
    const result = judge(verified, e => Effect.succeed(e.id));
    expectTypeOf(result).toEqualTypeOf<Effect.Effect<string, JudgeError, never>>();
  });

  it("judge MUST reject raw Test at the type level", () => {
    const raw: Test = { id: "x" };
    // @ts-expect-error -- raw T is not assignable to Verified<T> · the fence
    judge(raw, e => Effect.succeed(e.id));
  });
});
```

The `@ts-expect-error` directive IS the fence assertion. If a refactor ever stops the type-mismatch from being an error, `tsc --noEmit` fails with `TS2578 unused @ts-expect-error directive` · CI red.

Use `toEqualTypeOf` not `toMatchTypeOf` for the positive assertions — `toMatchTypeOf` is bivariant and won't catch brand erosion (a refactor that returns raw `T` when it should return `Verified<T>`).

### 4 · Open one tracking issue upstream

```bash
gh issue create --repo <upstream-org>/<upstream-repo> \
  --title "<your-project> adoption tracker [<cycle-id>]" \
  --body "Compile-time fence at lib/domain/verify-fence.ts:1.
          When Phase Xb signed-assertion API ships, is this brand pattern
          compatible · or should we refactor to the new shape?"
```

This issue:
- Signals to upstream that someone's adopting (early)
- Captures the question that ONLY the next-phase implementation can answer
- Becomes the trace evidence for "we tried · we documented · we waited"

## When this pattern fits

- Upstream substrate is in `Phase X-A` shape: spec-published, runtime-blocked
- Your project's verify⊥judge separation is meaningful but not yet load-bearing
- You can articulate the contract clearly enough to brand the boundary types
- You have at least one place where upstream-runtime will plug in once available

## When this pattern doesn't fit

- ❌ Upstream is fully shipped and has a stable npm release · just import it
- ❌ The contract is so fluid you can't brand a stable boundary type
- ❌ Your project doesn't yet have the surfaces the contract would gate (defer adoption · don't doc-only an absence)

## Cross-references

- [`hand-port-with-drift`](hand-port-with-drift.md) — sibling pattern for type-shaped (vs runtime-shaped) upstream adoption
- [`single-effect-provide-site`](single-effect-provide-site.md) — where the verify-fence Service composes
- Worked example: [`examples/compass-cycle-2026-05-12.md`](../examples/compass-cycle-2026-05-12.md) §S3 force-chain mapping + compile-time fence
