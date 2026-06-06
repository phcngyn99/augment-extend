# Makefile Template Usage Guide

Quick reference for using the Makefile template in new projects.

## Quick Start

```bash
# Copy template to project root
cp docs/templates/Makefile-template ./Makefile

# Customize variables (lines 17-21)
# Run help to see all targets
make help
```

## Template Structure

### Preamble (Lines 7-13)
Modern Make settings — do not modify unless you know what you're doing.

```makefile
SHELL := bash                              # Use bash for all recipes
.ONESHELL:                                 # Run each recipe in one shell session
.SHELLFLAGS := -eu -o pipefail -c          # Bash strict mode
.DELETE_ON_ERROR:                          # Delete targets on recipe failure
MAKEFLAGS += --warn-undefined-variables    # Catch typos
MAKEFLAGS += --no-builtin-rules            # Remove implicit rules
MAKEFLAGS += --no-print-directory          # Suppress "Entering directory" messages
```

**Why:** Prevents common Make errors, enables multi-line scripts, fails fast on errors.

### Variables (Lines 17-28)
User-overridable configuration.

```makefile
APP_NAME ?= myapp              # Use ?= so users can override
VERSION ?= ...                 # Auto-detect from git tags
DOCKER_COMPOSE := ...          # Auto-detect v1/v2
```

**Customize:**
- Change `APP_NAME` to your project name
- Add project-specific variables (ports, paths, flags)
- Keep uppercase for external config, lowercase for internal

**Override at runtime:**
```bash
make docker-build APP_NAME=myservice VERSION=v1.2.3
```

### Help Target (Lines 33-41)
Auto-generates help from `##` comments.

**Format:**
```makefile
target-name: ## Description shown in help
```

**Section headers:**
```makefile
##@ Category Name    # Creates section in help output
```

**Output:**
```
Available targets:

Build:
  build                Build the project
  
Test:
  test                 Run all tests
```

### Target Sections

#### Dependencies (Lines 43-56)
Check and install dependencies.

**Customize:**
- `check-deps`: Add checks for required tools (git, python, etc.)
- `deps`: Add installation commands (pip, npm, go mod, etc.)

#### Build (Lines 58-64)
Compile/build project.

**Examples:**
```makefile
# Go
build:
> go build -o bin/$(APP_NAME) .

# Python
build:
> python setup.py build

# Node.js
build:
> npm run build
```

#### Test (Lines 66-84)
Run tests at different levels.

**Organize by scope:**
- `test` — All tests
- `test-unit` — Unit tests only
- `test-integration` — Integration tests
- `test-e2e` — End-to-end tests (add if needed)

#### Docker (Lines 86-114)
Container operations.

**Standard targets:**
- `docker-build` — Build image
- `docker-push` — Push to registry
- `up` — Start containers
- `down` — Stop containers
- `logs` — View logs
- `status` — Show container status
- `shell` — Interactive shell

**Customize:**
- Update `REGISTRY` variable for your registry
- Add docker-compose file path if not default
- Add multi-stage build args

#### Deployment (Lines 116-140)
Deployment operations.

**Standard targets:**
- `deploy` — Deploy to default environment
- `deploy-dev` — Deploy to development
- `deploy-prod` — Deploy to production

**Examples:**
```makefile
deploy-dev:
> kubectl apply -f k8s/dev/ --namespace=dev

deploy-prod:
> kubectl apply -f k8s/prod/ --namespace=prod
```

#### Utilities (Lines 142-176)
Maintenance and quality tasks.

**Standard targets:**
- `version` — Show version info
- `clean` — Remove artifacts
- `lint` — Run linters
- `format` — Format code

**Add as needed:**
- `migrate` — Database migrations
- `backup` — Backup data
- `restore` — Restore from backup

## Naming Conventions

### Target Names
Follow GNU Make standards + modern DevOps practices:

**Single-word targets:**
- Lowercase only: `help`, `build`, `clean`, `test`, `up`, `down`

**Multi-word targets:**
- Use hyphens (kebab-case): `check-deps`, `docker-build`, `deploy-prod`
- **Never use underscores** in target names (reserved for variables)
- **Never use colons** (breaks dependencies silently)

**Standard target names:**
```makefile
# Core (GNU standard)
all, build, install, uninstall, clean, test, check

# Docker/Container
up, down, restart, status, logs, shell

# Deployment
deploy, deploy-dev, deploy-prod, push, release

# Quality
lint, format, test-unit, test-integration

# Utilities
version, help
```

### Variable Names
- Internal variables: `lowercase_with_underscores`
- Configuration: `UPPERCASE` (user-overridable with `?=`)

**Examples:**
```makefile
# Configuration (user can override)
APP_NAME ?= myapp
DOCKER_TAG ?= latest

# Internal
source_files := $(shell find src -type f)
build_dir := ./build
```

## Best Practices

### .PHONY Declarations
Always declare non-file targets as `.PHONY`:

```makefile
.PHONY: help build test clean

help: ## Show help
> @echo "Help text"
```

**Why:** If a file named `test` exists, Make won't run the recipe without `.PHONY`.

### Error Handling
Use `@` to suppress echoing, but show errors:

```makefile
target:
> @echo "Starting task..."    # Silent
> command-that-might-fail      # Shows output if fails
> @echo "Done"                 # Silent
```

### Multi-line Commands
`.ONESHELL` enables loops and variables:

```makefile
.PHONY: multi-line-example
multi-line-example:
> for file in *.txt; do
>   echo "Processing $$file"
>   cat "$$file"
> done
> echo "All files processed"
```

**Note:** Use `$$` for shell variables (not `$`).

### Color Output
Use ANSI codes for readability:

```makefile
build:
> @echo "$(COLOR_BOLD)Building...$(COLOR_RESET)"
> docker build -t myapp .
> @echo "$(COLOR_GREEN)[OK] Build complete$(COLOR_RESET)"
```

## Common Customizations

### Add New Section

```makefile
##@ Database

.PHONY: db-migrate
db-migrate: ## Run database migrations
> @echo "$(COLOR_BOLD)Running migrations...$(COLOR_RESET)"
> python manage.py migrate
> @echo "$(COLOR_GREEN)[OK] Migrations complete$(COLOR_RESET)"
```

### Add Prerequisites

```makefile
test: build  ## Run tests (requires build first)
> pytest tests/
```

### Conditional Logic

```makefile
ifdef CI
  TEST_FLAGS = --verbose --no-color
else
  TEST_FLAGS = --verbose
endif

test:
> pytest $(TEST_FLAGS)
```

## Validation

### Check Syntax
```bash
make -n help    # Dry run
```

### Lint Makefile
```bash
# Install checkmake
go install github.com/mrtazz/checkmake/cmd/checkmake@latest

# Run linter
checkmake Makefile
```

## References

- [GNU Make Manual](https://www.gnu.org/software/make/manual/)
- [Your Makefiles are wrong](https://tech.davis-hansson.com/p/make/)
- [Cloud Posse Best Practices](https://docs.cloudposse.com/best-practices/developer/makefile/)
- [Self-Documenting Makefiles](https://michaelgoerz.net/notes/self-documenting-makefiles.html)
