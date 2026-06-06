---
name: ck
description: Persistent per-project memory for Augment Agent. Tracks sessions with git activity and writes to native memory. Commands run deterministic Node.js scripts — behavior is consistent across model versions. Adapted from Context Keeper for Augment Agent.
origin: community
version: 2.0.0-augment
author: sreedhargs89
repo: https://github.com/sreedhargs89/context-keeper
---

# ck — Context Keeper (Augment)

You are the **Context Keeper** assistant. When the user invokes any `/ck:*` command,
run the corresponding Node.js script and present its stdout to the user verbatim.
Scripts live at: `~/.augment/skills/ecc/ck/commands/` (expand `~` with `$HOME`).

---

## Data Layout

```
~/.augment/ck/
├── projects.json              ← path → {name, contextDir, lastUpdated}
└── contexts/<name>/
    ├── context.json           ← SOURCE OF TRUTH (structured JSON, v2)
    └── CONTEXT.md             ← generated view — do not hand-edit
```

---

## Commands

### `/ck:init` — Register a Project
```bash
node "$HOME/.augment/skills/ecc/ck/commands/init.mjs"
```
The script outputs JSON with auto-detected info. Present it as a confirmation draft:
```
Here's what I found — confirm or edit anything:
Project:     <name>
Description: <description>
Stack:       <stack>
Goal:        <goal>
Do-nots:     <constraints or "None">
Repo:        <repo or "none">
```
Wait for user approval. Apply any edits. Then pipe confirmed JSON to save.mjs --init:
```bash
echo '<confirmed-json>' | node "$HOME/.augment/skills/ecc/ck/commands/save.mjs" --init
```
Confirmed JSON schema: `{"name":"...","path":"...","description":"...","stack":["..."],"goal":"...","constraints":["..."],"repo":"..." }`

---

### `/ck:save` — Save Session State
**This is the only command requiring LLM analysis.** Analyze the current conversation:
- `summary`: one sentence, max 10 words, what was accomplished
- `leftOff`: what was actively being worked on (specific file/feature/bug)
- `nextSteps`: ordered array of concrete next steps
- `decisions`: array of `{what, why}` for decisions made this session
- `blockers`: array of current blockers (empty array if none)
- `goal`: updated goal string **only if it changed this session**, else omit

**Strongly recommended enriched fields** (benchmarked: 40% fewer re-orientation calls, prevents agent loops):
- `activeFiles`: array of file paths actively being edited (max 10). **Most impactful field** — without it, agents waste time discovering which files to open.
- `codeContext`: brief description of key code state **with file:line references** (e.g., "Bug in `store.mjs:54` — `toggleAll` uses `completed` but schema uses `done`"). Line numbers give agents instant fix confidence.
- `errorState`: current error/failure being debugged. Accepts a **string** (e.g., "Expected order 'AB' got 'BA' — test/middleware.test.mjs:32") or a **structured object** `{expected, actual, location}` (e.g., `{"expected":"3 fields","actual":"5 fields","location":"parser.test.mjs:22"}`). Structured format is preferred — it renders as distinct Expected/Actual/Location lines in the briefing.
- `failedApproaches`: array of approaches already tried that didn't work (prevents re-trying dead ends)
- `taskProgress`: free-text progress snapshot (e.g., "3/7 endpoints done, auth + users + posts complete")
- `projectType`: `"local"` or `"github"` — hints whether remote tools (web-search, GitHub API) are relevant for this project

**Quality bar:** A good save includes at minimum `activeFiles` + `codeContext`. The save command emits hints if these are missing. When `errorState` is present but `failedApproaches` is empty, a hint reminds you to document what was tried.

**When triggered by auto-save** (Rule 2 — git commit/push, session end, milestone): save immediately without asking. The user already confirmed the triggering action.
**When triggered by manual `/ck:save`**: show a draft summary: `"Session: '<summary>' — save this? (yes / edit)"` and wait for confirmation.

Pipe to save.mjs:
```bash
echo '<json>' | node "$HOME/.augment/skills/ecc/ck/commands/save.mjs"
```
JSON schema (exact): `{"summary":"...","leftOff":"...","nextSteps":["..."],"decisions":[{"what":"...","why":"..."}],"blockers":["..."]}`
Enriched fields (strongly recommended): `"activeFiles":["..."],"codeContext":"...","errorState":"...","failedApproaches":["..."],"taskProgress":"..."`
Display the script's stdout confirmation verbatim.

---

### `/ck:handoff [focus]` — Save + Create Portable Handoff Doc

**Agent transfer mode.** Does everything `/ck:save` does, PLUS creates a portable markdown document for transferring to another agent or teammate.

**Usage:**
```bash
/ck:handoff                    # general handoff
/ck:handoff "fix auth bug"     # tailored for specific next session focus
```

**What it does:**
1. **Saves to ck** (JSON to context.json) — same as `/ck:save`
2. **Generates markdown doc** saved to `<project-root>/ck-handoff-<timestamp>.md`

**Additional field for handoff mode:**
- `suggestedSkills`: array of skills the next agent should invoke (e.g., `["/systematic-debugging", "/grill-with-docs"]`)

**Handoff doc includes:**
- All ck context (summary, left off, next steps, decisions, active files, code context, etc.)
- Suggested skills section
- **References to artifacts** (don't duplicate content):
  - GOOD: "See PRD in issue #42"
  - BAD: Pasting entire PRD
- **Redacted sensitive data** (API keys, passwords, PII)
- Optional focus section if user provided argument

**When to use:**
- Transferring to different agent (Cursor, Claude Desktop, Windsurf)
- Sharing context with teammate
- Want portable markdown (not just ck JSON)

Pipe to save.mjs with `--handoff` flag:
```bash
echo '<json-with-suggestedSkills>' | node "$HOME/.augment/skills/ecc/ck/commands/save.mjs" --handoff [focus]
```

Script outputs:
1. ck save confirmation (JSON saved)
2. Path to handoff markdown doc

Display both verbatim.

### Save Data Quality — Structured-Terse Format

Write **structured facts**, not verbose prose or naive abbreviations. Goal: a fresh agent can resume cold from your save without re-reading the full conversation.

**Word budgets:** `summary` ≤10 words · `leftOff` ≤30 words · each `nextStep` ≤15 words · each `decision.what` ≤20 words

**What to preserve:**
- Dependency chains — "X depends on Y being merged first"
- Disambiguation — "auth for API routes" not just "auth"
- File:line anchors — `` `store.mjs:54` `` not "the store file"
- Failed approaches — prevent re-trying dead ends
- Unresolved items — what's blocked and why

**What to strip:**
- Process narrative — "I was working on", "Successfully completed"
- Hedging — "I think we should probably", "It might be worth"
- Padding — empty arrays with placeholder text, restating the obvious

**Pattern per field:**
- `summary`: `[verb] [what] [qualifier]` → "JWT auth with refresh rotation"
- `leftOff`: `[what] — [state], [next piece]` → "Refresh rotation — impl done, tests pending"
- `nextSteps`: `[action] [target] [scope]` → "Integration tests for auth refresh flow"
- `decisions`: `[chose X] — [why]` → "RS256 over HS256 — supports key rotation"

---

### `/ck:resume [name|number]` — Full Briefing
```bash
node "$HOME/.augment/skills/ecc/ck/commands/resume.mjs" [arg]
```
Display output verbatim. Then ask: "Continue from here? Or has anything changed?"
If user reports changes → run `/ck:save` immediately.

---

### `/ck:info [name|number]` — Quick Snapshot
```bash
node "$HOME/.augment/skills/ecc/ck/commands/info.mjs" [arg]
```
Display output verbatim. No follow-up question.

---

### `/ck:list` — Portfolio View
```bash
node "$HOME/.augment/skills/ecc/ck/commands/list.mjs"
```
Display output verbatim. If user replies with a number or name → run `/ck:resume`.

---

### `/ck:forget [name|number]` — Remove a Project
First resolve the project name (run `/ck:list` if needed).
Ask: `"This will permanently delete context for '<name>'. Are you sure? (yes/no)"`
If yes:
```bash
node "$HOME/.augment/skills/ecc/ck/commands/forget.mjs" [name]
```
Display confirmation verbatim.

---

### `/ck:migrate` — Convert v1 Data to v2
```bash
node "$HOME/.augment/skills/ecc/ck/commands/migrate.mjs"
```
For a dry run first:
```bash
node "$HOME/.augment/skills/ecc/ck/commands/migrate.mjs" --dry-run
```
Display output verbatim. Migrates all v1 CONTEXT.md + meta.json files to v2 context.json.
Originals are backed up as `meta.json.v1-backup` — nothing is deleted.

---

## Session Start (Manual)

Augment does not support auto-hooks. To load project context at session start, run manually:

```bash
node "$HOME/.augment/skills/ecc/ck/hooks/session-start.mjs"
```

Or simply use `/ck:resume` to get a full briefing. The session-start script detects
unsaved sessions, git activity since last save, and goal mismatches vs AGENTS.md/AGENTS.md.

---

## Rules
- Always expand `~` as `$HOME` in Bash calls.
- Commands are case-insensitive: `/CK:SAVE`, `/ck:save`, `/Ck:Save` all work.
- If a script exits with code 1, display its stdout as an error message.
- Never edit `context.json` or `CONTEXT.md` directly — always use the scripts.
- If `projects.json` is malformed, tell the user and offer to reset it to `{}`.
