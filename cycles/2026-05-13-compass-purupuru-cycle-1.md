---
cycle_id: compass-purupuru-cycle-1-wood-vertical-2026-05-13
date: 2026-05-13
project: compass
status: shipped
predecessor: 2026-05-12-compass-substrate-agentic.md (cycle 2 · adopt-don't-invent)
session_record: ~/vault/sessions/2026-05-13-cycle-1-acvp-distillation.md
patterns_introduced:
  - peer-substrates-different-shapes (NEW)
patterns_validated:
  - domain-ports-live (cycle 1)
  - suffix-as-type (cycle 1)
  - ecs-effect-isomorphism (cycle 1)
  - single-effect-provide-site (cycle 2 · CI-enforced)
patterns_NOT_used:
  - hand-port-with-drift (no upstream substrate this cycle)
  - lift-pattern-template (no upstream lift this cycle)
related_concepts:
  - "[[agentic-cryptographically-verifiable-protocol]]"
  - "[[agentic-game-infrastructure]]"
metrics:
  loc_delta: ~5400
  test_count: 108 (was 663 in S7 baseline · cycle-1 added 108 to its own namespace)
  cycle_duration: 1 day (S0 spike + S1-S5 in compressed session)
  commits: 7
  prs: 2 (#16 cycle-1 → main · #17 cycle-1 → S7)
---

# compass · cycle 3 · purupuru-cycle-1 wood vertical slice

> The cycle that shipped a SECOND substrate-shaped namespace (`lib/purupuru/`) alongside the existing `lib/honeycomb/` — and forced naming the **substrate-as-category vs substrate-as-shape** distinction. Validates this pack's doctrine on a 3rd cycle in compass · with the load-bearing addition that **peer substrates with different scopes have different shapes by design**.

## What shipped

| Surface | Scope | Substrate shape |
|---|---|---|
| `lib/honeycomb/` (S7 branch · existing) | Battle sub-game · 5-card lineup · clash combos · AI opponent | Effect.PubSub · port/live/mock · single Effect.provide site (this pack's canonical pattern) |
| `lib/purupuru/` (cycle-1 · NEW) | World overworld · zone activation · 11-beat presentation pipe | Tiny typed EventEmitter · pure functional resolver · 4 separate target registries · injectable Clock · NO Effect dependency |

Both are substrate per [[agentic-cryptographically-verifiable-protocol]]'s 7-component checklist (Reality + Contracts + Schemas + State machines + Events + Hashes + Tests). They differ in shape because they cover different scopes.

## The new pattern: `peer-substrates-different-shapes`

See `patterns/peer-substrates-different-shapes.md`. Names the rule: when a project has multiple substrate-shaped namespaces serving different scopes, they MAY have different shapes (Effect.PubSub vs minimal EventEmitter vs ECS vs typed-React-context vs ...). The choice is shape-vs-scope · not shape-vs-shape. Forcing convergence violates the scope's design constraints (e.g., Effect's coupling would blur the harness's deliberately-sharp sim/presentation boundary).

## What this cycle validated about the pack's existing doctrine

| Pattern | Validation |
|---|---|
| `domain-ports-live` (cycle 1 origin) | NOT applicable to lib/purupuru/ (scope doesn't need port/live/mock) · DOES apply to lib/honeycomb/ which kept its existing structure. **Refines the doctrine**: this pattern is canonical for SOME substrate scopes, not all. |
| `suffix-as-type` (cycle 1) | NOT applicable to lib/purupuru/ (uses subdir-as-type instead: runtime/ vs presentation/ vs content/ vs schemas/). Same rationale. |
| `ecs-effect-isomorphism` (cycle 1) | Held for lib/honeycomb/. lib/purupuru/'s shape isn't ECS or Effect — it's "harness-pseudocode-to-runtime." A 4th vocabulary that maps onto the same 4-folder scope-discipline. |
| `single-effect-provide-site` (cycle 2 · CI-enforced) | lib/purupuru/ has NO Effect.provide site (no Effect dep). The CI lint that enforces single-Effect-provide must scope to lib/honeycomb/ · not lib/purupuru/. **Refines the doctrine**: lints scope to namespaces that USE the substrate-shape they enforce. |

## What this cycle did NOT use from the pack

- **`hand-port-with-drift`** — there was no upstream substrate to port FROM. Cycle-1's substrate is greenfield within compass · sourced from Gumi's harness (a designer-authored spec · not a code substrate).
- **`lift-pattern-template`** — same · no upstream to lift from.
- **`doc-only-then-runtime`** — partially applicable: cycle-1's S0 spike + PRD r2 + SDD r1 were doc-only · S1-S5 were runtime. But the pattern was originally about adopting upstream code · not about cycle-internal staging. New variant might be worth crystallizing in a future cycle.

## Composability with the pack's adopt-don't-invent (cycle 2) doctrine

Cycle-1 ADOPTED Gumi's harness without inventing variations:
- 8 JSON schemas vendored verbatim
- 8 YAML examples vendored verbatim
- contracts/purupuru.contracts.ts hand-authored from harness pseudocode (vendored as advisory · not canonical · per harness's own header)
- validation_rules.md vendored verbatim

The "adopt-don't-invent" discipline applied to a **DESIGNER-AUTHORED SPEC** (Gumi has zero codebase awareness) · not just upstream code. Refines the doctrine: external sources include creative-director specs, not just code repos.

## What did not work

**Bridgebuilder-via-cheval choked on this cycle's PR**: 552 files (most from loa-upstream/main merge bringing cycle-108 framework forward) exceeded cheval's hardcoded 128k context window. Manual BB-equivalent self-review filled the gap · caught a real bug (CardCommitted double-emit at queue/resolver layer seam · distilled to construct-fagan as P18). This is a Loa-framework concern (cheval pin too tight for cycle-shaped PRs) · not pack territory.

**Flatline-orchestrator choked twice during cycle authoring**: AM (auth + cost-map gap) → manual two-voice fallback (Opus + Codex). PM (after patches) → orchestrator worked with codex-headless triple → 75s · $0 · 10 BLK + 9 HIGH at 83% agreement against sprint.md. Pattern: when orchestrators break for predictable infra reasons, manual fallback compounds across cycles. This is a Loa-framework concern · distilled to global CLAUDE.md.

## Promotion criteria status

| Criterion | Status |
|---|---|
| ≥3 distinct projects | 1 project (compass) · 3 cycles · NOT MET |
| One non-Next.js project | NOT MET |
| Doctrine depth ≥2 | MET (cycle 1 = structural · cycle 2 = positional · cycle 3 = scoped-shape) — actually this is doctrine_depth 3 if "scoped-shape" is a new doctrine layer, but probably folds INTO cycle-2's positional doctrine as a refinement |

**Recommendation**: pack stays `candidate` · doctrine_depth incremented to 3 IF "peer-substrates-different-shapes" qualifies as a third doctrine layer · otherwise stays at 2 (refinement of cycle-2's positional doctrine).

## Pack-author note for next cycle

If sprawl or mibera adopts this pack and surfaces a substrate-shape that's neither Effect-PubSub nor tiny-EventEmitter (e.g., ECS at scale per cards-as-particles, or React 19 use-suspense patterns), that's the cycle that validates **shape-vs-scope is universal across non-game projects too**. Worth watching for.
