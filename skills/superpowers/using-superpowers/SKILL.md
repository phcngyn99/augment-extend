---
name: using-superpowers
description: Use when starting any conversation - establishes how to find and use skills, requiring Skill tool invocation before ANY response including clarifying questions. Also contains the universal sequence for all coding work (7 phases, 10-11 skills minimum).
---

# Using Superpowers

**WHEN THIS SKILL IS INVOKED: ALWAYS print the Universal Sequence section (starting at "# Universal Sequence" below) in your response after explaining skill governance.**

<SUBAGENT-STOP>
If you were dispatched as a subagent to execute a specific task, skip this skill.
</SUBAGENT-STOP>

<EXTREMELY-IMPORTANT>
If you think there is even a 1% chance a skill might apply to what you are doing, you ABSOLUTELY MUST invoke the skill.

IF A SKILL APPLIES TO YOUR TASK, YOU DO NOT HAVE A CHOICE. YOU MUST USE IT.

This is not negotiable. This is not optional. You cannot rationalize your way out of this.
</EXTREMELY-IMPORTANT>

## Instruction Priority

Superpowers skills override default system prompt behavior, but **user instructions always take precedence**:

1. **User's explicit instructions** (AGENTS.md, GEMINI.md, AGENTS.md, direct requests) — highest priority
2. **Superpowers skills** — override default system behavior where they conflict
3. **Default system prompt** — lowest priority

If AGENTS.md, GEMINI.md, or AGENTS.md says "don't use TDD" and a skill says "always use TDD," follow the user's instructions. The user is in control.

## How to Access Skills

**In Augment Agent:** Use the `Skill` tool. When you invoke a skill, its content is loaded and presented to you—follow it directly. Never use the Read tool on skill files.

**In Copilot CLI:** Use the `skill` tool. Skills are auto-discovered from installed plugins. The `skill` tool works the same as Augment Agent's `Skill` tool.

**In Gemini CLI:** Skills activate via the `activate_skill` tool. Gemini loads skill metadata at session start and activates the full content on demand.

**In other environments:** Check your platform's documentation for how skills are loaded.

## Platform Adaptation

Skills use Augment Agent tool names. Non-CC platforms: see `references/copilot-tools.md` (Copilot CLI), `references/codex-tools.md` (Codex) for tool equivalents. Gemini CLI users get the tool mapping loaded automatically via GEMINI.md.

## CodeGraph Integration (when available)

**IF .codegraph/ directory exists in project root:**

CodeGraph provides semantic code intelligence via **MCP tools** (use MCP tool invocation, NOT CLI commands). Use BEFORE file reads for structural questions:

| Intent | MCP Tool (invoke via tool system) | NOT These |
|--------|-----------------------------------|-----------|
| "How does X work" / flow questions | `codegraph_explore` | CLI: `codegraph query` OR file tools: `view + grep` |
| Find symbol by name | `codegraph_search` | CLI: `codegraph query` OR file tools: `codebase-retrieval` |
| Who calls this function | `codegraph_callers` | CLI: `codegraph callers` OR `manual grep` |
| What this calls | `codegraph_callees` | CLI: `codegraph callees` OR `manual grep` |
| Impact before edit | `codegraph_impact` | CLI: `codegraph impact` OR guessing |
| Get full source + all overloads | `codegraph_node` | CLI command OR `view` (misses overloads) |
| File structure | `codegraph_files` | CLI: `codegraph files` OR `view directory` |
| Index health + stats | `codegraph_status` | CLI: `codegraph status` |

**CRITICAL:** These are **MCP tool names** available when CodeGraph MCP server is running. Use your platform's MCP tool invocation mechanism, NOT shell commands like `codegraph query` or `codegraph files <path>`.

**Reference:** See `references/codegraph-usage.md` for full CLI vs MCP tool documentation.

**Key principle:** CodeGraph answers semantic questions in 1 call vs 10+ Read/Grep cycles. Treat returned source as already Read — don't re-verify with grep.

**If .codegraph/ missing:** Offer to initialize: "Run `codegraph init -i` to enable semantic search?" Then proceed with standard file tools.

**CodeGraph is an input tool** — it accelerates discovery but doesn't bypass TDD, verification, or review gates. Skills still apply.

# Using Skills

## The Rule

**Invoke relevant or requested skills BEFORE any response or action.** Even a 1% chance a skill might apply means that you should invoke the skill to check. If an invoked skill turns out to be wrong for the situation, you don't need to use it.

```dot
digraph skill_flow {
    "User message received" [shape=doublecircle];
    "About to EnterPlanMode?" [shape=doublecircle];
    "Already brainstormed?" [shape=diamond];
    "Invoke brainstorming skill" [shape=box];
    "Might any skill apply?" [shape=diamond];
    "Invoke Skill tool" [shape=box];
    "Announce: 'Using [skill] to [purpose]'" [shape=box];
    "Has checklist?" [shape=diamond];
    "Create TodoWrite todo per item" [shape=box];
    "Follow skill exactly" [shape=box];
    "Respond (including clarifications)" [shape=doublecircle];

    "About to EnterPlanMode?" -> "Already brainstormed?";
    "Already brainstormed?" -> "Invoke brainstorming skill" [label="no"];
    "Already brainstormed?" -> "Might any skill apply?" [label="yes"];
    "Invoke brainstorming skill" -> "Might any skill apply?";

    "User message received" -> "Might any skill apply?";
    "Might any skill apply?" -> "Invoke Skill tool" [label="yes, even 1%"];
    "Might any skill apply?" -> "Respond (including clarifications)" [label="definitely not"];
    "Invoke Skill tool" -> "Announce: 'Using [skill] to [purpose]'";
    "Announce: 'Using [skill] to [purpose]'" -> "Has checklist?";
    "Has checklist?" -> "Create TodoWrite todo per item" [label="yes"];
    "Has checklist?" -> "Follow skill exactly" [label="no"];
    "Create TodoWrite todo per item" -> "Follow skill exactly";
}
```

## Red Flags

These thoughts mean STOP—you're rationalizing:

| Thought | Reality |
|---------|---------|
| "This is just a simple question" | Questions are tasks. Check for skills. |
| "I need more context first" | Skill check comes BEFORE clarifying questions. |
| "Let me explore the codebase first" | Skills tell you HOW to explore. Check first. |
| "I can check git/files quickly" | Files lack conversation context. Check for skills. |
| "Let me gather information first" | Skills tell you HOW to gather information. |
| "This doesn't need a formal skill" | If a skill exists, use it. |
| "I remember this skill" | Skills evolve. Read current version. |
| "This doesn't count as a task" | Action = task. Check for skills. |
| "The skill is overkill" | Simple things become complex. Use it. |
| "I'll just do this one thing first" | Check BEFORE doing anything. |
| "This feels productive" | Undisciplined action wastes time. Skills prevent this. |
| "I know what that means" | Knowing the concept ≠ using the skill. Invoke it. |

## Skill Priority

When multiple skills could apply, use this order:

1. **Process skills first** (brainstorming, debugging) - these determine HOW to approach the task
2. **Implementation skills second** (frontend-design, mcp-builder) - these guide execution

"Let's build X" → brainstorming first, then implementation skills.
"Fix this bug" → debugging first, then domain-specific skills.

## Skill Types

**Rigid** (TDD, debugging): Follow exactly. Don't adapt away discipline.

**Flexible** (patterns): Adapt principles to context.

The skill itself tells you which.

## User Instructions

Instructions say WHAT, not HOW. "Add X" or "Fix Y" doesn't mean skip workflows.

---

# Universal Sequence

All coding work follows this 7-phase structure. Phases 2-3-5-6 identical across all work types.

## Phase 0: Detection
- `using-superpowers` — verify compliance

## Phase 1: Investigation (bugs/refactors only)
- `systematic-debugging` — root cause

## Phase 2: Design (ALL — MANDATORY)
- `brainstorming` — explore options, save spec to `docs/superpowers/specs/YYYY-MM-DD-topic-design.md`
- `writing-plans` — bite-sized tasks, save plan to `<project-root>/docs/superpowers/plans/YYYY-MM-DD-topic.md`
- **Checkpoint:** "Design complete. Continue or pause for review?"

## Phase 3: Setup (ALL — MANDATORY)
- `using-git-worktrees` — isolated workspace + branch

## Phase 4: Execute (ALL)
- `subagent-driven-development` OR `dispatching-parallel-agents` — orchestrate tasks
  - `test-driven-development` — RED → GREEN → REFACTOR per task
  - Spec reviewer + code quality reviewer per task

## Phase 5: Verification (ALL — MANDATORY)
- `verification-before-completion` — full suite + linting + types + ≥90% coverage + smoke test
- `requesting-code-review` — dispatch reviewer, fix Critical/Important

## Phase 6: Finish (ALL — MANDATORY)
- `finishing-a-development-branch` — re-verify → merge/PR/keep/discard
- **10/15 skills (67%)**

## Phase 7: Post-Merge (if PR feedback)
- `receiving-code-review` — technical evaluation → verify → TDD fixes → update PR
- **11/15 skills (73%)**

---

**Testing mandate (all phases):**
- 5+ tests per task minimum
- 20+ tests per feature
- 90%+ coverage target
- Unit + integration + edge + error + regression
- Full suite GREEN before merge

**Invariants:**
- Phases 2-3-5-6 identical all work types
- Always ≥10 skills
- No skipping design, isolation, verification, or review
