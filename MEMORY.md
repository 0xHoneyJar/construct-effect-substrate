# Pack memory · what each cycle taught

> **Pack-author surface · skip on first read.** First-time adopters: start at [SKILL.md](SKILL.md) · this file is for cycle authors writing the next entry.
>
> One line per cycle · ≤200 chars · the pack's auto-memory analog. Lineage in [`doctrine-evolution.md`](doctrine-evolution.md). Worked examples in `examples/`.

## Cycles

- [compass-substrate-ecs-2026-05-11](examples/compass-cycle-2026-05-11.md) — *structural isomorphism · 3 vocabularies converge on 4 folders · −1236 LOC · 128/128 tests*
- [compass-substrate-agentic-translation-adoption-2026-05-12](examples/compass-cycle-2026-05-12.md) — *adopt-don't-invent · 5 hand-ports + verify-fence brand · 3 upstream tracking issues · +5 CI gates · 130/130 tests*
- [compass-purupuru-cycle-1-wood-vertical-2026-05-13](cycles/2026-05-13-compass-purupuru-cycle-1.md) — *peer substrates · different shapes · second substrate-shaped namespace (lib/purupuru/ tiny-EventEmitter) alongside lib/honeycomb/ Effect.PubSub · proves substrate-as-category vs substrate-as-shape · +5400 LOC · 108 new tests*

## Pattern provenance (which cycle introduced each)

- `domain-ports-live` — cycle 1 · cycle 3 refined: applies to SOME substrate scopes, not all
- `suffix-as-type` — cycle 1 · cycle 3 refined: subdir-as-type is the alternative for greenfield namespaces
- `ecs-effect-isomorphism` — cycle 1 · cycle 3 added a 4th vocabulary (harness-pseudocode-to-runtime)
- `delete-heavy-cycle` — cycle 1
- `single-effect-provide-site` — cycle 1 (NAMED) · cycle 2 (CI-enforced + cross-layer composition) · cycle 3 refined: lint scope is per-namespace-using-Effect, not project-global
- `hand-port-with-drift` — cycle 2 · cycle 3 NOT used (no upstream code substrate)
- `doc-only-then-runtime` — cycle 2 · cycle 3 used in adapted form (S0 spike + planning docs · then runtime)
- `lift-pattern-template` — cycle 2 · cycle 3 NOT used
- `state-ownership-matrix` — cycle 2
- `peer-substrates-different-shapes` — **cycle 3 (NEW)** · names "substrate is a role, not a shape · shape serves scope"

## Lessons that didn't become patterns (yet)

These came up in reviews · weren't strong enough to promote to canonical pattern · captured here so the next cycle can promote OR refute:

- *Per-package CLAUDE.md is enormous ROI for ~150 LOC* (cycle 1) — not promoted because it's outside this pack's scope (it's the loa-framework operator's territory)
- *FAGAN-safe wrap-not-rewrite is the right move when test count says behavior is locked* (cycle 1) — captured in `delete-heavy-cycle.md` already
- *Vitest workspace test discovery split is a recurring papercut* (cycle 2) — not promoted · vitest-config-shape isn't substrate doctrine
- *Plain JSON import vs `with { type: "json" }` is TS-version-dependent* (cycle 2) — captured in `hand-port-with-drift.md` SDD-corrected example · not its own pattern
- *Flatline degraded mode #759 needs 2-agent fallback* (cycle 2) — Loa-framework concern · not pack territory
- *Pre-squash branch tags preserve cycle-doc verifiability post-merge* (cycle 2 · BB-PR1-004) — convention proposal · not yet a pattern · push `cycle/<date>-pre-squash` before squash so cycle-doc LOC/commit-count claims survive
- *Cycle-tag CI for compass-as-fixture* (level 3 candidate · per cycle 2 IMP-016) — would compass become a downstream CI gate for hounfour breaking changes · feasibility unclear
- *Bidirectional drift* (level 3 candidate) — when a hand-port reveals an upstream gap that should feed back · compass cycle 3 might surface this if hounfour rejects a tracking-issue proposal
- *Construct-substrate-conformance audit construct* (level 3 candidate) — sibling construct that scans any repo for these patterns · automates promotion-criteria check · concept only
- *Cross-project compounding* (level 3 candidate) — when sprawl or mibera adopts and a pattern emerges that compounds across all three · would be the first non-compass validation

## How to add a cycle

When your project completes adoption:

1. Author `examples/<your-cycle>-YYYY-MM-DD.md` following the structure of `compass-cycle-2026-05-12.md`
2. Update `construct.yaml` `provenance.validated_in` with project name + date + LOC delta + tests + cycle commit/PR link
3. Add a one-line entry under `## Cycles` in this file
4. If your cycle introduced new patterns, author them under `patterns/` and add to `## Pattern provenance`
5. If your cycle compounded doctrine to a new level, update `doctrine-evolution.md`
6. If your project is non-Next.js, you've helped meet the promotion criterion · note in your cycle's example
7. Open a PR against this pack with title `[validated:<your-project>] cycle-<N> doctrine deepening`

The pack accepts new cycles at any time. PRs that don't add a cycle (e.g., bug fixes to existing patterns) use other title prefixes.
