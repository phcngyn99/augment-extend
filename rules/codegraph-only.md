# Agent Architecture Constraints

> **Note:** This rule documents enforcement policy. The actual prohibition is enforced via `toolPermissions` in `settings.json` — `codebase-retrieval` and `grep-search` are hard-denied at the tool layer. This rule provides rationale and usage guidance for the allowed CodeGraph tools.

## CodeGraph as the Exclusive Code Intelligence Layer

### Required Tools
Use **CodeGraph MCP tools** for all codebase discovery, navigation, and dependency analysis tasks:

- `codegraph_explore_codegraph` — **PRIMARY** flow discovery tool. Takes symbol names, returns call paths + source
- `codegraph_node_codegraph` — **SECONDARY** depth tool. Returns symbol body + caller/callee trail OR reads file with line numbers
- `codegraph_search_codegraph` — Symbol name search by kind/limit
- `codegraph_callers_codegraph` — Who calls this symbol
- `codegraph_callees_codegraph` — What this symbol calls
- `codegraph_impact_codegraph` — Blast radius / dependency depth
- `codegraph_files_codegraph` — File tree + language + symbol counts
- `codegraph_status_codegraph` — Index health check

### Tool Policy
- **Do not use** `codebase-retrieval` (already denied in settings)
- **Do not use** `grep-search` (already denied in settings)
- All code search and code understanding workflows **must** use CodeGraph MCP tools exclusively

### When to Use Which Tool

**Start with `codegraph_explore_codegraph`** for:
- "How does X reach Y" flow questions
- Understanding call paths between components
- Tracing feature implementations
- Any question involving multiple symbols or flow

**Use `codegraph_node_codegraph`** for:
- **Reading ANY indexed file** (pass `file` alone, no `symbol`) — **USE THIS INSTEAD OF `view` FOR SOURCE/CONFIG FILES**
- Deep dive after explore identifies the symbols
- Getting full body + caller/callee trail for one symbol
- Disambiguating overloads (returns ALL matching bodies in one call)

**Use `codegraph_search_codegraph`** for:
- Finding symbols by name when you don't know location
- Filtering by kind (function/class/method/etc)

**Use `codegraph_callers_codegraph/callees_codegraph/impact_codegraph`** for:
- Refactor planning
- Understanding side effects
- Blast radius analysis

**Avoid `view` and Terminal commands for:**
- Reading source files → use `codegraph_node_codegraph({ file: "..." })`
- Searching code → use `codegraph_search_codegraph` or `codegraph_explore_codegraph`
- Finding files → use `codegraph_files_codegraph` (returns tree + metadata)
- Grepping content → use `codegraph_search_codegraph` with kind filters

### Reading Files — CRITICAL

**`codegraph_node_codegraph` with `file` param (no `symbol`) REPLACES the `view` tool for ALL indexed files.**

**Always try `codegraph_node_codegraph` FIRST before falling back to `view`.**

**Examples:**
```javascript
// CORRECT - read source file
codegraph_node_codegraph({ file: "app/services/api.py" })

// CORRECT - read config file (if indexed)
codegraph_node_codegraph({ file: "app/config/database.json" })

// CORRECT - read SQL file
codegraph_node_codegraph({ file: "schemas/users.sql" })

// WRONG - don't use view if file might be indexed
view({ path: "app/services/api.py" })
```

**What you get:**
- Source with line numbers (exact same format as `view`)
- One-line dependency note (which files depend on this)
- **Faster** (served from index, no disk read)
- Safe to edit from (line-numbered format)
- Works for `.py`, `.js`, `.ts`, `.sql`, `.json`, `.yaml`, config files

**Fallback to `view` only when:**
- `codegraph_node_codegraph` returns "file not in index"
- Binary files (images, PDFs)
- Generated files explicitly excluded from index

### Enforcement
- `codebase-retrieval` is **prohibited** (denied via `toolPermissions`)
- `grep-search` is **prohibited** (denied via `toolPermissions`)
- Requests that would use these tools must redirect to appropriate CodeGraph MCP tool
- Any workflow requiring codebase context must use CodeGraph MCP tools exclusively

### Why This Matters
CodeGraph provides:
- **Faster** — index-backed, no filesystem scan
- **Structural** — call graphs, impact analysis, flow tracing
- **Complete** — includes synthesized edges for dynamic dispatch (callbacks, React render, event emitters)
- **Always fresh** — auto-sync keeps index current
- **Fewer tool calls** — one `codegraph_node_codegraph` returns file + dependencies vs separate `view` + searches

**Common mistake:** Using `view` to read `.py`/`.js`/`.ts`/`.sql` files when `codegraph_node_codegraph({ file: "..." })` would work.

**Result:** Wasted reads, no dependency info, slower responses.

**Fix:** Always try `codegraph_node_codegraph` first for ANY file that might be indexed.
