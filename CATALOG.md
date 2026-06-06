# Catalog

**99 skills · 38 agents** — searchable reference for installed capabilities.

## Quick Lookup

**Need:** ANY coding task → `superpowers-workflow` (auto-routes to 10-11 skill flow)
**Need:** Feature implementation → `brainstorming` → `writing-plans` → `test-driven-development` → `subagent-driven-development`
**Need:** Bug/failure → `systematic-debugging` → `verification-before-completion`
**Need:** Code review → `requesting-code-review` (superpowers) or language-specific reviewer agent
**Need:** Research → `deep-research` (delegates to sub-agents) or `exa-search` (neural search)
**Need:** Design/UI → `ui-ux-pro-max` (67 styles, 161 palettes, 99 UX patterns)
**Need:** Security check → `security-review` skill or `security-reviewer` agent
**Need:** Build broken → language-specific build-resolver agent
**Need:** Documentation → `docs-lookup` (Context7) or `codebase-onboarding`

**Priority:** Superpowers > ECC when both match (`rules/superpowers-priority.md`)

---

## Superpowers (16 skills, 1 agent)

**Primary framework** — language-agnostic, triggers via mandatory activation checklist (`rules/superpowers-priority.md`).

| Skill | Trigger | Action |
|-------|---------|--------|
| **Workflow (Master)** |||
| `superpowers-workflow` | **ANY coding task (PRIMARY)** | Smart flow router: auto-detects work type (feature/bug/refactor/quick/investigation/parallel), routes through 10-11/15 skills with comprehensive testing |
| **Workflow (Individual)** |||
| `brainstorming` | Before creative/feature work | Explore intent, requirements, design |
| `writing-plans` | Multi-step task/complex feature | Step-by-step plan before code |
| `executing-plans` | Executing plan in separate session | Execute with review checkpoints |
| `subagent-driven-development` | Executing plan with independent tasks | Dispatch parallel sub-agents |
| `dispatching-parallel-agents` | 2+ independent tasks | Run simultaneously |
| **Quality** |||
| `test-driven-development` | Writing feature/bugfix | Tests first, then implement |
| `systematic-debugging` | Bug/test failure/unexpected behavior | Hypothesis → verify → fix |
| `verification-before-completion` | About to claim "done"/"fixed"/"passing" | Run verification, show evidence |
| `requesting-code-review` | Completing work/before merge | Review vs plan/standards |
| `receiving-code-review` | Receiving code review feedback | Verify technically, no blind agreement |
| **Git** |||
| `using-git-worktrees` | Starting feature needing isolation | Create isolated worktree + safety |
| `finishing-a-development-branch` | Implementation complete, tests pass | Options: merge, PR, cleanup |
| **Meta** |||
| `writing-skills` | Creating/editing skills | Skill authoring guidelines |
| `using-superpowers` | Starting any conversation | How to find/use skills |

**Agent:** `code-reviewer` — primary review agent (overrides ECC `code-reviewer`)

---

## ECC Skills (68 total)

**Agent & Automation (20)**

| Skill | Use When |
|-------|----------|
| `ck` | Auto: session start/end (Rules 1-2) — per-project memory |
| `continuous-learning` | Auto: session end (Rule 2) — extract reusable patterns |
| `continuous-learning-v2` | Instinct-based learning, confidence scoring |
| `strategic-compact` | Auto: ~20 tool calls (Rule 3) — context compaction |
| `autonomous-agent-harness` | Persistent memory, scheduled ops, task queues |
| `autonomous-loops` | Sequential pipelines → DAG systems |
| `continuous-agent-loop` | Quality gates, evals, recovery controls |
| `gan-style-harness` | Generator-Evaluator adversarial pattern |
| `agent-harness-construction` | Optimize action spaces, tool defs, observations |
| `agent-eval` | Head-to-head agent comparison (pass rate, cost, time) |
| `agent-payment-x402` | Per-task budgets, spending controls |
| `agentic-engineering` | Eval-first execution, 15-min units, model routing |
| `ai-first-engineering` | AI-heavy team operating model |
| `claude-devfleet` | Multi-agent orchestration in parallel worktrees |
| `dmux-workflows` | Multi-agent coordination via tmux panes |
| `team-builder` | Interactive agent picker, dispatch parallel teams |
| `ralphinho-rfc-pipeline` | RFC-driven DAG with merge queues, quality gates |
| `santa-method` | Two independent reviewers must both pass |
| `iterative-retrieval` | Progressive context refinement (subagent context problem) |
| `context-budget` | Audit Augment context, identify bloat |

**Architecture & Patterns (9)**

| Skill | Use When |
|-------|----------|
| `api-design` | Designing REST APIs — naming, codes, pagination, versioning |
| `backend-patterns` | Node/Express/Next.js server-side architecture |
| `frontend-patterns` | React/Next.js state management, performance, UI |
| `hexagonal-architecture` | Ports & Adapters design (TS, Java, Kotlin, Go) |
| `architecture-decision-records` | Capturing architectural decisions + rationale |
| `coding-standards` | TS/JS/React/Node universal standards |
| `content-hash-cache-pattern` | SHA-256 content-hash caching pattern |
| `design-system` | Design system audit, visual consistency |
| `project-guidelines-example` | Template for project-specific skills |

**Testing & Quality (8)**

| Skill | Use When |
|-------|----------|
| `tdd-workflow` | 80%+ coverage — unit, integration, E2E |
| `e2e-testing` | Playwright E2E — POM, CI/CD integration |
| `ai-regression-testing` | Sandbox API testing, catch AI blind spots |
| `benchmark` | Measure baselines, detect regressions |
| `browser-qa` | Visual testing, UI interaction verification |
| `verification-loop` | Comprehensive pre-completion verification |
| `eval-harness` | Eval-driven development workflows |
| `canary-watch` | Monitor deployed URL for regressions |

**Language-Specific (43 skills across 13 languages/frameworks)**

<details>
<summary>Python (3) · Java/Spring (6) · Kotlin/Android (7) · Rust (2) · Go (2) · C++ (2) · C#/.NET (2) · Dart/Flutter (2) · Swift/iOS (6) · Perl (3) · PHP/Laravel (5) · Django (4) · Web Frameworks (3)</summary>

| Language | Skills | Coverage |
|----------|--------|----------|
| **Python** | `python-patterns`, `python-testing`, `pytorch-patterns` | PEP 8, pytest, PyTorch |
| **Java/Spring** | `java-coding-standards`, `springboot-patterns`, `springboot-security`, `springboot-tdd`, `springboot-verification`, `jpa-patterns` | Layered arch, JPA, JUnit, JaCoCo |
| **Kotlin/Android** | `kotlin-patterns`, `kotlin-testing`, `kotlin-coroutines-flows`, `kotlin-ktor-patterns`, `kotlin-exposed-patterns`, `android-clean-architecture`, `compose-multiplatform-patterns` | Coroutines, Compose, clean arch |
| **Rust** | `rust-patterns`, `rust-testing` | Ownership, lifetimes, async tests |
| **Go** | `golang-patterns`, `golang-testing` | Idiomatic Go, table-driven tests |
| **C++** | `cpp-coding-standards`, `cpp-testing` | Core Guidelines, GoogleTest |
| **C#/.NET** | `dotnet-patterns`, `csharp-testing` | DI, async/await, xUnit |
| **Dart/Flutter** | `dart-flutter-patterns`, `flutter-dart-code-review` | BLoC/Riverpod, widget patterns |
| **Swift/iOS** | `swiftui-patterns`, `swift-concurrency-6-2`, `swift-actor-persistence`, `swift-protocol-di-testing`, `liquid-glass-design`, `foundation-models-on-device` | SwiftUI, actors, iOS 26 |
| **Perl** | `perl-patterns`, `perl-security`, `perl-testing` | Modern Perl 5.36+, Test2 |
| **PHP/Laravel** | `laravel-patterns`, `laravel-security`, `laravel-tdd`, `laravel-verification`, `laravel-plugin-discovery` | Eloquent, Pest, LaraPlugins.io |
| **Django** | `django-patterns`, `django-security`, `django-tdd`, `django-verification` | DRF, pytest-django |
| **Web** | `nextjs-turbopack`, `nuxt4-patterns`, `bun-runtime` | Next 16+, Nuxt 4, Bun |
</details>

**Database (3)**

| Skill | Coverage |
|-------|----------|
| `postgres-patterns` | Query optimization, indexing, Supabase patterns |
| `database-migrations` | Zero-downtime schema changes across ORMs |
| `clickhouse-io` | ClickHouse analytics, query optimization |

**DevOps & Deployment (3)**

| Skill | Coverage |
|-------|----------|
| `docker-patterns` | Compose, security, networking, volumes |
| `deployment-patterns` | CI/CD, health checks, rollbacks |
| `git-workflow` | Branching strategies, commit conventions |

**Security (2)**

| Skill | Use When |
|-------|----------|
| `security-review` | Auth, input validation, secrets, OWASP Top 10 |
| `security-scan` | Scan `.augment/` config for vulnerabilities |


**Domain-Specific (39 skills across 6 domains)**

| Domain | Count | Key Skills |
|--------|-------|------------|
| **Content & Writing** | 5 | `article-writing`, `brand-voice`, `content-engine`, `crosspost`, `x-api` |
| **Business & Outreach** | 12 | `investor-materials`, `investor-outreach`, `lead-intelligence`, `market-research`, `deep-research`, `product-lens`, `project-flow-ops` (GitHub+Linear), `google-workspace-ops`, `jira-integration`, `customer-billing-ops` (Stripe) |
| **Media & Video** | 7 | `manim-video`, `remotion-video-creation`, `video-editing`, `videodb`, `fal-ai-media`, `ui-demo`, `frontend-slides` |
| **Healthcare** | 4 | `healthcare-emr-patterns`, `healthcare-cdss-patterns`, `healthcare-phi-compliance`, `healthcare-eval-harness` |
| **Supply Chain** | 8 | `carrier-relationship-management`, `customs-trade-compliance`, `inventory-demand-planning`, `logistics-exception-management`, `production-scheduling`, `quality-nonconformance`, `returns-reverse-logistics`, `energy-procurement` |
| **Utilities** | 23 | `codebase-onboarding`, `documentation-lookup` (Context7), `exa-search`, `mcp-server-patterns`, `data-scraper-agent`, `nutrient-document-processing`, `regex-vs-llm-structured-text`, `opensource-pipeline`, `repo-scan`, `configure-ecc`, `workspace-surface-audit`, `safety-guard`, `click-path-audit`, `plankton-code-quality`, `search-first`, `cost-aware-llm-pipeline`, `prompt-optimizer`, `token-budget-advisor`, `rules-distill`, `skill-comply`, `nanoclaw-repl` |

---

---

## UI/UX Pro Max (1 skill)

**67 styles · 161 color palettes · 57 font pairings · 99 UX guidelines · 25 chart types** across 16 tech stacks.

Auto-triggers on design/UI questions. Manual search:
```bash
python3 ~/.augment/skills/ui-ux-pro-max/scripts/search.py "fintech" --domain style -n 5
```

---

## Caveman (5 skills)

**Token compression** — 75% reduction, auto-active at **full** level.

| Skill | Command | Purpose |
|-------|---------|---------|
| `caveman` | `/caveman [lite\|full\|ultra\|wenyan]` | Activate/switch compression level |
| `caveman-commit` | `/caveman-commit` | Terse conventional commit messages |
| `caveman-review` | `/caveman-review` | One-line PR review comments |
| `caveman-compress` | `/caveman:compress <file>` | Compress .md memory files |
| `caveman-help` | `/caveman-help` | Quick reference card |
| `cavecrew` | Auto-triggered | Delegate to compressed sub-agents |
| `caveman-stats` | `/caveman-stats` | Session token usage (real, not estimated) |

---

## Custom/Matt Pocock (10 skills)

Repository/team-specific workflows.

| Skill | Use When |
|-------|----------|
| `grill-with-docs` | Stress-test plan against domain model, update CONTEXT.md inline |
| `improve-codebase-architecture` | Find deepening opportunities, consolidate modules |
| `prototype` | Build throwaway prototypes (terminal app or UI variations) |
| `to-issues` | Break plan into vertical-slice issues on tracker |
| `to-prd` | Convert conversation context → PRD on issue tracker |
| `zoom-out` | Get broader context for unfamiliar code section |
| `create-adr` | Generate Architecture Decision Record |
| `create-makefile` | Generate modern self-documenting Makefile |
| `create-readme` | Generate comprehensive README |
| `create-usage` | Generate execution guide for jobs/scripts |

---

## ECC Agents (37)

**Dispatch for specialized tasks** — use when you need domain expertise.

| Category | Agents | Use When |
|----------|--------|----------|
| **Language Reviewers (9)** | `typescript-reviewer`, `python-reviewer`, `go-reviewer`, `rust-reviewer`, `java-reviewer`, `kotlin-reviewer`, `cpp-reviewer`, `csharp-reviewer`, `flutter-reviewer` | Language-specific code review |
| **Build Resolvers (8)** | `build-error-resolver` (TS/JS), `cpp-build-resolver`, `dart-build-resolver`, `go-build-resolver`, `java-build-resolver`, `kotlin-build-resolver`, `rust-build-resolver`, `pytorch-build-resolver` | Build broken, type errors, compiler failures |
| **Domain Specialists (8)** | `architect`, `planner`, `database-reviewer`, `security-reviewer`, `performance-optimizer`, `healthcare-reviewer`, `doc-updater`, `docs-lookup` | System design, security, performance, docs |
| **Testing & Quality (2)** | `tdd-guide`, `e2e-runner` | TDD guidance, E2E test generation |
| **GAN Harness (3)** | `gan-planner`, `gan-generator`, `gan-evaluator` | Autonomous app building (prompt → spec → implement → test → iterate) |
| **Open Source (3)** | `opensource-forker`, `opensource-sanitizer`, `opensource-packager` | Sanitize + package repos for open-source release |
| **Operations (4)** | `chief-of-staff`, `harness-optimizer`, `loop-operator`, `refactor-cleaner` | Communication triage, agent optimization, dead code cleanup |

**General Purpose (5):** `explore`, `plan`, `general-purpose`, `research`, `code`, `validate` — broad capability agents.

---

## Quick Reference

**Storage:**
- Skills: `skills/{superpowers,ecc,ui-ux-pro-max,caveman,custom,learned}/`
- Agents: `agents/{superpowers,ecc}/`
- Rules: `rules/` (always loaded)
- ck memory: `ck/` (no repo pollution)

**Session lifecycle:**
```
Start → auto-resume (/ck:init if new)
Work → skills match + execute
Git commit → auto-save (/ck:save)
"bye" → save + continuous-learning
"handoff" → portable markdown (/ck:handoff)
Next session → briefing (where left off)
```

See `rules/session-lifecycle.md` for automation details.