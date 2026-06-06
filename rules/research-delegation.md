# Research Delegation Rule

When the user asks to research, deep dive, investigate, or asks "what's the current state of" any topic:

1. **DO NOT** call `web-search` or `web-fetch` directly in the main conversation
2. **ALWAYS dispatch 2+ `sub-agent-explore` agents in parallel** — minimum 2, up to 4 for broad topics
3. Each agent gets a **different focus area** with its own search queries
4. Each agent instruction must be **self-contained** — include the actual `web-search('...')` calls to execute
5. **All agents dispatch in one parallel tool call block** — they run simultaneously
6. If an agent returns without results, re-dispatch that agent only — DO NOT fall back to inline searching
7. After all agents return, **synthesize** their reports into one unified report

**How to split — example for "State of AI code editors 2026":**
```
sub-agent-explore name="research-major-players"    → Cursor, Copilot, Windsurf
sub-agent-explore name="research-emerging-tools"   → Augment Agent, Augment, Devin, agentic coding
sub-agent-explore name="research-trends"           → market trends, developer surveys, adoption
```
All three dispatched in ONE parallel block.

**Why:** Parallel agents = faster results + better context isolation. Each agent's raw data stays sandboxed.

**Exception:** Single quick lookups ("what version is X?", "is X free?") can use web-search directly.
