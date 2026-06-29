# Augment Extend

Augment CLI extension with specialized agents, skills, and workflows powered by 9 integrated submodules.

## Overview

This workspace provides:
- **23+ Core Skills** (always available) - TDD, planning, debugging, code review, git workflows
- **6 Optional Skills** (on-demand) - cavecrew, caveman-compress, domain-modeling, grilling, grill-with-docs, ppt-master
- **8 Subagents** - explore, research, code, validate, e2e-runner, auggie-guide, general-purpose, plan (custom override)
- **CodeGraph MCP Integration** - Replaces codebase-retrieval with structural code intelligence
- **Agent Browser MCP** - E2E testing and browser automation
- **Context7 MCP** - Library documentation lookup
- **Sequential Thinking MCP** - Complex reasoning support

## Architecture

```
~/.augment/
├── agents/              # Subagent configurations
│   ├── e2e-runner.md   # E2E testing specialist (from ECC)
│   └── plan.md         # Custom plan agent (enforces writing-plans skill)
├── skills/             # Core skills (23 always-available)
│   ├── brainstorming, caveman, caveman-commit, caveman-help, etc.
│   └── (symlinks to submodule/*/skills/*)
├── skills-lib/         # Optional/advanced skills (6 on-demand)
│   ├── cavecrew        # Compressed-output subagents
│   ├── caveman-compress # Prose file compression (~75% token savings)
│   ├── domain-modeling # Domain glossary + ADRs
│   ├── grill-with-docs # Stress-test + docs generation
│   ├── grilling        # Stress-test plan/design
│   └── ppt-master      # AI-powered presentation generation
├── rules/              # Always-follow guidelines
│   └── codegraph-only.md # CodeGraph enforcement policy
├── scripts/            # Installation and setup automation
│   ├── install-to-augment.sh  # New machine installation
│   └── setup-symlinks.sh      # Submodule + symlink automation
├── startup/            # Startup scripts (run by Auggie)
│   ├── show-workspace.sh      # CodeGraph status check
│   └── update-submodules.sh   # Update all submodules
├── submodule/          # 9 integrated submodules
│   ├── ECC/            # Everything Claude Code (67 agents, 271 skills)
│   ├── agent-browser/  # Browser automation
│   ├── andrej-karpathy-skills/ # Karpathy coding guidelines
│   ├── caveman/        # Compressed communication
│   ├── codegraph/      # Code intelligence (reference only)
│   ├── ppt-master/     # Presentation generation
│   ├── skills/         # General skills library
│   ├── superpowers/    # Workflow superpowers
│   └── ui-ux-pro-max-skill/ # UI/UX design (reference only)
└── settings.json       # Tool permissions + MCP server config
```

## Prerequisites

**Required:**
- [Auggie CLI](https://www.augmentcode.com) - Augment Code CLI
- Node.js 20+
- npm
- git

**Optional (for specific skills):**
- Python 3.10+ (for ppt-master)
- pip (for ppt-master)
- gh (GitHub CLI - for some workflows)
- codegraph CLI (auto-installed by setup script)
- uipro-cli (for UI/UX Pro Max skill)
- agent-browser CLI (for E2E testing)

## Installation

### New Machine Installation

```bash
# 1. Clone the repo
git clone git@github.com:phcngyn99/augment-extend.git
cd augment-extend

# 2. Run installation script (one command does everything)
./scripts/install-to-augment.sh
```

**What it does:**
- Verifies Auggie CLI is installed
- Copies repo to `~/.augment` (excludes .gitignore files)
- Creates `settings.json` from template
- Initializes all 9 submodules recursively
- Creates symlinks for 23 skills, 1 rule, 1 agent
- Sets up MCP servers (codegraph, agent-browser, context7, sequential-thinking)

**IMPORTANT**: After installation, run `auggie` from **any project directory**. Auggie uses config from `~/.augment`, not the cloned repo. You can delete the clone or keep it for future updates.

### Updating Existing Installation

```bash
# 1. Pull latest changes
cd ~/.augment
git pull

# 2. Update submodules to latest versions
~/.augment/startup/update-submodules.sh

# 3. Refresh symlinks (if new skills/agents added)
~/.augment/scripts/setup-symlinks.sh
```

## Tool Integration

### CodeGraph (Code Intelligence)

**Replaces `codebase-retrieval`** with structural code intelligence.

```bash
# Install CLI (auto-installed by setup script, or manual install)
curl -fsSL https://raw.githubusercontent.com/colbymchenry/codegraph/main/install.sh | sh
# OR: npm i -g @colbymchenry/codegraph

# Initialize in your project
cd your-project
codegraph init

# Update CodeGraph
codegraph upgrade
```

**What it provides:**
- `codegraph_explore_codegraph` - Flow discovery (call paths + source)
- `codegraph_node_codegraph` - Symbol body or file reading with dependencies
- `codegraph_search_codegraph` - Symbol name search
- `codegraph_callers_codegraph` / `codegraph_callees_codegraph` - Call graph navigation
- `codegraph_impact_codegraph` - Blast radius analysis
- `codegraph_files_codegraph` - File tree with metadata

**Policy**: `codebase-retrieval` and `grep-search` are **denied** in `settings.json` - use CodeGraph exclusively.

### Agent Browser (E2E Testing)

```bash
# Install CLI
npm install -g agent-browser
agent-browser install  # Download Chrome for Testing (first time only)

# Update
agent-browser upgrade
```

**Usage**: The `e2e-runner` subagent uses Agent Browser (preferred) or Playwright (fallback) for E2E tests.

### UI/UX Pro Max (Design Systems)

```bash
# Install CLI
npm install -g uipro-cli
uipro init --ai augment

# Update
uipro update

# Uninstall
uipro uninstall --ai augment
```

### PPT Master (Presentation Generation)

```bash
# Install dependencies
cd ~/.augment/submodule/ppt-master
pip install -r requirements.txt

# Set environment variable
echo 'export SKILL_DIR="$HOME/.augment/skills-lib/ppt-master"' >> ~/.zshrc
source ~/.zshrc  # or restart terminal
```

**Note**: Requires same Python interpreter as Auggie CLI (typically system Python 3.10+).

## Skills

### Core Skills (Always Available)

Located in `skills/` - available by default:

- **brainstorming** - Explore user intent before implementation
- **caveman** - Compressed communication (~75% fewer tokens)
- **caveman-commit** - Ultra-compressed commit messages
- **caveman-help** - Quick reference for caveman modes
- **caveman-review** - Compressed code review comments
- **caveman-stats** - Show token usage and savings
- **deep-research** - Multi-source web research with citations
- **dispatching-parallel-agents** - Parallel subagent execution
- **executing-plans** - Execute implementation plans with review checkpoints
- **finishing-a-development-branch** - Structured merge/PR/cleanup options
- **handoff** - Compact conversation handoff documents
- **karpathy-guidelines** - Reduce common LLM coding mistakes
- **receiving-code-review** - Technical rigor for review feedback
- **requesting-code-review** - Verify work meets requirements
- **subagent-driven-development** - Execute plans with independent tasks
- **systematic-debugging** - Structured debugging workflow
- **test-driven-development** - Write tests before implementation
- **using-git-worktrees** - Isolated workspace via git worktree
- **using-superpowers** - Skill invocation framework
- **verification-before-completion** - Evidence before assertions
- **writing-plans** - Implementation planning before code
- **writing-skills** - Skill creation and verification

**Discover more**: Use the `browse-skills` skill to explore optional skills in `skills-lib/`.

### Optional Skills (On-Demand)

Located in `skills-lib/` - require explicit invocation:

| Skill | Use When | Dependencies |
|-------|----------|--------------|
| **cavecrew** | Delegate tasks to compressed-output subagents | Augment runtime |
| **caveman-compress** | Shrink prose files (~75% token savings) | Anthropic API |
| **domain-modeling** | Build/maintain domain glossary + ADRs | None |
| **grill-with-docs** | Stress-test plan + generate docs | grilling + domain-modeling |
| **grilling** | Stress-test plan/design before building | None |
| **ppt-master** | Generate presentations from sources | External APIs, Python |

See `skills-lib/README.md` for detailed documentation.

## Subagents

8 specialized subagents for delegation:

1. **explore** - Gather codebase information for planning
2. **auggie-guide** - Answer questions about Auggie/Cosmos (uses latest docs)
3. **general-purpose** - Deep research, code search, multi-step workflows
4. **research** - Explore codebases and gather technical information
5. **code** - Implement features and write production code
6. **validate** - Test implementations and validate correctness
7. **e2e-runner** - E2E testing specialist (Agent Browser + Playwright)
8. **plan** - Custom override that enforces writing-plans skill (sonnet4.5)

**Note**: `plan` agent overrides the built-in plan subagent to enforce the writing-plans skill workflow.

## Configuration

### MCP Servers

Configured in `settings.json`:

- **codegraph** - Code intelligence (explore, node, search, callers, callees, impact, files, status)
- **agent-browser** - Browser automation (all tools)
- **context7** - Library documentation lookup
- **sequential-thinking** - Complex reasoning support

### Tool Permissions

**Denied tools** (use CodeGraph instead):
- `codebase-retrieval` → use `codegraph_explore_codegraph` or `codegraph_node_codegraph`
- `grep-search` → use `codegraph_search_codegraph`
- `web-fetch` → (security policy)

See `rules/codegraph-only.md` for rationale and usage guidance.

### Startup Scripts

Configured in `settings.json` as `startupScript`:

- **show-workspace.sh** - Check CodeGraph index status
- **update-submodules.sh** - Update all submodules (manual trigger)

## Development

### Project Structure

- **agents/** - Custom subagent configurations (.md with YAML frontmatter)
- **skills/** - Core skills (symlinks to submodules)
- **skills-lib/** - Optional skills (symlinks to submodules)
- **rules/** - Always-follow guidelines
- **scripts/** - Installation and setup automation
- **startup/** - Startup scripts (run by Auggie)
- **submodule/** - 9 integrated submodules (git submodules)
- **settings.json** - MCP servers, tool permissions, startup script

### Contributing

See `CHANGELOG.md` for development history.

**Skill placement policy**:
- Core skills (always-on): `skills/`
- Optional skills (on-demand): `skills-lib/`

### Updating Submodules

```bash
# Update all submodules to latest remote versions
~/.augment/startup/update-submodules.sh

# Update specific submodule manually
cd ~/.augment/submodule/<name>
git pull origin main  # or master
```

### Adding New Skills

```bash
# Add skill to appropriate submodule
cd ~/.augment/submodule/<name>
# ... make changes ...

# Refresh symlinks
~/.augment/scripts/setup-symlinks.sh
```

## Troubleshooting

### CodeGraph not initialized

```bash
cd your-project
codegraph init
```

### Submodules not initialized

```bash
cd ~/.augment
git submodule update --init --recursive
~/.augment/scripts/setup-symlinks.sh
```

### Missing skills/agents

```bash
# Refresh symlinks
~/.augment/scripts/setup-symlinks.sh
```

### PPT Master not working

```bash
# Verify Python dependencies
cd ~/.augment/submodule/ppt-master
pip install -r requirements.txt

# Verify environment variable
echo $SKILL_DIR  # Should output: /Users/<you>/.augment/skills-lib/ppt-master
```

## License

See individual submodule licenses for details.