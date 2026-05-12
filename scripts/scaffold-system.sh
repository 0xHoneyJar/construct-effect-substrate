#!/usr/bin/env bash
# scaffold-system.sh — operationalized 5-command lift-pattern template
#
# Per patterns/lift-pattern-template.md. Run from your project root to
# scaffold a new Effect Service following the canonical 4-file trio.
#
# Usage:
#   scripts/scaffold-system.sh awareness lib/world           # lift Awareness in lib/world/
#   scripts/scaffold-system.sh weather lib                   # lift Weather in lib/
#   scripts/scaffold-system.sh price-feed apps/dashboard/lib # lift PriceFeed in apps/.../lib/
#
# The script:
#   1. Validates name + dir
#   2. Authors port + live + mock + test files in <dir>/<name>.{port,live,mock,test}.ts
#   3. Prints the manual amend you need to make to your runtime.ts AppLayer
#   4. Reminds you to add an example component
#
# It does NOT run typecheck/test/CI · those are your verification step.

set -euo pipefail

usage() {
  echo "Usage: $0 <name> <dir>"
  echo "  name: kebab-case system name (e.g. 'awareness', 'price-feed')"
  echo "  dir: target directory (e.g. 'lib/world', 'lib', 'apps/dashboard/lib')"
  exit 2
}

NAME="${1:-}"
DIR="${2:-}"

[ -z "$NAME" ] && usage
[ -z "$DIR" ] && usage

# Validate name shape
if ! [[ "$NAME" =~ ^[a-z][a-z0-9-]*$ ]]; then
  echo "FAIL: name must be kebab-case (lowercase + digits + hyphens, starting with letter)"
  exit 1
fi

# Pascal case for Service Tag (e.g., price-feed → PriceFeed)
PASCAL=$(echo "$NAME" | awk -F- '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2);}1' OFS='')

# Camel case for variable name (e.g., price-feed → priceFeed)
CAMEL=$(echo "$NAME" | awk -F- '{for(i=2;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2); print}' OFS='')

# Detect project name from package.json for the Service Tag namespace.
# Wrap in pipefail-safe block: missing/empty package.json must fall through
# to the "${PROJECT:-app}" default · NOT die silently (BB-PR1-002 fix).
detect_project() {
  set +o pipefail
  if [ -f package.json ]; then
    grep -E '"name"' package.json 2>/dev/null \
      | head -1 \
      | sed -E 's/.*"name": *"([^"]+)".*/\1/' \
      | sed 's/[^a-zA-Z0-9-]//g'
  fi
  set -o pipefail
}
PROJECT="${PROJECT:-$(detect_project)}"
PROJECT="${PROJECT:-app}"

mkdir -p "$DIR/__tests__"

# Compute the import path for the user's runtime.ts amend instructions.
# Strip a leading `lib/` (since most projects use `@/lib/...` alias-mapped) ·
# fall back to project-relative path if the dir doesn't start with lib/.
# (BB-PR1-002 fix · was generating doubled-slash paths like "@//tmp/...".)
case "$DIR" in
  lib/*)
    IMPORT_PATH="@/${DIR}/${NAME}.live"
    ;;
  lib)
    IMPORT_PATH="@/lib/${NAME}.live"
    ;;
  *)
    # Project doesn't use the lib/ convention · emit a relative-from-root path
    # the user must adjust to their tsconfig paths config.
    IMPORT_PATH="${DIR}/${NAME}.live  // TODO: adjust to your tsconfig paths alias"
    ;;
esac

# Refuse to overwrite
for suffix in port live mock; do
  TARGET="$DIR/${NAME}.${suffix}.ts"
  if [ -e "$TARGET" ]; then
    echo "FAIL: $TARGET already exists · refusing to overwrite"
    exit 1
  fi
done
TEST_TARGET="$DIR/__tests__/${NAME}.test.ts"
if [ -e "$TEST_TARGET" ]; then
  echo "FAIL: $TEST_TARGET already exists"
  exit 1
fi

# === port.ts ===
cat > "$DIR/${NAME}.port.ts" <<EOF
import { Context, Effect, Stream } from "effect";

export interface ${PASCAL}State {
  // TODO: define state shape
  readonly placeholder: string;
}

export interface ${PASCAL}Event {
  // TODO: define event shape
  readonly _tag: string;
}

export interface ${PASCAL}Command {
  // TODO: define command shape
  readonly _tag: string;
}

export class ${PASCAL} extends Context.Tag("${PROJECT}/${PASCAL}")<
  ${PASCAL},
  {
    readonly current: Effect.Effect<${PASCAL}State>;
    readonly events: Stream.Stream<${PASCAL}Event>;
    readonly invoke: (cmd: ${PASCAL}Command) => Effect.Effect<void>;
  }
>() {}
EOF

# === live.ts ===
cat > "$DIR/${NAME}.live.ts" <<EOF
import { Effect, Layer, Ref, Stream } from "effect";
import { ${PASCAL}, type ${PASCAL}State, type ${PASCAL}Command, type ${PASCAL}Event } from "./${NAME}.port";

const initial: ${PASCAL}State = {
  placeholder: "implement me",
};

export const ${PASCAL}Live = Layer.effect(
  ${PASCAL},
  Effect.gen(function* () {
    const ref = yield* Ref.make<${PASCAL}State>(initial);
    return ${PASCAL}.of({
      current: Ref.get(ref),
      events: Stream.empty as Stream.Stream<${PASCAL}Event>,
      invoke: (_cmd: ${PASCAL}Command) =>
        Ref.update(ref, (s) => s),
    });
  }),
);
EOF

# === mock.ts ===
cat > "$DIR/${NAME}.mock.ts" <<EOF
import { Effect, Layer, Ref, Stream } from "effect";
import { ${PASCAL}, type ${PASCAL}State, type ${PASCAL}Command, type ${PASCAL}Event } from "./${NAME}.port";

export const ${PASCAL}Mock = (seed?: ${PASCAL}State) => {
  const initial: ${PASCAL}State = seed ?? { placeholder: "mock" };
  return Layer.effect(
    ${PASCAL},
    Effect.gen(function* () {
      const ref = yield* Ref.make<${PASCAL}State>(initial);
      return ${PASCAL}.of({
        current: Ref.get(ref),
        events: Stream.empty as Stream.Stream<${PASCAL}Event>,
        invoke: (_cmd: ${PASCAL}Command) =>
          Ref.update(ref, (s) => s),
      });
    }),
  );
};
EOF

# === test.ts ===
cat > "$TEST_TARGET" <<EOF
import { describe, it, expect } from "vitest";
import { Effect } from "effect";
import { ${PASCAL} } from "../${NAME}.port";
import { ${PASCAL}Mock } from "../${NAME}.mock";

describe("${PASCAL}Live lift", () => {
  it("current returns seeded state", async () => {
    const seed = { placeholder: "test-seed" };
    const program = Effect.gen(function* () {
      const s = yield* ${PASCAL};
      return yield* s.current;
    });
    const result = await Effect.runPromise(Effect.provide(program, ${PASCAL}Mock(seed)));
    expect(result.placeholder).toBe("test-seed");
  });
});
EOF

cat <<EOF
✓ Scaffolded ${PASCAL} lift in $DIR

Files created:
  $DIR/${NAME}.port.ts    (Context.Tag · 3 standard primitives)
  $DIR/${NAME}.live.ts    (Layer.effect with placeholder Ref)
  $DIR/${NAME}.mock.ts    (per-instance test substrate)
  $DIR/__tests__/${NAME}.test.ts  (smoke test)

Next steps (manual):
  1. Edit $DIR/${NAME}.port.ts · define ${PASCAL}State / Event / Command shapes
  2. Edit $DIR/${NAME}.live.ts · wire to your existing impl (or build new)
  3. Add to lib/runtime/runtime.ts AppLayer:
       import { ${PASCAL}Live } from "${IMPORT_PATH}";
       // append to Layer.mergeAll(...) arg list
  4. Optionally: cp app/_components/awareness-example.tsx app/_components/${NAME}-example.tsx
     and sed-rename Awareness → ${PASCAL}, awareness → ${CAMEL}
  5. Run: pnpm typecheck && pnpm test && bash scripts/check-single-runtime.sh

The 5th step is your verification gate · do not skip.
EOF
