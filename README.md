# Augment Extend — Central Install

11 rules · 98 skills · 38 agents — Superpowers + ECC + Caveman + Custom + UI/UX

## Install (New Machine)

**Clone repo anywhere, cd into it, run install:**

```bash
# Clone to any location
git clone git@github.com:phcngyn99/augment-extend.git

# cd into cloned repo
cd augment-extend

# Option A: With Auggie (recommended)
auggie
# Tell Auggie: "install this augment config"

# Option B: Direct install
./install.sh
```

**What install does:**
- Backs up `~/.augment` if exists → `~/.augment.backup-TIMESTAMP`
- Copies all files → `~/.augment`
- Inits git (remote: git@github.com:phcngyn99/augment-extend.git)
- Creates `settings.json` from template
- Sets executable permissions
- Verifies counts (11 rules, 98 skills, 38 agents)

**For Auggie:**
1. Read this README
2. Run `./install.sh` from current directory
3. Check exit code (0 = success)
4. Run verification commands below
5. Report results

**Success criteria:**
- ✅ Script reports "Installation successful"
- ✅ Counts match: 11 rules, 98 skills, 38 agents
- ✅ `~/.augment/.git` exists
- ✅ `git remote -v` shows `phcngyn99/augment-extend`
- ✅ `settings.json` created from template
- ✅ `cd ~/.augment && git pull` → "Already up to date"

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

## Troubleshooting

### Install Failed at Git Setup

If install copied files but git remote failed:

```bash
# Already in cloned repo
git pull

# Copy .gitignore to ~/.augment
cp .gitignore ~/.augment/

# Fix git remote
cd ~/.augment
git remote set-url origin git@github.com:phcngyn99/augment-extend.git
# If no remote exists: git remote add origin git@github.com:phcngyn99/augment-extend.git

# Verify pull works
git pull

# Delete cloned repo
cd ..
rm -rf augment-extend
```

Keeps existing credentials/sessions intact.

---

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
