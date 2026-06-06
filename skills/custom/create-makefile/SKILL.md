---
name: create-makefile
description: >
  Use when user says "create makefile", "generate makefile", "add makefile", or needs build automation setup.
  Generates modern Makefile with GNU Make best practices, self-documenting help, Docker/test/build targets,
  and colored output. Based on Cloud Posse + Kubernetes patterns.
---

# create-makefile

Generate production-grade Makefile with:
- Modern GNU Make 4.0+ settings (bash strict mode, .ONESHELL, error handling)
- Self-documenting help with `##` annotations
- Standard targets: deps, build, test, docker-build, up, down, deploy
- ANSI color output
- Auto-detect docker-compose v1/v2
- User-overridable variables with `?=`

## Trigger

- "create makefile"
- "generate makefile"
- "add makefile"
- "setup build automation"
- "need makefile"

## Process

1. **Detect project type** — scan for language/framework (Go, Python, Node.js, Java, Rust, Docker)
2. **Ask customizations:**
   - App name (default: directory name)
   - Primary commands (build/test/run)
   - Docker registry (if applicable)
   - Additional targets needed
3. **Generate Makefile** from template with:
   - Preamble (lines 8-15) — modern Make settings, **never modify**
   - Variables (lines 17-28) — APP_NAME, VERSION, REGISTRY
   - Help target (lines 33-46) — auto-generated from `##` comments
   - Sections: Dependencies, Build, Test, Docker, Deployment, Utilities
4. **Add .PHONY declarations** for all non-file targets
5. **Generate companion guide** — save `docs/MAKEFILE-USAGE.md` with project-specific examples

## Template Reference

Full template embedded below. Copy sections as needed.

## Quality Checklist

- [ ] Preamble includes all 7 modern Make settings
- [ ] All targets have `##` help annotations
- [ ] `.PHONY` declarations present
- [ ] Variables use `?=` for user override
- [ ] Color codes defined and used
- [ ] Target names use kebab-case (not underscores)
- [ ] Multi-line commands work with `.ONESHELL`

## Example Output

```makefile
# Modern Makefile Template
SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-print-directory

.DEFAULT_GOAL := help

APP_NAME ?= myapp
VERSION ?= $(shell git describe --tags 2>/dev/null || echo "dev")

##@ Help
.PHONY: help
help: ## Show this help
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_/-]+:.*?##/ { printf "  %-20s %s\\n", $$1, $$2 }' $(MAKEFILE_LIST)

##@ Build
.PHONY: build
build: ## Build the project
	go build -o bin/$(APP_NAME) .
```

## References

- Template: `~/.augment/skills/custom/create-makefile/templates/Makefile-template`
- Guide: `~/.augment/skills/custom/create-makefile/templates/MAKEFILE-GUIDE.md`
- [GNU Make Manual](https://www.gnu.org/software/make/manual/)
- [Cloud Posse Best Practices](https://docs.cloudposse.com/best-practices/developer/makefile/)

## Anti-Patterns

- Using underscores in target names (use hyphens)
- Missing .PHONY declarations
- Hardcoding values instead of variables
- Skipping preamble settings
- Using `:=` for user-facing config (use `?=`)
