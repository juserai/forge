# KB Wiki Operations Reference

Detailed algorithms for ingest and lint operations.

## Ingest Algorithm

### Step 1: Route

Given raw content and the current `index.md`, determine which wiki pages need updating or creating.

- If raw content discusses an existing wiki topic: update that page
- If raw content introduces a new concept: create a new page
- One raw file may route to multiple wiki pages
- Prefer updating existing pages over creating new ones

New page naming: `wiki/{domain}/{topic-name}.md` (kebab-case)

### Step 2: Merge (for updates)

1. **Core Concept**: MERGE new info (add, don't replace)
2. **My Understanding Delta**: PRESERVE EXACTLY (copy verbatim, never modify)
3. **Open Questions**: APPEND new, remove only if answered by new material
4. **Connections**: UNION (keep all existing, add new)
5. **Frontmatter**: update last_compiled, append source_refs, update compiled_by

### Step 3: Validate

- My Understanding Delta identical to previous version
- All source_refs point to existing files
- Connections use `[[wiki/...]]` syntax
- If uncertain, add `<!-- REVIEW: explanation -->`

### Step 4: Update Index

Regenerate `index.md` listing all wiki pages sorted by domain.

### Step 5: Log

Append to `logs/{YYYY-MM}.md`: `- [{date} {HH:MM}] **ingest**: {raw_path} -> {wiki_pages}`

---

## Lint Checklist

### Errors (must fix)
- YAML frontmatter present with: domain, maturity, last_compiled, source_refs, confidence
- maturity is one of: draft, growing, stable, deprecated
- confidence is one of: low, medium, high
- Sections exist: Core Concept, My Understanding Delta, Open Questions, Connections

### Warnings (should fix)
- source_refs point to existing raw files
- [[links]] point to existing wiki pages
- Page listed in index.md
- Fast-moving domains: warn if last_compiled > 90 days
- Stable domains: warn if last_compiled > 365 days

### Info (human action)
- My Understanding Delta empty or placeholder
- Unresolved <!-- REVIEW: --> comments
- Open Questions answered in Core Concept
