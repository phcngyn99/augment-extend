# CONTEXT.md Usage Rule

When working in a codebase, check for and use the project's domain glossary to communicate precisely and concisely.

---

## Core Principle

**CONTEXT.md** is a domain glossary — the project's ubiquitous language (DDD). Use it to replace verbose explanations with precise terms, name code consistently, and reduce token usage.

---

## On First Codebase Exploration

**Check for domain documentation:**

```bash
# Single-context repos (most common)
CONTEXT.md                    # glossary
docs/adr/                     # architectural decisions

# Multi-context repos (large codebases)
CONTEXT-MAP.md                # points to each context
src/ordering/CONTEXT.md
src/ordering/docs/adr/
src/billing/CONTEXT.md
src/billing/docs/adr/
```

**If CONTEXT.md exists:**
- Read it immediately
- Use glossary terms throughout session
- Update it when new terms crystallize (via `/grill-with-docs`)

**If missing:**
- Operate normally
- Suggest creating one when terminology becomes fuzzy
- Use `/grill-with-docs` to build it inline

---

## Using the Glossary

### In Responses

**DON'T:**
"There's a problem when a lesson inside a section of a course is made 'real' (i.e. given a spot in the file system)"

**DO:**
"There's a problem with the materialization cascade"

### In Code

**Variable/function/class names use glossary terms:**

```typescript
// DON'T
function makeRealLesson(lesson: Lesson) { ... }

// DO (if glossary defines "materialization")
function materializeLesson(lesson: Lesson) { ... }
```

### When Terms Conflict

**If user uses term differently than glossary:**

Stop immediately:
> "Your glossary defines 'cancellation' as full order cancellation, but you seem to mean partial line-item cancellation — which is it?"

Wait for clarification, then update CONTEXT.md if term changes.

---

## Updating CONTEXT.md

**Via `/grill-with-docs`:**
- Updates happen inline during grilling
- New terms added immediately when resolved
- Fuzzy language sharpened into canonical terms

**Manual updates (when not grilling):**
- Only when new concept crystallizes
- Keep entries concise (1-2 sentences max)
- Glossary only — no implementation details

**What NOT to add:**
- Implementation decisions → use ADRs instead
- File paths or code snippets
- Process documentation
- Temporary notes

---

## Integration with Other Tools

**CodeGraph + CONTEXT.md:**
- CodeGraph: finds code structure (`processOrder` calls `validatePayment`)
- CONTEXT.md: explains domain meaning (`Order` = customer purchase request)
- Use both: "The `Order` intake module (via `processOrder`) validates `Payment` before updating `Inventory`"

**Skills + CONTEXT.md:**
- `/improve-codebase-architecture` — uses glossary to name deepened modules
- `/to-prd` — PRDs written in domain vocabulary
- `/to-issues` — issue titles use canonical terms
- `/zoom-out` — broader context explained with glossary
- `/prototype` — prototype comments reference domain concepts

---

## Multi-Context Repos

**If CONTEXT-MAP.md exists:**
- Read map first
- Identify which context you're working in
- Use that context's CONTEXT.md
- System-wide decisions → root `docs/adr/`
- Context-specific decisions → context's `docs/adr/`

**Example:**
```
Working in src/ordering/ → use src/ordering/CONTEXT.md
Cross-context change → reference both glossaries, note conflicts in CONTEXT-MAP.md
```

---

## Benefits

**Token savings:**
- 1 word replaces 20-word explanations
- ~75% reduction in verbosity
- Fewer thinking tokens (concise = clearer)

**Code quality:**
- Consistent naming across files
- Easier navigation (semantic, not just syntactic)
- Domain experts and devs speak same language

**Maintenance:**
- New team members read glossary → instant vocabulary
- Agents resume sessions with shared language intact
- Reduces "what does X mean?" questions

---

## When to Suggest Creating CONTEXT.md

**Triggers:**
- User repeatedly uses project-specific jargon
- Same concept described multiple ways
- Code has inconsistent naming for same domain concept
- Complex domain with many specialized terms

**Don't suggest:**
- Simple CRUD apps with standard terms
- Prototypes or throwaway code
- First 10 minutes of a new project (too early)

---

## Banner

When reading or updating CONTEXT.md proactively:

`[■] TOOL: view — reading domain glossary (CONTEXT.md)`

No banner when user explicitly invokes `/grill-with-docs` (skill handles announcement).

---

## Summary

**Check for CONTEXT.md on first exploration. Use glossary terms everywhere. Update inline via `/grill-with-docs`. Combine with CodeGraph for semantic + domain understanding.**
