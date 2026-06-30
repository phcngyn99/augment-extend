# Playwright Installation for ARM64 (NVIDIA Jetson Orin)

**Target Platform:** NVIDIA Jetson Orin / ARM64 Linux

This guide covers Playwright setup for ARM64 environments where standard installation methods fail due to architecture constraints.

## Prerequisites

### Snap Chromium

Check if snap Chromium is installed:
```bash
snap list | grep chromium
```

If missing, install it:
```bash
sudo snap install chromium
```

## Installation Steps

### 1. Install Node Packages

```bash
npm install playwright@^1.61.0 @playwright/test@^1.61.0 @playwright/mcp@^0.0.75
```

### 2. Configure MCP Server

Add to `.augment/settings.json`:

```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": [
        "-y",
        "@playwright/mcp@latest",
        "--executable-path",
        "/snap/bin/chromium",
        "--headless",
        "--no-sandbox",
        "--ignore-https-errors"
      ]
    }
  }
}
```

### 3. Test Installation

```bash
node <<'EOF'
import playwright from 'playwright';
const browser = await playwright.chromium.launch({
  headless: true,
  args: ['--no-sandbox', '--disable-setuid-sandbox']
});
const page = await browser.newPage();
await page.goto('http://example.com');
console.log('Title:', await page.title());
await browser.close();
EOF
```

### 4. Restart Augment

Restart Augment to load the MCP server configuration.

## Critical Flags for ARM64 Jetson

**Always use these flags:**

- `--headless` — No X server available on Jetson
- `--no-sandbox` — Required for ARM64 compatibility
- `--ignore-https-errors` — Corporate proxy compatibility
- `--executable-path /snap/bin/chromium` — Use system browser instead of bundled

## Don't Do This

❌ **Don't run:** `npx playwright install chrome`
- Requires sudo
- Downloads bloated x64 binaries
- Won't work on ARM64

❌ **Don't run without** `--no-sandbox`
- Process hangs indefinitely
- No error message

❌ **Don't use headed mode**
- Jetson typically has no display server
- Will fail with X11 errors

## Verification

After restart, verify MCP tools are available:

```javascript
// In Augment session
browser_navigate_playwright({ url: "http://example.com" })
browser_snapshot_playwright()
```

Expected output: Page snapshot with accessibility tree.

## Troubleshooting

**"Browser not found"**
- Verify: `which chromium` → `/snap/bin/chromium`
- Check: `snap list | grep chromium`

**"Permission denied"**
- Add `--no-sandbox` flag to args
- Verify user is in `video` group: `groups | grep video`

**"Connection timeout"**
- Add `--ignore-https-errors` if behind corporate proxy
- Check network with: `curl -I http://example.com`

**MCP server not loading**
- Check logs: `~/.augment/logs/` (if available)
- Test directly: `npx @playwright/mcp@latest --help`

## Why This Approach

**Standard Playwright installation** (`npx playwright install`) downloads pre-built Chromium binaries for x64/x86 architectures. ARM64 is not officially supported.

**Using snap Chromium:**
- ✅ ARM64-native build
- ✅ System-managed updates
- ✅ No sudo required for Playwright scripts
- ✅ Smaller footprint than bundled browsers

## Related Documentation

- [Agent Browser Setup](../submodule/agent-browser/README.md) — Alternative browser automation (may have better ARM64 support)
- [MCP Server Configuration](../README.md#mcp-servers) — General MCP setup guide
- [E2E Testing](../agents/e2e-runner.md) — E2E test patterns with Playwright/Agent Browser
