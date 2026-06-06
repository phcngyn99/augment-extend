# Changelog

Notable changes.

---

## 2026-06-06

### Code Quality
- Removed all emojis from tracked files
- `README.md` — replaced checkmark/lock with plain text
- `skills/ecc/ck/SKILL.md` — checkmark/cross → GOOD/BAD
- `skills/ui-ux-pro-max/SKILL.md` — removed emoji from table
- Complies with `rules/caveman-no-fucking-emoji.md` (no emojis in conversation text)

---

## 2026-06-05

### Superpowers Workflow Orchestrator
- Added `skills/superpowers/superpowers-workflow/` — master orchestrator (10-11/15 skills, 67-73%)
- 6 flows: Feature Development, Bug Fix, Quick Fix, Refactor, Investigation, Parallel Work
- Auto-detects work type from keywords ("bug" → Bug Fix Flow, "add" → Feature Flow, etc)
- Every flow uses 10-11 skills minimum, no shortcuts
- Quick Fix = compressed execution (2 questions, 3-5 tasks), still full verification
- Updated `rules/superpowers-priority.md` — superpowers-workflow now PRIMARY checklist entry
- Default for all coding tasks, individual skills now INDIVIDUAL section
- Added `writing-skills` to activation checklist

### Skill Description Compliance
- Fixed 4 custom skills to comply with `writing-skills` standards
- `create-adr`, `create-makefile`, `create-readme`, `create-usage` — all now start with "Use when..."
- Moved triggers to start, outcomes to end (no workflow summary in triggers)
- All 10 custom skills now compliant with description format rules

### Documentation Updates
- README.md: 98 → 99 skills (14 → 15 superpowers)
- CATALOG.md: Added superpowers-workflow as PRIMARY entry point
- CHANGELOG.md: This entry

---

## 2026-06-04

### ck Handoff Mode
- Added `/ck:handoff [focus]` — portable agent transfer docs
- Saves to `<project-root>/ck-handoff-<timestamp>.md` (not $TMPDIR)
- Includes: summary, state, next steps, decisions, active files, code context, suggested skills
- Auto-redacts: API keys, emails, secrets via regex
- Use case: transfer to Cursor/Claude Desktop/teammate
- Merged handoff into ck skill + session-lifecycle rule
- Tested: full workflow in ~/Downloads/ck-test-project

### Matt Pocock Skills (Tier 1)
- Adapted 6 engineering skills from [mattpocock/skills](https://github.com/mattpocock/skills)
- `grill-with-docs` — grilling + CONTEXT.md + ADR inline (DDD ubiquitous language)
- `improve-codebase-architecture` — deepening opportunities (John Ousterhout)
- `to-issues` / `to-prd` — PRD workflow
- `zoom-out` / `prototype` — context + prototypes
- Added `rules/context-md-usage.md` — domain glossary integration

### CodeGraph Priority
- Added `rules/codegraph-priority.md` — semantic analysis before file-based tools
- Use CodeGraph for: callers/impact before refactors, explore for flow, search over grep
- NOT for docs/config (use view)

### Context Budget (Augment)
- Adapted `skills/ecc/context-budget/` for Augment's `/context` command
- Authoritative token counts: system prompt (22k), built-in tools (38.7k), MCP tools, messages
- Component analysis on top of native command

### Karpathy Guidelines
- Added `skills/karpathy-guidelines/` — reduce LLM coding mistakes
- 4 principles: Think Before Coding, Simplicity First, Surgical Changes, Goal-Driven
- From [Andrej Karpathy](https://x.com/karpathy/status/2015883857489522876), [multica-ai](https://github.com/multica-ai/andrej-karpathy-skills)
- Impact: less overcomplication, questions before code, surgical changes

---

## 2026-04-03

### Initial Setup
- 3 plugins adapted: Superpowers (14 skills, 1 agent), ECC (~130 skills, 37 agents), UI/UX Pro Max (design DB)
- `.claude/` → `.augment/`
- Session lifecycle rules: transparency banners, auto-resume, auto-save, continuous-learning inline
- Priority: Superpowers > ECC
- ck centralized at `~/.augment/ck/`
- Docs: INSTALL.md, SKILLS-AND-AGENTS.md, README.md

---

## 2026-04-04

### MCP Servers
- 4 free: Context7 (docs), iterm-mcp (terminal), playwright (browser), sequential-thinking (reasoning)
- Paid (deferred): Exa, Firecrawl, fal.ai, Jira, Nutrient, LaraPlugins

---

### Security
- `session.json` excluded (auth)
- Gitignored: sessions, checkpoints, tasks, ck contexts, prompt history
