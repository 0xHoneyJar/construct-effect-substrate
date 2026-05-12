# Example · compass substrate-agentic-translation-adoption · 2026-05-12

The second project adoption of `effect-substrate`. Same project as cycle 1 (compass), different cycle: this one adopts UPSTREAM substrate (loa-hounfour schemas + construct-rooms-substrate envelope + loa-straylight doc-only) on top of the four-folder pattern that cycle 1 established.

This is the cycle that taught the pack about **doctrine deepening** — that a single project can compound the doctrine across cycles even before the 3-project promotion criterion is met.

## What changed since cycle 1

Cycle 1 (`compass-cycle-2026-05-11`) shipped:
- The four-folder pattern (`lib/{domain,ports,live,mock,runtime}/`)
- Suffix discipline (`*.port.ts` · `*.live.ts` · `*.mock.ts` · `*.system.ts`)
- Single Effect.provide site at `lib/runtime/runtime.ts`
- −1236 LOC net (target was −300 · achieved 4×)
- 128/128 tests passing throughout

Cycle 2 (`compass-substrate-agentic-translation-adoption-2026-05-12`) shipped on top of that:
- Vendored upstream envelope schemas (rooms-substrate JSON copies)
- Hand-ported 5 hounfour schemas as Effect Schemas (compass owns the mirrors)
- Compile-time verify⊥judge brand-type fence (zero straylight runtime imports)
- New `lib/world/` umbrella with 3 Services (Awareness · Observatory · Invocation)
- 5 CI gates (envelope-coverage · single-runtime · world-discipline · state-ownership · system-name-uniqueness)
- 3 upstream tracking issues filed (hounfour#115 · rooms-substrate#1 · loa-straylight#26)
- 130/130 tests passing throughout

## The seam this cycle named

Cycle 1 found the **structural** isomorphism (ECS ≡ Effect ≡ Hexagonal). Cycle 2 found the **positional** one: when canonical substrate exists upstream, **adopt-don't-invent**. The original Gemini synthesis that started this cycle proposed inventing a translation layer; the KEEPER pre-flight + grounding in upstream repos established the translation layer **already exists** across `loa-hounfour` (schemas) + `construct-rooms-substrate` (envelope) + `loa-straylight` (governance). The cycle then conformed compass to those substrates rather than authoring parallel ones.

This reframe became the load-bearing PRAISE-001 finding from the bridgebuilder design review · preserved verbatim through SDD § 1 abstract · enforced via PR-title `[adopt:<substrate>]` tagging on every commit.

## New patterns the pack absorbed

| Pattern | Source | What it is |
|---|---|---|
| [`hand-port-with-drift`](../patterns/hand-port-with-drift.md) | S2 (5 hounfour schemas) | Mirror upstream as Effect Schemas + vendored JSON + drift-detection CI |
| [`doc-only-then-runtime`](../patterns/doc-only-then-runtime.md) | S3 (straylight) | Adopt the contract at compile time when runtime hasn't shipped · brand-type fence |
| [`lift-pattern-template`](../patterns/lift-pattern-template.md) | S1+S4 (5 services lifted mechanically) | The 5-command recipe for adding a new Effect Service |
| [`state-ownership-matrix`](../patterns/state-ownership-matrix.md) | S4 (BB-006 finding) | Per-system declaration of owned Refs/PubSubs · CI-enforced read-only |
| [`single-effect-provide-site`](../patterns/single-effect-provide-site.md) updated | S1+S4 (BB-001 finding) | Cross-layer dep threading via Layer.provide while preserving the single-runtime rule |

## The 7-sprint shape

| Sprint | Branch tag | LOC | What |
|---|---|---|---|
| S0 | `[adopt:hounfour]` | 0 (docs only) | Conformance audit · 11 tasks · 3 upstream issues filed · operator pair-point gate |
| S1 | `[adopt:rooms-substrate]` | +200 | Vendor envelope JSONs · Effect Schema mirror · lift activity/population to Layers · pattern-lock template |
| S2 | `[adopt:hounfour]` | +340 | 5 hand-ports + verdict union narrowing + drift script |
| S3 | `[adopt:straylight:doc-only]` | +175 | Force-chain mapping doc + verify-fence brand type + tstyche-to-expect-type fence assertion |
| S4 | `[adopt:lift-pattern]` | +550 | World substrate · 14 files · 3 Effect Services lifted mechanically (awareness · observatory · invocation) · 3 example components · 3 CI scripts |
| S5 | `[adopt:playbook]` | +57 (docs) | Multi-world adoption playbook · evidence-grounded stubs |
| S6 | `[adopt:distill]` | (this PR) | Pack update · 5 new patterns · cycle-2 example · doctrine-evolution.md |

LOC budget: G5a conformance side ≤ +500 (achieved · honest accounting per SP-002), G5b world substrate ≤ +600 (achieved · ~+550), cycle net ≤ +1200 (achieved).

## The reviews that ran

Three adversarial reviews fired during the cycle (Flatline was degraded · #759 · 2-agent fallback used):

1. **PRD review** (2-agent skeptic + improver · ~5 min) — surfaced 8 BLOCKERS (verified counts: hounfour 92 schemas not 53 · tests 24 not 128 · type-system mismatch · straylight Phase 23a blocked · etc.) + 12 HIGH_CONSENSUS improvements · all auto-patched
2. **Bridgebuilder design review on SDD** (persona-driven · depth 3 · ~5 min) — 3 HIGH (Runtime.fromLayer doesn't exist · 5 phantom Live Layers · require() vs ESM JSON) + 1 REFRAME (S1+S4 same shape) + 2 PRAISE (vendor+AJV · brand-type fence) · all reconciled
3. **Sprint plan skeptic** (1 agent · ~2 min) — 3 BLOCKERS (tstyche/expect-type code contradiction · S2 LOC budget undefined · legacy migration without owner) + 7 HIGH · all patched
4. **Bridgebuilder review of merged PR diff** (depth 5 · ~5 min) — 1 HIGH (drift script regex stripped `schemas/` prefix · always 404'd) + 2 MEDIUM (Stream.empty double-cast · expectTypeOf overly loose) + 2 PRAISE (Layer composition done right · element-vocabulary seam labeling) · all fixed inline

The 4 review pipelines compounded: each caught what the previous missed. The pattern: at least one review per artifact type · the LAST review (PR-diff bridgebuilder) catches what code-only inspection finds (the regex bug · the type-system theater · the cleanup smells) that doctrine-level reviews miss.

## What worked

1. **HITL gates fired exactly when needed** · operator decisions on S0-T11 (Q7 promotion gate) · S2 entry (verdict-callers) · BB-012 REFRAME · G5a budget revision · all surfaced through `AskUserQuestion` with focused options
2. **Auto-integrate batch** for HIGH_CONSENSUS findings was the right HITL trade · operator approved categorically once · 12+8+10 findings auto-patched without 30 individual prompts
3. **`[adopt:<substrate>]` PR-title tagging** preserved the reframe through every commit · grep-discoverable in git log forever
4. **5 CI gates** at $0 dep cost (4 of 5 are bash · 1 is Node.js w/ Octokit) · all passed by the time PR merged

## What didn't

1. **Flatline degraded mode (#759)** · 2 of 4 adversarial reviews lost their primary tool · 2-agent agent-dispatch fallback was substituted but cost 26¢ per phase that produced empty results · upstream issue still open
2. **Vitest workspace test discovery split** · root vitest config doesn't pick up `packages/*/tests/` · 80 peripheral-events tests run as separate command (`cd packages/peripheral-events && pnpm test`) · operator gets two test counts to track · cleanup deferred
3. **TypeScript 5.0.2** doesn't support `with { type: "json" }` (needs 5.3+) · S0-T8 spike caught it · plain JSON import works as fallback but the modern syntax is preferred · TS bump deferred to separate cleanup cycle

## What the pack absorbed (S6 distill output)

- 4 NEW patterns (this PR · `hand-port-with-drift` · `doc-only-then-runtime` · `lift-pattern-template` · `state-ownership-matrix`)
- 1 UPDATED pattern (`single-effect-provide-site` cross-layer composition)
- 1 NEW concept doc (`doctrine-evolution.md` · the meta-narrative of how doctrine deepens through cycles)
- 1 NEW callable artifact (`scripts/scaffold-system.sh` · operationalized 5-command lift-pattern)
- `cycles/` directory · pack-level lineage memory
- `MEMORY.md` · what each cycle taught

## Doctrine confidence

After this cycle, the pack stays at `status: candidate` per its own promotion criterion (≥3 distinct projects, one non-Next.js · neither met) BUT bumps to `version: 0.2.0` and gains a new dimension: **doctrine_depth: 2** (cycle-2-deepened). Single-project compounding doesn't substitute for cross-project breadth · but it does deepen the doctrine the pack carries · and a future adopter benefits from the deeper version even before promotion happens.

If the pack ever ships a third validated adoption (or a non-Next.js one), promotion lands automatically. Until then, the ~level-2 patterns (hand-port-with-drift · doc-only-then-runtime · state-ownership-matrix) are the load-bearing additions that distinguish this cycle.

## Operator footnotes

- The `adopt-don't-invent` reframe was operator-authored mid-cycle · originated from KEEPER pre-flight that questioned the original Gemini synthesis · became the cycle's identity
- The card-game-stays-out gate (`find compass/lib -name '*card*'` empty · CI-enforced forever) honors the operator's clarification: compass hosts the world substrate · `purupuru-game` (separate SvelteKit prototype) hosts the actual card game
- The cycle ran end-to-end-autonomous after the operator gave a single `/goal` directive · 9-phase /simstim → 7-sprint /run → bridgebuilder review depth-5 → fix → squash-merge to main · all in one session continuation
- Plain JSON import (vs `with { type: "json" }`) was the SDD's grounding-correction moment · the SDD prescribed modern syntax · the runtime spike (S0-T8) showed compass's TS 5.0.2 doesn't support it · plain works · forward-cleanup tracked

## Numbers

- 9 commits squashed into PR #14 (compass) — pre-squash branch tag would preserve count for post-merge verification · convention recommended for future cycles per BB-PR1-004
- 130 tests passing (50 root + 80 peripheral-events)
- 5 CI gates added (all green at merge)
- 3 upstream tracking issues filed (passive-accept after 7 days per IMP-009)
- 6 PRD-level pre-decisions (D1-D6) preserved load-bearing through SDD
- 4 reviews · 23 PRD findings · 15 SDD findings · 10 sprint findings · 6 PR-diff findings · all reconciled
- LOC: G5a +280 (under +500 ceiling) · G5b +550 (under +600 ceiling) · cycle net under +1200
- Cycle duration: ~6 hours autonomous from `/goal` to squash-merge (1 session continuation)
