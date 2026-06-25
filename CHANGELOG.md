# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
