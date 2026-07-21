# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- CodeGraph MCP server now launched via local binary instead of `npx` (`settings.json`, `settings.json.template`, `settings.json.arm-template`)
  - **Before:** `"command": "npx", "args": ["-y", "@colbymchenry/codegraph", "serve", "--mcp"]`
  - **After:** `"command": "codegraph", "args": ["serve", "--mcp"]`
  - **Root cause:** `npx -y @colbymchenry/codegraph` re-resolves package metadata from npm registry on every Auggie startup. On 7.9GB index (3M nodes, 7.9M edges, entire `$HOME` indexed), startup budget was exceeded → `MCP error -32001: Request timed out`. Local binary `/usr/bin/codegraph` (v1.4.1, installed via official `install.sh`) skips registry lookup and initializes in ~1s.
  - **Prereq:** `codegraph` on PATH — already satisfied by `curl -fsSL https://raw.githubusercontent.com/colbymchenry/codegraph/main/install.sh | sh` (step 1 in `scripts/setup-symlinks.sh` "Next" instructions).
  - **Docs:** `README.md` — added "MCP wiring" note under CodeGraph section explaining the binary-vs-npx rationale.
  - **Verification:** `echo '{...initialize...}' | codegraph serve --mcp` returns valid JSON-RPC response in seconds. Stale `npx`-spawned MCP processes killed; healthy binary process (PID 13206) retained.

### Fixed

- MCP server startup timeouts (`-32001: Request timed out`) for `context7`, `codegraph`, `playwright` (`settings.json`, `settings.json.template`, `settings.json.arm-template`)
  - **Root cause:** `npx -y @<pkg>@latest` forces npm registry metadata fetch on every startup. Corporate/slow network made fetch hang >30s → MCP startup timed out.
  - **Fix:** Dropped `-y` and `@latest` from args. `npx @<pkg>` resolves from globally installed package (no registry recheck). Tested: old form = 30s timeout, new form = ~1.3s.
  - **Prereq:** Packages installed globally via `sudo npm i -g @upstash/context7-mcp @colbymchenry/codegraph @playwright/mcp` (already present for codegraph + playwright; context7 added).
  - **Files:** `settings.json`, `settings.json.template`, `settings.json.arm-template` — removed `-y` + `@latest` from 3 `mcpServers` entries (`context7`, `codegraph`, `playwright`).
  - **Docs:** `docs/playwright-arm64-jetson.md` — updated 4 stale `npx -y @playwright/mcp@latest` references to `npx @playwright/mcp`; added "Why no `-y` or `@latest`" rationale block; fixed version string (v1.62.0 → v0.0.78).

### Fixed

- `spawn bash ENOENT` error in `PreToolUse:launch-process` hook (`settings.json.template`, `settings.json.arm-template`)
  - **Root cause:** Augment CLI spawned from GUI/daemon with stripped `PATH` (missing `/bin`, `/usr/bin`). Hook command `~/.augment/hooks/dcg-pre-shell.sh` triggered Node `child_process.spawn('bash', ...)`, which failed PATH lookup for `bash`.
  - **Fix:** Bypass `.sh` wrapper. Point hook command directly at Python file: `/usr/bin/env python3 /home/wanek3/.augment/hooks/dcg-pre-shell.py`. `/usr/bin/env` is absolute (no PATH lookup for env itself), uses POSIX default PATH fallback when env PATH empty, resolves `python3` at runtime.
  - **Why not absolute `/usr/bin/python3`:** Keeps portability across systems where Python lives at different paths (e.g., `/opt/homebrew/bin/python3` on macOS ARM64).
  - **Verification:** Tested with empty env (`env -i /usr/bin/env python3 ...`) → resolves to `/usr/bin/python3` via POSIX default PATH. Both safe (`echo`) and destructive (`rm -rf /`) commands tested end-to-end.

### Added

- Playwright MCP server to `settings.json` (`mcpServers.playwright`) — ARM64 Jetson config
  - Uses Playwright's bundled ARM64 chromium via `--executable-path`
  - Flags: `--headless --no-sandbox --ignore-https-errors --executable-path /home/wanek3/.cache/ms-playwright/chromium-1228/chrome-linux/chrome`
  - **Why `--executable-path` is required on ARM64:** `@playwright/mcp` only supports `--browser` values `chrome`, `firefox`, `webkit`, `msedge` (no `chromium` channel). `chrome` channel looks for Google Chrome at `/opt/google/chrome/chrome` (sudo install, fails on ARM64 Jetson). Only working path = bundled chromium via `--executable-path`.
- Two `settings.json` templates:
  - `settings.json.template` — normal/x64 systems. Uses `--browser chrome` channel.
  - `settings.json.arm-template` — ARM64/Jetson. Uses `--executable-path` to bundled chromium. Contains `<USER>` placeholder + `chromium-1228` version dir (adjust per install + after Playwright upgrades).
- Updated `scripts/install-to-augment.sh` to auto-select template by architecture
  - Detects `aarch64`/`arm64` via `uname -m` → uses `settings.json.arm-template`
  - Falls back to `settings.json.template` on other archs (x64)
  - On ARM, runs `sed` to replace `/home/<USER>/` with actual `$HOME` path in the copied `settings.json`
  - Prints warning if Playwright upgraded (chromium version dir changes — user must update `--executable-path`)

### Changed

- Rewrote `docs/playwright-arm64-jetson.md` based on verified testing (2026-07-20)
  - Original snap-chromium approach fails on this device: `snap-confine` can't get `cap_dac_override` capability → snap browsers (brave, chromium) won't launch
  - New working path: Playwright bundled chromium (already installed in user cache)
  - Added "What Works Here" / "What Does NOT Work Here" sections with test evidence
  - Updated config snippet, test commands, troubleshooting, and "Why Bundled Chromium" rationale
  - Documented corporate web filter 503 blocking as a network issue, not Playwright

### Removed

- Removed ponytail skills, kept only the rule (sourced from `submodule/ponytail`)
  - Removed 6 skill symlinks: `skills/ponytail`, `skills/ponytail-audit`, `skills/ponytail-debt`, `skills/ponytail-gain`, `skills/ponytail-help`, `skills/ponytail-review`
  - Retained `submodule/ponytail` and `rules/ponytail.md` symlink → `submodule/ponytail/.agents/rules/ponytail.md` (the lazy-senior-dev rule stays)
  - Removed ponytail skill symlink creation from `scripts/setup-symlinks.sh` (kept rules symlink line)
  - Updated counts: README.md (29 → 23 core skills), AGENTS.md (29 → 23 core skills)
- Removed ponytail rule and `submodule/ponytail` entirely (lazy-senior-dev mode dropped)
  - `git submodule deinit -f submodule/ponytail` then `git rm -f submodule/ponytail rules/ponytail.md`
  - Removed `rules/ponytail.md` symlink (target gone)
  - Removed ponytail rule symlink creation from `scripts/setup-symlinks.sh`
  - Updated README.md (12 → 11 submodules, rules list no longer mentions `ponytail.md`)
  - Updated AGENTS.md (12 → 11 submodules, ponytail dropped from submodule list)

### Changed

- Synced `settings.json.template` with live `settings.json`
  - `PreToolUse.command`: `~/.augment/hooks/dcg-pre-shell.py` → `~/.augment/hooks/dcg-pre-shell.sh` (template was stale, live uses the `.sh` wrapper)
  - Added `grep-search` and `web-fetch` denies to `toolPermissions` in both files to match `rules/agent-browser-only.md` policy claims
  - Only remaining diff between template and live is `indexingAllowDirs` (template ships `[]`, live has the user's workspace path) — expected
- Moved `hooks/dcg-pre-shell.sh` into `scripts/store/hooks/` (source of truth for non-symlink files)
  - `--nuke` flag previously wiped this file since it wasn't in `store/`; now restored alongside `dcg-pre-shell.py`
  - Added `hooks/dcg-pre-shell.sh` to `.gitignore` (build artifact, regenerated from store)
  - Updated `scripts/setup-symlinks.sh`: chmod for `.sh` wrappers (`dcg-pre-shell.sh`, `session-start.sh`)
  - Added `--nuke` flag to `scripts/setup-symlinks.sh` — wipes `skills/`, `rules/`, `hooks/`, `agents/` completely, then recreates symlinks and restores non-symlink files from `scripts/store/`
  - Introduced `scripts/store/` as source of truth for non-symlink files (moved via `git mv`):
    - `scripts/store/skills/browse-skills/SKILL.md`
    - `scripts/store/rules/{agent-browser-only,caveman-active,codegraph,finn-guidelines}.md`
    - `scripts/store/hooks/dcg-pre-shell.py`
    - `scripts/store/agents/plan.md`
  - Script always restores real files from store at end of run (idempotent); `session-start.sh` stays heredoc-generated

### Changed

- Merged `startup/` into `scripts/` (both held shell utilities, semantic-only split)
  - `git mv startup/show-workspace.sh scripts/show-workspace.sh`
  - `git mv startup/update-submodules.sh scripts/update-submodules.sh`
  - Removed `startup/` directory
  - Updated `settings.json` + `settings.json.template` `startupScript` path → `~/.augment/scripts/show-workspace.sh`
  - Updated `README.md` (architecture tree, update command, structure list) + `scripts/update-submodules.sh` self-reference

### Added

- Added obsidian-skills submodule (`submodule/obsidian-skills`) — 5 new core skills for Obsidian workflows
  - `skills/defuddle` → `submodule/obsidian-skills/skills/defuddle`
  - `skills/json-canvas` → `submodule/obsidian-skills/skills/json-canvas`
  - `skills/obsidian-bases` → `submodule/obsidian-skills/skills/obsidian-bases`
  - `skills/obsidian-cli` → `submodule/obsidian-skills/skills/obsidian-cli`
  - `skills/obsidian-markdown` → `submodule/obsidian-skills/skills/obsidian-markdown`
  - Updated counts: README.md (23 → 28 core skills, 11 → 12 submodules), AGENTS.md (23 → 28 core, 11 → 12 submodules)
  - Wired symlink creation in `scripts/setup-symlinks.sh`

- Added dcg (Destructive Command Guard) PreToolUse hook integration
  - Created `hooks/dcg-pre-shell.py` - Python bridge that pipes Augment `launch-process` commands to dcg binary, translates dcg output to Augment's `hookSpecificOutput` protocol
  - Registered PreToolUse hook in `settings.json` matching `launch-process` tool with 5s timeout
  - Hook intercepts shell commands before execution, blocks destructive git/filesystem operations
  - Fail-open on all error paths (malformed input, dcg missing, parse errors)
  - Treats both `deny` and `ask` permission decisions as blocks (Augment only supports `deny`)

- Added superpowers hooks integration (SessionStart hook)
  - Created symlinks: `hooks/hooks.json`, `hooks/run-hook.cmd`, `hooks/session-start` → `submodule/superpowers/hooks/*`
  - Created `hooks/session-start.sh` - Unix wrapper with Augment-compatible JSON format (`hookSpecificOutput.additionalContext`)
  - Registered SessionStart hook in `settings.json` using absolute path
  - Hook injects `using-superpowers` skill content at session start for auto-triggering skills
  - Verified: `brainstorming` skill auto-triggers on "Let's make a react todo list" acceptance test

- Added `rules/codegraph.md` - CodeGraph MCP usage guidance converted from submodule
  - Converted from Cursor-specific `.mdc` format to Augment-compatible `.md` format
  - Changed frontmatter: `alwaysApply: true` → `type: always_apply`
  - Provides guidance on using `codegraph_explore` tool

### Removed

- Removed `rules/codegraph-only.md` - CodeGraph enforcement policy no longer needed
  - Removed symlink creation from setup script
  - CodeGraph remains default code intelligence layer via tool permissions in settings.json

- Added `rules/agent-browser-only.md` - Enforcement policy for using Agent Browser MCP tools exclusively for web interactions
  - Prohibits `web-fetch` (already denied in settings.json)
  - Establishes fallback hierarchy: Agent Browser → Playwright → Never web-fetch
  - Documents all agent-browser MCP tools and usage patterns
  - Mirrors structure of `rules/codegraph-only.md`
- Added `rules/finn-guidelines.md` - Personal technical decision-making guideline: prioritize correctness over development cost

### Changed

- Moved `skills/karpathy-guidelines` → `skills-lib/karpathy-guidelines` (now optional, on-demand skill)
  - Updated skill counts: 29 core → 28 core, 6 optional → 7 optional
  - Updated README.md and skills-lib/README.md to reflect new counts
  - Added karpathy-guidelines entry to skills-lib catalog
  - Updated scripts/setup-symlinks.sh to create symlink in skills-lib/ instead of skills/

### Changed

- Enhanced `AGENTS.md` with comprehensive workspace rules following recommended frontmatter format
  - Added YAML frontmatter with `type: always_apply`
  - Expanded from 2 rules to 8 sections covering: Version Control, Skills, Agents, Submodules, Rules, Scripts, File Organization, Documentation
  - Preserved original rules: "Update CHANGELOG.md before committing" and "Do not auto commit"
  - Added specific guidelines for symlink management, submodule updates, and directory structure

### Added

- Added ponytail submodule integration with symlinks for 6 skills:
  - `skills/ponytail` → `submodule/ponytail/skills/ponytail` (core YAGNI enforcement)
  - `skills/ponytail-audit` → `submodule/ponytail/skills/ponytail-audit` (/ponytail-audit command)
  - `skills/ponytail-debt` → `submodule/ponytail/skills/ponytail-debt` (/ponytail-debt command)
  - `skills/ponytail-gain` → `submodule/ponytail/skills/ponytail-gain` (/ponytail-gain command)
  - `skills/ponytail-help` → `submodule/ponytail/skills/ponytail-help` (/ponytail-help command)
  - `skills/ponytail-review` → `submodule/ponytail/skills/ponytail-review` (/ponytail-review command)
- Added `browse-skills` skill - catalog optional skills in skills-lib (TDD verified)
- Added `skills-lib/README.md` - single-source catalog for all optional skills
- Added `agents/plan.md` - custom plan agent that overrides built-in plan subagent to enforce writing-plans skill usage
- Added `docs/playwright-arm64-jetson.md` - comprehensive guide for Playwright setup on ARM64/Jetson with snap Chromium
- Updated `README.md` - comprehensive documentation reflecting current architecture, all 9 submodules, skills/skills-lib distinction, tool integrations, MCP servers, and troubleshooting

### Changed

- Enhanced `agents/plan.md` to enforce strict path compliance (`docs/superpowers/plans/YYYY-MM-DD-<feature>.md`) and explicit skill announcement

### Fixed

- Fixed plan agent to enforce correct directory structure (`docs/superpowers/plans/`) instead of `docs/plans/`
- Fixed plan agent to include required date prefix (YYYY-MM-DD) in plan filenames

### Changed

- Moved non-standalone caveman skills to `skills-lib/`:
  - `skills/cavecrew` → `skills-lib/cavecrew` (requires Augment subagent runtime)
  - `skills/caveman-compress` → `skills-lib/caveman-compress` (requires Anthropic API)
- Moved grill-related skills to `skills-lib/`:
  - `skills/grilling` → `skills-lib/grilling`
  - `skills/grill-with-docs` → `skills-lib/grill-with-docs`
  - `skills/domain-modeling` → `skills-lib/domain-modeling`
- Removed duplicate rule symlinks to prevent double-loading:
  - Deleted `rules/caveman.md` (kept `skills/caveman` as canonical source)
  - Deleted `rules/karpathy-guidelines.md` (kept `skills/karpathy-guidelines` as canonical source)

### Fixed

- Fixed `scripts/setup-symlinks.sh` to create optional skills symlinks in `skills-lib/` instead of `skills/` (cavecrew, caveman-compress, grilling, grill-with-docs, domain-modeling)
- Compressed README.md (~45% reduction, 344→190 lines) — dropped filler, condensed lists, preserved all technical content

### Added

- Added andrej-karpathy-skills submodule integration
- Created symlink from `skills/karpathy-guidelines` to `submodule/andrej-karpathy-skills/skills/karpathy-guidelines`
- Created symlink from `rules/karpathy-guidelines.md` to `submodule/andrej-karpathy-skills/CLAUDE.md`
- Added caveman submodule integration with symlinks for 7 skills:
  - `skills/cavecrew` → `submodule/caveman/skills/cavecrew`
  - `skills/caveman` → `submodule/caveman/skills/caveman`
  - `skills/caveman-commit` → `submodule/caveman/skills/caveman-commit`
  - `skills/caveman-compress` → `submodule/caveman/skills/caveman-compress`
  - `skills/caveman-help` → `submodule/caveman/skills/caveman-help`
  - `skills/caveman-review` → `submodule/caveman/skills/caveman-review`
  - `skills/caveman-stats` → `submodule/caveman/skills/caveman-stats`
- Created symlink from `rules/caveman.md` to `submodule/caveman/skills/caveman/SKILL.md` for auto-active compressed communication style
- Added codegraph submodule (reference only - already integrated via MCP server, no symlinks needed)
- Added skills submodule integration with symlinks:
  - `skills/handoff` → `submodule/skills/skills/productivity/handoff`
  - `skills/grill-with-docs` → `submodule/skills/skills/engineering/grill-with-docs`
  - `skills/grilling` → `submodule/skills/skills/productivity/grilling`
  - `skills/domain-modeling` → `submodule/skills/skills/engineering/domain-modeling`
- Added superpowers submodule integration with symlinks for 14 skills:
  - `skills/brainstorming` → `submodule/superpowers/skills/brainstorming`
  - `skills/dispatching-parallel-agents` → `submodule/superpowers/skills/dispatching-parallel-agents`
  - `skills/executing-plans` → `submodule/superpowers/skills/executing-plans`
  - `skills/finishing-a-development-branch` → `submodule/superpowers/skills/finishing-a-development-branch`
  - `skills/receiving-code-review` → `submodule/superpowers/skills/receiving-code-review`
  - `skills/requesting-code-review` → `submodule/superpowers/skills/requesting-code-review`
  - `skills/subagent-driven-development` → `submodule/superpowers/skills/subagent-driven-development`
  - `skills/systematic-debugging` → `submodule/superpowers/skills/systematic-debugging`
  - `skills/test-driven-development` → `submodule/superpowers/skills/test-driven-development`
  - `skills/using-git-worktrees` → `submodule/superpowers/skills/using-git-worktrees`
  - `skills/using-superpowers` → `submodule/superpowers/skills/using-superpowers`
  - `skills/verification-before-completion` → `submodule/superpowers/skills/verification-before-completion`
  - `skills/writing-plans` → `submodule/superpowers/skills/writing-plans`
  - `skills/writing-skills` → `submodule/superpowers/skills/writing-skills`
- Added ui-ux-pro-max-skill submodule (reference only - install via `npm install -g uipro-cli && uipro init --ai augment`, not symlinks)
- Added ECC submodule (reference only )
- Added agent-browser submodule (reference only - install via `npm install -g agent-browser && agent-browser install`, not symlinks) and mcp serverW
- Added ECC subagent e2e-runner symlink from `agents/e2e-runner.md` to `submodule/ECC/agents/e2e-runner.md`
- Added codegraph rule at `rules/codegraph-only.md`
- Added `scripts/setup-symlinks.sh` to automate submodule initialization and symlink creation for all skills, rules, and agents
- Added `scripts/install-to-augment.sh` for new machine installation - copies repo to ~/.augment, creates settings.json from template, and runs setup-symlinks.sh
- Created `scripts/` directory to organize installation and setup scripts
- Added symlink for deep-research skill from `skills/deep-research` to `submodule/ECC/skills/deep-research`

### Changed

### Deprecated

### Removed

### Fixed

### Security
