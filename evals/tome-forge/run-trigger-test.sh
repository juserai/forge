#!/usr/bin/env bash
# tome-forge trigger test
# Validates that the skill is properly registered and structurally sound

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "=== tome-forge Trigger Test ==="
echo ""

# Test 1: SKILL.md exists and has correct frontmatter
echo "[1/5] Checking SKILL.md..."
SKILL_FILE="$PROJECT_ROOT/skills/tome-forge/SKILL.md"
if [ ! -f "$SKILL_FILE" ]; then
  echo "  FAIL: $SKILL_FILE not found"
  exit 1
fi
if ! grep -q "^name: tome-forge" "$SKILL_FILE"; then
  echo "  FAIL: frontmatter missing 'name: tome-forge'"
  exit 1
fi
echo "  PASS"

# Test 2: References exist
echo "[2/5] Checking references..."
for ref in operations schema-template; do
  REF_FILE="$PROJECT_ROOT/skills/tome-forge/references/$ref.md"
  if [ ! -f "$REF_FILE" ]; then
    echo "  FAIL: $REF_FILE not found"
    exit 1
  fi
done
echo "  PASS"

# Test 3: Marketplace registration
echo "[3/5] Checking marketplace.json..."
MARKETPLACE="$PROJECT_ROOT/.claude-plugin/marketplace.json"
if ! grep -q "tome-forge" "$MARKETPLACE"; then
  echo "  FAIL: tome-forge not found in marketplace.json"
  exit 1
fi
echo "  PASS"

# Test 4: OpenClaw platform adaptation
echo "[4/5] Checking OpenClaw adaptation..."
OC_SKILL="$PROJECT_ROOT/platforms/openclaw/tome-forge/SKILL.md"
if [ ! -f "$OC_SKILL" ]; then
  echo "  FAIL: $OC_SKILL not found"
  exit 1
fi
echo "  PASS"

# Test 5: OpenClaw references exist
echo "[5/5] Checking OpenClaw references..."
for ref in operations schema-template; do
  REF_FILE="$PROJECT_ROOT/platforms/openclaw/tome-forge/references/$ref.md"
  if [ ! -f "$REF_FILE" ]; then
    echo "  FAIL: $REF_FILE not found"
    exit 1
  fi
done
echo "  PASS"

echo ""
echo "=== All 5 checks passed ==="
