# Pattern · state ownership matrix

> Discovered cycle 2 (compass-substrate-agentic-2026-05-12 · BB-006 finding). When multiple Effect Services compose, they may share access to Refs and PubSubs. Without explicit ownership, who-writes-what becomes implicit · debug-time landmine. The matrix makes ownership a first-class declaration · CI enforces it.

## The problem the matrix solves

You have three services in `lib/world/`:
- `awareness` · reads weather + activity + population · writes a consolidated state Ref
- `observatory` · reads awareness · displays projections
- `invocation` · publishes commands to a PubSub

Without explicit declaration, these temptations creep in:
- Observatory writes to awareness's state Ref to "patch" a stale projection (now you have two writers)
- Invocation reads its own commandsPubSub to verify what it published (now PubSub is bidirectional · race)
- Awareness publishes to commandsPubSub to "trigger" a follow-up command (now the chain is implicit)

Each individually feels reasonable. Together, they form an unmaintainable web. Erlang's gen_server pattern solved this 35 years ago: one process owns its state · others request via call/cast. Effect Services without explicit ownership recreate the shared-mutable-state problem.

## The matrix

In your system's `SKILL.md` (per [`domain-ports-live`](domain-ports-live.md)):

```markdown
## State ownership matrix

| System | Owns (writes) | Reads |
|---|---|---|
| awareness | awarenessRef · awarenessChanges PubSub | weather (read) · activity (read · events stream) · population (read · spawns stream) |
| observatory | (read-only · NO writes to any Ref/PubSub) | awareness (read · current+changes) · weather (read) |
| invocation | commandsPubSub (publishes only) | (commands consumed by awareness) |
```

Two columns · zero ambiguity:
- **Owns**: this system writes here · no other system may
- **Reads**: this system depends on these surfaces · changes here may affect this system

## CI enforcement (per-system)

For each system that's declared **read-only** in the matrix, fail CI if it ever writes:

```bash
#!/usr/bin/env bash
# scripts/check-state-ownership.sh
set -uo pipefail
WORLD_DIR="lib/world"

OBS_FILES=$(ls "$WORLD_DIR"/observatory.*.ts 2>/dev/null || true)
if [ -n "$OBS_FILES" ]; then
  WRITES=$(grep -lE "Ref\.set|Ref\.update|PubSub\.publish" $OBS_FILES 2>/dev/null | wc -l | tr -d ' ')
  if [ "${WRITES:-0}" != "0" ]; then
    echo "FAIL: observatory.* contains Ref/PubSub writes (matrix declares read-only)"
    exit 1
  fi
fi

echo "OK: state ownership matrix honored"
```

For owners, additional discipline: name your owned Refs/PubSubs in code with a recognizable prefix (`awarenessRef`, `commandsPubSub`) so a future reviewer can grep `Ref.set\|PubSub.publish` and immediately see WHO is writing to WHAT.

## When to use the matrix

- Three or more Services share a domain (any pair is fine without · just name your Refs locally)
- One service is read-only (the projection · the aggregator · the display layer)
- Cross-system events flow through PubSubs that more than one service might be tempted to publish to
- The system map fits in your head today · you're trying to keep it that way as the codebase grows

## When the matrix isn't worth it

- Single-service domain (no sharing · no ambiguity)
- All services are independent (no shared Refs · no shared PubSubs)
- The codebase is < 1k LOC of substrate · the cognitive overhead of the matrix exceeds the cognitive overhead of the code

## Variations

### Read-only-by-construction (no need for matrix enforcement)

If your projection service genuinely has no Ref / PubSub access AT ALL, the read-only declaration is structural · CI gate is redundant. The matrix is then documentation only. This is the ideal · pursue it when feasible.

### Multiple owners with pubsub for coordination

If two systems legitimately co-own a Ref (e.g., `awarenessRef` updated by both `awareness` and a future `external-event-importer`), promote the Ref to a PubSub-coordinated single-owner pattern: one owner, others publish updates via PubSub, owner consumes and applies. Matrix becomes:

| awareness | awarenessRef · awarenessChanges PubSub | (consumes) external-event-importer's updateRequests PubSub |
| external-event-importer | updateRequests PubSub | (none) |

## Anti-patterns

- ❌ Documenting the matrix in a comment buried in a .ts file (must be in SKILL.md · CI parses the SKILL location)
- ❌ Allowing a "temporary" exception (the exception becomes permanent · if you need to write, declare ownership)
- ❌ Putting Ref names in the matrix without `Ref.` prefix in code (grep-enforcement breaks · keep names searchable)

## Cross-references

- [`single-effect-provide-site`](single-effect-provide-site.md) — the runtime where these Services compose
- [`lift-pattern-template`](lift-pattern-template.md) — adding new systems honors the matrix
- Worked example: [`examples/compass-cycle-2026-05-12.md`](../examples/compass-cycle-2026-05-12.md) §S4 lib/world/SKILL.md state ownership matrix
