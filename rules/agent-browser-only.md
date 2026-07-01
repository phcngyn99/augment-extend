# Web Automation & Scraping Constraints

> **Note:** This rule documents enforcement policy. The actual prohibition is enforced via `toolPermissions` in `settings.json` — `web-fetch` is hard-denied at the tool layer. This rule provides rationale and usage guidance for the allowed web interaction tools.

## Agent Browser as the Exclusive Web Interaction Layer

### Required Tools
Use **Agent Browser MCP tools** for all web browsing, scraping, and automation tasks:

- `agent_browser_open_agent-browser` — Launch browser and navigate to URL
- `agent_browser_snapshot_agent-browser` — Get accessibility tree with element refs
- `agent_browser_click_agent-browser` — Click elements by @ref or CSS selector
- `agent_browser_fill_agent-browser` — Fill input fields
- `agent_browser_type_agent-browser` — Type text into elements
- `agent_browser_screenshot_agent-browser` — Capture screenshots
- `agent_browser_get_text_agent-browser` — Extract text from elements
- `agent_browser_get_html_agent-browser` — Get innerHTML from elements
- `agent_browser_eval_agent-browser` — Execute JavaScript in page context
- `agent_browser_wait_for_*` — Wait for selectors, text, URL, load states
- `agent_browser_scroll_agent-browser` — Scroll page or elements
- `agent_browser_close_agent-browser` — Close browser session

### Tool Policy
- **Do not use** `web-fetch` (already denied in settings)
- All web scraping, content extraction, and browser automation workflows **must** use Agent Browser MCP tools exclusively
- **Fallback hierarchy**: Agent Browser → Playwright (if Agent Browser unavailable) → Never `web-fetch`

### When to Use Which Tool

**Start with `agent_browser_open_agent-browser`** for:
- Any URL that needs to be visited
- Starting a new browser session
- Initial page navigation

**Use `agent_browser_snapshot_agent-browser`** for:
- Understanding page structure before interaction
- Getting element references for clicking/filling
- Accessibility tree analysis
- Finding interactive elements

**Use `agent_browser_get_text_agent-browser` / `agent_browser_get_html_agent-browser`** for:
- Extracting content from pages
- Scraping data
- Reading page information
- Getting structured content

**Use `agent_browser_eval_agent-browser`** for:
- Complex data extraction requiring JavaScript
- Interacting with dynamic content
- Accessing browser APIs
- Custom scraping logic

**Use interaction tools** (`click`, `fill`, `type`, `scroll`) for:
- Form submission
- Navigation through multi-page flows
- Interacting with dynamic SPAs
- Automated user journeys

**Use `agent_browser_screenshot_agent-browser`** for:
- Visual verification
- Debugging automation flows
- Capturing UI state
- Documentation

### Reading Web Content — CRITICAL

**`agent_browser_*` tools REPLACE `web-fetch` for ALL web content access.**

**Always try Agent Browser FIRST before considering Playwright.**

**Examples:**
```javascript
// CORRECT - use agent browser
agent_browser_open_agent-browser({ url: "https://example.com" })
agent_browser_get_text_agent-browser({ selector: "body" })

// FALLBACK - only if agent browser fails
// Use Playwright browser automation

// WRONG - don't use web-fetch
web_fetch({ url: "https://example.com" })
```

**What you get with Agent Browser:**
- Full browser context with JavaScript execution
- Ability to handle dynamic content and SPAs
- Session persistence across multiple interactions
- Screenshot and visual debugging capabilities
- Accessibility tree for robust element selection
- Real browser behavior (no bot detection issues)

**Fallback to Playwright only when:**
- Agent Browser MCP server is not available
- Agent Browser tools fail or timeout
- Specific Playwright features are required

**Never use `web-fetch` for:**
- Any web content that might have JavaScript
- Pages requiring cookies or sessions
- Dynamic/SPA applications
- Content behind user interactions
- Pages with bot detection

### Enforcement
- `web-fetch` is **prohibited** (denied via `toolPermissions`)
- Requests that would use `web-fetch` must redirect to Agent Browser tools
- Any workflow requiring web content must use Agent Browser MCP tools exclusively

### Why This Matters
Agent Browser provides:
- **Real browser** — full JavaScript execution, no static HTML limitations
- **Interactive** — can click, fill forms, navigate multi-step flows
- **Session-aware** — maintains cookies, localStorage, authentication state
- **Bot-resistant** — real browser fingerprint, passes most anti-bot measures
- **Visual debugging** — screenshots at any step for verification
- **Accessibility-first** — semantic element selection via accessibility tree
- **Fewer failures** — handles dynamic content that breaks static fetchers

**Common mistake:** Using `web-fetch` for modern web pages when Agent Browser can handle dynamic content and JavaScript.

**Result:** Missing content, broken on SPAs, failed bot detection, no interaction capability.

**Fix:** Always use Agent Browser for web content. Only consider Playwright if Agent Browser is unavailable.
