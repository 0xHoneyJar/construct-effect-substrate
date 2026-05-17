# Doctrine evolution · how the substrate deepens through cycles

> **Pack-author surface · skip on first read.** First-time adopters: start at [SKILL.md](SKILL.md) · this file is for understanding how the pack itself evolves between cycles.
>
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

## Level 3 · peer-substrate plurality · shape serves scope (cycle 3 · compass-purupuru-cycle-1-wood-vertical-2026-05-13)

**The discovery**: a project may host multiple substrate-shaped namespaces with DIFFERENT shapes, all valid. Substrate is a ROLE (the 7-component ACVP checklist: Reality + Contracts + Schemas + State machines + Events + Hashes + Tests). Shape is scope-specific (Effect.PubSub for async-coordination scopes · tiny EventEmitter for grep-testable sim-presentation scopes · ECS for thousands-of-entities scopes · React state + typed-context for UI-local scopes · actor model for network-distributed scopes). The cycle-1 + cycle-2 framing implied "one substrate, one shape, pick your vocabulary"; cycle 3 broke that framing without contradicting prior cycles — it REFINED them ("applies to SOME substrate scopes, not all").

**The artifacts**:
- Peer-substrates-different-shapes pattern (substrate-as-CATEGORY vs substrate-as-SHAPE · the 7-component checklist holds per substrate · shapes MAY differ · three adapter patterns named for future cross-substrate bridges: tunnel · unified-substrate · bridge)
- 4th vocabulary added to the isomorphism table (harness-pseudocode-to-runtime alongside ECS · Effect · Hexagonal; the pack's own term Honeycomb crystallized as the 4th register in README)
- Cycle-1 + cycle-2 pattern refinements: `domain-ports-live` applies to SOME substrate scopes (not all) · `suffix-as-type` has `subdir-as-type` as its greenfield-namespace alternative · `single-effect-provide-site` lint scopes per-namespace-using-Effect (not project-globally)

**The slogan**: *Substrate is a role, not a shape. Shape serves scope.*

**The validation**: compass-purupuru cycle 1 · second substrate-shaped namespace (lib/purupuru/ tiny-EventEmitter) shipped alongside lib/honeycomb/ (Effect.PubSub) · 108 new tests · +5400 LOC · both substrates pass the 7-component checklist · different shapes.

## Level 4 · grounding envelope · agentic content is rated, not assumed canon (cycle 4 · compass-substrate-grounding-2026-05-16)

**The discovery**: every substrate that hosts agent-generated content needs an envelope distinguishing what an agent generated freely from what the operator blessed from what user-truth canvases back. The envelope is CROSS-CUTTING metadata (not an 8th ACVP component), riding on every artifact regardless of which structural component hosts it. Medallion architecture (Databricks lakehouse, ~2020) applied to agentic CONTENT, not data: bronze → silver → gold promotion ladder × `grounded | refuted | unverifiable` epistemic tristate (per loa-hounfour's epistemic-tristate doctrine — three states must require DIFFERENT consumer behaviors). Companion operation `hakkutsu` listens across the envelope index and returns 3-5 humming shards (faint signals operator-intuition would recognize) — the substrate observes, never declares.

**The artifacts**:
- Grounding-ladder-as-substrate-primitive pattern (tier × grounding_status orthogonality · 7 cross-component grounding invariants · cross-substrate envelope semantics · medallion-for-content mapping)
- Hakkutsu-as-divining-rod pattern (3-5 shards · whisper-not-declaration discipline · 13 legendary-studio lenses · `/honey` · `/hive` · `/hakkutsu` true-name triad)
- Grounding-envelope sealed schema (`schemas/grounding-envelope.schema.json` · JSON Schema 2020-12 · `additionalProperties: false` + metadata escape hatch · UUID `envelope_id` · semver `contract_version` · UTC links with SHA-256 `quote_hash`)
- Hakkutsu-shard sealed schema (`schemas/hakkutsu-shard.schema.json` · shard output contract · 13-enum `lens` field)
- Cross-field constraints (`constraints/GroundingEnvelope.constraints.json` · 10 rules · 7 ERROR + 3 WARNING · mirrors loa-hounfour constraint DSL)
- 6 golden vectors (`vectors/grounding-envelope/` · 4 valid + 2 invalid REJECT)
- `/hakkutsu` runtime stub (`scripts/hakkutsu-sketch.sh` · per `doc-only-then-runtime` discipline · full runtime ships in cycle-N+1 once schema vectors prove out)

**The slogan**: *Grounding is an envelope · hakkutsu is how the envelope speaks back.*

**The validation**: pack-internal cycle (no downstream adopter — the validation is the doctrine + sealed schemas + golden vectors landing as ratified surface, per `doc-only-then-runtime`). Composes with cycle-098's L1-L7 audit envelope as the meta-protocol parent; first named application of envelope-as-cross-cutting-metadata inside a doctrine pack.

## Level 5 · ??? (open · awaiting discovery)

Per BB-PR1-001 + BB-PR1-011: speculation about future levels lives in [MEMORY.md §Lessons that didn't become patterns (yet)](MEMORY.md), not here. The published doctrine page claims only what HAS happened. Level 5 will be made, not planned.

## How doctrine deepens

The pattern that emerged across cycles 1-4:

1. **A real cycle ships** — usually in a project that adopts the pack (cycles 1, 2, 3 were compass-adoption-cycles), occasionally pack-internal when a primitive is discovered without yet having an adopter to validate it (cycle 4 introduced the grounding envelope as doctrine + sealed schemas + golden vectors, per `doc-only-then-runtime` discipline)
2. **Reviews surface gaps** · in cycle 2's case · 4 distinct review pipelines (PRD review · bridgebuilder SDD · sprint skeptic · PR-diff bridgebuilder) each caught what the previous missed
3. **Operator decisions get captured** as inline NOTES.md entries · time-stamped · cited from PR commits
4. **The cycle's S6 distill** writes back to this pack · adds new pattern files · updates existing patterns · adds the cycle as a worked example (or, for pack-internal cycles, lands the doctrine + schemas as the artifact-set without a downstream worked-example)
5. **The doctrine version bumps** even if the promotion criteria (project-count) hasn't been met · the pack records depth as a separate dimension from breadth · the depth bump may also come from a pack-internal primitive landing (cycle 4 precedent)

A pack at version 0.2.0 with 1-project validation but level-4 doctrine is meaningfully different from the same pack at version 0.1.0 with 1-project validation. The depth dimension matters · this file makes it visible.

## Promotion criteria · revised perspective

The original promotion criteria (≥3 projects · one non-Next.js) measure **breadth**. They're recorded in `construct.yaml` and still binding for `status: active` promotion.

This file proposes a complement: **depth**. Each cycle that compounds the doctrine adds a new level. A pack at level-N doctrine in 1 project is a different artifact than the same pack at level-1 doctrine in 1 project · the patterns are richer · the worked example is deeper · the operator who runs the next cycle will benefit from accumulated learning.

For the curious adopter who wants to know "is this pack alive?" the answer lives at two coordinates:

- `status` (candidate · validated · active) — measures breadth · in `construct.yaml`
- doctrine depth (level 1 · level 2 · ...) — measures depth · narrative-only · this file is the canonical claim

Per BB-PR1-001: doctrine depth is **narrative not manifest** · it lives in this prose, not as a `construct.yaml` field. The canonical loa-constructs schema declares `additionalProperties: false` at the root · adding a new top-level field would fragment the ecosystem schema. When a future schema_version: 4 adopts an optional `doctrine_depth: integer` field at the manifest level, this pack will adopt it. Until then, the depth dimension lives where it should: in the doctrine the pack publishes, not in the manifest validators check.

## What this file doesn't claim

- Not a roadmap · level 3 will be made, not planned
- Not a promotion mechanism · `status: active` still requires the original 3-project criterion
- Not a substitute for the worked examples · each cycle's `examples/<cycle>.md` carries the concrete LOC/test/finding numbers
- Not finished · this file grows when the next cycle deepens the doctrine

## The lineage so far

```
└── effect-substrate (status: candidate · doctrine depth: 4 · narrative)
    ├── cycle 1 · compass-substrate-ecs-2026-05-11 (level 1 · structural isomorphism)
    ├── cycle 2 · compass-substrate-agentic-translation-adoption-2026-05-12 (level 2 · adopt-don't-invent)
    ├── cycle 3 · compass-purupuru-cycle-1-wood-vertical-2026-05-13 (level 3 · peer-substrate plurality · shape serves scope)
    └── cycle 4 · compass-substrate-grounding-2026-05-16 (level 4 · grounding envelope · hakkutsu is how the envelope speaks back)
```

The next adopter is invited to add their cycle here.
