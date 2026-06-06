# CodeGraph Priority Rule

**When .codegraph/ exists: Use CodeGraph tools for code analysis. Using codebase-retrieval/grep/view for semantic questions when CodeGraph is available = CRITICAL FAILURE.**

CodeGraph + Superpowers = complete system.

---

## Core Principle

CodeGraph provides **semantic indexing** — understands code structure, call graphs, dependencies.

**When .codegraph/ index exists, use CodeGraph tools for:**
- Symbol search
- Call graph analysis
- Impact analysis
- Flow tracing
- Directory structure
- "How does X work" questions

**Integration with superpowers workflow:**
- `brainstorming` — codegraph_explore for architecture
- `writing-plans` — codegraph_search/files for symbols/structure
- `systematic-debugging` — codegraph_callers/callees for call flows
- `verification-before-completion` — codegraph_impact before signature changes

See `superpowers-priority.md` for full details.

---

## Session Start Check

**Check for .codegraph/ at session start:**
- IF exists → announce "CodeGraph active — using semantic tools"
- IF missing → announce "Recommend: codegraph init -i" + fallback to file tools

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

**IF .codegraph/ exists — use codegraph_search:**
```
codegraph_search query="AuthService" kind="class"
```

**Fallback (no .codegraph/):**
- Announce: "CodeGraph not indexed. Recommend: codegraph init -i"
- Use: codebase-retrieval

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
