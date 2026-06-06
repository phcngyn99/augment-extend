# Augment Extend — Central Install

11 rules · 98 skills · 38 agents — Superpowers + ECC + Caveman + Custom + UI/UX

## Install (Machine with Auggie)

**Prerequisites:**
- Auggie installed, `~/.augment` exists
- CodeGraph installed (optional but recommended — used by codegraph-priority rule)

```bash
# 1. Init git in ~/.augment
cd ~/.augment
git init

# 2. Add remote
git remote add origin git@github.com:phcngyn99/augment-extend.git

# 3. Fetch + checkout
git fetch
git checkout -b main --track origin/main

# 4. Verify
git pull  # Should say "Already up to date"
```

**What happens:**
- Git merges repo into existing ~/.augment
- Keeps your credentials/sessions (gitignored)
- settings.json.template available for reference

**Edit settings.json for your machine:**
```bash
nano ~/.augment/settings.json
```

## Update

**Safe workflow — personal data never syncs:**

```bash
cd ~/.augment && git pull
```

Your local sessions, settings.json, checkpoints stay intact. Only shared config updates.

### What Gets Synced (Tracked)

✅ **Shared config:**
- `rules/` — Auto rules
- `skills/` — All skills
- `agents/` — All agents
- `docs/` — Documentation
- `scripts/` — Setup scripts
- `settings.json.template` — Machine setup template
- `install.sh`, `README.md`, `CATALOG.md`, `CHANGELOG.md`

### What Stays Local (Ignored)

🔒 **Personal data:**
- `settings.json` — Machine-specific paths
- `sessions/`, `session.json*` — Conversation data
- `checkpoint-documents/` — Editor state
- `prompt-history.jsonl` — Session logs
- `projects/`, `ck/contexts/` — Project memory
- `task-storage/` — Task state
- `.codegraph/`, `skill-library/` — Local caches
- `binaries/` — Platform-specific executables

**You can edit local files freely — git won't touch them.**

## What You Get

**Rules (11):** caveman, superpowers-priority, session-lifecycle, coding-principles, karpathy, security, agentic-workflow, codegraph-priority, context-md, research-delegation, honest-feedback

**Skills (98):** Superpowers (15), ECC (68), Caveman (7), Custom (7), UI/UX (1)

**Agents (38):** code-reviewer + 37 ECC (lang reviewers, build resolvers, domain specialists)

**MCP:** codegraph, Context7, sequential-thinking

## Verify

```bash
echo "Rules:  $(ls ~/.augment/rules/*.md | wc -l)"
echo "Skills: $(find ~/.augment/skills -name 'SKILL.md' | wc -l)"
echo "Agents: $(find ~/.augment/agents -name '*.md' | wc -l)"
```

See **CATALOG.md** for full skill/agent reference.
