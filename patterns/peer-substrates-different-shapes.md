---
pattern_id: peer-substrates-different-shapes
introduced_in_cycle: compass-purupuru-cycle-1-wood-vertical-2026-05-13
status: candidate
related_patterns:
  - single-effect-provide-site (orthogonal · this pattern says when-NOT-to-apply that pattern)
  - ecs-effect-isomorphism (this pattern adds a 4th vocabulary: harness-pseudocode-to-runtime)
related_concepts:
  - "[[agentic-cryptographically-verifiable-protocol]]"
  - "[[agentic-game-infrastructure]]"
---

# Peer substrates · different shapes

> When a project has **multiple substrate-shaped namespaces serving different scopes**, they MAY have different shapes. Forcing convergence (one substrate shape across all scopes) violates the scope-specific design constraints. Substrate-as-CATEGORY (the role) is shape-agnostic · substrate-as-SHAPE (Effect-PubSub vs minimal-EventEmitter vs ECS vs typed-React-context vs ...) is scope-specific.

## The framing collision that named the pattern

Operator pushback during compass-cycle-1 SDD interview: I had framed `lib/honeycomb/` (Effect-substrate · this pack's canonical shape) and `lib/purupuru/` (new harness-namespace · tiny EventEmitter · pure resolver) as DIFFERENT CATEGORIES — implying one would eventually subsume the other. Operator's correction:

> "I view harness as substrate, both the same to me. This is the reality, contracts, schemas, state machines, tests that define constraints and enable truth seeking within a sandbox."

Both are substrate · same role · different specialization. The category is invariant. The shape serves the scope.

## The two shapes in cycle-3 of this pack

| Property | `lib/honeycomb/` shape | `lib/purupuru/` shape |
|---|---|---|
| **Event distribution** | `Effect.PubSub` (fiber-aware · backpressure · async coordination) | Tiny typed EventEmitter (synchronous · no-dep · easy to grep-test) |
| **Layer composition** | `Effect.Layer` + single `runtime.ts` provide site | Pure functional · `(state, command) → ResolveResult` returned · no provide site needed |
| **Boundary discipline** | Port/live/mock four-folder | Subdir-as-type (runtime/ presentation/ content/ schemas/ contracts/ __tests__/) |
| **Adapter substitution** | Effect.Layer.succeed swap · test/prod parity by Layer choice | Manual constructor injection · explicit `bus`/`lock`/`content` deps passed to factories |
| **Tests dimension** | Effect-based test runners · service mocking | Vitest · pure-function snapshot |
| **Use case rationale** | Many concurrent state-streams (clash beats · sonifier · weather · tweakpane · audio · sequencer) need composable async coordination | Sim/presentation discipline requires SHARP grep-testable boundary · Effect's coupling would blur it |

Both are substrate. Neither is "better." They serve different scopes.

## When to use one shape vs another

The choice is **scope-driven**, not preference-driven:

| Scope characteristic | Shape preference |
|---|---|
| Many concurrent async state-streams that need to coordinate | Effect.PubSub + Layer |
| Hard sim/presentation boundary that must be grep-testable | Tiny EventEmitter + pure resolver |
| Thousands-of-entities scale (cards-as-particles · AI sims) | ECS (DOTS/SoA) |
| UI-local state that doesn't cross network | React state + typed context |
| Cross-process / network-distributed | Actor model + serializable messages |

When a single project has multiple namespaces with different scope characteristics, they MAY have different shapes. The substrate-as-category checklist (R+C+S+SM+E+H+T from [[agentic-cryptographically-verifiable-protocol]]) MUST hold for each. The shape MAY differ.

## Anti-pattern: forcing shape convergence

The temptation: "we use Effect everywhere · so the new namespace should also use Effect." Often wrong. Three failure modes:

1. **Coupling-blurs-boundary**: Effect-PubSub introduces cross-fiber coordination. Sim/presentation discipline requires the OPPOSITE — a boundary so sharp that grep-tests can statically prove `presentation/*` doesn't import `runtime/resolver`. Effect would blur this · making the boundary runtime-only.

2. **Dependency-bloat-on-greenfield**: starting a new namespace with Effect inherits all of Effect's complexity for code that may never need it. The harness's resolver is `(state, command) → result` · pure · 380 lines · zero dependencies. Wrapping it in Effect.Effect would add ~200 LOC of coordination code for no scope-driven benefit.

3. **Pattern-lint-misfires**: this pack's `single-effect-provide-site` lint scopes to "every namespace that uses Effect must have exactly one provide site." If a peer substrate doesn't use Effect at all, the lint must scope to namespaces that USE the shape · not project-globally. Forcing the new namespace to use Effect just to satisfy the lint is shape-cargo-cult.

## The scope-vs-shape decision rule

When proposing a new substrate-shaped namespace:

1. **First**: verify the 7-component substrate checklist applies (Reality + Contracts + Schemas + State machines + Events + Hashes + Tests). If any component is missing, you don't have substrate · you have typed glue.
2. **Second**: identify the scope characteristic — what does this namespace actually do that's distinct from existing peer substrates?
3. **Third**: choose the shape that serves the scope · NOT the shape that matches existing peer substrates.
4. **Fourth**: name the shape choice in the namespace's own README/SDD · so future agents understand WHY it differs.
5. **Fifth**: scope your existing pack's lints to namespaces that use the lint's target shape · not project-globally.

## Composability between peer substrates

When a future cycle bridges two peer substrates (e.g., cycle-2 dispatches a zone-event from the harness substrate INTO the honeycomb battle sub-game), the bridge needs a **typed adapter** at the boundary. The adapter:

- Translates the source substrate's event/command shape into the target's
- Owns the lifecycle of the cross-substrate call (when does the source resume?)
- Must NOT short-circuit either substrate's contract (the source still emits its event · the target still owns its state)

Three known adapter patterns (cycle-2 PRD interview will pick):

- **Tunnel pattern**: source spawns a target-mode overlay · target runs in a sub-context · returns a result code on close
- **Unified-substrate pattern**: source's event_table[] REPLACES target's trigger logic · target sub-game becomes a presentation-sequence within source substrate
- **Bridge pattern**: keep both substrates · build a typed adapter that translates between them · adapter carries the operational lifecycle

Cycle-1 didn't ship the adapter (deliberately · cycle-2 territory). Cycle-1 PROVED that two peer substrates can coexist in the same project without one absorbing the other.

## How to apply this pattern

When reviewing a proposal that introduces a new substrate-shaped namespace alongside an existing one:

1. Don't ask "should this use Effect/the existing shape?"
2. Ask "what's the scope characteristic that distinguishes this namespace from the existing peer?"
3. Then ask "does the existing shape serve THAT scope, or would a different shape serve it better?"
4. Then ask "do both namespaces still satisfy the 7-component substrate checklist?"
5. If yes to (4) and the shape serves (3) better than the existing pattern, the proposal is sound. Document the shape choice in the new namespace's spec so future agents inherit the rationale.

## Lineage

- **Cycle 1** (this pack): named the structural isomorphism (ECS ≡ Effect ≡ Hexagonal). Implied "one substrate · one shape · pick your vocabulary."
- **Cycle 2** (this pack): added "adopt-don't-invent" — port from upstream rather than re-author. Reinforced "one substrate" framing within compass.
- **Cycle 3** (this pack · this cycle): broke the "one substrate · one shape" framing. Two peer substrates · two shapes · both substrate · different scopes.

The pack's doctrine deepens: **substrate is a role, not a shape. Shape serves scope.**
