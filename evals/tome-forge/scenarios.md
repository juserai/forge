# Tome Forge — Evaluation Scenarios

## Scenario 1: Init (default)

**Trigger:** `/tome-forge init` (from a non-KB directory)
**Expected:**
- Creates KB at `~/.tome-forge/`
- Contains `raw/`, `wiki/`, `logs/`, `CLAUDE.md`, `index.md`, `.tome-forge.json`, `.gitignore`
- Reports: `KB: ~/.tome-forge/`

## Scenario 1b: Init (current dir)

**Trigger:** `/tome-forge init .`
**Expected:**
- Creates KB in current working directory
- Reports: `KB: /current/working/dir`

## Scenario 1c: KB Discovery — inside KB

**Setup:** cd into a directory whose parent contains `.tome-forge.json`
**Trigger:** `/tome-forge capture "test note"`
**Expected:**
- Walks up, finds `.tome-forge.json`, uses that directory as KB root
- Captures into the local KB, not `~/.tome-forge/`

## Scenario 1d: KB Discovery — outside KB

**Setup:** cd into a directory with no `.tome-forge.json` anywhere upward
**Trigger:** `/tome-forge capture "test note"`
**Expected:**
- Falls back to `~/.tome-forge/`
- Auto-creates `~/.tome-forge/` (including `.tome-forge.json`) if it doesn't exist
- Captures into `~/.tome-forge/raw/captures/{date}/`

## Scenario 2: Capture Note

**Trigger:** `/tome-forge capture "transformers use self-attention to process sequences in parallel"`
**Expected:**
- Creates `raw/captures/{today}/notes.md` if not exists
- Appends note under `## {HH:MM}` heading
- Appends to `logs/{YYYY-MM}.md`

## Scenario 3: Capture URL

**Trigger:** `/tome-forge capture https://arxiv.org/abs/1706.03762`
**Expected:**
- Creates `raw/captures/{today}/links.md` if not exists
- Appends link in markdown format
- Appends to `logs/{YYYY-MM}.md`

## Scenario 4: Ingest — Create New Page

**Setup:** KB initialized, `raw/papers/attention.md` exists with content about attention mechanisms
**Trigger:** `/tome-forge ingest raw/papers/attention.md`
**Expected:**
- Creates `wiki/ai/attention-mechanisms.md` (or similar)
- Page has valid frontmatter with all required fields
- `source_refs` includes `raw/papers/attention.md`
- `My Understanding Delta` says "To be filled by human"
- `index.md` updated with new page
- `logs/{YYYY-MM}.md` has ingest entry

## Scenario 5: Ingest — Update Existing Page

**Setup:** `wiki/ai/attention.md` exists with content and a human-written My Understanding Delta
**Trigger:** `/tome-forge ingest raw/papers/flash-attention.md`
**Expected:**
- Core Concept is MERGED (new info added, old preserved)
- My Understanding Delta is IDENTICAL to before
- New source_ref appended
- `last_compiled` updated

## Scenario 6: Query

**Setup:** Wiki has pages about transformers, attention, and GPT
**Trigger:** `/tome-forge query "what is the relationship between attention and transformers?"`
**Expected:**
- Answer references specific wiki pages
- Citations like `[wiki/ai/transformers.md]`
- If gaps exist, states what raw material is needed

## Scenario 7: Lint — Clean Wiki

**Setup:** Well-formed wiki with 5 pages
**Trigger:** `/tome-forge lint`
**Expected:**
- Reports 0 errors, 0 warnings
- May report info items for empty My Understanding Delta

## Scenario 8: Lint — Broken Wiki

**Setup:** Wiki page with missing frontmatter, broken links, missing sections
**Trigger:** `/tome-forge lint`
**Expected:**
- Reports errors for missing frontmatter and sections
- Reports warnings for broken links
- Each issue includes file path and description

## Scenario 9: Compile — Batch

**Setup:** KB with `.last_compile` from 7 days ago, 3 new raw files added since
**Trigger:** `/tome-forge compile`
**Expected:**
- Finds 3 new files
- Ingests each one
- Runs lint
- Updates `.last_compile`
- Stages changes in git
- Does NOT auto-commit

## Scenario 10: My Understanding Delta Protection (diff verification)

**Setup:** Page with human-written delta: "I think attention is fundamentally a soft dictionary lookup"
**Trigger:** `/tome-forge ingest raw/papers/new-paper.md` (paper about attention)
**Expected:**
- Ingest saves Delta copy BEFORE merge
- After writing, compares new Delta with saved copy
- If identical → passes silently
- If different → auto-restores original, logs `DELTA_RESTORED` warning
- Final page Delta is byte-for-byte identical to original

## Scenario 11: Capture Clipboard

**Trigger:** `/tome-forge capture clip`
**Expected:**
- Runs system clipboard command (xclip/pbpaste/powershell.exe)
- Saves to `raw/captures/{date}/clipboard-{HHMM}.md`
- Appends to `logs/{YYYY-MM}.md`

## Scenario 12: Ingest Dry Run

**Setup:** KB with existing wiki pages, new raw file added
**Trigger:** `/tome-forge ingest raw/papers/new-paper.md --dry-run`
**Expected:**
- Displays routing plan (which raw files → which wiki pages, create/update)
- Does NOT write any files
- Does NOT update index.md or logs

## Scenario 13: Lint Orphan Detection

**Setup:** `wiki/ai/orphan-page.md` exists but is not linked from any other page or index.md
**Trigger:** `/tome-forge lint`
**Expected:**
- Reports orphan-page.md as orphan
- Offers to move to `wiki/_orphans/`

## Scenario 14: Ingest with compiled_by Tracking

**Trigger:** `/tome-forge ingest raw/papers/paper.md`
**Expected:**
- New/updated wiki page frontmatter includes `compiled_by: <current model ID>`
- Model ID reflects actual model used (e.g. `claude-opus-4-6`)
