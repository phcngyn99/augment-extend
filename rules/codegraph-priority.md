# CodeGraph Priority Rule

When working with **code** (not docs/config), use CodeGraph MCP tools for semantic analysis before falling back to file-based tools.

**CodeGraph + Superpowers = complete system.** CodeGraph provides semantic intelligence that supercharges all superpowers skills.

---

## Core Principle

CodeGraph provides **semantic indexing** — understands code structure, call graphs, dependencies. Use it over text-based tools (`view`, `grep`, `codebase-retrieval`) when analyzing code relationships.

**Integration with superpowers:** When using `superpowers-workflow`, CodeGraph tools are automatically prioritized in:
- `brainstorming` — understanding existing architecture
- `writing-plans` — discovering symbols/structure before planning
- `systematic-debugging` — tracing call flows during root cause investigation
- `verification-before-completion` — MANDATORY impact analysis before signature changes

See `superpowers-priority.md` for full integration details.

---

## Mandatory CodeGraph Usage

### Before Any Code Edit

**ALWAYS check impact before changing signatures, refactoring, or modifying APIs:**

1. **Find all callers:**
   ```
   codegraph_callers symbol="functionName"
   ```

2. **Check impact:**
   ```
   codegraph_impact symbol="functionName" depth=2
   ```

3. **Verify callees:**
   ```
   codegraph_callees symbol="functionName"
   ```

**Why:** Text search misses indirect dependencies. CodeGraph sees the full graph.

### Understanding Code Flow

**When the user asks "how does X work" or "show me the auth flow":**

1. **Use `codegraph_explore` first:**
   ```
   codegraph_explore query="auth login session"
   ```
   Returns full source grouped by file in ONE call.

2. **Then use `codegraph_node` for details:**
   ```
   codegraph_node symbol="loginUser" includeCode=true
   ```

**Why:** One `explore` call = multiple `view` calls worth of context, semantically filtered.

### Finding Symbols

**When searching for "where is X defined" or "find all uses of Y":**

1. **Use `codegraph_search` first:**
   ```
   codegraph_search query="AuthService" kind="class"
   ```

2. **Fall back to `codebase-retrieval` only if:**
   - Symbol not found (not indexed)
   - Searching prose/comments (not code structure)
   - Repo not initialized with CodeGraph

**Why:** Semantic search finds symbols even when names don't match exactly.

---

## When NOT to Use CodeGraph

- **Documentation files** (`.md`, `.txt`) — use `view`
- **Configuration** (`package.json`, `.env`, `tsconfig.json`) — use `view`
- **Repo not indexed** (no `.codegraph/`) — fall back to file tools
- **Fresh files** (just created, not yet indexed) — use `view` until next index

---

## CodeGraph Tool Priority

| Task | Use This | NOT This |
|------|----------|----------|
| Find callers of function | `codegraph_callers` | `view` + grep |
| Impact analysis before refactor | `codegraph_impact` | `codebase-retrieval` |
| Understand code area | `codegraph_explore` | Multiple `view` calls |
| Find symbol definition | `codegraph_search` | `codebase-retrieval` |
| Get full symbol details | `codegraph_node` | `view` + manual search |

---

## Verification

**Before claiming "no impact" or "no callers":**

Run `codegraph_impact` and `codegraph_callers` — don't trust manual inspection alone.

**Before major refactor:**

1. `codegraph_impact symbol="targetSymbol" depth=2`
2. Review all affected symbols
3. Plan updates for each

**Why:** CodeGraph catches transitive dependencies humans miss.

---

## Banner

When using CodeGraph tools proactively (not user-requested):

`[■] TOOL: codegraph_impact — checking refactor safety`

---

## Index Requirement

CodeGraph requires `.codegraph/` index. If missing:

1. Announce: `CodeGraph not indexed — run: codegraph init -i`
2. Fall back to file tools
3. Suggest indexing for future sessions

Don't fail silently — tell user CodeGraph available but not set up.

---

## Summary

**Semantic analysis first, file reading second.** CodeGraph understands code structure — use it.
