# Doctrine evolution · how the substrate deepens through cycles

> A doctrine pack is alive when each cycle leaves it stronger than the previous found it. This file is the pack's narrative memory · what each cycle taught · what the next cycle might discover.

## Level 1 · structural isomorphism (cycle 1 · compass-substrate-ecs-2026-05-11)

**The discovery**: ECS, Effect, and Hexagonal Architecture have been describing the same shape for years. Naming the isomorphism makes the choice between them a vocabulary preference, not an architecture decision.

**The artifacts**:
- Four-folder pattern (`domain` · `ports` · `live` · `mock`)
- Suffix discipline (`*.port.ts` · `*.live.ts` · `*.mock.ts` · `*.system.ts`)
- Single Effect.provide site (`lib/runtime/runtime.ts`)
- Delete-heavy refactor recipe (net LOC must go negative)

**The slogan**: *Name the boundary, type the boundary, let implementations move behind it.*

**The validation**: compass cycle 1 · −1236 LOC net · 128/128 tests · 4× over target.

## Level 2 · positional isomorphism · adopt-don't-invent (cycle 2 · compass-substrate-agentic-2026-05-12)

**The discovery**: when canonical substrate exists upstream, you don't need to invent your own translation layer · adopt the existing one. Hand-port what you need · vendor the JSON · let CI tell you when reality drifts. Adopt the contract before the runtime when the runtime hasn't shipped yet (compile-time fence · zero runtime imports).

**The artifacts**:
- Hand-port-with-drift pattern (effect-schema mirrors of typebox/zod/openapi sources)
- Doc-only-then-runtime adoption stance (brand-type fence for upstream-runtime-not-yet-shipped)
- State ownership matrix (per-system Ref/PubSub ownership · CI-enforced)
- Lift-pattern template (5-command recipe for adding new Effect Services)
- SHA-pin manifest discipline (every vendored upstream has provenance)
- Cross-layer composition update to single-effect-provide-site (Layer.provide threading while preserving the single-runtime rule)

**The slogan**: *Don't invent the translation layer · adopt the one that exists upstream. Brand the boundary even when the runtime hasn't shipped.*

**The validation**: compass cycle 2 · 130/130 tests · 5 hand-ports · 3 systems lifted mechanically · 5 CI gates · 3 upstream tracking issues filed · merged PR #14.

## Level 3 · ??? (open · awaiting discovery)

What might level 3 be? Best-guesses based on the trajectory:

- **Cross-project conformance** · when multiple worlds adopt this pack and one of them lifts a pattern that compounds across all (e.g., a shared envelope schema that compass + sprawl + mibera all use, validated bidirectionally)
- **Live-runtime adoption** of straylight signed-assertion APIs · what the brand-type fence becomes when upstream Phase 23b lands · the mechanical-swap moment
- **Bidirectional drift** · the pack itself learning when a downstream adoption needs to feed evolution back upstream (compass's hand-port revealing a hounfour schema gap that hounfour absorbs)
- **Construct-substrate-conformance audit** · a sibling construct that scans any repo for the patterns this pack documents · automated promotion-criteria check
- **Doctrine-as-runtime** · the pack's patterns become enforceable lints/CI scripts that any adopting project installs as a single dependency

These are guesses · the actual level-3 discovery will be made by the cycle that fires it.

## How doctrine deepens

The pattern that emerged across cycles 1 and 2:

1. **A real cycle ships** in a project that adopts the pack
2. **Reviews surface gaps** · in cycle 2's case · 4 distinct review pipelines (PRD review · bridgebuilder SDD · sprint skeptic · PR-diff bridgebuilder) each caught what the previous missed
3. **Operator decisions get captured** as inline NOTES.md entries · time-stamped · cited from PR commits
4. **The cycle's S6 distill** writes back to this pack · adds new pattern files · updates existing patterns · adds the cycle as a worked example
5. **The doctrine version bumps** even if the promotion criteria (project-count) hasn't been met · the pack records depth as a separate dimension from breadth

A pack at version 0.2.0 with 1-project validation but level-2 doctrine is meaningfully different from the same pack at version 0.1.0 with 1-project validation. The depth dimension matters · this file makes it visible.

## Promotion criteria · revised perspective

The original promotion criteria (≥3 projects · one non-Next.js) measure **breadth**. They're still in `construct.yaml` and still binding for `status: active` promotion.

This file proposes a complement: **depth**. Each cycle that compounds the doctrine adds a new level. A pack at level-N doctrine in 1 project is a different artifact than the same pack at level-1 doctrine in 1 project · the patterns are richer · the worked example is deeper · the operator who runs the next cycle will benefit from accumulated learning.

For the curious adopter who wants to know "is this pack alive?" the answer lives at two coordinates:

- `status` (candidate · validated · active) — measures breadth
- `doctrine_depth` (level 1 · level 2 · ...) — measures depth

Both are recorded in `construct.yaml`. The pack's status field is the strict honest measure · the doctrine_depth field is the secondary signal that helps a next-cycle operator decide if the pack is worth the read.

## What this file doesn't claim

- Not a roadmap · level 3 will be made, not planned
- Not a promotion mechanism · `status: active` still requires the original 3-project criterion
- Not a substitute for the worked examples · each cycle's `examples/<cycle>.md` carries the concrete LOC/test/finding numbers
- Not finished · this file grows when the next cycle deepens the doctrine

## The lineage so far

```
└── effect-substrate (status: candidate · doctrine_depth: 2)
    ├── cycle 1 · compass-substrate-ecs-2026-05-11 (level 1 · structural isomorphism)
    └── cycle 2 · compass-substrate-agentic-translation-adoption-2026-05-12 (level 2 · adopt-don't-invent)
```

The next adopter is invited to add their cycle here.
