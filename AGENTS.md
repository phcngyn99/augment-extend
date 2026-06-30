---
type: always_apply
---

# Augment Extend Configuration Repository Rules

## Version Control & Documentation

- **Before committing, always update CHANGELOG.md** following [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) format
  - Use sections: Added, Changed, Fixed, Removed, Deprecated
  - Add entries under `## [Unreleased]`
  - Include specific details (file paths, symlink targets, submodule names)
- **Do not auto commit** - always let the user review changes before committing

## Skills Management

- Skills are organized in two locations:
  - `skills/` - Core skills (29 total), always loaded, mostly symlinked from submodules
  - `skills-lib/` - Optional skills (6 total), loaded on-demand, requires manual activation
- When adding new skills:
  - Create symlinks, don't copy files: `ln -s ../submodule/<name>/skills/<skill> skills/<skill>`
  - Update README.md skill counts if adding core skills
  - Document in CHANGELOG.md with full symlink path
- Follow agentskills.io specification for skill structure (SKILL.md format)

## Agents Management

- Custom agents go in `agents/` directory
- Can be standalone files or symlinks to submodule agents
- Agent files use `.md` extension (e.g., `plan.md`, `e2e-runner.md`)
- Document purpose and configuration in agent frontmatter

## Submodules

- All submodules are in `submodule/` directory (9 total: ECC, agent-browser, caveman, codegraph, ponytail, ppt-master, skills, superpowers, ui-ux-pro-max-skill)
- When updating submodules:
  - Use `git submodule update --remote <submodule-name>` for targeted updates
  - Test symlinks still work after updates
  - Document submodule changes in CHANGELOG.md

## Rules Management

- User-wide rules: `~/.augment/rules/` (always apply to all workspaces)
- Workspace rules: Use `AGENTS.md` or `CLAUDE.md` at repo root
- Keep rules focused and actionable with specific examples
- Use frontmatter for workspace rules in `.augment/rules/` subdirectories

## Scripts & Automation

- Installation scripts in `scripts/` directory
- Startup hooks can be configured but should be documented
- Test scripts on clean environments before committing
- Use shell best practices: set -e, quote variables, check prerequisites

## File Organization

- `/agents` - Subagent definitions
- `/skills` - Core skills (always loaded)
- `/skills-lib` - Optional skills (on-demand)
- `/rules` - Workspace-specific rules
- `/scripts` - Installation and maintenance scripts
- `/submodule` - Git submodules
- `/docs` - Documentation and guides
- `/checkpoint-documents` - Session checkpoints

## Documentation Standards

- Keep README.md up to date with current architecture
- Document installation steps, prerequisites, and troubleshooting
- Include examples in documentation
- Use clear section headings and formatting