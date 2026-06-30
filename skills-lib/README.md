# Skills Library Catalog

Optional/advanced skills requiring external dependencies or specialized capabilities.

## Quick Reference

| Skill | Use When | Dependencies |
|-------|----------|--------------|
| **cavecrew** | Delegate tasks to compressed-output subagents | Augment runtime |
| **caveman-compress** | Shrink prose files (~75% token savings) | Anthropic API |
| **domain-modeling** | Build/maintain domain glossary + ADRs | None |
| **grill-with-docs** | Stress-test plan + generate docs | grilling + domain-modeling |
| **grilling** | Stress-test plan/design before building | None |
| **karpathy-guidelines** | Reduce LLM coding mistakes (overcomplication, etc.) | None |
| **ppt-master** | Generate presentations from sources | External APIs |

---

## cavecrew

**When:** Delegate to compressed-output subagents (locate code / edit 1-2 files / review diff)

**What:** Three subagent presets that return ~60% smaller output → main context lasts longer

**Triggers:** "delegate to subagent", "use cavecrew", "save context"

**Agents:**
- `cavecrew-investigator` - locate code (defs/callers/uses)
- `cavecrew-builder` - surgical edit ≤2 files
- `cavecrew-reviewer` - review diff for bugs

**Dependency:** Augment subagent runtime

---

## caveman-compress

**When:** Reduce token usage of prose files (CLAUDE.md, todos, preferences)

**What:** Strip filler/articles/pleasantries. Preserve code/URLs/technical terms exact. Backup as `.original.md`

**Triggers:** `/caveman-compress <filepath>`, "compress memory file"

**Dependency:** Anthropic API (calls Claude for compression)

---

## domain-modeling

**When:** Pin down domain terminology, record architectural decisions, maintain ubiquitous language

**What:** 
- Challenge fuzzy terms
- Update `CONTEXT.md` with canonical definitions
- Create ADRs sparingly (hard-to-reverse + surprising + real tradeoff)
- Cross-reference code vs stated concepts

**Triggers:** User wants domain terminology/glossary, another skill needs domain model

**Dependency:** None

---

## grill-with-docs

**When:** Stress-test plan/design AND generate documentation (ADRs + glossary)

**What:** Wrapper that runs grilling + domain-modeling together

**Triggers:** User wants interrogation + docs output

**Dependency:** grilling + domain-modeling skills

**Note:** `disable-model-invocation: true` (meta-skill, delegates only)

---

## grilling

**When:** Stress-test existing plan/design before implementation

**What:**
- Relentless interview about plan
- One question at a time
- Provide recommended answer per question
- Explore codebase when question answerable that way

**Triggers:** "grill this plan", "stress-test design", "challenge assumptions"

**Dependency:** None

---

## karpathy-guidelines

**When:** Writing, reviewing, or refactoring code to avoid common LLM mistakes

**What:**
- Think before coding (surface assumptions, ask when unclear)
- Simplicity first (no speculative features/abstractions)
- Surgical changes (touch only what you must)
- Goal-driven execution (define verifiable success criteria)

**Triggers:** "use karpathy-guidelines", code review, refactoring tasks

**Dependency:** None

---

## ppt-master

**When:** Create presentations from source materials (PDF/DOCX/URL/Markdown)

**What:** Multi-step AI pipeline:
1. Convert sources → structured Markdown
2. Strategic planning (template selection)
3. AI-driven design spec
4. Generate SVG pages (live preview)
5. Export to PPTX

**Triggers:** "create PPT", "make presentation", "生成PPT", "做PPT", "ppt-master"

**Dependency:** External APIs (complex, 730-line skill)

---

## Installation Notes

All skills-lib entries are symlinks to submodules. They load on-demand, not by default.

**Core skills** (always available): see `skills/` directory  
**Optional skills** (this catalog): require explicit invocation or dependencies
