---
pattern_id: grounding-ladder-as-substrate-primitive
introduced_in_cycle: compass-substrate-grounding-2026-05-16
status: candidate
related_patterns:
  - peer-substrates-different-shapes (composes · grounding crosses BOTH shapes via envelope, not runtime)
  - hand-port-with-drift (composes · the envelope is a hand-port of medallion lakehouse semantics)
  - doc-only-then-runtime (composes · pattern lands here as doctrine · runtime ships in cycle-N+1 once schema proves out)
  - single-effect-provide-site (composes · the grounding-aware integrator is one Service · one provide-site)
related_concepts:
  - "[[agentic-cryptographically-verifiable-protocol]]"
  - "[[agentic-game-infrastructure]]"
  - "[[medallion-architecture]]" (Databricks lakehouse origin · applied here to CONTENT not data)
  - "[[user-truth-canvas]]" (the anti-spiral tether · hivemind-laboratory schema)
---

# Pattern · Grounding Ladder as Substrate Primitive

> Every substrate that hosts agent-generated content needs a way to distinguish what an agent generated freely from what the operator blessed from what user-truth canvases back. This pattern names that distinction as a CROSS-CUTTING property — the **grounding envelope** — that travels with every artifact regardless of which of the 7 ACVP components hosts it (Reality, Contracts, Schemas, State machines, Events, Hashes, Tests). The ladder is `bronze → silver → gold`, with `refuted` as the absorbing terminal. Medallion architecture, applied to agentic content, not data.

## The framing collision that named the pattern

Operator direction during compass session-13 (2026-05-16), in the wake of cycle-098's L1-L7 audit infrastructure and cycle-098's recognition that loa has been building ACVP infrastructure for ~30 cycles without naming it:

> "Agents over-generate without backpressure. The graduation tier system is the load-bearing fix — NOT a quality rank, a GROUNDING rank."

Initial framing (build doc `enhance-substrate-graduation-utc.md`, same morning): build a separate `construct-graduation-substrate` repo to host the schema + validators + golden vectors. Sibling to honeycomb. Reusable across projects via import.

Operator pushback an hour later:

> "The honeycomb substrate is an architecture pattern just like this one. This one could collapse and distill into our honeycomb game engine substrate. I think this would be an even better move in the sense that this single substrate is the architectural decisions and evolving architecture that I will use across many games. I want to build out an agent first game infra."

The reframe: graduation isn't a sibling substrate. It's a primitive **inside** honeycomb. honeycomb is THE agent-first game infra substrate — across compass, mibera, freeside-characters, dixie, future-game-N. The grounding ladder is one of honeycomb's load-bearing primitives, not a sibling pack.

This pattern doc IS that distillation.

## The three tiers · plus the tristate epistemic status

The pattern carries TWO ORTHOGONAL AXES. The narrative-facing "4 states" (bronze, silver, gold, refuted) decompose into a 3-state promotion ladder × 3-state epistemic tristate. The orthogonality is load-bearing because refutation can occur at ANY tier (a gold artifact can be refuted) without collapsing the artifact's tier history.

### Tier · the promotion ladder (3-state)

| Tier | Meaning | How an artifact enters | What gates downstream consumption |
|---|---|---|---|
| **bronze** | Agent-forward generation · unanchored to operator or user-truth · default for any new artifact | Agent emits content; envelope auto-defaults to bronze if absent | Bronze artifacts MAY surface in tooling · MUST NOT enter integration gates that require operator-validated content |
| **silver** | Operator-blessed · backed by operator intuition · no UTC link yet | Operator-signed activation receipt (signature non-transferable · only signer can revoke) | Silver artifacts MAY enter most integration gates · MUST NOT be treated as user-validated truth |
| **gold** | User-truth-backed · `linked_utcs` references at least one UTC with `learning_status ∈ {strongly-validated, directionally-correct}` | UTC link added by observer pack OR operator manual link | Gold artifacts MAY anchor canon decisions · cross-game graft eligible · operator's-mirror training data |

The ladder is monotonic for promotion (bronze → silver → gold), but demotion can skip — `gold → bronze` is valid when the underlying UTC moves and the operator hasn't manually re-blessed.

### Grounding status · the epistemic tristate (3-state)

Per [[epistemic-tristate]] discipline (`loa-hounfour/docs/patterns/epistemic-tristate.md`): three states must require DIFFERENT consumer behaviors · collapse to two states = degenerated tristate (rejected by doctrine).

| Status | Meaning | Consumer behavior |
|---|---|---|
| **grounded** | Underlying evidence (UTC link, operator signature) is current and valid | Integration gates pass at tier-appropriate level |
| **refuted** | Underlying UTC moved to `hypothesis-failed` OR operator marked refuted | Integration gates HALT regardless of tier · artifact surfaces in negative ledger · `refuted_at` timestamp REQUIRED |
| **unverifiable** | Evidence cannot be confirmed right now (UTC unreachable, signature expired, network failure) | Integration gates pass with warning · do NOT treat as canon · re-verify when possible |

The two axes coexist independently. A `tier: gold · grounding_status: refuted` artifact retains its tier history (it WAS gold · the operator promoted it via the proper path) while the substrate refuses to integrate it (the UTC backing failed). The refutation is the marker, not the demotion. Operators MAY explicitly demote refuted artifacts via a separate action; the substrate doesn't force the demotion automatically.

This separation honors hounfour's tristate discipline AND preserves provenance — a refuted gold's history shows it was canon for a window. The "negative ledger" vocabulary card surfaces exactly this set: `grounding_status=refuted` artifacts across all tiers.

## Why medallion architecture, applied to content not data

Medallion architecture (Databricks lakehouse, ~2020) separates raw / cleansed / enriched DATA across bronze/silver/gold tables. Reads downstream constrain to the highest-confidence layer their query tolerates.

This pattern applies the SAME SHAPE to agentic CONTENT — taste tokens, VFX configs, lore entries, mechanics, items, dialogue — where the source isn't INGESTION (raw → cleansed) but GENERATION (agent → operator → user-truth).

| Lakehouse medallion | Agentic medallion (this pattern) |
|---|---|
| Source: external data ingestion | Source: agent forward-generation |
| Bronze: raw, schema-on-read | Bronze: unanchored agent output |
| Silver: cleansed, deduplicated | Silver: operator-blessed via signature |
| Gold: business-rule-enriched | Gold: UTC-backed, anti-spiral tethered |
| Promotion: pipeline ETL | Promotion: operator-signed receipt + UTC linkage |
| Consumer constraint: query lakehouse layer matching tolerance | Consumer constraint: integration gates select minimum tier |

The shape transfers because both domains face the same problem: **distinguish unverified production from verified canon, at machine-readable scale, without collapsing the unverified.**

Critical distinction from prior art: `freeside-score` already implements medallion internally for the THJ scoring substrate (sealed schemas in `packages/protocol/`, ports in `packages/ports/`, MCP-tools agent surface, typed adapters). That repo PROVES the shape works for THJ infrastructure. This pattern lifts the same shape into honeycomb so it's available to every game-infra substrate, not just score.

## The grounding envelope shape

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://schemas.honeycomb/grounding-envelope/1.0.0",
  "x-cross-field-validated": true,
  "additionalProperties": false,
  "type": "object",
  "required": [
    "envelope_id",
    "artifact_path",
    "tier",
    "grounding_status",
    "asserted_at",
    "contract_version"
  ],
  "properties": {
    "envelope_id":      { "type": "string", "format": "uuid" },
    "artifact_path":    { "type": "string", "minLength": 1 },
    "tier":             { "type": "string", "enum": ["bronze", "silver", "gold"] },
    "grounding_status": { "type": "string", "enum": ["grounded", "refuted", "unverifiable"] },
    "linked_utcs": {
      "type": "array",
      "items": {
        "type": "object",
        "additionalProperties": false,
        "required": ["canvas_url", "quote_hash"],
        "properties": {
          "canvas_url":      { "type": "string", "minLength": 1 },
          "quote_hash":      { "type": "string", "pattern": "^sha256:[0-9a-f]{64}$" },
          "confidence":      { "type": "number", "minimum": 0, "maximum": 1 },
          "learning_status": {
            "type": "string",
            "enum": ["strongly-validated", "directionally-correct", "hypothesis-failed", "smol-evidence", "cant-make-a-conclusion"]
          }
        }
      }
    },
    "blessed_by":       { "type": "string", "enum": ["operator", "auto-derived", "construct-consensus"] },
    "operator_signed":  { "type": "boolean" },
    "asserted_at":      { "type": "string", "format": "date-time" },
    "refuted_at":       { "type": "string", "format": "date-time" },
    "refutation_reason":{ "type": "string" },
    "contract_version": { "type": "string", "pattern": "^\\d+\\.\\d+\\.\\d+$" },
    "metadata":         { "type": "object", "patternProperties": { "^.*$": {} } }
  }
}
```

Schema discipline mirrors loa-hounfour:
- `additionalProperties: false` with a `metadata` open-object escape hatch (10KB consumer-side cap by convention)
- `*_id` UUID format · `*_at` date-time format · `contract_version` semver-regex
- Tristate `grounding_status` (never boolean) per [[epistemic-tristate]] doctrine
- SHA-256 `quote_hash` for evidence integrity
- Sister `.constraints.json` carries cross-field rules (see below)

## Cross-component invariance — the envelope is metadata, not a structural peer

The temptation: name Grounding as the 8th component of ACVP (R + C + S + SM + E + H + T + **G**). The 8-cell honeycomb is visually elegant.

**Resist this.**

R/C/S/SM/E/H/T are *structural categories* — each one defines a portion of how the substrate is built. They're orthogonal axes that any artifact lives along.

Grounding is *metadata that travels with content* — it propagates through artifacts that live across all 7 components. A schema record has a grounding envelope. A state machine transition has a grounding envelope. An event payload has a grounding envelope. A test fixture has a grounding envelope. The envelope is *cross-cutting*, not *structural-peer*.

The accurate framing: **substrate is a role · shape serves scope · grounding is an envelope.** The grounding ladder is a CROSS-COMPONENT PROPERTY that the substrate enforces uniformly across R/C/S/SM/E/H/T, not a new component peer.

The 8-cell honeycomb sigil is a visual mnemonic for the doctrinal addition. The schema reality is: 7 components + 1 cross-cutting envelope.

## The 7 grounding invariants

Analogous to ACVP's 7 cross-component invariants (Hash-determinism, Event-completeness, Schema-enforcement, State-machine-totality, Contract-typing, Test-anchoring, Hash-chain-continuity), the grounding ladder adds 7 invariants the substrate MUST enforce:

| # | Invariant | What it forbids |
|---|---|---|
| 1 | **Tier monotonicity on promotion** | bronze → gold direct skip without silver intermediary (unless `--override` with explicit operator signature) |
| 2 | **UTC link immutability** | mutating `linked_utcs` on a gold artifact without first demoting (preserves provenance audit chain) |
| 3 | **Refutation finality** | refuted artifacts cannot re-enter gold without a NEW UTC link (the refutation chain witnesses the contradiction) |
| 4 | **Operator-signature non-transferability** | only the signing operator can revoke their own silver blessing (multi-operator projects require operator-identity per OPERATORS.md) |
| 5 | **Drift detection** | UTC moves / supersedes → linked gold artifacts auto-demote to silver (or bronze if no operator backing remains) |
| 6 | **Provenance traceability** | every artifact has a creation event referencing the envelope_id · audit-chain-walkable from artifact → events → envelope → UTC |
| 7 | **Envelope completeness** | substrate refuses uncoupled artifacts past declared integration gates (gates may require minimum tier · cycle-1 default is silver for canon, gold for cross-game graft) |

These compose with the existing 7 ACVP invariants. Substrate-level enforcement is the substrate's job; the agents reason, the substrate verifies — that's the ACVP bargain. Grounding doesn't change the bargain; it adds an epistemic dimension to what counts as "verified."

## Anti-pattern: agent-as-canon

The failure mode this pattern guards against:

> Agent generates a taste token / VFX preset / lore entry. The output is plausible, internally consistent, and stylistically aligned. Nothing in the substrate enforces that it's *blessed* or *user-truth-backed*. It enters the substrate's integration gates because no gate refuses it. Downstream artifacts (game systems, marketing copy, canon decisions) reference it. Two cycles later, the operator realizes the original artifact was agent-forward generation with no real grounding. By then it's woven into N downstream artifacts. Untangling is expensive.

The pattern's bronze-as-default + tier-gated-integration combination prevents this: ungraduated agent output is *visible* in the substrate but *fenced* from canon-shaping consumers until an operator or UTC promotion occurs.

This is the same shape as `doc-only-then-runtime` (compile-time contract before runtime ships) — the substrate carries the artifact *without* committing the consumers, and the commitment is gated by an explicit promotion event.

## The 3 true-names — operator-facing substrate vocabulary

Doctrine alone doesn't compound; vocabulary does. Loa truenames work because they're terms-with-history in a specific universe (Neuromancer: `simstim`, `flatline-review`; autopoiesis: `spiraling`). For honeycomb substrate, the equivalents are bee-technical and Tsuheji-canonical terms. Three names lock the deck. Each is a different *relationship to the comb*.

| true-name | what it does | lore source |
|---|---|---|
| **`/honey`** | bind one cell to user-truth · the activation moment that binds an artifact to a UTC | purupuru-canon · "all magic is rooted in honey" · the foundational essence of Tsuheji magic |
| **`/hive`** | see the colony's pulse · the substrate's vital signs across all envelopes | bee-canon · the apiary at-a-glance · pressure gauges in one verb |
| **`/hakkutsu`** | listen for shards humming · the divining rod for latent patterns the operator's intuition would recognize | purupuru-canon · `loc-the-unearthing` · hakkutsu-ba = excavation site · "on certain nights, the clay shards are said to hum" |

The three compose as a complete operator-substrate toolkit:

```
/honey      commit · the tether to UTC                  (one cell · bound)
/hive       inspect · the substrate's vital signs       (colony-wide · pulse)
/hakkutsu   excavate · the divining rod for latent pattern  (faint signal · 3-5 shards humming)
```

See [`hakkutsu-as-divining-rod`](hakkutsu-as-divining-rod.md) for the full design of how `/hakkutsu` surfaces creative-trigger shards across legendary-studio lenses (30s/30m/30d/30y · economy · ux · loops · engagement · systems · narrative · art · social).

These three names are operator-facing. Code-facing names stay literal (`tier: "bronze"`, `grounding_status: "grounded"`).

### Parked vocabulary (earn use first · expand only when invoked enough to stick)

The earlier draft of this section named 7 cards (tide pool · the clearing · anti-spiral tether · resonance harvest · negative ledger · pressure gauges · operator's mirror) plus 3 future-seeds (refutation cone · echo detection · honey pot). Operator pushback: *names earn meaning through invocation, not through being declared*. The 3 above are the *use-resonance-validated* core. The rest are parked — when an operator-named invocation pattern emerges that needs its own true-name, the deck expands. Until then, the 3 verbs cover everything via composition + flags + lenses.

## Composability with peer substrates

The grounding envelope is metadata that crosses both shapes named in [`peer-substrates-different-shapes`](peer-substrates-different-shapes.md):

- `lib/honeycomb/` (Effect.PubSub shape · battle sub-game): grounding envelope rides on every Schema record · Service-level integration gates use envelope tier
- `lib/purupuru/` (tiny-EventEmitter shape · world overworld): grounding envelope rides on every `(state, command) → ResolveResult` artifact · pure-resolver checks tier before integration

The envelope crosses peer substrates because it's *cross-cutting metadata*, not *runtime infrastructure*. No Layer composition required. No PubSub channel. The envelope is JUST DATA — JSON Schema 2020-12, validated at substrate boundaries.

When cycle-N introduces a 3rd peer substrate (e.g., ECS for thousands-of-card-particles scope), the grounding envelope rides into it unchanged. The envelope is *shape-agnostic*. The shape serves the runtime; the envelope serves the epistemics.

## When to apply this pattern

✅ Apply when:
- Substrate hosts content generated by AI agents at scale (>N artifacts/week where N · operator attention is finite)
- Operator's intuition is a load-bearing source of truth that needs to be COMPUTABLE (not just stored as instinct)
- User-truth canvases (UTCs per hivemind-laboratory schema) exist or are planned · the anti-spiral tether requires them
- Cross-game artifact migration is on the substrate's roadmap · gold-tier graftability needs uniform envelope
- Agent forward-generation has been observed to drift from operator intent (the original empirical trigger)

❌ Don't apply when:
- Substrate hosts only operator-authored content · no agent generation surface · the medallion has only one tier (gold-as-default)
- The artifact stream is small enough (<10/week) that operator attention scales linearly · no backpressure problem to solve · enforcing envelope adds ceremony without payoff
- The substrate is single-game and won't compose across games · the cross-game queryability is the strongest payoff and you don't need it
- UTCs aren't part of the org's observability surface · gold tier has no anchor

## Lineage

- **Cycle 098 (loa-meta)**: L1-L7 audit envelope shipped · hash-chain + signatures + JCS canonicalization · the META-PROTOCOL that ACVP applications inherit
- **Cycle 1 (compass-cycle-1-wood-vertical-2026-05-13)**: agentic-game-infrastructure first application of ACVP · 7-component substrate validated end-to-end for Wood element
- **Cycle 3 (this pack, 2026-05-13)**: [`peer-substrates-different-shapes`](peer-substrates-different-shapes.md) — substrate is role, shape serves scope · the doctrine fissures from "one substrate per project" to "N peer substrates per project, each shape-matched to scope"
- **Cycle 4 (this pattern, 2026-05-16)**: grounding ladder — substrate gains epistemic envelope · agentic content is *rated*, not assumed canon · medallion architecture applied to content not data · cross-game queryable via gold-tier graft
- Forward (cycle 5+): operator's mirror UI surfacing latent taste field · gold-tier density telemetry · refutation cone adjacency-flagging · cross-game canon graft (compass → mibera, freeside-characters)

The pack's doctrine deepens: **substrate is a role · shape serves scope · grounding is an envelope.**

## Cross-references

- [`peer-substrates-different-shapes`](peer-substrates-different-shapes.md) — sibling pattern · the envelope crosses both shapes named there
- [`hand-port-with-drift`](hand-port-with-drift.md) — sibling pattern · the envelope is hand-ported medallion semantics with drift-CI against the lakehouse origin
- [`doc-only-then-runtime`](doc-only-then-runtime.md) — sibling pattern · this pattern lands as doctrine here · runtime implementation ships in cycle-N+1 once schema vectors prove out
- [`single-effect-provide-site`](single-effect-provide-site.md) — sibling pattern · the grounding-aware integrator is one Service · one provide-site
- Doctrine: [[agentic-cryptographically-verifiable-protocol]] (vault) — the parent protocol this envelope inhabits
- Doctrine: [[agentic-game-infrastructure]] (vault) — the first-named application of ACVP that this pattern extends
- Doctrine: medallion architecture (Databricks lakehouse, ~2020) — the shape origin
- Doctrine: [[user-truth-canvas]] (hivemind-laboratory schemas/labels.schema.json) — the anti-spiral tether's anchor
- Reference: [`loa-hounfour/schemas/audit-trail-entry.schema.json`](https://github.com/0xHoneyJar/loa-hounfour) — envelope discipline parent (UUID, semver, tristate, additionalProperties:false + metadata escape hatch)
- Reference: [`freeside-score`](https://github.com/0xHoneyJar/freeside-score) — proven medallion application for THJ score substrate · pattern's structural ancestor

---

🍯 *the substrate gains a comb cell · cross-cutting · the honey is rated · the bees keep working.*
