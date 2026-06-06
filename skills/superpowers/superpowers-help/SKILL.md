---
name: superpowers-help
description: "Use when the user types 'use superpowers-help' or asks about the superpowers workflow, commands, or how to use superpowers skills. Displays the full workflow and command reference."
---

# Superpowers Help

Display the full superpowers workflow and command reference. This is a read-only skill — it shows information, it does not execute anything.

## When to Use

- User types "use superpowers-help"
- User asks "what superpowers commands are there?"
- User asks "how do I use superpowers?"
- User asks "show me the superpowers workflow"

## Response

When triggered, display the following exactly:

---

## Superpowers Workflow

```
use brainstorming → use writing-plans → use using-git-worktrees → use subagent-driven-development → use finishing-a-development-branch
```

## All Skills (13)

| # | Command | Purpose |
|---|---------|---------|
| 1 | `use brainstorming` | Design through dialogue → spec file |
| 2 | `use writing-plans` | Spec → bite-sized implementation plan |
| 3 | `use using-git-worktrees` | Isolated workspace on new branch |
| 4 | `use subagent-driven-development` | Fresh subagent per task + two-stage review |
| 5 | `use executing-plans` | Sequential execution with checkpoints |
| 6 | `use test-driven-development` | RED-GREEN-REFACTOR enforcement |
| 7 | `use systematic-debugging` | Root cause investigation before fixes |
| 8 | `use verification-before-completion` | Evidence before claiming done |
| 9 | `use requesting-code-review` | Dispatch code-reviewer subagent |
| 10 | `use receiving-code-review` | Evaluate feedback technically |
| 11 | `use finishing-a-development-branch` | Merge/PR/keep/discard options |
| 12 | `use writing-skills` | Create new skills using TDD |
| 13 | `use superpowers-help` | This reference |

## Project Lifecycle Commands

```
# Phase 1: Design (Session 1)
"use brainstorming for [project/feature description]"
  → asks clarifying questions one at a time
  → proposes 2-3 approaches
  → presents design section by section
  → saves spec to docs/superpowers/specs/YYYY-MM-DD-topic-design.md
  → auto-chains to writing-plans
  → saves plan to docs/superpowers/plans/YYYY-MM-DD-feature.md

# You: review and edit both .md files

# Phase 2: Execute (Session 2, or continue)
"use using-git-worktrees for [feature]"
"use subagent-driven-development for the plan at [path]"
  → fresh subagent per task
  → TDD: failing test → verify fail → implement → verify pass → commit
  → two-stage review per task (spec compliance + code quality)

# Phase 3: Finish
"use finishing-a-development-branch"
  → choose: merge locally / push+PR / keep / discard
```

## During Execution

```
# Something broke
"use systematic-debugging for [problem]"

# Force test-first discipline
"use test-driven-development"

# Require proof before claiming done
"use verification-before-completion"

# Request code review
"use requesting-code-review"
```

## Multi-Session Flow (recommended for large features)

```
Session 1:  "use brainstorming for [project]"
            → spec saved → plan saved → committed

You:        review + edit .md files

Session 2:  "use using-git-worktrees for [feature], then
             use subagent-driven-development for the plan at
             docs/superpowers/plans/YYYY-MM-DD-feature.md"
            → worktree → execute task by task → finish branch
```

## Large Project (multiple subsystems)

```
Session 1:  "use brainstorming for [entire project]"
            → decomposes into sub-projects A, B, C
            → spec + plan for sub-project A

Session 2:  Execute plan A (worktree A)
Session 3:  "use brainstorming for [sub-project B]" → plan B
Session 4:  Execute plan B (worktree B)
            → independent sub-projects can run in parallel sessions
Session N:  "use brainstorming for integration testing"
```

## Sizing Guide

| Size | Skills to use |
|------|--------------|
| Small (< 30 min) | Just code it. TDD + verification still apply. |
| Medium (1-3 hrs) | brainstorming (light) → writing-plans → execute same session |
| Large (1+ day) | Full pipeline. Multi-session. Worktrees. |
| Massive (multi-day) | Decompose → sub-project cycles → parallel worktrees |

## CodeGraph Integration (optional, when available)

**IF project has `.codegraph/` directory:**

CodeGraph provides semantic code intelligence that accelerates all skills:

- **brainstorming** — `codegraph_explore` understands existing architecture before design
- **writing-plans** — `codegraph_search` finds symbols, `codegraph_files` shows structure
- **systematic-debugging** — `codegraph_callers`/`codegraph_callees` trace flows
- **verification-before-completion** — `codegraph_impact` checks blast radius before claiming done

**To enable:** Run `codegraph init -i` in project root (one-time setup).

**Key benefit:** Answers "how does X work" in 1 call vs 10+ file reads.

---
