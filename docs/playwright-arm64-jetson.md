# Playwright MCP on ARM64 (NVIDIA Jetson Orin)

**Target Platform:** NVIDIA Jetson Orin / ARM64 Linux (`aarch64`)
**Tested:** 2026-07-20 on this device. Playwright MCP **works**.

This guide covers Playwright MCP setup for ARM64. The original plan (use snap chromium) failed on this device — snap confinement blocks brave/chromium launches. The working path is **Playwright's bundled chromium**, which runs natively on ARM64.

## What Works Here (verified)

- `@playwright/mcp@latest` (v1.62.0) launches as MCP server
- 24 MCP tools exposed (`browser_navigate`, `browser_snapshot`, `browser_close`, `browser_evaluate`, etc.)
- Bundled chromium at `~/.cache/ms-playwright/chromium-1228/chrome-linux/chrome` runs on ARM64
- Bundled firefox at `~/.cache/ms-playwright/firefox-1532/firefox` also works (but MCP `--browser firefox` channel fails — needs MCP-specific browser install)
- Full MCP round-trip: `initialize` → `tools/list` → `browser_navigate` → `browser_snapshot` returns accessibility-tree YAML with element refs
- **Working config requires `--executable-path`** to bundled chromium. `@playwright/mcp` has no `chromium` channel flag (only `chrome`, `firefox`, `webkit`, `msedge`), and `chrome` channel looks for Google Chrome at `/opt/google/chrome/chrome` (sudo install — fails on ARM64).

## What Does NOT Work Here (verified)

- ❌ `snap install chromium` — needs sudo password, no candidate on this system
- ❌ `snap/bin/brave` as `--executable-path` — `snap-confine` fails: `required permitted capability cap_dac_override not found`. All snap-packaged browsers blocked by snap confinement on this device.
- ❌ `apt install chromium` — no candidate in apt repos
- ❌ External network access — corporate web filter returns 503 on `example.com`, `neverssl.com`, all external URLs. **Not a Playwright issue.** `--ignore-https-errors` cannot bypass HTTP-level 503 blocking.

## Prerequisites

### Node + Playwright already installed

Verify (this device already has these globally at `/usr/lib/node_modules`):

```bash
node --version        # v20.20.2
npm --version         # 11.16.0
npm ls -g playwright @playwright/mcp  # both present
```

### Bundled chromium installed

```bash
ls ~/.cache/ms-playwright/
# Expect: chromium-1228/ chromium_headless_shell-1228/ firefox-1532/ ...
ls ~/.cache/ms-playwright/chromium-1228/chrome-linux/chrome
# Should exist
```

If missing, run `npx playwright install chromium` (downloads ARM64 build, no sudo needed — installs to user cache).

## Configure MCP Server

Add to `~/.augment/settings.json` under `mcpServers`:

```json
"playwright": {
  "command": "npx",
  "args": [
    "-y",
    "@playwright/mcp@latest",
    "--headless",
    "--no-sandbox",
    "--ignore-https-errors",
    "--executable-path",
    "/home/<USER>/.cache/ms-playwright/chromium-1228/chrome-linux/chrome"
  ]
}
```

**Why `--executable-path` is required on this device:**

`@playwright/mcp` `--browser` flag only accepts: `chrome`, `firefox`, `webkit`, `msedge`. **No `chromium` option.** Defaults to `chrome` channel = looks for Google Chrome at `/opt/google/chrome/chrome` (requires sudo install — fails on ARM64 Jetson). `firefox`/`webkit` channels need MCP-specific browser install (`npx @playwright/mcp install-browser <name>`), also fail.

Only working path on ARM64 Jetson = `--executable-path` pointing to Playwright's bundled ARM64 chromium (installed via `npx playwright install chromium`, no sudo). Pin to the version dir name.

**Note:** `--executable-path` is user-specific (absolute path). Replace `<USER>` with the actual username.

**Two templates ship in this repo:**
- `settings.json.template` — normal/x64 systems. Uses `--browser chrome` channel (relies on Google Chrome at `/opt/google/chrome/chrome`).
- `settings.json.arm-template` — ARM64/Jetson. Uses `--executable-path` to Playwright's bundled ARM64 chromium. Replace `<USER>` + version dir (`chromium-1228`) per install.

**Version directory naming:** `chromium-1228` is the build number for Playwright 1.61. When Playwright upgrades, the directory name changes (e.g. `chromium-1234`). Re-run `npx playwright install chromium` and update `--executable-path` to match the new dir.

## Critical Flags for ARM64 Jetson

**Always use:**

- `--headless` — No X server on headless Jetson
- `--no-sandbox` — Required on ARM64; without it the process hangs with no error
- `--ignore-https-errors` — Corporate proxy MITMs TLS
- `--executable-path <bundled chromium>` — Required. `@playwright/mcp` doesn't ship a `chromium` channel flag, and `chrome` channel fails (no Google Chrome on ARM64 without sudo).

## Test Installation

### 1. Smoke test bundled chromium directly

```bash
cd /tmp && cat > pw_test.mjs <<'EOF'
import pkg from '/usr/lib/node_modules/playwright/index.js';
const { chromium } = pkg;
const browser = await chromium.launch({
  headless: true,
  args: ['--no-sandbox', '--disable-setuid-sandbox']
});
const page = await browser.newPage();
await page.goto('http://localhost', { timeout: 30000 }).catch(e => console.log('nav err:', e.message.split('\n')[0]));
console.log('TITLE:', await page.title());
console.log('URL:', page.url());
await browser.close();
console.log('PASS');
EOF
node pw_test.mjs
```

Expected: prints TITLE + URL + `PASS`. (External URLs may return 503 from corporate filter — that's network, not Playwright.)

### 2. MCP server smoke test (with the exact settings.json arg set)

```bash
npx -y @playwright/mcp@latest --headless --no-sandbox --ignore-https-errors --executable-path ~/.cache/ms-playwright/chromium-1228/chrome-linux/chrome --help | head -20
```

Expected: prints Playwright MCP usage / options list. If `--help` works, the server launches successfully with bundled chromium.

### 3. Restart Augment

Restart Augment to load the MCP server configuration.

### 4. Verify in session

After restart, in an Augment session:

```javascript
browser_navigate({ url: "http://localhost" })
browser_snapshot()
```

Expected: Page snapshot with accessibility tree (element refs like `[ref=e2]`).

## Don't Do This

❌ **Don't use snap chromium as `--executable-path`** on this device
- `snap-confine` missing `cap_dac_override` capability → snap browsers can't launch
- Affects both `snap/bin/chromium` and `snap/bin/brave`

❌ **Don't run** `npx playwright install chrome`
- `chrome` channel = Google Chrome, not bundled chromium
- Use `npx playwright install chromium` instead (ARM64 build, user cache, no sudo)

❌ **Don't run without** `--no-sandbox`
- Process hangs indefinitely, no error message

❌ **Don't use headed mode**
- Headless Jetson has no display server → X11 errors

❌ **Don't expect `--ignore-https-errors` to bypass corporate 503 blocking**
- That flag only ignores TLS cert errors, not HTTP-level blocks

## Troubleshooting

**"Chromium distribution 'chrome' is not found at /opt/google/chrome/chrome"**
- `@playwright/mcp` defaults to `chrome` channel = Google Chrome (sudo install, fails on ARM64)
- Fix: add `--executable-path /home/<USER>/.cache/ms-playwright/chromium-1228/chrome-linux/chrome` to args
- Don't use `--browser chromium` — that channel name doesn't exist (only `chrome`, `firefox`, `webkit`, `msedge`)

**"Browser 'firefox' is not installed. Run npx @playwright/mcp install-browser firefox"**
- `--browser firefox` channel needs MCP-specific firefox install, not the standard Playwright one
- On ARM64 Jetson, stick with chromium path: `--executable-path ~/.cache/ms-playwright/chromium-1228/chrome-linux/chrome`

**"Browser not found" / "executable doesn't exist"**
- Verify: `ls ~/.cache/ms-playwright/chromium-1228/chrome-linux/chrome`
- If missing: `npx playwright install chromium`

**"snap-confine is packaged without necessary permissions"**
- Stop using snap browsers. Switch `--executable-path` to Playwright bundled chromium.
- Root cause: snap confinement cannot get required capabilities on this kernel.

**"Permission denied"**
- Add `--no-sandbox` to args
- Verify user is in `video` group: `groups | grep video`

**"SEC_ERROR_UNKNOWN_ISSUER" (firefox) or TLS errors**
- Add `--ignore-https-errors` (chromium path only)
- For firefox, the snap build doesn't accept this flag — use chromium

**"Application Blocked" / "Web Page Blocked" in page title**
- Not a Playwright failure — corporate web filter returned 503
- Test against a URL you know is allowlisted, or `http://localhost`

**"Connection timeout"**
- Check network: `curl -I http://<url>` — if 503, it's the corporate filter
- Confirm `--ignore-https-errors` is set (for TLS MITM, not HTTP blocks)

**MCP server not loading**
- Check JSON syntax in `settings.json` (one trailing comma breaks it)
- Test directly: `npx -y @playwright/mcp@latest --help`
- Check `~/.augment/logs/` if present

## Why Bundled Chromium (not snap)

The original version of this doc recommended snap chromium. On this device that path is broken — snap confinement (`snap-confine`) can't get `cap_dac_override`, so no snap-packaged browser launches. Bundled Playwright chromium works because:

- ✅ ARM64-native build (Playwright ships ARM64 binaries since 1.29)
- ✅ No snap confinement — plain executable, runs under normal user
- ✅ User-cache install — no sudo, updates on `npx playwright install`
- ✅ Matches `@playwright/mcp` expectations (channel, version, debug protocol)
- ✅ Smaller surface than maintaining a separate snap install

Tradeoff: Playwright chromium updates require re-running `npx playwright install chromium` periodically AND updating `--executable-path` in `settings.json` (the `chromium-XXXX` dir name changes per release). This is the price of `@playwright/mcp` not shipping a `chromium` channel flag.

## Related Documentation

- [Agent Browser Setup](../submodule/agent-browser/README.md) — Alternative browser automation (already configured as `agent-browser` MCP server in this workspace)
- [MCP Server Configuration](../README.md#mcp-servers) — General MCP setup guide
- [E2E Testing](../agents/e2e-runner.md) — E2E test patterns with Playwright/Agent Browser
