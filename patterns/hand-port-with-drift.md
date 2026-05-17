---
pattern_id: hand-port-with-drift
introduced_in_cycle: compass-substrate-agentic-translation-adoption-2026-05-12
status: candidate
---

# Pattern · hand-port with drift detection

> Discovered cycle 2 (compass-substrate-agentic-2026-05-12). When two type systems can't interop directly (Effect Schema ↔ TypeBox · Zod ↔ JSON Schema · Pydantic ↔ TS), don't invent a bridge. Hand-port the schemas you need, vendor the upstream JSON, and let CI tell you when reality drifts.

## When to use

Your project depends on schemas authored upstream in an incompatible type system. Examples:
- Compass uses `effect/Schema`; `loa-hounfour` uses `@sinclair/typebox`. No automatic bridge exists.
- A Python service emits Pydantic-validated JSON; your TS consumer wants Zod types.
- An OpenAPI spec is the source of truth, but your runtime is bun + Effect.

The instinct is to write a converter (codegen TypeBox → Effect Schema). The hand-port pattern says: **don't**. Codegen invests in the wrong asset (the converter rots when the upstream changes); hand-porting invests in the right asset (a small, owned, drift-detected mirror).

## The pattern in three files

For each upstream schema named `<name>` (e.g., `agent-identity`):

```
lib/domain/
├── <name>.hounfour-port.ts            # Effect Schema mirror (you own this)
├── schemas/hounfour-<name>.schema.json # Vendored copy of upstream JSON
└── __tests__/<name>.{port,drift}.test.ts
```

Plus one drift detection script at the project level:

```
scripts/hounfour-drift.ts              # Fetches upstream main, structural-diffs vendored
```

## File 1 · the port

```typescript
/**
 * Hand-port of hounfour `agent-identity` schema as Effect Schema.
 *
 * Source: hounfour@<resolved-S0-SHA>:schemas/agent-identity.schema.json
 * Drift policy: see scripts/hounfour-drift.ts (weekly cron)
 *
 * DO NOT EDIT to match an evolving upstream — let drift CI flag deltas.
 * Adopting an upstream change requires bumping the SHA + re-porting + operator pair-point.
 */
import { Schema as S } from "effect";
import upstreamSchema from "./schemas/hounfour-agent-identity.schema.json";

export const AgentIdentityPort = S.Struct({
  agent_id: S.String.pipe(S.pattern(/^[a-z][a-z0-9_-]{2,63}$/)),
  display_name: S.String.pipe(S.minLength(1), S.maxLength(128)),
  // ... mirror upstream fields
});

export type AgentIdentityPort = S.Schema.Type<typeof AgentIdentityPort>;
export const AgentIdentityUpstreamSchema = upstreamSchema; // exposed for drift check
```

The `Source:` header line is **load-bearing** — it's the machine-readable provenance pin that the drift script greps for. If you can't write it because there's no canonical upstream URL + SHA, you can't hand-port (you have nothing to detect drift against).

## File 2 · the vendored JSON

A verbatim copy. No edits. The README in the schemas dir documents provenance:

```markdown
# Vendored upstream schemas

| File | Source repo | SHA | Refresh policy |
|---|---|---|---|
| `hounfour-agent-identity.schema.json` | `0xHoneyJar/loa-hounfour@7.0.0` | `ec5024...` | Weekly drift CI |
```

## File 3 · the drift script

```typescript
// Pseudocode — see compass scripts/hounfour-drift.ts for the full implementation
for (const portFile of glob("lib/domain/*.hounfour-port.ts")) {
  const { pinnedSha, schemaPath } = parseSourceHeader(portFile); // captures `schemas/<name>.schema.json`
  const upstreamMain = await octokit.repos.getContent({
    owner: "0xHoneyJar", repo: "loa-hounfour",
    path: schemaPath, ref: "main",
  });
  const vendored = readJSON(`lib/domain/schemas/hounfour-<name>.schema.json`);
  const diff = structuralDiff(vendored, upstreamMain);
  if (diff.changes.length > 0) {
    report.push({ schema: portFile, drift: diff });
  }
}
```

Three hardenings (learned the hard way per cycle 2 BB-PR-001):

1. **Authenticate** with `${{ secrets.GITHUB_TOKEN }}` in the workflow · GitHub raw without auth has no per-token rate limit
2. **404 on stale SHA = CI red** (not silent pass) — the operator must know if the pin moved
3. **Diff target = `vendored vs upstream-current-main`** — what you actually want to know is "has upstream evolved past my pin", not "does my pin still match itself"

## What this gets you

| Property | How |
|---|---|
| Compile-time type safety | Effect Schema gives you `Type<typeof Port>` |
| Runtime structural validation | Vendored JSON Schema parsed by AJV at boundaries |
| Drift detection | Weekly cron diffs vendored vs upstream main |
| Owned dependency surface | Your `Port` is yours · upstream evolution doesn't auto-break you |
| Audit trail | Every port file's `Source:` header has SHA provenance |

## What this avoids

- **Codegen rot**: a TypeBox-to-Effect-Schema converter would break every time hounfour adds a new construct (oneOf, conditional, $ref). The hand-port stays as small as the schema it mirrors.
- **Auto-merge surprises**: if you `pnpm install --latest` an npm-published schema package, breaking changes land silently. Hand-porting + drift detection makes upstream evolution explicit.
- **Type-system fork**: introducing `@sinclair/typebox` to compass's deps would mean two schema runtimes in one app. Hand-porting keeps Effect Schema canonical.

## Anti-patterns

- ❌ Hand-porting WITHOUT a `Source:` header (you've lost provenance · drift detection won't fire)
- ❌ Editing the vendored JSON to match local needs (it's a mirror · fork the type instead)
- ❌ Auto-bumping the SHA on cron schedule (drift detection's whole job is to prompt operator decision · automation defeats the gate)
- ❌ Hand-porting the entire upstream surface (port the SUBSET you actually use · this isn't a redistribution license, it's a fit-for-purpose mirror)

## Cross-references

- [`single-effect-provide-site`](single-effect-provide-site.md) — the runtime where ports compose
- [`doc-only-then-runtime`](doc-only-then-runtime.md) — adopt the contract before the implementation lands
- Worked example: [`examples/compass-cycle-2026-05-12.md`](../examples/compass-cycle-2026-05-12.md) §S2 hand-port 5 schemas
