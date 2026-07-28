# Augment Extend

Augment CLI extension — specialized agents, skills, workflows via 12 submodules.

## Overview

- **28 Core Skills** (always on) — TDD, planning, debug, code review, git workflows, impeccable (design guidance), Obsidian (markdown, canvas, bases, CLI, defuddle), image-reader (vision delegation)
- **7 Optional Skills** (on-demand) — cavecrew, caveman-compress, domain-modeling, grilling, grill-with-docs, karpathy-guidelines, ppt-master
- **9 Subagents** — explore, research, code, validate, e2e-runner, auggie-guide, general-purpose, plan, image-reader (Grok 4.5 vision)
- **CodeGraph MCP** — Structural code intelligence (replaces codebase-retrieval)
- **Agent Browser MCP** — E2E testing + browser automation
- **Context7 MCP** — Library docs lookup
- **Sequential Thinking MCP** — Complex reasoning

## Architecture

```
~/.augment/
├── agents/              # e2e-runner.md, plan.md, image-reader.md
├── skills/              # 28 core (symlinks to submodule/*/skills/*)
├── skills-lib/          # 7 optional (cavecrew, caveman-compress, domain-modeling, karpathy-guidelines, etc.)
├── rules/               # codegraph.md, agent-browser-only.md, finn-guidelines.md, caveman-active.md, i-have-adhd.md, image-reader.md
├── hooks/               # SessionStart hook (superpowers integration)
├── scripts/             # install-to-augment.sh, setup-symlinks.sh, show-workspace.sh, update-submodules.sh, store/
├── submodule/           # 12 submodules (ECC, agent-browser, caveman, codegraph, impeccable, obsidian-skills, i-have-adhd, etc.)
└── settings.json        # MCP servers, tool permissions, hooks
```

## Prerequisites

**Required:** Auggie CLI, Node.js 20+, npm, git

**Optional:** Python 3.10+ (ppt-master), gh, codegraph CLI, uipro-cli, agent-browser CLI

## Installation

### New Machine

```bash
git clone git@github.com:phcngyn99/augment-extend.git
cd augment-extend
./scripts/install-to-augment.sh
```

Does: verify Auggie, copy to `~/.augment`, init 10 submodules, create symlinks, setup MCP servers.

**Run `auggie` from any project** — uses `~/.augment` config.

### Update Existing

```bash
cd ~/.augment
git pull
~/.augment/scripts/update-submodules.sh
~/.augment/scripts/setup-symlinks.sh  # if new skills/agents
```

## Tool Integration

### CodeGraph (Code Intelligence)

Replaces `codebase-retrieval` + `grep-search` (denied in settings.json).

```bash
curl -fsSL https://raw.githubusercontent.com/colbymchenry/codegraph/main/install.sh | sh
cd your-project && codegraph init
codegraph upgrade  # update
```

Tools: explore, node, search, callers, callees, impact, files.

**MCP wiring:** `settings.json` invokes the installed `codegraph` binary directly (`"command": "codegraph"`), not `npx -y @colbymchenry/codegraph`. The `npx` form re-downloads package metadata on every Auggie startup → MCP `-32001: Request timed out` on slow/corporate networks. The binary form resolves from PATH (already on `/usr/bin/codegraph` after install) and starts in ~1s.

### Agent Browser (E2E)

```bash
npm i -g agent-browser
agent-browser install  # Chrome for Testing
agent-browser upgrade
```

Used by e2e-runner subagent (preferred) or Playwright fallback.

### Playwright MCP (E2E fallback)

Two `settings.json` templates ship:
- `settings.json.template` — normal/x64 (uses `--browser chrome` channel)
- `settings.json.arm-template` — ARM64/Jetson (uses `--executable-path` to bundled chromium; see `docs/playwright-arm64-jetson.md`)

ARM64 Jetson requires the bundled-chromium path — `chrome` channel needs sudo install of Google Chrome. Install bundled chromium with:

```bash
npx playwright install chromium  # ARM64-native, no sudo, user cache
```

Update `--executable-path` in `settings.json` after Playwright upgrades (version dir name changes, e.g. `chromium-1228` → `chromium-1234`).

### UI/UX Pro Max

```bash
npm i -g uipro-cli
uipro init --ai augment
uipro update
```

### PPT Master

```bash
cd ~/.augment/submodule/ppt-master
pip install -r requirements.txt
echo 'export SKILL_DIR="$HOME/.augment/skills-lib/ppt-master"' >> ~/.zshrc
source ~/.zshrc
```

Needs Python 3.10+ (same as Auggie).

## Skills

### Core (28 always-on)

brainstorming, caveman, caveman-commit, caveman-help, caveman-review, caveman-stats, deep-research, defuddle, dispatching-parallel-agents, executing-plans, finishing-a-development-branch, handoff, impeccable, json-canvas, karpathy-guidelines, obsidian-bases, obsidian-cli, obsidian-markdown, receiving-code-review, requesting-code-review, subagent-driven-development, systematic-debugging, test-driven-development, using-git-worktrees, using-superpowers, verification-before-completion, writing-plans, writing-skills.

Use `browse-skills` to discover optional.

### Optional (6 on-demand)

| Skill | Use | Deps |
|-------|-----|------|
| cavecrew | Delegate to compressed subagents | Augment runtime |
| caveman-compress | Shrink prose (~75% tokens) | Anthropic API |
| domain-modeling | Glossary + ADRs | None |
| grill-with-docs | Stress-test + docs | grilling + domain-modeling |
| grilling | Stress-test plan | None |
| ppt-master | Generate presentations | APIs, Python |

See `skills-lib/README.md`.

## Subagents

1. **explore** — Codebase info for planning
2. **auggie-guide** — Auggie/Cosmos docs (always latest)
3. **general-purpose** — Deep research, multi-step
4. **research** — Codebase exploration
5. **code** — Feature implementation
6. **validate** — Test + verify
7. **e2e-runner** — E2E tests (Agent Browser + Playwright)
8. **plan** — Custom override (enforces writing-plans, sonnet4.5)

## Configuration

### MCP Servers (settings.json)

- **codegraph** — explore, node, search, callers, callees, impact, files, status
- **agent-browser** — all tools
- **context7** — lib docs
- **sequential-thinking** — reasoning

### Tool Permissions

Denied: `codebase-retrieval`, `grep-search`, `web-fetch` → use CodeGraph.

### Hooks

**SessionStart** — Injects `using-superpowers` skill content at session start, enabling auto-triggering of skills (brainstorming, TDD, etc.).

- `hooks/session-start.sh` — Unix wrapper (Augment `hookSpecificOutput.additionalContext` format)
- Symlinks to `submodule/superpowers/hooks/*`

### Startup Scripts

- show-workspace.sh — CodeGraph status
- update-submodules.sh — update all submodules

## Development

### Structure

agents/, skills/, skills-lib/, rules/, hooks/, scripts/, submodule/, settings.json

### Skill Placement

- Core (always-on): `skills/`
- Optional (on-demand): `skills-lib/`

### Update Submodules

```bash
~/.augment/scripts/update-submodules.sh
# Or specific: cd ~/.augment/submodule/<name> && git pull
```

### Add Skills

```bash
cd ~/.augment/submodule/<name>
# make changes
~/.augment/scripts/setup-symlinks.sh
```

## Troubleshooting

**CodeGraph not init:** `cd your-project && codegraph init`

**Submodules missing:** `cd ~/.augment && git submodule update --init --recursive && ~/.augment/scripts/setup-symlinks.sh`

**Skills/agents missing:** `~/.augment/scripts/setup-symlinks.sh`

**PPT Master fail:** `cd ~/.augment/submodule/ppt-master && pip install -r requirements.txt && echo $SKILL_DIR`

**Playwright on ARM64/Jetson:** See [docs/playwright-arm64-jetson.md](docs/playwright-arm64-jetson.md) for snap Chromium setup

## License

See submodule licenses.