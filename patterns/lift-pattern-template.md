# Pattern · lift-pattern template (5-command system add)

> Discovered cycle 2 (compass-substrate-agentic-2026-05-12). Once the four-folder pattern is in place + the single Effect.provide site is enforced, adding a NEW Effect Service should be 5 commands or less. This template makes it so.

## When to use

You want to wrap an existing module-singleton (or `subscribe(cb)` API, or class-based store) as an **Effect Service** that composes into the app's runtime. The four-folder pattern + suffix discipline already hold.

## The 5 commands

```bash
# 1. Copy the canonical trio (from any existing system as exemplar)
cp lib/<dir>/awareness.{port,live,mock,test}.ts lib/<dir>/<name>.{port,live,mock,test}.ts

# 2. Sed-rename Awareness → <Name>
sed -i '' 's/Awareness/<Name>/g' lib/<dir>/<name>.{port,live,mock,test}.ts
sed -i '' 's/awareness/<name>/g' lib/<dir>/<name>.{port,live,mock,test}.ts

# 3. Append to AppLayer in lib/runtime/runtime.ts (one line · the import + one line in mergeAll)
# (Manual edit · the script can't safely amend the runtime.ts AST.)

# 4. Copy an example component
cp app/_components/awareness-example.tsx app/_components/<name>-example.tsx
sed -i '' 's/Awareness/<Name>/g; s/awareness/<name>/g' app/_components/<name>-example.tsx

# 5. Run the verification cluster
pnpm typecheck && pnpm test && bash scripts/check-single-runtime.sh
```

Optionally `scripts/scaffold-system.sh` (in this pack) automates steps 1-4.

## What each file looks like

### `<name>.port.ts` · the contract

```typescript
import { Context, Effect, Stream } from "effect";

export class <Name> extends Context.Tag("<project>/<Name>")<
  <Name>,
  {
    // Three standard primitives · keep these names for grep-discoverability
    readonly current: Effect.Effect</* state */>;
    readonly events: Stream.Stream</* event */>;
    readonly invoke: (cmd: /* command */) => Effect.Effect</* ack */, /* error */>;
    // Add domain-specific methods after the standard 3
  }
>() {}
```

The Service Tag prefix (`<project>/<Name>`) namespaces against upstream Tags. Standard 3 primitives (`current` · `events` · `invoke`) are convention · they make `find lib -name '*.port.ts' | xargs grep -l "current:"` enumerable.

### `<name>.live.ts` · the production wiring

Wraps the existing impl. Two flavors:

**Flavor A · existing singleton with `subscribe(cb)`**:
```typescript
export const <Name>Live = Layer.succeed(
  <Name>,
  <Name>.of({
    current: Effect.sync(() => existingSingleton.current()),
    events: Stream.async((emit) => {
      const unsub = existingSingleton.subscribe((e) => { void emit.single(e); });
      return Effect.sync(() => unsub());
    }),
    invoke: (cmd) => Effect.sync(() => existingSingleton.write(cmd)),
  }),
);
```

**Flavor B · captures dependent services**:
```typescript
export const <Name>Live = Layer.effect(
  <Name>,
  Effect.gen(function* () {
    const ref = yield* Ref.make</* state */>(initial);
    const dependentService = yield* DependentService;  // captured at setup time
    return <Name>.of({
      current: Effect.gen(function* () {
        const data = yield* dependentService.method();
        yield* Ref.set(ref, derive(data));
        return yield* Ref.get(ref);
      }),
      events: Stream.empty as Stream.Stream</* event */>,
      invoke: (cmd) => Ref.update(ref, (s) => apply(s, cmd)),
    });
  }),
);
```

### `<name>.mock.ts` · per-instance test substrate

NO module-singleton state · returns a Layer factory:

```typescript
export const <Name>Mock = (seed: readonly /* state */[] = []) => {
  const buffer = [...seed];
  const subscribers = new Set<(e: /* event */) => void>();

  return Layer.succeed(<Name>, <Name>.of({
    current: Effect.sync(() => buffer.slice()),
    events: Stream.async((emit) => {
      const cb = (e: /* event */) => { void emit.single(e); };
      subscribers.add(cb);
      return Effect.sync(() => { subscribers.delete(cb); });
    }),
    invoke: (cmd) => Effect.sync(() => {
      buffer.push(/* derive event from cmd */);
      for (const cb of subscribers) cb(/* event */);
    }),
  }));
};
```

Per-instance state means tests don't bleed between cases · each `Effect.provide(program, <Name>Mock(seed))` gets fresh state.

### `__tests__/<name>.test.ts` · the smoke

```typescript
import { describe, it, expect } from "vitest";
import { Effect } from "effect";
import { <Name> } from "../<name>.port";
import { <Name>Mock } from "../<name>.mock";

describe("<Name>Live lift", () => {
  it("current returns seeded state", async () => {
    const program = Effect.gen(function* () {
      const s = yield* <Name>;
      return yield* s.current;
    });
    const result = await Effect.runPromise(Effect.provide(program, <Name>Mock(/* seed */)));
    expect(result).toBeDefined();
  });
});
```

Three standard tests recommended · `current returns seeded` · `events stream surface exists` · one `invoke` round-trip if the service has commands.

## Anti-patterns

- ❌ New file in `lib/runtime/` for the new service (composes into existing AppLayer · don't fork)
- ❌ Mock with module-singleton state (must be per-instance · tests bleed)
- ❌ Missing `Layer.succeed` or `Layer.effect` wrapping (raw object won't compose)
- ❌ `Stream.async` without cleanup function (memory leak)
- ❌ Inventing new top-level folders for "adapters" or "shims" (the four-folder pattern is closed · suffix discipline carries the rest)
- ❌ Skipping the 5th verification command (broken types or a forgotten import won't surface until much later)

## What this template DOESN'T cover

- Cross-system dependencies that need explicit Layer.provide threading — see [`single-effect-provide-site`](single-effect-provide-site.md) §"When the rule bends"
- State ownership across Services (when system A reads/writes state owned by system B) — see [`state-ownership-matrix`](state-ownership-matrix.md)
- Hand-porting a Schema from an upstream type system — see [`hand-port-with-drift`](hand-port-with-drift.md)

## Cross-references

- Operationalized: [`scripts/scaffold-system.sh`](../scripts/scaffold-system.sh) — runs steps 1-2-4 mechanically
- Worked example: [`examples/compass-cycle-2026-05-12.md`](../examples/compass-cycle-2026-05-12.md) §S4 (3 systems applied mechanically)
