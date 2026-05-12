# Pack memory · what each cycle taught

> One line per cycle · ≤200 chars · the pack's auto-memory analog. Lineage in [`doctrine-evolution.md`](doctrine-evolution.md). Worked examples in `examples/`.

## Cycles

- [compass-substrate-ecs-2026-05-11](examples/compass-cycle-2026-05-11.md) — *structural isomorphism · 3 vocabularies converge on 4 folders · −1236 LOC · 128/128 tests*
- [compass-substrate-agentic-translation-adoption-2026-05-12](examples/compass-cycle-2026-05-12.md) — *adopt-don't-invent · 5 hand-ports + verify-fence brand · 3 upstream tracking issues · +5 CI gates · 130/130 tests*

## Pattern provenance (which cycle introduced each)

- `domain-ports-live` — cycle 1
- `suffix-as-type` — cycle 1
- `ecs-effect-isomorphism` — cycle 1
- `delete-heavy-cycle` — cycle 1
- `single-effect-provide-site` — cycle 1 (NAMED) · cycle 2 (CI-enforced + cross-layer composition)
- `hand-port-with-drift` — cycle 2
- `doc-only-then-runtime` — cycle 2
- `lift-pattern-template` — cycle 2
- `state-ownership-matrix` — cycle 2

## Lessons that didn't become patterns (yet)

These came up in reviews · weren't strong enough to promote to canonical pattern · captured here so the next cycle can promote OR refute:

- *Per-package CLAUDE.md is enormous ROI for ~150 LOC* (cycle 1) — not promoted because it's outside this pack's scope (it's the loa-framework operator's territory)
- *FAGAN-safe wrap-not-rewrite is the right move when test count says behavior is locked* (cycle 1) — captured in `delete-heavy-cycle.md` already
- *Vitest workspace test discovery split is a recurring papercut* (cycle 2) — not promoted · vitest-config-shape isn't substrate doctrine
- *Plain JSON import vs `with { type: "json" }` is TS-version-dependent* (cycle 2) — captured in `hand-port-with-drift.md` SDD-corrected example · not its own pattern
- *Flatline degraded mode #759 needs 2-agent fallback* (cycle 2) — Loa-framework concern · not pack territory

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
