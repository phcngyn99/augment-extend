---
name: superpowers-workflow
description: Use when implementing features, fixing bugs, refactoring, or working on any coding task that needs maximum rigor and comprehensive testing
---

# Superpowers Smart Flow Router

**Philosophy: Use maximum applicable skills for work type. Test everything.**

Auto-detects work type → routes to appropriate flow → uses 10-11/15 skills minimum.

**6 flows, all maximize skill usage. Quality over speed.**

## When to Use

User says:
- "use superpowers-workflow for [ANYTHING]"

Agent auto-detects work type, routes to appropriate flow.

## Flow Detection (Auto)

**Step 1: Analyze task keywords**

```
Keywords → Flow

"bug", "fix", "broken", "failing", "error"
  → Bug Fix Flow (10-11 skills)

"add", "create", "build", "new", "feature", "implement"
  → Feature Development Flow (10-11 skills)

"typo", "rename", "quick", "simple", "one-line"
  → Quick Fix Flow (10-11 skills, compressed)

"refactor", "improve", "clean", "reorganize", "optimize"
  → Refactor Flow (10-11 skills)

"investigate", "why", "debug", "explore", "understand"
  → Investigation Flow (10-11 skills)

"multiple", "several", "independent", "parallel"
  → Parallel Work Flow (10-11 skills)
```

**If ambiguous:** Ask user which flow to use.

**Default:** Feature Development Flow (when no keywords match).

## The 6 Flows (All Use Maximum Skills)

### Flow 1: Feature Development (10-11 skills)

**Trigger:** "add", "create", "build", "new", "feature", "implement"

```
1. using-superpowers        (governance)
2. brainstorming            (design)
3. writing-plans            (implementation plan)
4. using-git-worktrees      (isolation)
5. systematic-debugging     (pre-verify clean state)
6. subagent-driven-dev      (orchestration)
   └─ test-driven-dev       (per task)
7. verification             (comprehensive)
8. requesting-review        (quality gate)
9. finishing-branch         (integration)
10. receiving-review        (if PR feedback)

10-11 skills (67-73%)
```

### Flow 2: Bug Fix (10-11 skills)

**Trigger:** "bug", "fix", "broken", "failing", "error"

```
1. using-superpowers        (governance)
2. systematic-debugging     (root cause investigation)
3. brainstorming            (fix design - verify approach)
4. writing-plans            (fix implementation plan)
5. using-git-worktrees      (isolation)
6. subagent-driven-dev      (orchestration)
   └─ test-driven-dev       (per task + regression tests)
7. verification             (comprehensive + verify bug gone)
8. requesting-review        (quality gate)
9. finishing-branch         (integration)
10. receiving-review        (if PR feedback)

10-11 skills (67-73%)
```

### Flow 3: Quick Fix (10-11 skills, compressed execution)

**Trigger:** "typo", "rename", "quick", "simple", "one-line"

```
STILL uses 10-11 skills, but compressed:

1. using-superpowers        (governance)
2. brainstorming            (quick design - 2 questions max)
3. writing-plans            (minimal plan - 3-5 tasks)
4. using-git-worktrees      (isolation)
5. systematic-debugging     (quick pre-check - 2 min max)
6. subagent-driven-dev      (1-2 tasks max)
   └─ test-driven-dev       (per task)
7. verification             (full suite still)
8. requesting-review        (quick review)
9. finishing-branch         (integration)
10. receiving-review        (if PR feedback)

10-11 skills (67-73%) - same rigor, faster execution
```

### Flow 4: Refactor (10-11 skills)

**Trigger:** "refactor", "improve", "clean", "reorganize", "optimize"

```
1. using-superpowers        (governance)
2. brainstorming            (refactor design - what/why)
3. writing-plans            (refactor plan - preserve behavior)
4. using-git-worktrees      (isolation)
5. systematic-debugging     (document current behavior)
6. subagent-driven-dev      (orchestration)
   └─ test-driven-dev       (per task + extra regression)
7. verification             (comprehensive + behavior unchanged)
8. requesting-review        (quality gate)
9. finishing-branch         (integration)
10. receiving-review        (if PR feedback)

10-11 skills (67-73%)
```

### Flow 5: Investigation (10-11 skills)

**Trigger:** "investigate", "why", "debug", "explore", "understand"

```
1. using-superpowers        (governance)
2. systematic-debugging     (investigation)
3. brainstorming            (findings analysis)
4. writing-plans            (action plan based on findings)
5. using-git-worktrees      (isolation for experiments)
6. subagent-driven-dev      (implement solution)
   └─ test-driven-dev       (per task)
7. verification             (comprehensive)
8. requesting-review        (quality gate)
9. finishing-branch         (integration)
10. receiving-review        (if PR feedback)

10-11 skills (67-73%)
```

### Flow 6: Parallel Work (10-11 skills)

**Trigger:** "multiple", "several", "independent", "parallel"

```
1. using-superpowers        (governance)
2. systematic-debugging     (identify all issues)
3. brainstorming            (overall strategy)
4. writing-plans            (plan per independent item)
5. using-git-worktrees      (isolation)
6. dispatching-parallel-agents (parallel orchestration)
   └─ test-driven-dev       (per task in each agent)
7. verification             (comprehensive all items)
8. requesting-review        (quality gate)
9. finishing-branch         (integration)
10. receiving-review        (if PR feedback)

10-11 skills (67-73%) - uses parallel instead of sequential
```

## Maximum Testing (All Flows)

**Test everything, all flows:**

```
Per Task:
├─ Unit tests (happy + edge + error)
├─ Integration tests (if multi-component)
├─ Regression tests (if bug fix/refactor)
├─ 5+ tests minimum per task
└─ 90%+ coverage target

Per Feature:
├─ 20+ tests minimum
├─ Full suite GREEN
├─ E2E tests (if applicable)
├─ Performance tests (if applicable)
├─ Security tests (if applicable)
└─ 90%+ coverage overall

Before Merge (ALL flows):
├─ Re-run full suite
├─ Linting (all files)
├─ Type checking (all files)
├─ Coverage ≥ 90%
└─ Manual smoke test
```

---

## Execution Example (Auto-Routing)

### Phase 0: Detection & Routing

**Step 1: Analyze task**
```
User: "use superpowers-workflow for fix login redirect bug"

Agent analyzes:
- Keywords detected: "fix", "bug"
- Work type: Bug Fix
- Flow selected: Bug Fix Flow (10-11 skills)
```

**Step 2: Announce**
```
"Using superpowers-workflow (Bug Fix Flow) for login redirect bug.

Flow: 10-11/15 skills, root cause → fix → comprehensive testing.
No shortcuts. Quality over speed."
```

**Step 3: Run using-superpowers (MANDATORY)**
- Verify skill compliance
- Check activation checklist
- Confirm no ECC when superpowers exists
- **Skill: 1/15**

### Phase 1: Investigation (Bug Fix Flow starts here)

**Step 4: Run systematic-debugging (MANDATORY for bugs)**
- Phase 1: Root cause investigation
- Phase 2: Document exact failure
- Phase 3: Identify fix approach
- Phase 4: Verify no other related bugs
- **Skill: 2/15**

### Phase 2: Design (ALL flows)

**Step 5: Run brainstorming (MANDATORY)**
- Bug Fix: analyze fix approach (2-3 options)
- Feature: full design exploration
- Quick Fix: compressed (2 questions max)
- Refactor: what/why/preserve behavior
- Investigation: findings analysis
- Parallel: overall strategy
- Save spec: `docs/superpowers/specs/YYYY-MM-DD-topic-design.md`
- **Skill: 3/15**

**Step 6: Run writing-plans (MANDATORY)**
- Bug Fix: fix plan + regression tests
- Feature: full implementation plan
- Quick Fix: minimal plan (3-5 tasks)
- Refactor: preserve behavior plan
- Investigation: action plan
- Parallel: plan per independent item
- Plan location: Auto-detected project root (NEVER ~/.augment)
- Save plan: `<project-root>/docs/superpowers/plans/YYYY-MM-DD-topic.md`
- **Skill: 4/15**

**Checkpoint**
```
Design complete. Spec + plan saved.
Continue or pause for review?
```

### Phase 3: Setup (ALL flows)

**Step 7: Run using-git-worktrees (MANDATORY)**
- ALWAYS create isolated workspace
- Prevents contamination
- Create feature branch
- Switch to worktree
- **Skill: 5/15**

### Phase 4: Execute (ALL flows)

**Step 8: Choose orchestration strategy**

**IF Bug Fix / Feature / Quick Fix / Refactor / Investigation:**
Run **subagent-driven-development**
- Read plan, extract all tasks
- Create TodoWrite
- **Skill: 6/15**

**FOR EACH TASK** — Dispatch implementer with **test-driven-development**:

**RED Phase:**
- Unit test (happy path)
- Unit tests (edge cases)
- Unit tests (error paths)
- Integration test (if multi-component)
- Regression test (if bug fix)
- Run ALL, verify ALL RED
- **Skill: 7/15**

**GREEN Phase:**
- Minimal implementation
- Run ALL, verify ALL GREEN

**REFACTOR Phase:**
- Clean up
- Tests still GREEN
- Commit

Dispatch spec-reviewer → PASS or fix loop
Dispatch code-quality-reviewer → PASS or fix loop

**IF Parallel Work Flow:**
Run **dispatching-parallel-agents** (instead of subagent-driven)
- One agent per independent item
- All agents run simultaneously
- Each uses test-driven-development
- **Skill: 6/15 (alternative)**
- **Skill: 7/15 (test-driven embedded)**

### Phase 5: Comprehensive Verification (ALL flows)

**Step 9: Run verification-before-completion (MANDATORY)**

**Full test suite:**
- Unit (all)
- Integration (all)
- E2E (if applicable)
- Performance (if applicable)
- Security (if applicable)
- Regression (Bug Fix / Refactor)

**Static analysis:**
- Linting
- Type checking
- Coverage report (≥90%)

**Manual:**
- Smoke test
- Bug Fix: verify bug gone
- Refactor: verify behavior unchanged

Show output, verify 0 failures
- **Skill: 8/15**

**Step 10: Run requesting-code-review (MANDATORY)**
- Git SHAs (base → head)
- Dispatch code-reviewer
- Review against spec + plan
- Fix Critical/Important
- **Skill: 9/15**

### Phase 6: Finish (ALL flows)

**Step 11: Run finishing-a-development-branch (MANDATORY)**
- Re-verify full suite
- Options: merge / push+PR / keep / discard
- Execute choice
- Cleanup
- **Skill: 10/15**

**Summary: Used 10/15 skills (67%)**

### Phase 7: Post-Merge (ALL flows if PR feedback)

**Step 12: Run receiving-code-review (if feedback)**
- Evaluate technically
- Verify before implementing
- TDD for fixes
- Re-verify full suite
- Update PR
- **Skill: 11/15**

**Total with PR feedback: 11/15 skills (73%)**

## Flow-Specific Skill Usage

### All Flows Use 10-11 Skills

**Feature Development Flow:**
```
using-superpowers           [1/15]
brainstorming               [2/15]
writing-plans               [3/15]
using-git-worktrees         [4/15]
systematic-debugging        [5/15] (pre-verify clean)
subagent-driven-dev         [6/15]
  └─ test-driven-dev        [7/15]
verification                [8/15]
requesting-review           [9/15]
finishing-branch            [10/15]
receiving-review            [11/15] (if PR feedback)

10-11 skills (67-73%)
```

**Bug Fix Flow:**
```
using-superpowers           [1/15]
systematic-debugging        [2/15] (root cause first)
brainstorming               [3/15]
writing-plans               [4/15]
using-git-worktrees         [5/15]
subagent-driven-dev         [6/15]
  └─ test-driven-dev        [7/15] (+ regression)
verification                [8/15]
requesting-review           [9/15]
finishing-branch            [10/15]
receiving-review            [11/15] (if PR feedback)

10-11 skills (67-73%)
```

**Quick Fix Flow:**
```
Same 10-11 skills, compressed execution:
- brainstorming: 2 questions max
- writing-plans: 3-5 tasks
- systematic-debugging: 2 min pre-check
- subagent-driven: 1-2 tasks
- Still comprehensive verification

10-11 skills (67-73%)
```

**Refactor Flow:**
```
Same as Feature, plus:
- systematic-debugging: document current behavior
- test-driven-dev: extra regression tests
- verification: behavior unchanged check

10-11 skills (67-73%)
```

**Investigation Flow:**
```
Same as Bug Fix:
- systematic-debugging first (investigation)
- Then branch to solution

10-11 skills (67-73%)
```

**Parallel Work Flow:**
```
using-superpowers           [1/15]
systematic-debugging        [2/15] (identify all)
brainstorming               [3/15]
writing-plans               [4/15]
using-git-worktrees         [5/15]
dispatching-parallel        [6/15] (instead of subagent-driven)
  └─ test-driven-dev        [7/15]
verification                [8/15]
requesting-review           [9/15]
finishing-branch            [10/15]
receiving-review            [11/15] (if PR feedback)

10-11 skills (67-73%)
```

## Real-World Examples

### Example 1: Bug Fix Flow

```
User: "use superpowers-workflow for fix login redirect bug"

Agent: Analyzing... "fix", "bug" detected
       → Bug Fix Flow (10-11 skills)

Execution:
1. using-superpowers (governance)
2. systematic-debugging
   - Reproduce bug
   - Root cause: missing await on auth check
   - Impact: users redirected before session loaded
3. brainstorming (fix design)
   - Option A: add await
   - Option B: refactor to promise chain
   - Option C: use callback pattern
   - Recommend: A (simplest)
4. writing-plans
   - Task 1: Add unit test for auth check timing
   - Task 2: Add await to auth middleware
   - Task 3: Add integration test for full redirect flow
   - Task 4: Add regression test for this specific bug
5. using-git-worktrees (.worktrees/fix-login-redirect)
6. subagent-driven-dev
   - Task 1: TDD (RED → GREEN → REFACTOR)
   - Task 2: TDD
   - Task 3: TDD
   - Task 4: TDD
7. verification (full suite + manual smoke)
8. requesting-review (code-reviewer found 1 edge case)
9. finishing-branch (push+PR)
10. receiving-review (teammate approved)

Total: 10/15 skills (67%)
```

### Example 2: Feature Development Flow

```
User: "use superpowers-workflow for add two-factor authentication"

Agent: Analyzing... "add" detected
       → Feature Development Flow (10-11 skills)

Execution:
1. using-superpowers
2. brainstorming
   - Asks: SMS, email, or authenticator app?
   - User: authenticator app
   - Proposes: TOTP vs HOTP
   - Recommends: TOTP (standard)
   - Design: QR code setup, 6-digit code, backup codes
3. writing-plans (15 tasks with comprehensive tests)
4. using-git-worktrees (.worktrees/2fa)
5. systematic-debugging (pre-verify auth system clean)
6. subagent-driven-dev (15 tasks, each with TDD + reviews)
7. verification
   - 47 tests (unit + integration + E2E)
   - Security tests (replay attack, timing attack)
   - Coverage: 94%
8. requesting-review
9. finishing-branch (push+PR)
10. receiving-review (PR feedback on backup codes)

Total: 10/15 skills (67%)
```

### Example 3: Parallel Work Flow

```
User: "use superpowers-workflow for fix 5 independent bugs in different modules"

Agent: Analyzing... "5 independent" detected
       → Parallel Work Flow (10-11 skills)

Execution:
1. using-superpowers
2. systematic-debugging (identify all 5 bugs)
3. brainstorming (strategy: parallel agents)
4. writing-plans (plan per bug)
5. using-git-worktrees (.worktrees/multi-bugfix)
6. dispatching-parallel-agents
   - Agent 1: auth bug (TDD)
   - Agent 2: payment bug (TDD)
   - Agent 3: cart bug (TDD)
   - Agent 4: search bug (TDD)
   - Agent 5: profile bug (TDD)
   - All run simultaneously
7. verification (full suite all modules)
8. requesting-review
9. finishing-branch
10. receiving-review

Total: 10/15 skills (67%)
```

## Never Used (4 Skills)

**Mutually exclusive execution strategies (use one):**
- `dispatching-parallel-agents` OR
- `subagent-driven-development` OR
- `executing-plans` (no subagents)

**Separate workflows:**
- `writing-skills` (for creating new skills)
- `superpowers-help` (reference display)

**All flows use 10-11/15 skills (67-73%).**

## Resume Command

```
User: "use superpowers-workflow continue from [plan-path]"
```

Resumes at Phase 2 (using-git-worktrees). Still runs 8-9 skills minimum (skips using-superpowers + brainstorming + writing-plans).

## Iron Laws (ALL Flows)

1. **ALWAYS auto-detect flow** — analyze keywords, route to appropriate flow
2. **ALWAYS use 10-11 skills** — all flows use maximum applicable skills
3. **ALWAYS test comprehensively** — unit + integration + edge + error + regression
4. **ALWAYS isolate** — worktree for every change (all flows)
5. **ALWAYS design first** — brainstorming + plans (all flows, even Quick Fix)
6. **ALWAYS orchestrate** — subagent-driven or dispatching-parallel (never manual)
7. **ALWAYS verify comprehensively** — full suite + linting + types + coverage
8. **ALWAYS review** — code-review (no self-merge)
9. **NO SHORTCUTS** — Quick Fix = compressed execution, not fewer skills
10. **Coverage target: 90%+** — all flows

## Flow Selection Logic

```
Keyword → Flow

"bug", "fix", "broken"
  → Bug Fix Flow
  → systematic-debugging FIRST (root cause)
  → Then design → implement

"add", "create", "new"
  → Feature Flow
  → brainstorming FIRST (design)
  → systematic-debugging for pre-verify
  → Then implement

"typo", "quick", "simple"
  → Quick Fix Flow
  → Same 10-11 skills, compressed
  → brainstorming: 2 questions
  → plans: 3-5 tasks
  → Still full verification

"refactor", "improve"
  → Refactor Flow
  → systematic-debugging: document current
  → Extra regression tests
  → Verify behavior unchanged

"investigate", "why", "debug"
  → Investigation Flow
  → systematic-debugging: investigation
  → Branch to fix or feature after

"multiple", "independent", "parallel"
  → Parallel Work Flow
  → dispatching-parallel-agents
  → All items processed simultaneously
```

## Philosophy

**"The only way to go fast is to go well." — Robert C. Martin**

6 flows, all use 10-11 skills. Route by work type, maximize rigor.

**Quality over speed. Every task deserves full treatment.**
