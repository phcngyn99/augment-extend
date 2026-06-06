---
name: deep-research
description: "Multi-source deep research. MANDATORY: DO NOT run web-search inline — ALWAYS delegate to sub-agent-explore. Read the full SKILL.md for the dispatch template. Use when the user wants thorough research on any topic with evidence and citations."
origin: ECC
---

# Deep Research

Produce thorough, cited research reports from multiple web sources.

## When to Activate

- User asks to research any topic in depth
- Competitive analysis, technology evaluation, or market sizing
- Due diligence on companies, investors, or technologies
- Any question requiring synthesis from multiple sources
- User says "research", "deep dive", "investigate", or "what's the current state of"

## Execution Mode — MANDATORY

**DO NOT run web-search or web-fetch directly in the main conversation. ALWAYS delegate to `sub-agent-explore`.** This is not optional — running research inline pollutes the main context with ~15-20K tokens of raw search results.

**Step 1:** Identify 4-6 research angles for the topic.
**Step 2:** Split angles across 2-4 parallel `sub-agent-explore` agents (minimum 2, scale up for broader topics).
**Step 3:** Dispatch all agents simultaneously — they run in parallel.
**Step 4:** Synthesize the parallel reports into a single unified report for the user.

**Scaling guide:**
- Narrow topic (single product, specific question): 2 agents
- Medium topic (comparison, market segment): 3 agents
- Broad topic (industry landscape, trend analysis): 4 agents

**CRITICAL: You MUST make multiple separate `sub-agent-explore` tool calls in ONE parallel block. DO NOT put all angles into a single agent. Each agent is a separate tool call with a unique name.**

**Example — "State of AI code editors 2026" dispatches 3 agents simultaneously:**

Agent 1 — `sub-agent-explore` name=`research-major-players` instruction:
```
You are a research agent. EXECUTE searches now.
TOPIC: AI code editors 2026
YOUR FOCUS: Major players and market positioning
STEP 1 — SEARCH (run all in parallel):
- web-search('Cursor AI editor 2026')
- web-search('GitHub Copilot 2026 features')
- web-search('Windsurf AI editor 2026')
STEP 2 — FETCH 2-3 best URLs from results
STEP 3 — Return: Key Findings (bulleted with URLs), Sources, Confidence, Gaps
You MUST call web-search and web-fetch. Do NOT just return instructions.
```

Agent 2 — `sub-agent-explore` name=`research-emerging-tools` instruction:
```
You are a research agent. EXECUTE searches now.
TOPIC: AI code editors 2026
YOUR FOCUS: Emerging and agentic tools
STEP 1 — SEARCH (run all in parallel):
- web-search('Augment Agent Augment Code 2026')
- web-search('Devin AI agent coding 2026')
- web-search('agentic coding autonomous AI 2026')
STEP 2 — FETCH 2-3 best URLs from results
STEP 3 — Return: Key Findings (bulleted with URLs), Sources, Confidence, Gaps
You MUST call web-search and web-fetch. Do NOT just return instructions.
```

Agent 3 — `sub-agent-explore` name=`research-trends` instruction:
```
You are a research agent. EXECUTE searches now.
TOPIC: AI code editors 2026
YOUR FOCUS: Industry trends and developer adoption
STEP 1 — SEARCH (run all in parallel):
- web-search('AI code editor market trends 2026')
- web-search('developer survey AI coding tools 2026')
- web-search('vibe coding AI native IDE 2026')
STEP 2 — FETCH 2-3 best URLs from results
STEP 3 — Return: Key Findings (bulleted with URLs), Sources, Confidence, Gaps
You MUST call web-search and web-fetch. Do NOT just return instructions.
```

**All 3 agents above are dispatched in ONE parallel tool call block — they run simultaneously.**

**Step 4 — Synthesis (you do this in the main conversation):**
After all agents return, merge their reports into:
- Executive Summary (3-5 sentences)
- Key Findings (bulleted, deduplicated, with source URLs)
- Sources (combined numbered list)
- Confidence Level (high/medium/low per section)
- Open Questions (combined gaps from all agents)

**Why:** Each agent's raw search results (~5-8K tokens) stay sandboxed. The main conversation receives only the merged findings (~3-4K tokens total). Parallel execution also cuts wall-clock time significantly.

## Tools

**Free (always available):**
- `web-search` — keyword search, returns snippets
- `web-fetch` — fetch full page content as markdown

**Optional MCP (if configured):**
- **firecrawl** — `firecrawl_search`, `firecrawl_scrape`, `firecrawl_crawl`
- **exa** — `web_search_exa`, `web_search_advanced_exa`, `crawling_exa`

The sub-agent uses whichever tools are available. Free tools are sufficient for most research.

## Workflow

### Step 1: Understand the Goal

Ask 1-2 quick clarifying questions:
- "What's your goal — learning, making a decision, or writing something?"
- "Any specific angle or depth you want?"

If the user says "just research it" — skip ahead with reasonable defaults.

### Step 2: Plan the Research

Break the topic into 3-5 research sub-questions. Example:
- Topic: "Impact of AI on healthcare"
  - What are the main AI applications in healthcare today?
  - What clinical outcomes have been measured?
  - What are the regulatory challenges?
  - What companies are leading this space?
  - What's the market size and growth trajectory?

### Step 3: Execute Multi-Source Search

For EACH sub-question, search using available MCP tools:

**With firecrawl:**
```
firecrawl_search(query: "<sub-question keywords>", limit: 8)
```

**With exa:**
```
web_search_exa(query: "<sub-question keywords>", numResults: 8)
web_search_advanced_exa(query: "<keywords>", numResults: 5, startPublishedDate: "2025-01-01")
```

**Search strategy:**
- Use 2-3 different keyword variations per sub-question
- Mix general and news-focused queries
- Aim for 15-30 unique sources total
- Prioritize: academic, official, reputable news > blogs > forums

### Step 4: Deep-Read Key Sources

For the most promising URLs, fetch full content:

**With firecrawl:**
```
firecrawl_scrape(url: "<url>")
```

**With exa:**
```
crawling_exa(url: "<url>", tokensNum: 5000)
```

Read 3-5 key sources in full for depth. Do not rely only on search snippets.

### Step 5: Synthesize and Write Report

Structure the report:

```markdown
# [Topic]: Research Report
*Generated: [date] | Sources: [N] | Confidence: [High/Medium/Low]*

## Executive Summary
[3-5 sentence overview of key findings]

## 1. [First Major Theme]
[Findings with inline citations]
- Key point ([Source Name](url))
- Supporting data ([Source Name](url))

## 2. [Second Major Theme]
...

## 3. [Third Major Theme]
...

## Key Takeaways
- [Actionable insight 1]
- [Actionable insight 2]
- [Actionable insight 3]

## Sources
1. [Title](url) — [one-line summary]
2. ...

## Methodology
Searched [N] queries across web and news. Analyzed [M] sources.
Sub-questions investigated: [list]
```

### Step 6: Deliver

- **Short topics**: Post the full report in chat
- **Long reports**: Post the executive summary + key takeaways, save full report to a file

## Quality Rules

1. **Every claim needs a source.** No unsourced assertions.
2. **Cross-reference.** If only one source says it, flag it as unverified.
3. **Recency matters.** Prefer sources from the last 12 months.
4. **Acknowledge gaps.** If you couldn't find good info on a sub-question, say so.
5. **No hallucination.** If you don't know, say "insufficient data found."
6. **Separate fact from inference.** Label estimates, projections, and opinions clearly.

## Examples

```
"Research the current state of nuclear fusion energy"
"Deep dive into Rust vs Go for backend services in 2026"
"Research the best strategies for bootstrapping a SaaS business"
"What's happening with the US housing market right now?"
"Investigate the competitive landscape for AI code editors"
```
