# Cycle entry · 2026-05-11 · compass-substrate-ecs

> **Pack-author surface · skip on first read.** First-time adopters: start at [`../SKILL.md`](../SKILL.md) and the pattern docs · this file is for cycle authors authoring the next entry.

**Project**: compass (Solana hackathon · Next.js · TypeScript)
**Operator**: zksoju
**Doctrine level introduced**: 1 (structural isomorphism)
**Net LOC delta**: −1236
**Tests at start / end**: 128/128 → 128/128
**Worked example**: [`examples/compass-cycle-2026-05-11.md`](../examples/compass-cycle-2026-05-11.md)

## Patterns introduced or named

- `domain-ports-live` — the four-folder pattern
- `suffix-as-type` — filename discipline
- `ecs-effect-isomorphism` — three-vocabulary mapping
- `delete-heavy-cycle` — refactor recipe with FAGAN gates
- `single-effect-provide-site` (NAMED · CI-enforcement deferred to cycle 2)

## Operator notes

- ECS≡Effect≡Hexagonal mapping was operator-flagged during Sprint 6 pair-point
- Sprint 4 (CSS theme collapse) didn't ship · `try/catch silent-swallow` was intentional failsafe
- Cycle ran in `/simstim` posture with sprint-boundary HITL
