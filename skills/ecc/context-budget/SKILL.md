---
name: context-budget
description: Audits Augment context consumption using native /context command. Analyzes component overhead (agents, skills, rules, MCP), identifies bloat, produces prioritized optimizations.
origin: ECC (Augment-adapted)
---

# Context Budget (Augment)

Analyze context consumption using Augment's native `/context` command, then break down component overhead and surface optimizations.

## When to Use

- Session at 70%+ tokens (check with `/context`)
- Output quality degrading
- Added skills/agents/MCP servers recently
- Need to know headroom before adding components
- User runs `/context-budget`

## How It Works

### Phase 0: Get Ground Truth

Run Augment's `/context` command first — parse output for:
- Total used/max tokens + %
- System prompt tokens
- Built-in tools tokens
- MCP tools tokens
- Messages tokens

This is **authoritative** — use these numbers, not estimates.

### Phase 1: Component Breakdown

Scan files to break down the system prompt overhead:

**Agents** (`~/.augment/agents/`)
- Count files + total lines
- Extract `description` frontmatter (loads into Task tool always)
- Flag: >200 lines (heavy), description >30 words (bloated)

**Skills** (`~/.augment/skills/`)
- Count SKILL.md files + total lines
- YAML frontmatter (`name`/`description`) loads into available_skills
- Flag: >400 lines

**Rules** (`~/.augment/rules/`)
- Count files + total lines
- All rules load into every session (User Rules = always)
- Flag: >100 lines, detect overlap

**MCP Servers** (from `/context` MCP tools count)
- Parse server count + tool count from ground truth
- Flag: >10 servers, >50 total tools, CLI-replaceable servers

### Phase 2: Classify

| Bucket | Criteria | Action |
|--------|----------|--------|
| **Core** | Superpowers, session-lifecycle, caveman, priority rules | Keep |
| **Project-match** | Language-specific (matches current project stack) | Keep |
| **Dormant** | Language/domain skills not matching project | Consider removing |
| **Redundant** | Duplicate logic between skills/agents/rules | Merge or remove |

### Phase 3: Issues

- **Bloated descriptions** — agent/skill description >30 words (loads always)
- **Heavy files** — agents >200 lines, skills >400 lines, rules >100 lines
- **Language mismatch** — Python/Go/Rust/Java skills when project is TypeScript/Node
- **MCP bloat** — >10 servers, >50 tools, CLI-replaceable servers
- **Redundant** — skills duplicate agent logic, rules duplicate each other

### Phase 4: Report

```
Context Budget (Augment)
══════════════════════════════════════

Ground Truth (/context):
Used: XXXk/200k (XX%) | Available: XXk (XX%)

Breakdown:
├ System prompt: XXk (XX%) ← agents + skills + rules
├ Built-in tools: XXk (XX%)
├ MCP tools: XXk (XX%) ← N servers, N tools
└ Messages: XXk (XX%)

Component Detail:
┌──────────┬───────┬────────┬──────────┐
│ Type     │ Count │ Lines  │ Est. Tok │
├──────────┼───────┼────────┼──────────┤
│ Agents   │ N     │ X,XXX  │ ~X,XXX   │
│ Skills   │ N     │ X,XXX  │ ~X,XXX   │
│ Rules    │ N     │ XXX    │ ~XXX     │
└──────────┴───────┴────────┴──────────┘

Issues (N):
1. [issue] → save ~X,XXX tokens
2. [issue] → save ~X,XXX tokens
3. [issue] → save ~X,XXX tokens

Potential savings: ~XXk tokens (XX% of system prompt)
```

Verbose mode: per-file breakdown, heaviest files, redundancy details, MCP server list.

## Examples

**Basic**
```
User: /context-budget
Agent: Runs /context → 147.8k/200k (73.9%)
       Scans components → 38 agents (15k lines), 100 skills (25k lines), 5 rules (300 lines)
       MCP: 5 servers, 30 tools (4.7k tokens)
       Issues: 12 language-mismatch skills (Python/Go/Rust), 3 heavy agents
       Top saving: remove 12 dormant skills → save ~8k tokens (36% of system prompt)
```

**Verbose**
```
User: /context-budget --verbose
Agent: Full report + per-file (planner.md 213 lines, 1.8k est. tokens)
       MCP detail: Context7 (8 tools), playwright (12 tools), etc.
```

**Pre-add check**
```
User: Can I add 3 MCP servers?
Agent: Current 73.9%, adding 3 servers (~20 tools, ~3k tokens) → 75.4%
       Recommend: wait until fresh session or remove dormant skills first
```

## Best Practices

- **Always run `/context` first** — ground truth over estimates
- **Token estimation**: `words × 1.3` prose, `chars / 4` code (for component breakdown only)
- **MCP biggest lever**: built-in tools (38.7k) fixed, MCP tools variable
- **Descriptions load always**: agent/skill frontmatter in every session
- **Audit after changes**: run after adding agents/skills/MCP
- **Target <40% system prompt**: leaves room for long conversations

## Augment-Specific Notes

- `/context` command is authoritative — parse its output first
- System prompt includes: rules (always), skill frontmatter (available_skills), agent descriptions (Task tool)
- Built-in tools (38.7k) are fixed — can't optimize
- MCP tools grow with server count — biggest optimization target
- Messages grow during session — checkpoint at 70% total usage
