# Priority Rule: Superpowers over ECC

**ALWAYS use superpowers skills and agents. No exceptions.** Superpowers is the ONLY framework for core workflows.

**Using ECC equivalents when superpowers exists is a critical failure.**

---

## MANDATORY: Pre-Work Activation Checklist

Before responding to ANY user request, check this list. If ANY condition matches, invoke the skill FIRST:

**PRIMARY (use this for full workflows):**

- [ ] **ANY coding task** — follow universal sequence in `using-superpowers` skill (7 phases, 10-11 skills minimum)

**INDIVIDUAL (use only if user explicitly requests specific skill, or workflow not applicable):**

- [ ] **Writing feature/bugfix** → `test-driven-development`
- [ ] **Bug/test failure/unexpected behavior** → `systematic-debugging`
- [ ] **About to claim "done"/"fixed"/"passing"** → `verification-before-completion`
- [ ] **Creative work/new feature/design** → `brainstorming`
- [ ] **Multi-step task/complex feature** → `writing-plans`
- [ ] **Receiving code review feedback** → `receiving-code-review`
- [ ] **2+ independent tasks** → `dispatching-parallel-agents`
- [ ] **Completing work (tests pass, ready to merge)** → `requesting-code-review`
- [ ] **Starting feature work needing isolation** → `using-git-worktrees`
- [ ] **Implementation complete, need to integrate** → `finishing-a-development-branch`
- [ ] **Executing a plan with independent tasks** → `subagent-driven-development`
- [ ] **Executing a plan in separate session** → `executing-plans`
- [ ] **Creating/editing skills** → `writing-skills`

**Violation penalty:** Using ECC instead of superpowers = critical failure. Using ECC when superpowers exists = ignoring user's absolute requirement.

---

## Workflow

Before implementing, debugging, planning, or reviewing:

1. Check mandatory activation checklist above
2. **DEFAULT: For any coding task, follow universal sequence** (see `using-superpowers` skill for 7-phase structure)
3. If user explicitly requests individual skill, use that specific skill
4. If no checklist match, check if superpowers has a skill for this task
5. If yes, use superpowers skill/agent — NEVER use ECC equivalent
6. If no superpowers equivalent exists, use ECC
7. If neither, proceed without framework

**Absolute rule: When superpowers and ECC both cover a domain, ALWAYS use superpowers. Zero exceptions.**

**Universal sequence is the primary workflow for all coding work. Phases 2-3-5-6 identical across all work types.**

## Agent Priority

**NEVER use ECC agents when superpowers equivalent exists:**

| Task | ALWAYS Use This | NEVER Use These |
|------|----------------|-----------------|
| Code review | `sub-agent-code-reviewer` (superpowers) | `sub-agent-code-reviewer` (ecc) |
| TDD guidance | `skills/superpowers/test-driven-development` | `sub-agent-tdd-guide` (ecc) |
| Planning | `skills/superpowers/writing-plans` | `sub-agent-plan` (ecc), `sub-agent-planner` (ecc) |

## Skill Priority

**NEVER use ECC skills when superpowers equivalent exists:**

| Domain | ALWAYS Use This (superpowers) | NEVER Use These (ecc) |
|--------|-------------------------------|----------------------|
| Code review | `skills/superpowers/requesting-code-review`, `receiving-code-review` | Any ECC code review skills |
| TDD / Testing | `skills/superpowers/test-driven-development` | `skills/ecc/tdd-workflow` |
| Planning | `skills/superpowers/writing-plans`, `executing-plans` | `skills/ecc/blueprint` |
| Debugging | `skills/superpowers/systematic-debugging` | `skills/ecc/click-path-audit`, any ECC debugging skills |
| Verification | `skills/superpowers/verification-before-completion` | `skills/ecc/verification-loop` |
| Subagent orchestration | `skills/superpowers/subagent-driven-development`, `dispatching-parallel-agents` | Any ECC orchestration skills |
| Git workflow | `skills/superpowers/using-git-worktrees`, `finishing-a-development-branch` | `skills/ecc/git-workflow` |
| Brainstorming | `skills/superpowers/brainstorming` | Any ECC brainstorming/ideation skills |

## CodeGraph Integration (superpowers + CodeGraph = complete system)

**CodeGraph and superpowers are a pair.** When `.codegraph/` exists, CodeGraph provides semantic intelligence that supercharges all superpowers skills.

### Tool Priority (when .codegraph/ exists)

**CodeGraph tools take priority over file-based discovery for semantic questions:**

| Question Type | Use This FIRST | NOT This |
|---------------|----------------|----------|
| "How does X work" / flow questions | `codegraph_explore` | `view` + `grep` loop |
| "Find symbol/function/class" | `codegraph_search` | `codebase-retrieval` |
| "Who calls this function" | `codegraph_callers` | manual `grep` |
| "What does this call" | `codegraph_callees` | manual `grep` |
| "Impact before changing X" | `codegraph_impact` | guess + hope |
| "Get full source + overloads" | `codegraph_node` | `view` (misses overloads) |
| "Show file structure" | `codegraph_files` | `view` directory |

**Key principle:** CodeGraph answers semantic questions in **1 call vs 10+ Read/Grep cycles**. Treat returned source as already Read — don't re-verify with grep.

### Integration Points

CodeGraph enhances these superpowers skills:

- **brainstorming** — `codegraph_explore` understands existing architecture before design
- **writing-plans** — `codegraph_search`/`codegraph_files` map symbols/structure before planning
- **systematic-debugging** — `codegraph_callers`/`codegraph_callees`/`codegraph_impact` trace flows
- **verification-before-completion** — `codegraph_impact` MANDATORY before signature changes

### Graceful Fallback

**IF .codegraph/ missing:**
- Superpowers skills fall back to file-based tools (`view`, `codebase-retrieval`, `grep`)
- Offer to initialize: "Run `codegraph init -i` to enable semantic search?"
- All workflows continue unchanged — CodeGraph is optional enhancement

**CodeGraph is an input tool** — accelerates discovery but doesn't bypass TDD/verification/review gates. Superpowers workflow still applies.

## ECC-only (no superpowers equivalent — use freely)

- Language-specific reviewer agents (cpp, go, rust, python, java, kotlin, typescript, csharp, flutter)
- Build resolver agents (build-error-resolver, cpp, go, rust, java, kotlin, dart, pytorch)
- Domain specialist agents (database-reviewer, security-reviewer, performance-optimizer, architect, healthcare-reviewer, e2e-runner, doc-updater, docs-lookup)
- All language/framework-specific pattern skills

## Reminder: New Project Setup

When the user starts a new project or initializes a new repository, remind them to install ECC rules as **Auto** type workspace rules into `<repo>/.augment/rules/`. Available rule sets from `~/.augment/plugins/marketplaces/everything-claude-code/rules/`:

- **common** — agents, code-review, coding-style, development-workflow, git-workflow, hooks, patterns, performance, security, testing
- **python** — coding-style, hooks, patterns, security, testing
- Other languages: cpp, csharp, dart, golang, java, kotlin, perl, php, rust, swift, typescript, web
