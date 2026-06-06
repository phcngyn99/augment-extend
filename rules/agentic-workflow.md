# Agentic Workflow

Operating principles for AI-assisted engineering. For deep patterns, invoke `agentic-engineering` skill.

---

## 1. Eval-First Execution

**Before implementing:**
1. Define success criteria (capability eval)
2. Define regression check
3. Run baseline
4. Implement
5. Re-run evals, compare delta

**No work without verifiable completion criteria.**

## 2. Decompose into Agent-Sized Units

**15-minute unit rule:**
- Independently verifiable
- Single dominant risk
- Clear done condition

**Examples:**
- ✓ "Add email validation to signup form"
- ✓ "Fix race condition in payment flow"
- ✗ "Build authentication system" (too large)
- ✗ "Improve performance" (no done condition)

## 3. Model Routing by Complexity

Match model tier to task:
- **Haiku:** classification, boilerplate, narrow edits
- **Sonnet:** implementation, refactors, multi-file changes
- **Opus:** architecture, root-cause analysis, cross-system invariants

Escalate only when lower tier fails with clear reasoning gap.

## 4. Session Strategy

**Continue session:**
- Closely-coupled units
- Active debugging
- Iterating on feedback

**Start fresh session:**
- Major phase transitions (research → implementation)
- After milestone completion
- Switching unrelated work
- Context pressure (50+ tool calls)

**Never compact mid-task** — lose variable names, error context.

## 5. Review Focus for AI Code

Prioritize review on:
- Invariants and edge cases
- Error boundaries
- Security/auth assumptions
- Hidden coupling
- Rollout risk

**Don't review:**
- Style (auto-formatters handle it)
- Syntax (linters catch it)
- Naming (unless domain-specific)

## 6. Cost Discipline

Track per task:
- Model used
- Token estimate
- Retries
- Wall-clock time
- Success/failure

Route cheapest model first, escalate on failure.

---

**For deep patterns** (multi-agent orchestration, eval harness setup), invoke `agentic-engineering` skill.
