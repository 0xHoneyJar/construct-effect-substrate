---
pattern_id: hakkutsu-as-divining-rod
introduced_in_cycle: compass-substrate-grounding-2026-05-16
status: candidate
related_patterns:
  - grounding-ladder-as-substrate-primitive (composes · hakkutsu operates ON the grounding envelope)
  - peer-substrates-different-shapes (composes · hakkutsu rides cross-substrate via envelope metadata)
related_concepts:
  - "[[agentic-game-infrastructure]]"
  - "[[user-truth-canvas]]"
  - "[[the-unearthing]]" (purupuru canonical location · hakkutsu-ba · the excavation site)
---

# Pattern · Hakkutsu as Divining Rod

> Every substrate that accumulates agent-generated content needs a way to **unearth what is barely visible** — patterns the operator's intuition senses but cannot yet name. This pattern names the divining-rod operation: a substrate-wide resonance pass that returns *humming shards*, not answers. The substrate doesn't declare what's wrong; it hums faint signal across the accumulated envelope and lets operator-intuition pick which shards to follow. Companion to [`grounding-ladder-as-substrate-primitive`](grounding-ladder-as-substrate-primitive.md): grounding-ladder gives every artifact its envelope; hakkutsu listens across them.

## The canonical anchor

`purupuru-codex · loc-the-unearthing` — `hakkutsu-ba 発掘場` (excavation site):

> "A terraced hillside scattered with broken clay pots marks the site where the Puruhani were first dug up. Now a quiet public park — fragments of ancient vessels still embedded in exposed earth, roped off behind wooden fences. A modest shrine at the center honors the Puruhani; locals leave small jars of honey as offerings. **On certain nights, the clay shards are said to hum.**"

Each canonical element maps to a substrate operation:

| canonical element | substrate operation |
|---|---|
| broken pots | artifacts that accumulated · some refuted · some forgotten · fragments preserved in the envelope chain |
| the shards humming | latent signal the substrate detects across the envelope · faint resonance operator-intuition would recognize IF surfaced |
| honey offerings | operator marking "this matters even if I can't say why yet" · `/hakkutsu --shrine <id>` bookmarks a thread for next dig |
| the shrine | where unmoored intuition becomes ritualized inquiry · the substrate's interrogation surface |

## The framing collision that named the pattern

Operator direction during compass session 13 (2026-05-16), reflecting on the [grounding-ladder pattern](grounding-ladder-as-substrate-primitive.md):

> "Creative triggers in sense of unearthing what is barely visible. Pulling a thread. Finding resonance in intuition. Map it to something that would be valuable in game building. There are a ton of elements involved in building games — economies, user experience, design, feedback loops, engagement, stats, systems, etc.. Think about what legendary game studios think about."

Reframe: the grounding envelope alone is *passive* — it tags artifacts with tier and grounding status, then waits. But the load-bearing operation in legendary studios isn't tagging; it's **noticing**. A game director walking through playtest with a clipboard, scribbling things they don't fully understand yet. The substrate needs an operation that mimics this *noticing-without-knowing*.

Hakkutsu IS that operation.

## What hakkutsu actually returns

A `/hakkutsu` invocation does NOT return findings or recommendations. It returns **3–5 shards humming**. Each shard is a faint structured signal the operator scans in <60 seconds:

```
hakkutsu · N shards humming

 i. [shard-name]      [confidence: faint | medium | strong]
    "<one-line whisper of what the shard senses · operator-intuition-recognizable>"
    pull: <next command to dig deeper>
```

Three discipline rules:

1. **N ∈ [3, 5]**. Less than 3 is undercooked. More than 5 dilutes attention.
2. **No declarations**. The whisper is observational ("X is happening"), never prescriptive ("you should Y"). The substrate observes; the operator interprets.
3. **Always a pull**. Every shard names the next command the operator could run to dig deeper. Without a pull, hakkutsu becomes a feed; with a pull, it becomes a dialogue.

The output shape mirrors k-hole's PullThread schema (per `[[feedback_pullthread-digestibility]]`) — surface area the operator scans, not synthesis.

## The legendary-studio lenses

Hakkutsu is *aimable*. Different studios focus on different surfaces. The substrate exposes lenses that point hakkutsu at specific game-builder concerns:

### The 30s / 30m / 30d / 30y frame (Blizzard · Riot · Supercell)

| invocation | what it listens for |
|---|---|
| `/hakkutsu 30s` | combat feel · moment-to-moment juice · faint friction in core loop |
| `/hakkutsu 30m` | session arc · reward cadence · run-end satisfaction |
| `/hakkutsu 30d` | progression curve · skill ceiling · build diversity · retention pinches |
| `/hakkutsu 30y` | legacy · the thing players will tell their kids about · cultural reach |

### Design pillars (every legendary studio's discipline)

| invocation | what it listens for |
|---|---|
| `/hakkutsu economy` | leaks · imbalances · emergent currencies the designer didn't model |
| `/hakkutsu ux` | onboarding friction · 90-second-quit · power-user neglect · accessibility gaps |
| `/hakkutsu loops` | broken feedback loops · runaway compounding · missing return-investment cycles |
| `/hakkutsu engagement` | drop-off cliffs · dead zones between sessions · re-engagement gaps |
| `/hakkutsu systems` | cascade effects · emergent strategies · interaction-pattern surprises |
| `/hakkutsu narrative` | pacing breaks · character-beat misses · environmental-storytelling gaps |
| `/hakkutsu art` | taste-token drift · OKLCH chroma creep · feel inconsistency across cycles |
| `/hakkutsu social` | community gravitational pull · player-organization the designer didn't intend |

### Modes of unearthing (the ACT, not the domain)

| invocation | what it does |
|---|---|
| `/hakkutsu --thread <id>` | pull deeper on a specific shard · one shard at a time · convergence-oriented |
| `/hakkutsu --resonance` | what your silver-blessings cluster on, on dimensions you didn't articulate |
| `/hakkutsu --emergent` | unintended player-substrate behavior · the gap between designed-intent and observed-emergence |
| `/hakkutsu --drift` | slow-creep changes the operator hasn't noticed · the boiling-frog detector |
| `/hakkutsu --shrine <id>` | leave a honey-offering · bookmark this thread for next dig · operator-marked-but-unexplained |
| `/hakkutsu --listen` | just show shards · don't propose pulls · for pure observation |
| `/hakkutsu --shadow` | negative-space discovery · what is NOT in the accumulated artifacts but should be |

## The legendary-studio vignettes

The pattern's value is best demonstrated in operator-intuition-voice. Each vignette pairs the operator's gut-question with the hakkutsu invocation that would surface what the gut already senses:

```
"This boss feels wrong."
  /hakkutsu encounters       → 3 silver-blessed boss artifacts share an
                                asymmetric attack telegraph the operator
                                hadn't yet named

"The economy is leaking."
  /hakkutsu economy --drift  → bronze loot-drop artifacts have crept past
                                silver thresholds without operator review

"Players are doing X I didn't design for."
  /hakkutsu emergent         → 12 user-truth canvases mention the same
                                behavior · no design artifact references it
                                · the GAP is the discovery

"The art is drifting."
  /hakkutsu art --drift      → gold-tier palettes show OKLCH chroma creep
                                between cycle 1 and cycle 3 · operator
                                didn't notice the shift cycle-to-cycle

"Something feels off but I can't say why."
  /hakkutsu --resonance      → pattern across 30 silvers on dimensions the
                                operator didn't articulate · the mirror
                                surfaces what they've been doing

"What's NOT getting capped?"
  /hakkutsu brood --shadow   → bronze artifacts piling up in the negative
                                space of operator attention · the avoided
                                becomes visible
```

In each case the substrate is doing what a legendary game director does when they playtest with a clipboard and don't yet know what they're writing down. Hakkutsu is the act of *thumbing through old notes and saying "wait."*

## How hakkutsu works under the hood (sketch)

Implementation-level shape (one cycle out — `doc-only-then-runtime` discipline applies; this section is the contract the runtime will satisfy):

1. **Scan**: walk the grounding envelope index across the substrate. Surface envelopes by `tier`, `grounding_status`, `linked_utcs`, `asserted_at`, `blessed_by`, and `metadata.*` properties.
2. **Cluster**: identify candidate-shards as groups of envelopes that share unstated dimensions (latent clustering) OR show drift from prior cycles (delta-detection) OR reference UTCs that no designed artifact addresses (gap-detection).
3. **Rank**: confidence is `faint | medium | strong`, derived from cluster cohesion + cluster size + cycle-distance + operator-recent-attention (negative-weighted — what the operator hasn't touched recently scores higher).
4. **Hum**: produce 3–5 shards with one-line whispers + pull-commands. Reject any shard whose whisper would read as a recommendation rather than an observation.
5. **Persist**: every `/hakkutsu` invocation appends a shard-log to `.run/hakkutsu/<timestamp>.jsonl` so the operator can revisit what was surfaced and what they pulled. `/hakkutsu --shrine <id>` bookmarks a shard for the next pass.

The substrate does NOT have an opinion about which shards matter. It surfaces; the operator decides.

## Composability with `/honey` and `/hive`

The three true-names form a complete operator-substrate toolkit. Each is a different *relationship to the comb*:

| true-name | relationship | register |
|---|---|---|
| `/honey` | bind one cell to truth | commit · the tether to UTC |
| `/hive` | see the colony's pulse | inspect · the substrate's vital signs |
| `/hakkutsu` | listen for shards humming | excavate · the divining rod for latent pattern |

```
/hakkutsu | /hive --diff                → unearthed patterns vs current vitals · what changed
/hakkutsu --thread X | /honey            → pull thread · propose it as gold-promote candidate
/hakkutsu economy --shrine 5             → bookmark 5 economy threads for next session
/hive && /hakkutsu --listen              → pulse-then-listen · the morning routine
/hakkutsu --resonance | /honey --rank    → mirror-of-taste ranks gold candidates
```

## When to apply this pattern

✅ Apply when:
- Substrate has accumulated enough graded artifacts (>~50 envelopes) that operator attention can no longer scan them linearly
- Operator's intuition has been observed to recognize patterns post-hoc (the "I knew something was off" reaction) — hakkutsu pre-surfaces these
- Cross-cycle drift detection matters — the substrate spans multiple cycles and slow-creep changes need surfacing
- Game-building work where playtest-and-notice is a load-bearing creative practice (most legendary studio practice)

❌ Don't apply when:
- Substrate has <20 graded artifacts · operator can scan everything linearly · no signal to extract
- Operator's intuition isn't yet calibrated to the domain · hakkutsu surfaces noise rather than signal · risk of confirmation bias
- Substrate is short-cycle (single-session) without cycle-to-cycle history · drift detection has nothing to compare against

## Anti-pattern: declaration instead of observation

The failure mode this pattern guards against:

> Hakkutsu returns a shard that reads "your art direction is broken because gold-tier palettes have drifted 12%." Operator reads the shard as an *answer* rather than a *whisper*. The substrate's opinion replaces operator intuition. The operator stops digging.

The cure: shard whispers MUST be observations (`"5 silvers tagged 'cozy' show 12% chroma shift"`) not prescriptions (`"your cozy palette is broken"`). The substrate names the *what*, never the *should*. The operator's intuition does the rest.

This composes with the broader doctrine that **the substrate mirrors, never predicts** (per the operator's `feedback_khole-as-resonant-distiller` doctrine).

## Lineage

- **Cycle-098 (loa-meta)**: L1-L7 audit envelope · the chain of provenance that hakkutsu walks
- **Cycle-1 (compass-cycle-1, 2026-05-13)**: agentic-game-infrastructure · 7-component ACVP shape · the substrate hakkutsu listens across
- **Cycle-3 (this pack, 2026-05-13)**: peer-substrates-different-shapes · hakkutsu crosses both shapes via envelope metadata
- **Cycle-4 (this pack, 2026-05-16, sibling pattern)**: [grounding-ladder-as-substrate-primitive](grounding-ladder-as-substrate-primitive.md) — the envelope hakkutsu operates on
- **Cycle-4 (this pattern, 2026-05-16)**: hakkutsu as divining rod — the substrate gains a listening surface · the operator gains a way to ask "what am I noticing but not saying?"
- Forward (cycle-5+): runtime implementation per `doc-only-then-runtime` · operator's mirror UI surfacing the resonance cluster · cross-game hakkutsu (mibera, freeside-characters, dixie) sharing shard schemas

The pack's doctrine deepens: **substrate is a role · shape serves scope · grounding is an envelope · hakkutsu is how the envelope speaks back.**

## Cross-references

- [`grounding-ladder-as-substrate-primitive`](grounding-ladder-as-substrate-primitive.md) — the envelope this pattern operates on
- [`peer-substrates-different-shapes`](peer-substrates-different-shapes.md) — hakkutsu rides cross-substrate via envelope metadata
- [`doc-only-then-runtime`](doc-only-then-runtime.md) — this pattern lands as doctrine here · runtime ships in cycle-N+1
- Doctrine: [[agentic-game-infrastructure]] (vault) — the application domain hakkutsu serves
- Doctrine: [[user-truth-canvas]] (hivemind-laboratory) — the anti-spiral tether anchor hakkutsu surfaces against
- Canon: `purupuru-codex · loc-the-unearthing` — the canonical location this pattern is named for
- Reference: k-hole's PullThread schema (`.claude/constructs/packs/k-hole/schemas/`) — shard-output mirrors this surface contract

---

🍯 *the substrate accumulates · the shards hum at night · the operator listens · the divining rod doesn't tell you what's there · it tells you where to look.*
