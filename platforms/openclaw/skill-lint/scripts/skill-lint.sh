#!/usr/bin/env bash
# Skill Lint — Structure checker for Claude Code plugin projects
#
# Usage: skill-lint.sh [plugin-root-path]
# Output: JSON { "errors": [...], "warnings": [...], "passed": [...] }
#
# Core rules (S01-S08) always run for any Claude Code plugin.
# Extended rules (S09-S17) only run when .skill-lint.json exists in the target directory.

set -euo pipefail

PLUGIN_ROOT="${1:-.}"
PLUGIN_ROOT="$(cd "$PLUGIN_ROOT" && pwd)"

ERRORS=()
WARNINGS=()
PASSED=()

add_error()   { ERRORS+=("$1"); }
add_warning() { WARNINGS+=("$1"); }
add_passed()  { PASSED+=("$1"); }

# --- Load optional .skill-lint.json config ---
CONFIG_FILE="$PLUGIN_ROOT/.skill-lint.json"
CFG_NAMING_PATTERN=""
CFG_CATEGORY_VALUES=""
CFG_REQUIRE_TRIGGER_TEST=""
CFG_REQUIRE_GUIDE=""
CFG_REQUIRE_DESIGN_DOC=""
CFG_PLATFORMS=""
CFG_I18N_DIR=""
CFG_REQUIRE_I18N_GUIDE=""
CFG_REQUIRE_PERMISSIONS=""
CFG_VERIFY_INTEGRITY=""
CFG_REQUIRE_AGENT_MODEL=""
CFG_NO_DANGEROUS_PATTERNS=""
CFG_VERIFY_PLATFORM_SUBDIRS=""
CFG_VERIFY_I18N_STRUCTURE=""
CFG_VERIFY_CROSS_SKILL_CATEGORY=""
CFG_VERIFY_VERSION_LOCKSTEP=""
CFG_VERIFY_HELP_CARD_VERSION_LINE=""
CFG_VERIFY_CHANGELOG_ENTRY=""
CFG_VERIFY_DOCS_VERSION_DRIFT=""
CFG_VERIFY_ARCHIVED_SPEC_MERGE=""
CFG_VERIFY_HELP_CARD_FLAG_COVERAGE=""
CFG_VERIFY_LANG_FLAG_REQUIRED=""
CFG_REQUIRE_HELP_SECTION=""
# Path config (see rules.md): fallback to legacy layout if keys absent.
# i18n is single-track: <i18n-dir>/<lang>/{README.md, <skill>-guide.md}
CFG_USER_GUIDE_DIR="docs/guide"
CFG_DESIGN_DIR="docs/plans"
CFG_PROTECT_CROSS_NAMESPACE=""

if [ -f "$CONFIG_FILE" ]; then
    # Parse config using python
    eval "$(python3 -c "
import json, sys, shlex
with open('$CONFIG_FILE') as f:
    cfg = json.load(f)
rules = cfg.get('rules', {})
if 'naming-pattern' in rules:
    print(f'CFG_NAMING_PATTERN={shlex.quote(rules[\"naming-pattern\"])}')
if 'category-values' in rules:
    print(f'CFG_CATEGORY_VALUES={shlex.quote(\"|\".join(rules[\"category-values\"]))}')
if rules.get('require-trigger-test'):
    print('CFG_REQUIRE_TRIGGER_TEST=1')
if rules.get('require-guide'):
    print('CFG_REQUIRE_GUIDE=1')
if rules.get('require-design-doc'):
    print('CFG_REQUIRE_DESIGN_DOC=1')
if 'platforms' in rules and rules['platforms']:
    print(f'CFG_PLATFORMS={shlex.quote(\" \".join(rules[\"platforms\"]))}')
if 'i18n-dir' in rules:
    print(f'CFG_I18N_DIR={shlex.quote(rules[\"i18n-dir\"])}')
if rules.get('require-i18n-guide'):
    print('CFG_REQUIRE_I18N_GUIDE=1')
if rules.get('require-permissions-declaration'):
    print('CFG_REQUIRE_PERMISSIONS=1')
if rules.get('verify-integrity-hash'):
    print('CFG_VERIFY_INTEGRITY=1')
if rules.get('require-agent-model'):
    print('CFG_REQUIRE_AGENT_MODEL=1')
if rules.get('no-dangerous-patterns'):
    print('CFG_NO_DANGEROUS_PATTERNS=1')
if rules.get('verify-platform-subdirs'):
    print('CFG_VERIFY_PLATFORM_SUBDIRS=1')
if rules.get('verify-i18n-structure-parity'):
    print('CFG_VERIFY_I18N_STRUCTURE=1')
if rules.get('verify-cross-skill-category-claim'):
    print('CFG_VERIFY_CROSS_SKILL_CATEGORY=1')
if rules.get('verify-version-lockstep'):
    print('CFG_VERIFY_VERSION_LOCKSTEP=1')
if rules.get('verify-help-card-version-line'):
    print('CFG_VERIFY_HELP_CARD_VERSION_LINE=1')
if rules.get('verify-changelog-entry'):
    print('CFG_VERIFY_CHANGELOG_ENTRY=1')
docs_drift_rule = rules.get('verify-docs-version-drift')
if docs_drift_rule is True or docs_drift_rule == 'error':
    print('CFG_VERIFY_DOCS_VERSION_DRIFT=error')
elif docs_drift_rule == 'warn':
    print('CFG_VERIFY_DOCS_VERSION_DRIFT=warn')
archived_merge_rule = rules.get('verify-archived-spec-merge')
if archived_merge_rule is True or archived_merge_rule == 'error':
    print('CFG_VERIFY_ARCHIVED_SPEC_MERGE=error')
elif archived_merge_rule == 'warn':
    print('CFG_VERIFY_ARCHIVED_SPEC_MERGE=warn')
help_flag_coverage_rule = rules.get('verify-help-card-flag-coverage')
if help_flag_coverage_rule is True or help_flag_coverage_rule == 'error':
    print('CFG_VERIFY_HELP_CARD_FLAG_COVERAGE=error')
elif help_flag_coverage_rule == 'warn':
    print('CFG_VERIFY_HELP_CARD_FLAG_COVERAGE=warn')
lang_flag_rule = rules.get('verify-lang-flag-required')
if lang_flag_rule is True or lang_flag_rule == 'error':
    print('CFG_VERIFY_LANG_FLAG_REQUIRED=error')
elif lang_flag_rule == 'warn':
    print('CFG_VERIFY_LANG_FLAG_REQUIRED=warn')
# require-help-section: tri-value 'warn' / 'error' / 'off' (also accepts true/false for back-compat)
help_rule = rules.get('require-help-section')
if help_rule is True or help_rule == 'error':
    print('CFG_REQUIRE_HELP_SECTION=error')
elif help_rule == 'warn':
    print('CFG_REQUIRE_HELP_SECTION=warn')
# Path config — single source of truth; legacy defaults applied in shell if absent.
if 'user-guide-dir' in rules:
    print(f'CFG_USER_GUIDE_DIR={shlex.quote(rules[\"user-guide-dir\"])}')
if 'design-dir' in rules:
    print(f'CFG_DESIGN_DIR={shlex.quote(rules[\"design-dir\"])}')
if rules.get('protect-cross-namespace'):
    print('CFG_PROTECT_CROSS_NAMESPACE=1')
" 2>/dev/null)" || true
fi

# ============================================================
# Core Rules (S01-S08) — always run
# ============================================================

# --- S01: plugin.json existence ---
if [ -f "$PLUGIN_ROOT/plugin.json" ]; then
    add_passed "S01: plugin.json exists at root"
else
    add_error "S01: plugin.json missing at root"
fi

if [ -f "$PLUGIN_ROOT/.claude-plugin/plugin.json" ]; then
    add_passed "S01: .claude-plugin/plugin.json exists"
else
    add_error "S01: .claude-plugin/plugin.json missing"
fi

# --- S02: marketplace.json existence ---
if [ -f "$PLUGIN_ROOT/.claude-plugin/marketplace.json" ]; then
    add_passed "S02: .claude-plugin/marketplace.json exists"
else
    add_error "S02: .claude-plugin/marketplace.json missing"
fi

# --- Discover skills ---
SKILLS_DIR="$PLUGIN_ROOT/skills"
if [ ! -d "$SKILLS_DIR" ]; then
    add_error "S03: skills/ directory not found"
    # Output and exit early
    printf '{"errors": %s, "warnings": %s, "passed": %s}\n' \
        "$(printf '%s\n' "${ERRORS[@]}" | python -c 'import sys,json; print(json.dumps([l.strip() for l in sys.stdin]))')" \
        "$(printf '%s\n' "${WARNINGS[@]:-}" | python -c 'import sys,json; print(json.dumps([l.strip() for l in sys.stdin if l.strip()]))')" \
        "$(printf '%s\n' "${PASSED[@]:-}" | python -c 'import sys,json; print(json.dumps([l.strip() for l in sys.stdin if l.strip()]))')"
    exit 0
fi

# Enumerate skill directories
SKILL_NAMES=()
for skill_dir in "$SKILLS_DIR"/*/; do
    [ -d "$skill_dir" ] || continue
    skill_name="$(basename "$skill_dir")"
    SKILL_NAMES+=("$skill_name")
done

if [ ${#SKILL_NAMES[@]} -eq 0 ]; then
    add_warning "No skill directories found under skills/"
fi

for skill_name in "${SKILL_NAMES[@]}"; do
    skill_md="$SKILLS_DIR/$skill_name/SKILL.md"

    # --- S03: SKILL.md existence ---
    if [ -f "$skill_md" ]; then
        add_passed "S03: skills/$skill_name/SKILL.md exists"
    else
        add_error "S03: skills/$skill_name/SKILL.md missing"
        continue
    fi

    # --- S04: Frontmatter required fields ---
    frontmatter=$(sed -n '/^---$/,/^---$/p' "$skill_md" | sed '1d;$d')

    if echo "$frontmatter" | grep -qE '^name:'; then
        add_passed "S04: skills/$skill_name/SKILL.md has 'name' field"
    else
        add_error "S04: skills/$skill_name/SKILL.md missing required field 'name'"
    fi

    if echo "$frontmatter" | grep -qE '^description:'; then
        add_passed "S04: skills/$skill_name/SKILL.md has 'description' field"
    else
        add_error "S04: skills/$skill_name/SKILL.md missing required field 'description'"
    fi

    # --- S06: marketplace.json entry ---
    if [ -f "$PLUGIN_ROOT/.claude-plugin/marketplace.json" ]; then
        if python -c "
import json, sys
with open('$PLUGIN_ROOT/.claude-plugin/marketplace.json') as f:
    data = json.load(f)
plugins = data.get('plugins', [])
names = [p.get('name', '') for p in plugins]
if '$skill_name' in names:
    sys.exit(0)
for p in plugins:
    skills = p.get('skills', [])
    for s in skills:
        if s.rstrip('/').endswith('$skill_name'):
            sys.exit(0)
sys.exit(1)
" 2>/dev/null; then
            add_passed "S06: '$skill_name' listed in marketplace.json"
        else
            add_warning "S06: '$skill_name' not listed in .claude-plugin/marketplace.json"
        fi
    fi

    # --- S07: References link check ---
    # Match `references/X.md` only when NOT preceded by `/` — i.e., relative reference
    # like `references/foo.md`, NOT cross-skill absolute path like
    # `skills/tome-forge/references/X.md`.
    ref_mentions=$(grep -oE '(^|[^/])references/[a-zA-Z0-9_-]+\.md' "$skill_md" 2>/dev/null \
        | sed -E 's/^[^r]//' || true)
    if [ -n "$ref_mentions" ]; then
        while IFS= read -r ref_path; do
            full_path="$SKILLS_DIR/$skill_name/$ref_path"
            if [ -f "$full_path" ]; then
                add_passed "S07: skills/$skill_name/$ref_path exists"
            else
                add_error "S07: skills/$skill_name/$ref_path referenced in SKILL.md but file missing"
            fi
        done <<< "$ref_mentions"
    fi

    # --- S08: Evals directory ---
    if [ -f "$PLUGIN_ROOT/evals/$skill_name/scenarios.md" ]; then
        add_passed "S08: evals/$skill_name/scenarios.md exists"
    else
        add_warning "S08: evals/$skill_name/scenarios.md missing — no evaluation scenarios"
    fi

    # ============================================================
    # Extended Rules (S09-S16) — only when .skill-lint.json exists
    # ============================================================

    # --- S09: Naming convention ---
    if [ -n "$CFG_NAMING_PATTERN" ]; then
        if echo "$skill_name" | grep -qE "$CFG_NAMING_PATTERN"; then
            add_passed "S09: '$skill_name' matches naming pattern ($CFG_NAMING_PATTERN)"
        else
            add_warning "S09: '$skill_name' does not match naming pattern ($CFG_NAMING_PATTERN)"
        fi
    fi

    # --- S10: Category field ---
    if [ -n "$CFG_CATEGORY_VALUES" ]; then
        category_value=$(echo "$frontmatter" | grep -E '^\s*category:' | sed 's/.*category:\s*//' | tr -d '[:space:]' || true)
        if echo "$category_value" | grep -qE "^($CFG_CATEGORY_VALUES)$"; then
            add_passed "S10: skills/$skill_name/SKILL.md has valid 'category' ($category_value)"
        elif [ -z "$category_value" ]; then
            add_error "S10: skills/$skill_name/SKILL.md missing 'category' (expected: $CFG_CATEGORY_VALUES)"
        else
            add_error "S10: skills/$skill_name/SKILL.md invalid category '$category_value' (expected: $CFG_CATEGORY_VALUES)"
        fi
    fi

    # --- S11: Trigger test script ---
    if [ -n "$CFG_REQUIRE_TRIGGER_TEST" ]; then
        if [ -f "$PLUGIN_ROOT/evals/$skill_name/run-trigger-test.sh" ]; then
            add_passed "S11: evals/$skill_name/run-trigger-test.sh exists"
        else
            add_warning "S11: evals/$skill_name/run-trigger-test.sh missing"
        fi
    fi

    # --- S12: User guide ---
    if [ -n "$CFG_REQUIRE_GUIDE" ]; then
        if [ -f "$PLUGIN_ROOT/$CFG_USER_GUIDE_DIR/$skill_name-guide.md" ]; then
            add_passed "S12: $CFG_USER_GUIDE_DIR/$skill_name-guide.md exists"
        else
            add_warning "S12: $CFG_USER_GUIDE_DIR/$skill_name-guide.md missing"
        fi
    fi

    # --- S13: Design document (recursive find — typical layout <design-dir>/<category>/<skill>-design.md) ---
    if [ -n "$CFG_REQUIRE_DESIGN_DOC" ]; then
        design_match=""
        if [ -d "$PLUGIN_ROOT/$CFG_DESIGN_DIR" ]; then
            design_match=$(find "$PLUGIN_ROOT/$CFG_DESIGN_DIR" -name "$skill_name-design.md" -type f 2>/dev/null | head -1)
        fi
        if [ -n "$design_match" ]; then
            add_passed "S13: ${design_match#"$PLUGIN_ROOT/"} exists"
        else
            add_warning "S13: $CFG_DESIGN_DIR/<category>/$skill_name-design.md missing"
        fi
    fi

    # --- S14: Platform adaptations ---
    if [ -n "$CFG_PLATFORMS" ]; then
        for platform in $CFG_PLATFORMS; do
            plat_skill="$PLUGIN_ROOT/platforms/$platform/$skill_name/SKILL.md"
            if [ -f "$plat_skill" ]; then
                add_passed "S14: platforms/$platform/$skill_name/SKILL.md exists"
            else
                add_warning "S14: platforms/$platform/$skill_name/SKILL.md missing"
            fi
            # Check references sync
            if [ -d "$PLUGIN_ROOT/skills/$skill_name/references" ] && [ -f "$plat_skill" ]; then
                for cc_ref in "$PLUGIN_ROOT/skills/$skill_name/references/"*.md; do
                    [ -f "$cc_ref" ] || continue
                    ref_basename="$(basename "$cc_ref")"
                    plat_ref="$PLUGIN_ROOT/platforms/$platform/$skill_name/references/$ref_basename"
                    if [ -f "$plat_ref" ]; then
                        add_passed "S14: platforms/$platform/$skill_name/references/$ref_basename exists"
                    else
                        add_warning "S14: platforms/$platform/$skill_name/references/$ref_basename missing"
                    fi
                done
            fi
        done
    fi

    # --- S15: i18n README coverage (single-track <i18n-dir>/<lang>/README.md) ---
    if [ -n "$CFG_I18N_DIR" ]; then
        i18n_path="$PLUGIN_ROOT/$CFG_I18N_DIR"
        if [ -d "$i18n_path" ]; then
            for lang_dir in "$i18n_path"/*/; do
                [ -d "$lang_dir" ] || continue
                i18n_readme="$lang_dir/README.md"
                [ -f "$i18n_readme" ] || continue
                lang="$(basename "$lang_dir")"
                if grep -q "$skill_name" "$i18n_readme" 2>/dev/null; then
                    add_passed "S15: '$skill_name' listed in $lang/README.md"
                else
                    add_warning "S15: '$skill_name' not found in $CFG_I18N_DIR/$lang/README.md"
                fi
            done
        fi
    fi

    # --- S16: i18n guide coverage (single-track <i18n-dir>/<lang>/<skill>-guide.md) ---
    if [ -n "$CFG_REQUIRE_I18N_GUIDE" ] && [ -n "$CFG_I18N_DIR" ]; then
        i18n_path="$PLUGIN_ROOT/$CFG_I18N_DIR"
        if [ -d "$i18n_path" ]; then
            for lang_dir in "$i18n_path"/*/; do
                [ -d "$lang_dir" ] || continue
                lang="$(basename "$lang_dir")"
                guide_i18n_file="$lang_dir/$skill_name-guide.md"
                if [ -f "$guide_i18n_file" ]; then
                    add_passed "S16: $CFG_I18N_DIR/$lang/$skill_name-guide.md exists"
                else
                    add_warning "S16: $CFG_I18N_DIR/$lang/$skill_name-guide.md missing"
                fi
            done
        fi
    fi
done

# --- S17: legacy i18n path guard ---
# After single-track migration, <user-guide-dir>/i18n/ should not contain any .md files.
# Any leftover signals an incomplete or reverted migration.
if [ -n "$CFG_REQUIRE_I18N_GUIDE" ] \
    && [ -d "$PLUGIN_ROOT/$CFG_USER_GUIDE_DIR/i18n" ]; then
    wrong_count=$(find "$PLUGIN_ROOT/$CFG_USER_GUIDE_DIR/i18n" -type f -name "*.md" 2>/dev/null | wc -l)
    if [ "$wrong_count" -gt 0 ]; then
        add_error "S17: $CFG_USER_GUIDE_DIR/i18n/ contains $wrong_count file(s) — i18n guides moved to $CFG_I18N_DIR/<lang>/<skill>-guide.md"
    fi
fi

# --- S18: permissions declaration ---
if [ -n "$CFG_REQUIRE_PERMISSIONS" ]; then
    s18_fail=0
    for skill_md in "$PLUGIN_ROOT"/skills/*/SKILL.md; do
        [ -f "$skill_md" ] || continue
        skill_name="$(basename "$(dirname "$skill_md")")"
        if ! head -30 "$skill_md" | grep -q "permissions:"; then
            add_error "S18: $skill_name/SKILL.md missing metadata.permissions declaration"
            s18_fail=1
        fi
    done
    [ "$s18_fail" -eq 0 ] && add_passed "S18: All skills declare metadata.permissions"
fi

# --- S19: integrity hash verification ---
if [ -n "$CFG_VERIFY_INTEGRITY" ] && [ -f "$PLUGIN_ROOT/.claude-plugin/marketplace.json" ]; then
    s19_fail=0
    for skill_md in "$PLUGIN_ROOT"/skills/*/SKILL.md; do
        [ -f "$skill_md" ] || continue
        skill_name="$(basename "$(dirname "$skill_md")")"
        skill_rel="./skills/$skill_name"
        expected_hash=$(python -c "
import json
with open('$PLUGIN_ROOT/.claude-plugin/marketplace.json') as f:
    data = json.load(f)
target = '$skill_name'
target_path = '$skill_rel'
for p in data.get('plugins', []):
    # Match either legacy layout (source='./' + skills=['./skills/<name>'])
    # or per-skill source layout (source='./skills/<name>' + skills=['./']).
    if target_path in p.get('skills', []):
        print(p.get('integrity', {}).get('skill-md-sha256', ''))
        break
    if p.get('source', '').rstrip('/').endswith('/' + target) and p.get('name') == target:
        print(p.get('integrity', {}).get('skill-md-sha256', ''))
        break
" 2>/dev/null)
        if [ -z "$expected_hash" ]; then
            add_warning "S19: $skill_name missing integrity hash in marketplace.json"
            continue
        fi
        actual_hash=$(sha256sum "$skill_md" | cut -d' ' -f1)
        if [ "$expected_hash" != "$actual_hash" ]; then
            add_error "S19: $skill_name SKILL.md hash mismatch (expected: ${expected_hash:0:12}... got: ${actual_hash:0:12}...)"
            s19_fail=1
        fi
    done
    [ "$s19_fail" -eq 0 ] && add_passed "S19: All integrity hashes match"
fi

# --- S25: require-help-section (user-invokable skills must carry `## Help`) ---
# Tri-value: 'error' → add_error, 'warn' → add_warning, empty → skip.
# Note: S24 is already taken by the cross-skill-category-claim rule below.
if [ -n "$CFG_REQUIRE_HELP_SECTION" ]; then
    s25_fail=0
    # Report helper resolves tri-value to the correct add_* function.
    _s25_report() {
        local severity="$1" msg="$2"
        case "$severity" in
            error) add_error "$msg"; s25_fail=1 ;;
            warn)  add_warning "$msg" ;;
        esac
    }
    for skill_md in "$PLUGIN_ROOT"/skills/*/SKILL.md; do
        [ -f "$skill_md" ] || continue
        skill_name="$(basename "$(dirname "$skill_md")")"
        # 1) Must contain `## Help` heading (standalone, not `## Help Text` variants)
        if ! grep -qE '^## Help[[:space:]]*$' "$skill_md"; then
            _s25_report "$CFG_REQUIRE_HELP_SECTION" "S25: $skill_name SKILL.md missing '## Help' section"
            continue
        fi
        # 2) Must mention both `help` and `--help` tokens somewhere in the file (literal, in backticks)
        if ! grep -q '`help`' "$skill_md"; then
            _s25_report "$CFG_REQUIRE_HELP_SECTION" "S25: $skill_name SKILL.md Help section missing \`help\` token"
            continue
        fi
        if ! grep -q '`--help`' "$skill_md"; then
            _s25_report "$CFG_REQUIRE_HELP_SECTION" "S25: $skill_name SKILL.md Help section missing \`--help\` token"
            continue
        fi
    done
    [ "$s25_fail" -eq 0 ] && add_passed "S25: All skills declare '## Help' section with required tokens"
fi

# --- S26: cross-namespace protection in <design-dir>/ ---
# Any file in $CFG_DESIGN_DIR named cross-<token>-design.md must NOT shadow an existing skill
# named <token>. Preserves the 'cross-' prefix as a reserved namespace for horizontal design docs
# without restricting skill naming itself.
if [ -n "$CFG_PROTECT_CROSS_NAMESPACE" ] && [ -d "$PLUGIN_ROOT/$CFG_DESIGN_DIR" ]; then
    s26_fail=0
    for cross_file in "$PLUGIN_ROOT/$CFG_DESIGN_DIR"/cross-*.md; do
        [ -f "$cross_file" ] || continue
        # Strip `cross-` prefix and `-design.md` suffix (both optional; prefix required)
        token=$(basename "$cross_file")
        token="${token#cross-}"
        token="${token%-design.md}"
        token="${token%.md}"
        if [ -d "$PLUGIN_ROOT/skills/$token" ]; then
            add_error "S26: $CFG_DESIGN_DIR/$(basename "$cross_file") collides with skills/$token/ — 'cross-' prefix is reserved for horizontal design docs, not per-skill files"
            s26_fail=1
        fi
    done
    [ "$s26_fail" -eq 0 ] && add_passed "S26: cross-* namespace in $CFG_DESIGN_DIR/ does not shadow any skill"
fi

# --- S20: agent model declaration ---
if [ -n "$CFG_REQUIRE_AGENT_MODEL" ]; then
    s20_fail=0
    for agent_md in "$PLUGIN_ROOT"/skills/*/agents/*.md; do
        [ -f "$agent_md" ] || continue
        agent_name="$(basename "$agent_md")"
        if ! head -10 "$agent_md" | grep -q "^model:"; then
            add_error "S20: $agent_name missing 'model' in frontmatter"
            s20_fail=1
        fi
    done
    [ "$s20_fail" -eq 0 ] && add_passed "S20: All agent files declare model"
fi

# --- S21: no dangerous patterns ---
if [ -n "$CFG_NO_DANGEROUS_PATTERNS" ]; then
    s21_fail=0
    dangerous_patterns="--dangerously-skip-permissions|--no-verify|rm -rf /|curl.*\| *sh"
    for skill_dir in "$PLUGIN_ROOT"/skills/*/; do
        [ -d "$skill_dir" ] || continue
        skill_name="$(basename "$skill_dir")"
        matches=$(grep -rlE "$dangerous_patterns" "$skill_dir"SKILL.md "$skill_dir"references/ "$skill_dir"agents/ 2>/dev/null || true)
        if [ -n "$matches" ]; then
            for m in $matches; do
                rel_path="${m#$PLUGIN_ROOT/}"
                add_warning "S21: Dangerous pattern found in $rel_path"
            done
            s21_fail=1
        fi
    done
    [ "$s21_fail" -eq 0 ] && add_passed "S21: No dangerous patterns detected"
fi

# --- S22: platform-parity for agents/ templates/ scripts/ subdirs ---
# Extends S14 which only covers references/.
# When "platforms" and "verify-platform-subdirs" are set, mirror-check every subdir under skills/<name>/
# against platforms/<platform>/<name>/.
if [ -n "$CFG_VERIFY_PLATFORM_SUBDIRS" ] && [ -n "$CFG_PLATFORMS" ]; then
    s22_fail=0
    for skill_name in "${SKILL_NAMES[@]}"; do
        for platform in $CFG_PLATFORMS; do
            for subdir in agents templates scripts; do
                cc_sub="$PLUGIN_ROOT/skills/$skill_name/$subdir"
                plat_sub="$PLUGIN_ROOT/platforms/$platform/$skill_name/$subdir"
                [ -d "$cc_sub" ] || continue
                for cc_file in "$cc_sub"/*; do
                    [ -f "$cc_file" ] || continue
                    fname="$(basename "$cc_file")"
                    plat_file="$plat_sub/$fname"
                    if [ -f "$plat_file" ]; then
                        add_passed "S22: platforms/$platform/$skill_name/$subdir/$fname exists"
                    else
                        add_warning "S22: platforms/$platform/$skill_name/$subdir/$fname missing (present in skills/$skill_name/$subdir/)"
                        s22_fail=1
                    fi
                done
            done
        done
    done
    [ "$s22_fail" -eq 0 ] && add_passed "S22: All skill subdirectories mirrored to platforms"
fi

# --- S23: i18n structure parity (H2 headings) ---
# For each skill's English guide, ensure each i18n guide has >= 90% of the H2 headings.
# Single-track layout: <i18n-dir>/<lang>/<skill>-guide.md
if [ -n "$CFG_VERIFY_I18N_STRUCTURE" ] && [ -n "$CFG_I18N_DIR" ]; then
    s23_fail=0
    guide_dir="$PLUGIN_ROOT/$CFG_USER_GUIDE_DIR"
    i18n_root="$PLUGIN_ROOT/$CFG_I18N_DIR"
    for skill_name in "${SKILL_NAMES[@]}"; do
        en_guide="$guide_dir/$skill_name-guide.md"
        [ -f "$en_guide" ] || continue
        en_h2_count=$(grep -c "^## " "$en_guide" 2>/dev/null || echo 0)
        [ "$en_h2_count" -eq 0 ] && continue
        for lang_dir in "$i18n_root"/*/; do
            [ -d "$lang_dir" ] || continue
            lang=$(basename "$lang_dir")
            i18n_file="$lang_dir/$skill_name-guide.md"
            [ -f "$i18n_file" ] || continue
            i18n_h2_count=$(grep -c "^## " "$i18n_file" 2>/dev/null || echo 0)
            # require i18n to have >= ceil(en * 0.9) sections
            threshold=$(( (en_h2_count * 90 + 99) / 100 ))
            if [ "$i18n_h2_count" -ge "$threshold" ]; then
                add_passed "S23: $skill_name.$lang H2 parity OK ($i18n_h2_count/$en_h2_count)"
            else
                add_error "S23: $skill_name.$lang H2 structure gap ($i18n_h2_count/$en_h2_count, need >= $threshold)"
                s23_fail=1
            fi
        done
    done
    [ "$s23_fail" -eq 0 ] && add_passed "S23: All i18n guides match English structure within 90%"
fi

# --- S24: cross-skill category-claim detection ---
# Detect "same category" / "different category" claims in guide files and flag for manual review
# when they reference a category keyword. Does not prove correctness (full semantic check is out
# of scope for bash lint), but warns on the pattern that caused past regressions.
if [ -n "$CFG_VERIFY_CROSS_SKILL_CATEGORY" ]; then
    s24_fail=0
    cat_keywords='hammer|crucible|anvil|quench'
    same_category_patterns='Same category|Different categories?|同一分类|不同分类|同カテゴリ|異なるカテゴリ|동일 카테고리|다른 카테고리|समान श्रेणी|अलग श्रेणी|Misma categoría|Categorías diferentes|Même catégorie|Catégories différentes|Gleiche Kategorie|Unterschiedliche Kategorien|Mesma categoria|Categorias diferentes|Та же категория|Разные категории|Aynı kategori|Farklı kategoriler|Cùng phân loại|Phân loại khác'
    declare -A seen_categories
    # Build skill → category map
    for skill_name in "${SKILL_NAMES[@]}"; do
        skill_md="$SKILLS_DIR/$skill_name/SKILL.md"
        [ -f "$skill_md" ] || continue
        cat_val=$(grep -E '^\s*category:' "$skill_md" | head -1 | sed 's/.*category:[[:space:]]*//' | tr -d '[:space:]')
        [ -n "$cat_val" ] && seen_categories[$skill_name]=$cat_val
    done
    # Scan guide files for potentially stale claims (single-track i18n: <i18n-dir>/<lang>/<skill>-guide.md)
    for guide_file in "$PLUGIN_ROOT/$CFG_USER_GUIDE_DIR/"*.md "$PLUGIN_ROOT/$CFG_I18N_DIR"/*/*-guide.md; do
        [ -f "$guide_file" ] || continue
        # Find lines matching "<same/different category phrase> ... (<category keyword>)" OR "... is <category>"
        matches=$(grep -nE "($same_category_patterns).*\\((${cat_keywords})\\)|\\*\\*(${cat_keywords})\\*\\*" "$guide_file" 2>/dev/null || true)
        if [ -n "$matches" ]; then
            # Check if this guide is for a specific skill
            guide_basename=$(basename "$guide_file")
            guide_skill=$(echo "$guide_basename" | sed 's/-guide.*$//')
            if [ -n "${seen_categories[$guide_skill]:-}" ]; then
                # The guide belongs to a known skill — verify claims against the referenced other skill
                declared_category="${seen_categories[$guide_skill]}"
                # Check each matched line: does it mention another skill? If so, is the stated category consistent?
                while IFS= read -r line; do
                    [ -n "$line" ] || continue
                    # Determine whether "same" or "different" is being claimed
                    is_same=0; is_different=0
                    if echo "$line" | grep -qE "(Same category|同一分类|同カテゴリ|동일 카테고리|समान श्रेणी|Misma categoría|Même catégorie|Gleiche Kategorie|Mesma categoria|Та же категория|Aynı kategori|Cùng phân loại)" 2>/dev/null; then
                        is_same=1
                    fi
                    if echo "$line" | grep -qE "(Different categories?|不同分类|異なるカテゴリ|다른 카테고리|अलग श्रेणी|Categorías diferentes|Catégories différentes|Unterschiedliche Kategorien|Categorias diferentes|Разные категории|Farklı kategoriler|Phân loại khác)" 2>/dev/null; then
                        is_different=1
                    fi
                    [ $is_same -eq 0 ] && [ $is_different -eq 0 ] && continue
                    # Which other skill is being referenced in this line?
                    other_skill=""
                    for s in "${!seen_categories[@]}"; do
                        [ "$s" = "$guide_skill" ] && continue
                        if echo "$line" | grep -qw "$s" 2>/dev/null; then
                            other_skill="$s"
                            break
                        fi
                    done
                    [ -z "$other_skill" ] && continue
                    other_cat="${seen_categories[$other_skill]}"
                    if [ $is_same -eq 1 ] && [ "$declared_category" != "$other_cat" ]; then
                        add_error "S24: $guide_basename claims 'same category' between $guide_skill($declared_category) and $other_skill($other_cat) — mismatch"
                        s24_fail=1
                    elif [ $is_different -eq 1 ] && [ "$declared_category" = "$other_cat" ]; then
                        add_error "S24: $guide_basename claims 'different categories' between $guide_skill($declared_category) and $other_skill($other_cat) — but they're the same"
                        s24_fail=1
                    fi
                done <<< "$matches"
            fi
        fi
    done
    [ "$s24_fail" -eq 0 ] && add_passed "S24: Cross-skill category claims consistent with SKILL.md frontmatter"
fi

# --- S28: platform-hook parity (error, v1.2) ---
# 若 skills/<s>/hooks/ 存在 + .skill-lint.json platforms 含 <p>，
# 则 platforms/<p>/<s>/hooks/<p>/ 必须存在且每个 HOOK.md frontmatter events 非空。
# 豁免：SKILL.md "## 平台 hook 等价位置" 段含"无等价机制可用"则跳过对应 hook 的检查。
s28_warnings_raw=$(python3 - "$PLUGIN_ROOT" << 'S28EOF' 2>/dev/null || true
import json
import os
import re
import sys

root = sys.argv[1]
platforms_cfg = []
sl_cfg_path = os.path.join(root, ".skill-lint.json")
if os.path.isfile(sl_cfg_path):
    try:
        with open(sl_cfg_path, "r", encoding="utf-8") as fh:
            cfg = json.load(fh)
        # platforms 在 rules.platforms 嵌套层（与 .skill-lint.json schema 对齐）
        rules = cfg.get("rules", {}) or {}
        platforms_cfg = rules.get("platforms", []) or cfg.get("platforms", []) or []
    except Exception:
        pass

if not platforms_cfg:
    sys.exit(0)

skills_dir = os.path.join(root, "skills")
errors = []

if not os.path.isdir(skills_dir):
    sys.exit(0)

for skill_name in sorted(os.listdir(skills_dir)):
    skill_path = os.path.join(skills_dir, skill_name)
    if not os.path.isdir(skill_path):
        continue
    canonical_hooks = os.path.join(skill_path, "hooks")
    # 仅 owner skill（有 hooks/ 目录）需要 platform 镜像
    if not os.path.isdir(canonical_hooks):
        continue
    # 收集 canonical hook 名（hooks/ 下的 .sh 脚本对应 hook 名）
    canonical_hook_names = set()
    for f in os.listdir(canonical_hooks):
        if f.endswith(".sh"):
            # e.g. prompt-gate.sh → prompt-gate；epistemic-pushback-trigger.sh → epistemic-pushback-trigger
            canonical_hook_names.add(f[:-3])

    for plat in platforms_cfg:
        plat_skill = os.path.join(root, "platforms", plat, skill_name)
        # 读 platform SKILL.md 检查"无等价机制可用"豁免段
        plat_skill_md = os.path.join(plat_skill, "SKILL.md")
        exempted_hooks = set()
        if os.path.isfile(plat_skill_md):
            try:
                with open(plat_skill_md, "r", encoding="utf-8") as fh:
                    md = fh.read()
                # 在 "## 平台 hook 等价位置" 段查找"无等价机制可用"行
                m = re.search(r"##\s+平台 hook 等价位置.*?(?=\n##\s|\Z)", md, re.DOTALL)
                if m:
                    section = m.group(0)
                    # 每行查 hook 名 + "无等价"
                    for line in section.splitlines():
                        if "无等价机制可用" in line or "no equivalent" in line.lower():
                            for hn in canonical_hook_names:
                                # 接受 prompt-gate / claim-ground-prompt-gate 等命名变体
                                hn_short = hn.replace(f"{skill_name}-", "")
                                hn_strip = hn.replace("-trigger", "")
                                if hn in line or hn_short in line or hn_strip in line:
                                    exempted_hooks.add(hn)
            except Exception:
                pass

        # 平台 hooks/<plat>/ 目录
        plat_hooks_dir = os.path.join(plat_skill, "hooks", plat)

        for hn in canonical_hook_names:
            if hn in exempted_hooks:
                continue
            # 命名兼容：canonical 的 epistemic-pushback-trigger 可能在 platform 叫 epistemic-pushback
            hn_strip = hn.replace("-trigger", "")
            candidate_dirs = [
                os.path.join(plat_hooks_dir, hn),
                os.path.join(plat_hooks_dir, hn_strip),
            ]
            found_dir = next((d for d in candidate_dirs if os.path.isdir(d)), None)
            if not found_dir:
                errors.append(f"S28: skills/{skill_name}/hooks/{hn} has no openclaw mirror at platforms/{plat}/{skill_name}/hooks/{plat}/{hn}/ (and no '无等价机制可用' exemption in SKILL.md)")
                continue
            # 检 HOOK.md events 字段非空
            hook_md = os.path.join(found_dir, "HOOK.md")
            if not os.path.isfile(hook_md):
                errors.append(f"S28: {os.path.relpath(found_dir, root)} missing HOOK.md")
                continue
            try:
                with open(hook_md, "r", encoding="utf-8") as fh:
                    content = fh.read()
                ev_match = re.search(r'"events"\s*:\s*\[([^\]]*)\]', content, re.DOTALL)
                if not ev_match or not ev_match.group(1).strip():
                    errors.append(f"S28: {os.path.relpath(hook_md, root)} 'events' field is empty")
            except Exception as e:
                errors.append(f"S28: {os.path.relpath(hook_md, root)} parse failed: {e}")

for e in errors:
    print(e)
S28EOF
) || true

s28_fail=0
if [ -n "$s28_warnings_raw" ]; then
    while IFS= read -r line; do
        [ -n "$line" ] && add_error "$line"
    done <<< "$s28_warnings_raw"
    s28_fail=1
fi
[ "$s28_fail" -eq 0 ] && add_passed "S28: All hook-owner skills have platform-mirror hooks (or '无等价机制可用' exemption)"

# --- S27: term-reference density (warning, v1.2, white-list mode) ---
# Python 单次扫描：对 watchlist 内每个 term 建一次 file-list，per skill 检查 O(1)
s27_warnings_raw=$(python3 - "$PLUGIN_ROOT" << 'PYEOF'
import os, re, sys
root = sys.argv[1]
watchlist = ['openclaw', 'clawhub', 'forge', 'claude-code', 'anthropic', 'openspec', 'marketplace']
patterns = {t: re.compile(r'\b' + re.escape(t) + r'\b') for t in watchlist}

# 收集所有 .md / .json 文件（限定 skills/, platforms/, openspec/, docs/, README.md）
target_files = []
for sub in ['skills', 'platforms', 'openspec', 'docs']:
    sub_path = os.path.join(root, sub)
    if not os.path.isdir(sub_path):
        continue
    for dirpath, _, filenames in os.walk(sub_path):
        if '.git' in dirpath:
            continue
        for f in filenames:
            if f.endswith('.md') or f.endswith('.json'):
                target_files.append(os.path.join(dirpath, f))
readme = os.path.join(root, 'README.md')
if os.path.isfile(readme):
    target_files.append(readme)

# 单次读全部文件 → term -> set(filepaths)
term_index = {t: set() for t in watchlist}
for fp in target_files:
    try:
        with open(fp, 'r', encoding='utf-8', errors='ignore') as fh:
            content = fh.read()
        for t, p in patterns.items():
            if p.search(content):
                term_index[t].add(fp)
    except Exception:
        pass

# Per SKILL.md check
skills_dir = os.path.join(root, 'skills')
warnings = []
if os.path.isdir(skills_dir):
    for skill_name in sorted(os.listdir(skills_dir)):
        skill_md = os.path.join(skills_dir, skill_name, 'SKILL.md')
        if not os.path.isfile(skill_md):
            continue
        for t in watchlist:
            if skill_md in term_index[t]:
                # 该 SKILL.md 提及 term；查其他文件
                other_refs = term_index[t] - {skill_md}
                if not other_refs:
                    warnings.append(f"S27: skills/{skill_name}/SKILL.md mentions '{t}' but no other reference exists in repo (potential ambiguity)")

for w in warnings:
    print(w)
PYEOF
) || true

s27_fail=0
if [ -n "$s27_warnings_raw" ]; then
    while IFS= read -r line; do
        [ -n "$line" ] && add_warning "$line"
    done <<< "$s27_warnings_raw"
    s27_fail=1
fi
[ "$s27_fail" -eq 0 ] && add_passed "S27: All watchlist terms in SKILL.md have repo-wide references"

# --- S29 / S30 / S31: version governance + CHANGELOG (error, version-governance change) ---
# SSOT for skill version = .claude-plugin/marketplace.json `plugins[].version` (Claude Code
# skill schema does NOT support a `version` field in SKILL.md frontmatter — see version-governance
# change spec deltas for rationale).
#
# S29: marketplace.json plugins[].version MUST be SemVer 2.0.0 (MAJOR.MINOR.PATCH[-pre][+build]).
#      Regression guard: SKILL.md frontmatter (canonical + platform mirrors) MUST NOT contain a
#      top-level `version:` field (rejected by Claude Code official schema).
# S30: `## Help` section's first code block first line MUST match
#      `^[A-Z][A-Za-z0-9 -]+ v(<X.Y.Z>) — .+$` where <X.Y.Z> equals marketplace plugins[].version.
#      Applied to canonical AND every platform mirror that has a Help section
#      (heading regex tolerates variants like `## Help (no arguments)`).
# S31: For each plugin in marketplace.json, root /CHANGELOG.md MUST contain a
#      `### [<X.Y.Z>]` line under `## <skill-name>` heading where <X.Y.Z> equals
#      marketplace plugins[].version (top-most entry).
if [ "$CFG_VERIFY_VERSION_LOCKSTEP" = "1" ] || [ "$CFG_VERIFY_HELP_CARD_VERSION_LINE" = "1" ] || [ "$CFG_VERIFY_CHANGELOG_ENTRY" = "1" ]; then
    s29s30s31_raw=$(python3 - "$PLUGIN_ROOT" "$CFG_VERIFY_VERSION_LOCKSTEP" "$CFG_VERIFY_HELP_CARD_VERSION_LINE" "$CFG_VERIFY_CHANGELOG_ENTRY" "${CFG_PLATFORMS:-}" << 'S29S30S31EOF' 2>/dev/null || true
import json, os, re, sys

root = sys.argv[1]
do_s29 = sys.argv[2] == "1"
do_s30 = sys.argv[3] == "1"
do_s31 = sys.argv[4] == "1"
platforms = [p for p in (sys.argv[5] or "").split() if p]

mk_path = os.path.join(root, ".claude-plugin", "marketplace.json")
mk = {}
if os.path.isfile(mk_path):
    try:
        with open(mk_path, "r", encoding="utf-8") as fh:
            mk = json.load(fh)
    except Exception:
        pass
mk_versions = {p.get("name"): p.get("version") for p in mk.get("plugins", [])}

semver_re = re.compile(r"^\d+\.\d+\.\d+(-[0-9A-Za-z.-]+)?(\+[0-9A-Za-z.-]+)?$")
help_first_line_re = re.compile(r"^[A-Z][A-Za-z0-9 -]+ v(\d+\.\d+\.\d+) — .+$")
# `## Help` heading tolerates trailing tokens (e.g. `## Help (no arguments)`).
help_section_re = re.compile(r"^##\s+Help\b.*?$(.*?)(?=^##\s|\Z)", re.MULTILINE | re.DOTALL)

def has_frontmatter_version_field(content):
    """Return True if frontmatter contains a top-level `version:` field (regression guard)."""
    fm_match = re.match(r"^---\n(.*?)\n---\n", content, re.DOTALL)
    if not fm_match:
        return False
    return bool(re.search(r"^version:\s*\S+", fm_match.group(1), re.MULTILINE))

def find_help_first_line(content):
    """Return (first_line, no_code_block_flag). first_line is None if no Help section."""
    m = help_section_re.search(content)
    if not m:
        return None, False
    section = m.group(1)
    code_m = re.search(r"```[a-zA-Z0-9_-]*\n(.*?)\n```", section, re.DOTALL)
    if not code_m:
        return None, True
    return code_m.group(1).split("\n", 1)[0].rstrip(), False

# --- Parse CHANGELOG.md once if S31 enabled ---
changelog_versions = {}  # {skill_name: top-most version literal}
changelog_present = False
if do_s31:
    changelog_path = os.path.join(root, "CHANGELOG.md")
    if os.path.isfile(changelog_path):
        changelog_present = True
        try:
            with open(changelog_path, "r", encoding="utf-8") as fh:
                cl_content = fh.read()
            current_skill = None
            for line in cl_content.splitlines():
                h2 = re.match(r"^##\s+([a-z0-9][a-z0-9-]*)\s*$", line)
                if h2:
                    current_skill = h2.group(1)
                    continue
                if current_skill is not None:
                    h3 = re.match(r"^###\s+\[(\d+\.\d+\.\d+(?:-[0-9A-Za-z.-]+)?(?:\+[0-9A-Za-z.-]+)?)\]", line)
                    if h3 and current_skill not in changelog_versions:
                        changelog_versions[current_skill] = h3.group(1)
        except Exception:
            pass

skills_dir = os.path.join(root, "skills")
errors = []
checked_s29 = 0
checked_s30 = 0
checked_s31 = 0

if not os.path.isdir(skills_dir):
    print(f"##S29S30S31_CHECKED s29={checked_s29} s30={checked_s30} s31={checked_s31}")
    for e in errors:
        print(e)
    sys.exit(0)

if do_s31 and not changelog_present:
    errors.append("S31: CHANGELOG.md missing at repo root (required when verify-changelog-entry is enabled)")

# S29 — validate marketplace.json SemVer (skill-level, not per-skill-md)
if do_s29:
    for skill_name, mk_v in mk_versions.items():
        if mk_v is None:
            errors.append(f"S29: marketplace.json plugin '{skill_name}' missing `version` field")
        elif not semver_re.match(mk_v):
            errors.append(f"S29: marketplace.json plugin '{skill_name}' version='{mk_v}' is non-SemVer-2.0.0 format")

for skill_name in sorted(os.listdir(skills_dir)):
    skill_md = os.path.join(skills_dir, skill_name, "SKILL.md")
    if not os.path.isfile(skill_md):
        continue
    try:
        with open(skill_md, "r", encoding="utf-8") as fh:
            content = fh.read()
    except Exception:
        continue

    mk_v = mk_versions.get(skill_name)

    # S29 regression guard — frontmatter MUST NOT have `version:` field
    if do_s29:
        checked_s29 += 1
        if has_frontmatter_version_field(content):
            errors.append(f"S29: skills/{skill_name}/SKILL.md frontmatter contains `version:` field (Claude Code schema rejects it; SSOT is marketplace.json)")
        # Platform mirror regression guard
        for plat in platforms:
            plat_md = os.path.join(root, "platforms", plat, skill_name, "SKILL.md")
            if not os.path.isfile(plat_md):
                continue
            try:
                with open(plat_md, "r", encoding="utf-8") as fh:
                    plat_content = fh.read()
            except Exception:
                continue
            if has_frontmatter_version_field(plat_content):
                errors.append(f"S29: platforms/{plat}/{skill_name}/SKILL.md frontmatter contains `version:` field (forbidden)")

    if mk_v is None or not semver_re.match(str(mk_v)):
        # Skip S30/S31 if marketplace version is invalid (S29 already reported)
        continue

    # S30 canonical — help-card-version-line vs marketplace SSOT
    if do_s30:
        first_line, no_code = find_help_first_line(content)
        if no_code:
            errors.append(f"S30: skills/{skill_name}/SKILL.md ## Help section has no code block")
        elif first_line is not None:
            checked_s30 += 1
            m = help_first_line_re.match(first_line)
            if not m:
                errors.append(f"S30: skills/{skill_name}/SKILL.md help-card first line does not match `<Name> v<X.Y.Z> — <tagline>` pattern: {first_line!r}")
            elif m.group(1) != mk_v:
                errors.append(f"S30: skills/{skill_name}: help-card v{m.group(1)} ≠ marketplace v{mk_v}")

    # S30 platform mirror — help-card-version-line vs canonical marketplace SSOT
    if do_s30:
        for plat in platforms:
            plat_md = os.path.join(root, "platforms", plat, skill_name, "SKILL.md")
            if not os.path.isfile(plat_md):
                continue
            try:
                with open(plat_md, "r", encoding="utf-8") as fh:
                    plat_content = fh.read()
            except Exception:
                continue
            first_line, no_code = find_help_first_line(plat_content)
            if no_code:
                errors.append(f"S30: platforms/{plat}/{skill_name}/SKILL.md ## Help section has no code block")
            elif first_line is not None:
                m = help_first_line_re.match(first_line)
                if not m:
                    errors.append(f"S30: platforms/{plat}/{skill_name}/SKILL.md help-card first line does not match `<Name> v<X.Y.Z> — <tagline>` pattern: {first_line!r}")
                elif m.group(1) != mk_v:
                    errors.append(f"S30: platforms/{plat}/{skill_name}: help-card v{m.group(1)} ≠ marketplace v{mk_v}")

    # S31 — root CHANGELOG.md entry per skill vs marketplace SSOT
    if do_s31 and changelog_present:
        checked_s31 += 1
        cl_v = changelog_versions.get(skill_name)
        if cl_v is None:
            errors.append(f"S31: CHANGELOG.md has no `## {skill_name}` section or no `### [X.Y.Z]` entry under it (marketplace v{mk_v})")
        elif cl_v != mk_v:
            errors.append(f"S31: skills/{skill_name}: marketplace v{mk_v} ≠ CHANGELOG top entry v{cl_v} (add `### [{mk_v}]` under `## {skill_name}`)")

print(f"##S29S30S31_CHECKED s29={checked_s29} s30={checked_s30} s31={checked_s31}")
for e in errors:
    print(e)
S29S30S31EOF
)

    s29s30s31_fail=0
    while IFS= read -r line; do
        case "$line" in
            "##S29S30S31_CHECKED"*) ;;
            "S29:"*|"S30:"*|"S31:"*) add_error "$line"; s29s30s31_fail=1 ;;
            "") ;;
        esac
    done <<< "$s29s30s31_raw"
    if [ "$s29s30s31_fail" -eq 0 ]; then
        [ "$CFG_VERIFY_VERSION_LOCKSTEP" = "1" ] && add_passed "S29: marketplace.json plugin versions are valid SemVer 2.0.0; SKILL.md frontmatter has no version field (canonical + platforms)"
        [ "$CFG_VERIFY_HELP_CARD_VERSION_LINE" = "1" ] && add_passed "S30: All help-card first lines carry version equal to marketplace.json plugins[].version (canonical + platforms)"
        [ "$CFG_VERIFY_CHANGELOG_ENTRY" = "1" ] && add_passed "S31: All skill versions in marketplace.json have matching CHANGELOG.md top entries"
    fi
fi

# --- S32: docs-version-drift detection (warn by default) ---
# 扫 docs/user-guide/<skill>-guide.md + docs/i18n/<lang>/<skill>-guide.md 首行(H1)
# 提取版本号字面量,与 marketplace.json plugins[].version 做 prefix-match;
# drift 报 warn(初期不阻塞 PR,观察期满后可升 error)
if [ -n "$CFG_VERIFY_DOCS_VERSION_DRIFT" ]; then
    s32_raw=$(python3 - "$PLUGIN_ROOT" << 'S32EOF' 2>/dev/null || true
import json, os, re, sys

root = sys.argv[1]
mk_path = os.path.join(root, ".claude-plugin", "marketplace.json")
mk_versions = {}
if os.path.isfile(mk_path):
    try:
        with open(mk_path, "r", encoding="utf-8") as fh:
            mk = json.load(fh)
        mk_versions = {p.get("name"): p.get("version") for p in mk.get("plugins", [])}
    except Exception:
        pass

version_re = re.compile(r"\bv(\d+\.\d+(?:\.\d+)?)\b")

def prefix_match(short, full):
    if not short or not full:
        return False
    s = short.split(".")
    f = full.split(".")
    if len(s) > len(f):
        return False
    return all(a == b for a, b in zip(s, f))

def extract_skill_from_path(p):
    base = os.path.basename(p)
    if base.endswith("-guide.md"):
        return base[: -len("-guide.md")]
    return None

paths = []
ug_dir = os.path.join(root, "docs", "user-guide")
if os.path.isdir(ug_dir):
    for f in os.listdir(ug_dir):
        if f.endswith("-guide.md"):
            paths.append(os.path.join(ug_dir, f))
i18n_dir = os.path.join(root, "docs", "i18n")
if os.path.isdir(i18n_dir):
    for lang in os.listdir(i18n_dir):
        lang_dir = os.path.join(i18n_dir, lang)
        if not os.path.isdir(lang_dir):
            continue
        for f in os.listdir(lang_dir):
            if f.endswith("-guide.md"):
                paths.append(os.path.join(lang_dir, f))

issues = []
checked = 0
for p in sorted(paths):
    skill = extract_skill_from_path(p)
    if skill is None or skill not in mk_versions:
        continue
    expected = mk_versions[skill]
    try:
        with open(p, "r", encoding="utf-8") as fh:
            first_line = fh.readline()
    except Exception:
        continue
    m = version_re.search(first_line)
    if not m:
        # 未声明版本号 — 不算 drift,跳过(P1 政策:仅 warn 飘移,不强制必须有)
        continue
    checked += 1
    found = m.group(1)
    if not prefix_match(found, expected):
        rel = os.path.relpath(p, root)
        issues.append(f"S32: {rel} H1 version 'v{found}' is not a prefix of marketplace v{expected}")

print(f"##S32_CHECKED count={checked}")
for i in issues:
    print(i)
S32EOF
)
    s32_fail=0
    while IFS= read -r line; do
        case "$line" in
            "##S32_CHECKED"*) ;;
            "S32:"*)
                if [ "$CFG_VERIFY_DOCS_VERSION_DRIFT" = "error" ]; then
                    add_error "$line"
                else
                    add_warning "$line"
                fi
                s32_fail=1
                ;;
            "") ;;
        esac
    done <<< "$s32_raw"
    [ "$s32_fail" -eq 0 ] && add_passed "S32: docs/user-guide + docs/i18n H1 versions prefix-match marketplace SSOT"
fi

# --- S33: archived spec-merge completeness (warn by default) ---
# 扫 openspec/changes/archive/<id>/specs/<capability>/spec.md;若主 spec
# openspec/specs/<capability>/spec.md 不含对应 archive id 的"合并自"标记,
# 则报 warn — 提醒 archive 流程缺漏(F3 即此机制缺位的活例)
if [ -n "$CFG_VERIFY_ARCHIVED_SPEC_MERGE" ]; then
    s33_raw=$(python3 - "$PLUGIN_ROOT" << 'S33EOF' 2>/dev/null || true
import os, re, sys

root = sys.argv[1]
archive_root = os.path.join(root, "openspec", "changes", "archive")
specs_root = os.path.join(root, "openspec", "specs")

if not os.path.isdir(archive_root) or not os.path.isdir(specs_root):
    sys.exit(0)

issues = []
checked = 0
for change_id in sorted(os.listdir(archive_root)):
    archive_specs_dir = os.path.join(archive_root, change_id, "specs")
    if not os.path.isdir(archive_specs_dir):
        continue
    for capability in sorted(os.listdir(archive_specs_dir)):
        archive_spec = os.path.join(archive_specs_dir, capability, "spec.md")
        main_spec = os.path.join(specs_root, capability, "spec.md")
        if not os.path.isfile(archive_spec) or not os.path.isfile(main_spec):
            continue
        try:
            with open(archive_spec, "r", encoding="utf-8") as fh:
                archive_content = fh.read()
            with open(main_spec, "r", encoding="utf-8") as fh:
                main_content = fh.read()
        except Exception:
            continue
        # 统计 archive spec 中的 Requirement 数量
        requirements = re.findall(r"^### Requirement:.*$", archive_content, re.MULTILINE)
        if not requirements:
            continue
        checked += 1
        # 主 spec 是否含对该 archive id 的"合并自"标记或 archive id substring
        if change_id not in main_content:
            issues.append(f"S33: archive/{change_id}/specs/{capability}/spec.md has {len(requirements)} Requirement(s) but main spec openspec/specs/{capability}/spec.md does not reference '{change_id}' (no '合并自' merge mark — archive sync may be incomplete)")

print(f"##S33_CHECKED count={checked}")
for i in issues:
    print(i)
S33EOF
)
    s33_fail=0
    while IFS= read -r line; do
        case "$line" in
            "##S33_CHECKED"*) ;;
            "S33:"*)
                if [ "$CFG_VERIFY_ARCHIVED_SPEC_MERGE" = "error" ]; then
                    add_error "$line"
                else
                    add_warning "$line"
                fi
                s33_fail=1
                ;;
            "") ;;
        esac
    done <<< "$s33_raw"
    [ "$s33_fail" -eq 0 ] && add_passed "S33: All archived change spec deltas are referenced in main specs (merge marks present)"
fi

# --- S34: help-card-flag-coverage (warn by default) ---
# 解析每个 SKILL.md frontmatter argument-hint 中的所有 --flag,与
# `## Help` 段第一个 fenced code block 内出现的 --flag 集合比对;hint 有但 help 漏 → 报。
# 子命令模式(argument-hint 不含任何 --flag)豁免;无 argument-hint 字段也豁免。
# canonical + platform mirror 同等约束(mirror 含 Help 段时一并扫)。
if [ -n "$CFG_VERIFY_HELP_CARD_FLAG_COVERAGE" ]; then
    s34_raw=$(python3 - "$PLUGIN_ROOT" "${CFG_PLATFORMS:-}" << 'S34EOF' 2>/dev/null || true
import os, re, sys

root = sys.argv[1]
platforms_raw = sys.argv[2] if len(sys.argv) > 2 else ""
platforms = [p for p in platforms_raw.split() if p]

flag_re = re.compile(r"--[a-z][a-z0-9-]+")

def extract_argument_hint(text):
    # 取 frontmatter 区域(--- ... ---)中的 argument-hint 字段值
    fm_match = re.match(r"^---\s*\n(.*?)\n---\s*\n", text, re.DOTALL)
    if not fm_match:
        return None
    fm = fm_match.group(1)
    m = re.search(r'^argument-hint:\s*"(.*)"\s*$', fm, re.MULTILINE)
    if not m:
        m = re.search(r"^argument-hint:\s*'(.*)'\s*$", fm, re.MULTILINE)
    if not m:
        m = re.search(r'^argument-hint:\s*(.*)$', fm, re.MULTILINE)
    if m:
        return m.group(1).strip()
    return None

def extract_help_card_body(text):
    # 取 ## Help 段后第一个 ``` fenced block 内容
    h2_match = re.search(r'^## Help\b', text, re.MULTILINE)
    if not h2_match:
        return None
    after = text[h2_match.end():]
    fence_match = re.search(r"\n```[a-zA-Z]*\n(.*?)\n```", after, re.DOTALL)
    if not fence_match:
        return None
    return fence_match.group(1)

def check_skill_md(path, label):
    try:
        with open(path, 'r', encoding='utf-8') as fh:
            text = fh.read()
    except Exception:
        return None
    hint = extract_argument_hint(text)
    if hint is None:
        return None  # 无 argument-hint 字段 → 豁免(子命令型 skill 也常这样)
    hint_flags = set(flag_re.findall(hint))
    if not hint_flags:
        return None  # 子命令模式(无 --flag) → 豁免
    body = extract_help_card_body(text)
    if body is None:
        return None  # Help 段或 fenced block 缺失 → S25 已报,S34 跳过避免重复
    help_flags = set(flag_re.findall(body))
    missing = hint_flags - help_flags
    if missing:
        return f"S34: {label} argument-hint has flags not listed in help card: {' '.join(sorted(missing))}"
    return None

issues = []
checked = 0
skills_dir = os.path.join(root, "skills")
if os.path.isdir(skills_dir):
    for name in sorted(os.listdir(skills_dir)):
        if name.startswith('_'):
            continue
        skill_md = os.path.join(skills_dir, name, "SKILL.md")
        if os.path.isfile(skill_md):
            checked += 1
            r = check_skill_md(skill_md, f"skills/{name}/SKILL.md")
            if r:
                issues.append(r)

for plat in platforms:
    plat_dir = os.path.join(root, "platforms", plat)
    if not os.path.isdir(plat_dir):
        continue
    for name in sorted(os.listdir(plat_dir)):
        if name.startswith('_'):
            continue
        skill_md = os.path.join(plat_dir, name, "SKILL.md")
        if os.path.isfile(skill_md):
            checked += 1
            r = check_skill_md(skill_md, f"platforms/{plat}/{name}/SKILL.md")
            if r:
                issues.append(r)

print(f"##S34_CHECKED count={checked}")
for i in issues:
    print(i)
S34EOF
)
    s34_fail=0
    while IFS= read -r line; do
        case "$line" in
            "##S34_CHECKED"*) ;;
            "S34:"*)
                if [ "$CFG_VERIFY_HELP_CARD_FLAG_COVERAGE" = "error" ]; then
                    add_error "$line"
                else
                    add_warning "$line"
                fi
                s34_fail=1
                ;;
            "") ;;
        esac
    done <<< "$s34_raw"
    [ "$s34_fail" -eq 0 ] && add_passed "S34: All argument-hint --flags are documented in their help card (canonical + platforms)"
fi

# --- S35: lang-flag-required (--lang in argument-hint for every user-invokable skill) ---
# output-language spec: 每个 user-invokable skill 的 argument-hint MUST 含 --lang。
# canonical(nested 优先,flat 兜底) + platform mirror 同等约束。
if [ -n "$CFG_VERIFY_LANG_FLAG_REQUIRED" ]; then
    s35_raw=$(python3 - "$PLUGIN_ROOT" "${CFG_PLATFORMS:-}" << 'S35EOF' 2>/dev/null || true
import os, re, sys

root = sys.argv[1]
platforms_raw = sys.argv[2] if len(sys.argv) > 2 else ""
platforms = [p for p in platforms_raw.split() if p]

def extract_argument_hint(text):
    fm_match = re.match(r"^---\s*\n(.*?)\n---\s*\n", text, re.DOTALL)
    if not fm_match:
        return None
    fm = fm_match.group(1)
    for pat in (r'^argument-hint:\s*"(.*)"\s*$', r"^argument-hint:\s*'(.*)'\s*$", r'^argument-hint:\s*(.*)$'):
        m = re.search(pat, fm, re.MULTILINE)
        if m:
            return m.group(1).strip()
    return None

def check(path, label, issues):
    try:
        with open(path, 'r', encoding='utf-8') as fh:
            text = fh.read()
    except Exception:
        return
    hint = extract_argument_hint(text)
    if hint is None:
        issues.append(f"S35: {label} missing argument-hint with --lang (output-language spec requires --lang)")
    elif "--lang" not in hint:
        issues.append(f"S35: {label} argument-hint missing --lang (output-language spec)")

issues = []
checked = 0
skills_dir = os.path.join(root, "skills")
if os.path.isdir(skills_dir):
    for name in sorted(os.listdir(skills_dir)):
        if name.startswith('_'):
            continue
        nested = os.path.join(skills_dir, name, "skills", name, "SKILL.md")
        flat = os.path.join(skills_dir, name, "SKILL.md")
        skill_md = nested if os.path.isfile(nested) else (flat if os.path.isfile(flat) else None)
        if skill_md:
            checked += 1
            check(skill_md, f"skills/{name}/SKILL.md", issues)

for plat in platforms:
    plat_dir = os.path.join(root, "platforms", plat)
    if not os.path.isdir(plat_dir):
        continue
    for name in sorted(os.listdir(plat_dir)):
        if name.startswith('_'):
            continue
        skill_md = os.path.join(plat_dir, name, "SKILL.md")
        if os.path.isfile(skill_md):
            checked += 1
            check(skill_md, f"platforms/{plat}/{name}/SKILL.md", issues)

print(f"##S35_CHECKED count={checked}")
for i in issues:
    print(i)
S35EOF
)
    s35_fail=0
    while IFS= read -r line; do
        case "$line" in
            "##S35_CHECKED"*) ;;
            "S35:"*)
                if [ "$CFG_VERIFY_LANG_FLAG_REQUIRED" = "error" ]; then
                    add_error "$line"
                else
                    add_warning "$line"
                fi
                s35_fail=1
                ;;
            "") ;;
        esac
    done <<< "$s35_raw"
    [ "$s35_fail" -eq 0 ] && add_passed "S35: All user-invokable skills declare --lang in argument-hint (canonical + platforms)"
fi

# --- Output JSON ---
json_array() {
    local arr=("$@")
    if [ ${#arr[@]} -eq 0 ]; then
        echo "[]"
        return
    fi
    printf '%s\n' "${arr[@]}" | python -c 'import sys,json; print(json.dumps([l.strip() for l in sys.stdin if l.strip()]))'
}

printf '{"errors": %s, "warnings": %s, "passed": %s}\n' \
    "$(json_array "${ERRORS[@]+"${ERRORS[@]}"}")" \
    "$(json_array "${WARNINGS[@]+"${WARNINGS[@]}"}")" \
    "$(json_array "${PASSED[@]+"${PASSED[@]}"}")"
