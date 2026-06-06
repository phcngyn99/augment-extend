#!/usr/bin/env bash
set -euo pipefail

# Augment Extend — Central Install Script
# Installs this repo's config to ~/.augment

REPO_REMOTE="git@github.com:phcngyn99/augment-extend.git"
TARGET_DIR="${HOME}/.augment"
BACKUP_DIR="${HOME}/.augment.backup-$(date +%Y%m%d-%H%M%S)"

# Verification counts
EXPECTED_RULES=11
EXPECTED_SKILLS=98
EXPECTED_AGENTS=38

echo "🚀 Augment Extend — Install to ~/.augment"
echo "=========================================="
echo

# ── Step 1: Verify we're in the cloned repo ──────────────────────────────────
if [ ! -f "README.md" ] || [ ! -f "settings.json.template" ]; then
    echo "❌ Error: Must run from augment-extend repo directory"
    echo "   Expected: ~/Downloads/augment-extend"
    echo "   Current: $(pwd)"
    exit 1
fi

echo "✓ Running from repo: $(pwd)"
echo

# ── Step 2: Backup existing ~/.augment ───────────────────────────────────────
if [ -d "$TARGET_DIR" ]; then
    echo "📦 Backing up existing ~/.augment → $BACKUP_DIR"
    mv "$TARGET_DIR" "$BACKUP_DIR"
    echo "✓ Backup complete"
    echo
fi

# ── Step 3: Copy files to ~/.augment ──────────────────────────────────────────
echo "📂 Copying files to ~/.augment..."
mkdir -p "$TARGET_DIR"

# Use rsync to copy everything except .git
if command -v rsync >/dev/null 2>&1; then
    rsync -av --exclude .git --exclude .gitignore . "$TARGET_DIR/"
else
    # Fallback: cp -R (less precise, may include unwanted files)
    cp -R . "$TARGET_DIR/"
    rm -rf "$TARGET_DIR/.git"
fi

echo "✓ Files copied"
echo

# Check git installed
if ! command -v git >/dev/null 2>&1; then
    echo "❌ Error: git not found. Install git first."
    exit 1
fi

# ── Step 4: Git init with remote ──────────────────────────────────────────────
echo "🔗 Setting up git tracking..."
cd "$TARGET_DIR"

git init
git remote add origin "$REPO_REMOTE"
git fetch origin --quiet
git checkout -b main origin/main --track

echo "✓ Git configured (remote: $REPO_REMOTE)"
echo

# ── Step 5: Create settings.json from template ────────────────────────────────
echo "⚙️  Creating settings.json from template..."

if [ ! -f "settings.json.template" ]; then
    echo "❌ Error: settings.json.template not found"
    exit 1
fi

if [ -f "settings.json" ]; then
    echo "⚠️  Warning: Overwriting existing settings.json"
fi

cp settings.json.template settings.json
echo "✓ settings.json created (edit indexingAllowDirs for your machine)"
echo

# ── Step 6: Set executable permissions ────────────────────────────────────────
echo "🔐 Setting executable permissions..."

find . -name "*.sh" -exec chmod +x {} \;
find . -name "*.mjs" -exec chmod +x {} \;

echo "✓ Permissions set"
echo

# ── Step 7: Verify install ────────────────────────────────────────────────────
echo "✅ Verifying install..."

RULE_COUNT=$(ls rules/*.md 2>/dev/null | wc -l | tr -d ' ')
SKILL_COUNT=$(find skills -name 'SKILL.md' 2>/dev/null | wc -l | tr -d ' ')
AGENT_COUNT=$(find agents -name '*.md' 2>/dev/null | wc -l | tr -d ' ')

echo "   Rules:  $RULE_COUNT (expected: $EXPECTED_RULES)"
echo "   Skills: $SKILL_COUNT (expected: $EXPECTED_SKILLS)"
echo "   Agents: $AGENT_COUNT (expected: $EXPECTED_AGENTS)"

if [ "$RULE_COUNT" -ne "$EXPECTED_RULES" ] || [ "$SKILL_COUNT" -ne "$EXPECTED_SKILLS" ] || [ "$AGENT_COUNT" -ne "$EXPECTED_AGENTS" ]; then
    echo
    echo "⚠️  Warning: Count mismatch detected"
    echo "   Install may be incomplete. Check repo integrity."
    exit 1
fi

echo
echo "=========================================="
echo "✅ Install complete!"
echo
echo "Installed to: $TARGET_DIR"
echo "Backup: $BACKUP_DIR"
echo
echo "Next steps:"
echo "  1. Edit ~/.augment/settings.json (add indexingAllowDirs)"
echo "  2. Restart Auggie to load new config"
echo "  3. Update: cd ~/.augment && git pull"
echo
echo "To cleanup cloned repo (if in ~/Downloads/augment-extend):"
echo "  rm -rf ~/Downloads/augment-extend"
echo
