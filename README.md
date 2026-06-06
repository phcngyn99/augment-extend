# Augment Extend — Central Install

11 rules · 98 skills · 38 agents — Superpowers + ECC + Caveman + Custom + UI/UX

## Install (New Machine)

**Clone → cd → start Auggie → run install:**

```bash
# 1. Clone to staging
git clone https://github.com/phcngyn99/augment-extend ~/Downloads/augment-extend

# 2. cd into repo
cd ~/Downloads/augment-extend

# 3. Start Auggie session IN this repo
auggie

# 4. Tell Auggie (canonical prompt):
"install this augment config"
```

**What Auggie does:**
- Reads README.md (this file)
- Executes `./install.sh`
- Script backs up `~/.augment` if exists → `~/.augment.backup-TIMESTAMP`
- Copies all files → `~/.augment`
- Inits git tracking (remote: phcngyn99/augment-extend)
- Creates `settings.json` from template
- Sets executable permissions
- Verifies counts (11 rules, 98 skills, 38 agents)
- Reports success

**After install:**
```bash
# Exit Auggie, delete staging repo
exit
rm -rf ~/Downloads/augment-extend

# Edit settings.json for your machine (indexingAllowDirs)
nano ~/.augment/settings.json

# Restart Auggie to load config
auggie
```

## Update

```bash
cd ~/.augment && git pull
```

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
