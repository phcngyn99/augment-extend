# Session Lifecycle Rules

---

## Rule 0: Transparency — Announce Activations

**MANDATORY — NEVER SKIP. Missing a banner is a rule violation.**

Print a one-line banner in your response text immediately before EVERY activation. No exceptions — not for parallel calls, not for session start, not for implicit skill invocations triggered by agents.

Format:

- `[●] RULE: <name> — <action>`
- `[◆] SKILL: <name> (<superpowers|ecc>) — <reason>`
- `[▲] AGENT: <name> — <task>`
- `[■] TOOL: <name> — <what>`
- `[!] SAFETY: <command> — confirm? (yes/no)`

**Action tools that REQUIRE `[■]` banners:**
- Write/execute: `launch-process`, `save-file`, `str-replace-editor`, `remove-files`
- External: `web-search`, `web-fetch`, `github-api`
- User-facing: `ask-user`

**`[●]` RULE banners fire for:** session-start hook, auto-save trigger, safety guard, context pressure check, caveman activation — ANY rule activation.

**`[◆]` SKILL banners fire for:** ANY skill referenced or loaded, even if triggered inside a sub-agent.

**Parallel calls:** Print ALL banners as a block BEFORE the tool calls. Example:
```
[●] RULE: caveman — full mode active
[●] RULE: session-lifecycle — auto-resume
[■] TOOL: web-search — Augment release notes
[■] TOOL: save-file — /tmp/test.txt
[■] TOOL: github-api — check open PRs
[▲] AGENT: docs-lookup — Next.js App Router
```

**No banner for read-only/internal tools:** `view`, `codebase-retrieval`, `read-process`, `list-processes`, `view_tasklist`, `update_tasks`, `add_tasks`, `reorganize_tasklist`, `sequentialthinking`

One line per banner. No box formatting.

---

## Rule 1: Session Start — Auto-Resume

At the start of every conversation, before anything else:

1. Print: `[●] RULE: caveman — full mode active` (always — caveman rule is always loaded)
2. Run: `node "$HOME/.augment/skills/ecc/ck/hooks/session-start.mjs"`
3. If project is registered: display the compact briefing (goal, left off, next steps).
4. If not registered: ask if the user wants to register it. If yes, run `/ck:init` flow.

---

## Rule 2: Auto-Save Context

### Triggers

- **Session end** — user says "bye", "done", "wrap up", or similar.
- **Git operations** — after `git commit`, `git merge`, or `git push` completes.
- **Milestones** — PR created, feature done, bug fixed, tests passing.

### Mode Selection

**Normal save (default):**
- Use `/ck:save` — saves JSON to context.json
- Auto-triggered by the events above

**Handoff mode (agent transfer):**
- User says "handoff" or "create handoff doc"
- Use `/ck:handoff [focus]` — saves JSON + creates portable markdown doc
- See ck skill for full handoff documentation

### Save flow

1. Analyze the conversation and build:
   - `summary`: one sentence, what was accomplished
   - `leftOff`: what was actively being worked on
   - `nextSteps`: concrete next steps (array)
   - `decisions`: `[{what, why}]` for key decisions
   - `blockers`: array (empty if none)
   - `activeFiles`: array of file paths being edited (**strongly recommended**, max 10)
   - `codeContext`: brief code state with file:line references (**strongly recommended**)
   - `errorState`: current error — string or `{expected, actual, location}` object (include when debugging)
   - `failedApproaches`: approaches already tried (include when iterating)
   - `taskProgress`: progress snapshot (include on multi-step work)
   - `suggestedSkills`: skills to invoke in next session (**only for `/ck:handoff`**)

2. **Write structured-terse** — not verbose prose, not naive caveman grunts. Preserve decision chains and disambiguation.

   **Word budgets:** `summary` ≤10 words · `leftOff` ≤30 words · each `nextStep` ≤15 words · each `decision.what` ≤20 words

   **Principles:**
   - Anchor on changes, dependencies, and unresolved items — not process narrative
   - Include file:line references in `codeContext` and `errorState`
   - No filler: drop "I was working on", "The next thing to do would be", "Successfully completed"
   - Keep arrays short — 3-5 items max per field
   - Empty = omit. Don't write `"blockers": []` with placeholder text

   **Examples:**

   | Field |  Verbose |  Caveman grunt |  Structured-terse |
   |-------|-----------|-----------------|---------------------|
   | `summary` | "Successfully implemented JWT authentication with refresh token rotation" | "impl auth" | "JWT auth with refresh rotation" |
   | `leftOff` | "I was working on the refresh token rotation but hadn't finished the integration tests yet" | "refresh WIP" | "Refresh token rotation — impl done, integration tests pending" |
   | `nextSteps` | "The next thing to do would be to write integration tests for the auth flow" | "write test" | "Integration tests for auth refresh flow" |
   | `decisions` | "We decided to use RS256 algorithm instead of HS256 because it supports key rotation" | "RS256" | "RS256 over HS256 — supports key rotation without secret sharing" |

3. Save immediately — no confirmation prompt. The triggering action was already user-confirmed.
4. Run `/ck:save` (normal) or `/ck:handoff` (agent transfer mode)

### Continuous learning (session end only)

Review the conversation for reusable patterns in these categories:
error_resolution, user_corrections, workarounds, debugging_techniques, project_specific.

Skip typos, one-time fixes, and external API issues. If patterns found, present each for approval. If approved, save to `~/.augment/skills/learned/<pattern-name>/SKILL.md`. If none found, skip silently.

---

## Rule 3: Context Pressure — Proactive Checkpoints

**You are responsible for monitoring context pressure. Do not wait for the user to ask.**

### Automatic checkpoints — announce and save at these moments:
1. **After completing a major task** (feature done, bug fixed, research delivered)
2. **After 50+ tool calls** in the session
3. **When switching to a completely different topic**
4. **After any research delegation** (sub-agent results add bulk)

### What to do at a checkpoint:
1. Announce: `[●] RULE: context-pressure — checkpoint, saving context`
2. Run ck save with current state (summary, left off, next steps, decisions)
3. Tell the user: "Context is getting heavy. Recommend starting a fresh session — I'll auto-resume."

### Do NOT checkpoint:
- Mid-implementation (losing variable names and partial state is costly)
- During active debugging (preserve error context)

### If the user ignores the suggestion:
- Continue working but note that quality may degrade
- Repeat the suggestion after the next logical breakpoint

---

## Rule 4: Safety Guard

Before any destructive command (`rm -rf`, `DROP TABLE`, `git push --force`, production deploys, branch deletion):

`[!] SAFETY: <the command> — confirm? (yes/no)`

Never auto-execute destructive operations.