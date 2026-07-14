#!/bin/bash

set -e

echo "Install Augment config..."
echo ""

# Initialize git submodules if needed
echo "Check submodules..."
if git submodule status | grep -q '^-'; then
    echo "Init submodules..."
    git submodule update --init --recursive
else
    echo "Submodules OK"
fi

# Create symlinks helper function
create_symlink() {
    local target=$1
    local link=$2
    local dir=$(dirname "$link")

    mkdir -p "$dir"

    if [ -L "$link" ]; then
        rm "$link"
    elif [ -e "$link" ]; then
        echo "WARN: $link exists, not symlink. Skip."
        return
    fi

    ln -s "$target" "$link"
    echo "  $link -> $target"
}

echo ""
echo "Create symlinks..."

# Skills from caveman submodule
echo "Caveman skills..."
create_symlink "../submodule/caveman/skills/caveman" "skills/caveman"
create_symlink "../submodule/caveman/skills/caveman-commit" "skills/caveman-commit"
create_symlink "../submodule/caveman/skills/caveman-help" "skills/caveman-help"
create_symlink "../submodule/caveman/skills/caveman-review" "skills/caveman-review"
create_symlink "../submodule/caveman/skills/caveman-stats" "skills/caveman-stats"

# Optional caveman skills (skills-lib)
echo "Caveman optional skills..."
create_symlink "../submodule/caveman/skills/caveman-compress" "skills-lib/caveman-compress"
create_symlink "../submodule/caveman/skills/cavecrew" "skills-lib/cavecrew"

# Skills from superpowers submodule
echo "Superpowers skills..."
create_symlink "../submodule/superpowers/skills/brainstorming" "skills/brainstorming"
create_symlink "../submodule/superpowers/skills/dispatching-parallel-agents" "skills/dispatching-parallel-agents"
create_symlink "../submodule/superpowers/skills/executing-plans" "skills/executing-plans"
create_symlink "../submodule/superpowers/skills/finishing-a-development-branch" "skills/finishing-a-development-branch"
create_symlink "../submodule/superpowers/skills/receiving-code-review" "skills/receiving-code-review"
create_symlink "../submodule/superpowers/skills/requesting-code-review" "skills/requesting-code-review"
create_symlink "../submodule/superpowers/skills/subagent-driven-development" "skills/subagent-driven-development"
create_symlink "../submodule/superpowers/skills/systematic-debugging" "skills/systematic-debugging"
create_symlink "../submodule/superpowers/skills/test-driven-development" "skills/test-driven-development"
create_symlink "../submodule/superpowers/skills/using-git-worktrees" "skills/using-git-worktrees"
create_symlink "../submodule/superpowers/skills/using-superpowers" "skills/using-superpowers"
create_symlink "../submodule/superpowers/skills/verification-before-completion" "skills/verification-before-completion"
create_symlink "../submodule/superpowers/skills/writing-plans" "skills/writing-plans"
create_symlink "../submodule/superpowers/skills/writing-skills" "skills/writing-skills"

# Skills from skills submodule
echo "Matt Pocock skills..."
create_symlink "../submodule/skills/skills/productivity/handoff" "skills/handoff"

# Optional skills from skills submodule (skills-lib)
echo "Matt Pocock optional skills..."
create_symlink "../submodule/skills/skills/engineering/grill-with-docs" "skills-lib/grill-with-docs"
create_symlink "../submodule/skills/skills/productivity/grilling" "skills-lib/grilling"
create_symlink "../submodule/skills/skills/engineering/domain-modeling" "skills-lib/domain-modeling"

# Optional skills from andrej-karpathy-skills submodule (skills-lib)
echo "Karpathy optional skills..."
create_symlink "../submodule/andrej-karpathy-skills/skills/karpathy-guidelines" "skills-lib/karpathy-guidelines"

# Skills from ponytail submodule
echo "Ponytail skills..."
create_symlink "../submodule/ponytail/skills/ponytail" "skills/ponytail"
create_symlink "../submodule/ponytail/skills/ponytail-audit" "skills/ponytail-audit"
create_symlink "../submodule/ponytail/skills/ponytail-debt" "skills/ponytail-debt"
create_symlink "../submodule/ponytail/skills/ponytail-gain" "skills/ponytail-gain"
create_symlink "../submodule/ponytail/skills/ponytail-help" "skills/ponytail-help"
create_symlink "../submodule/ponytail/skills/ponytail-review" "skills/ponytail-review"

# Rules from ponytail submodule
echo "Ponytail rules..."
create_symlink "../submodule/ponytail/.agents/rules/ponytail.md" "rules/ponytail.md"

# Skills from impeccable submodule
echo "Impeccable skills..."
create_symlink "../submodule/impeccable/.agents/skills/impeccable" "skills/impeccable"

# Rules
echo "Rules..."
# Note: rules/caveman.md and rules/karpathy-guidelines.md removed to prevent
# double-loading (skills/caveman is core, skills-lib/karpathy-guidelines is optional)

# Agents
echo "Agents..."
create_symlink "../submodule/ECC/agents/e2e-runner.md" "agents/e2e-runner.md"

# Hooks from superpowers submodule
echo "Superpowers hooks..."
create_symlink "../submodule/superpowers/hooks/hooks.json" "hooks/hooks.json"
create_symlink "../submodule/superpowers/hooks/run-hook.cmd" "hooks/run-hook.cmd"
create_symlink "../submodule/superpowers/hooks/session-start" "hooks/session-start"

# Unix wrapper for session-start (Augment requires .sh extension + hookSpecificOutput format)
cat > hooks/session-start.sh << 'WRAPPER'
#!/usr/bin/env bash
# Wrapper for superpowers session-start hook (Augment CLI)
# Augment SessionStart expects JSON with hookSpecificOutput.additionalContext

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Read using-superpowers content
using_superpowers_content=$(cat "${PLUGIN_ROOT}/skills/using-superpowers/SKILL.md" 2>&1 || echo "Error reading using-superpowers skill")

# Escape string for JSON embedding
escape_for_json() {
    local s="$1"
    s="${s//\\/\\\\}"
    s="${s//\"/\\\"}"
    s="${s//$'\n'/\\n}"
    s="${s//$'\r'/\\r}"
    s="${s//$'\t'/\\t}"
    printf '%s' "$s"
}

using_superpowers_escaped=$(escape_for_json "$using_superpowers_content")
session_context="You have superpowers.\n\n**Below is the full content of your 'superpowers:using-superpowers' skill - your introduction to using skills. For all other skills, use the 'Skill' tool:**\n\n${using_superpowers_escaped}"

# Augment SessionStart format: hookSpecificOutput.additionalContext
printf '{\n  "hookSpecificOutput": {\n    "hookEventName": "SessionStart",\n    "additionalContext": "%s"\n  }\n}\n' "$session_context"

exit 0
WRAPPER
chmod +x hooks/session-start.sh

echo ""
echo "Install complete."
echo ""
echo "Next:"
echo "  1. Install CodeGraph: curl -fsSL https://raw.githubusercontent.com/colbymchenry/codegraph/main/install.sh | sh"
echo "  2. Wire to agent: codegraph install"
echo "  3. Init project: cd your-project && codegraph init"
echo ""
