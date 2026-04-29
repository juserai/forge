#!/usr/bin/env bash
# One-shot i18n migration: docs/i18n/README.<lang>.md +
# docs/user-guide/i18n/<skill>-guide.<lang>.md → docs/i18n/<lang>/<file>
#
# Usage: bash scripts/migrate-i18n.sh dry-run | apply

set -euo pipefail

REPO_ROOT="${REPO_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
cd "$REPO_ROOT"

MODE="${1:-dry-run}"
case "$MODE" in
    dry-run|apply) ;;
    *) echo "Usage: $0 dry-run | apply"; exit 1 ;;
esac

LANGS=(de es fr hi ja ko pt-BR ru tr vi zh-CN)

run() {
    if [ "$MODE" = "apply" ]; then
        eval "$@"
    else
        echo "  [dry-run] $*"
    fi
}

echo "=== Phase 1: create language directories ==="
for lang in "${LANGS[@]}"; do
    target="docs/i18n/$lang"
    if [ ! -d "$target" ]; then
        run "mkdir -p '$target'"
    fi
done

echo ""
echo "=== Phase 2: move 11 README translations ==="
for lang in "${LANGS[@]}"; do
    src="docs/i18n/README.$lang.md"
    dst="docs/i18n/$lang/README.md"
    if [ -f "$src" ]; then
        run "git mv '$src' '$dst' 2>/dev/null || mv '$src' '$dst'"
    else
        echo "  [skip] $src not found"
    fi
done

echo ""
echo "=== Phase 3: move 88 skill guide translations ==="
moved=0
for src in docs/user-guide/i18n/*.md; do
    [ -f "$src" ] || continue
    fname="$(basename "$src")"
    # parse <skill>-guide.<lang>.md
    skill_part="${fname%.*.md}"   # block-break-guide
    rest="${fname#"$skill_part."}" # <lang>.md
    lang="${rest%.md}"             # <lang>
    new_fname="$skill_part.md"
    dst="docs/i18n/$lang/$new_fname"
    run "git mv '$src' '$dst' 2>/dev/null || mv '$src' '$dst'"
    moved=$((moved + 1))
done
echo "  ($moved guide files)"

echo ""
echo "=== Phase 4: rewrite main README.md language switcher ==="
for lang in "${LANGS[@]}"; do
    old="docs/i18n/README.$lang.md"
    new="docs/i18n/$lang/README.md"
    run "sed -i 's|$old|$new|g' README.md"
done

echo ""
echo "=== Phase 5: rewrite i18n README depth + sibling links ==="
# Each docs/i18n/<lang>/README.md needs:
#   ../../LICENSE     -> ../../../LICENSE
#   ../../README.md   -> ../../../README.md
#   ../../CLAUDE.md   -> ../../../CLAUDE.md
#   (README.<other>.md) -> (../<other>/README.md)  for sibling switcher
for lang in "${LANGS[@]}"; do
    f="docs/i18n/$lang/README.md"
    [ "$MODE" = "apply" ] && [ ! -f "$f" ] && continue
    [ "$MODE" = "dry-run" ] && [ ! -f "$f" ] && continue

    # Bump depth: ../../X -> ../../../X for LICENSE / README.md / CLAUDE.md
    run "sed -i 's|(\\.\\./\\.\\./LICENSE)|(../../../LICENSE)|g' '$f'"
    run "sed -i 's|(\\.\\./\\.\\./README\\.md)|(../../../README.md)|g' '$f'"
    run "sed -i 's|(\\.\\./\\.\\./CLAUDE\\.md)|(../../../CLAUDE.md)|g' '$f'"

    # Sibling switcher: (README.<other>.md) -> (../<other>/README.md)
    for other in "${LANGS[@]}"; do
        [ "$other" = "$lang" ] && continue
        run "sed -i 's|(README\\.${other}\\.md)|(../${other}/README.md)|g' '$f'"
    done
done

echo ""
echo "=== Phase 6: cleanup empty docs/user-guide/i18n/ ==="
if [ -d "docs/user-guide/i18n" ]; then
    if [ "$MODE" = "apply" ]; then
        # only remove if empty
        if [ -z "$(ls -A docs/user-guide/i18n)" ]; then
            run "rmdir 'docs/user-guide/i18n'"
        else
            echo "  [skip] docs/user-guide/i18n/ not empty:"
            ls docs/user-guide/i18n
        fi
    else
        echo "  [dry-run] would: rmdir docs/user-guide/i18n (if empty)"
    fi
fi

echo ""
echo "=== Done (mode: $MODE) ==="
if [ "$MODE" = "dry-run" ]; then
    echo "Re-run with: bash scripts/migrate-i18n.sh apply"
fi
