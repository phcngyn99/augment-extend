---
name: create-readme
description: >
  Use when user says "create readme", "generate readme", "write readme", or needs project documentation.
  Generates comprehensive README.md with one-sentence description, features, tech stack table,
  quick start, directory structure, architecture diagram, configuration, troubleshooting.
  Based on Standard Readme + Google + CNCF templates.
---

# create-readme

Generate production-grade README.md with:
- One-sentence description (what problem does this solve)
- Feature list (4-6 key capabilities)
- Tech stack table (component, technology, purpose)
- Quick start (4 steps max)
- Directory structure tree
- Architecture diagram (ASCII art)
- Configuration guide
- Development workflow
- Deployment instructions
- Troubleshooting section
- Contributing guidelines
- Documentation index

## Trigger

- "create readme"
- "generate readme"
- "write readme"
- "add readme"
- "document this project"

## Process

1. **Analyze project** — scan for:
   - Primary language/framework
   - Dependencies (package.json, requirements.txt, go.mod, etc.)
   - Config files (docker-compose.yml, Makefile, .env.example)
   - Directory structure
   - Existing docs (docs/, ADRs, CHANGELOG.md)
2. **Ask for details:**
   - Project title
   - One-sentence description
   - Key features (4-6)
   - Tech stack components
   - Quick start command sequence
   - License type
3. **Generate README.md** with:
   - Title + description (1 line)
   - Badges (build, license, coverage)
   - Features list
   - Tech stack table
   - Quick start (numbered steps)
   - Directory structure (tree format)
   - Architecture diagram (if multi-component)
   - Configuration section
   - Development section
   - Deployment section
   - Troubleshooting links
   - Contributing section
   - License
   - Documentation index
4. **Validate completeness:**
   - All sections present
   - Links point to existing files or placeholders
   - Code blocks have language tags
   - No TODO markers in critical sections

## Template Reference

Full template at: `~/.augment/skills/custom/create-readme/templates/README-template.md`

## Quality Checklist

- [ ] One-sentence description at top
- [ ] 4-6 features listed
- [ ] Tech stack table present
- [ ] Quick start ≤4 steps
- [ ] Directory structure tree included
- [ ] Architecture diagram (if applicable)
- [ ] Configuration section with env vars
- [ ] Troubleshooting section with links
- [ ] Contributing guidelines present
- [ ] Documentation index at bottom

## Example Output

```markdown
# Spark Standalone Cluster

Dockerized Apache Spark 4.x standalone cluster with Delta Lake 4.x and Jupyter support.

## Features

- Standalone Spark cluster (1 master + 2 workers)
- Delta Lake 4.x with ACID transactions
- Jupyter notebook integration
- Pre-configured monitoring with Spark History Server

## Tech Stack

| Component | Technology | Purpose |
|-----------|------------|---------|
| Compute | Apache Spark 4.x | Distributed processing |
| Storage | Delta Lake 4.x | ACID transactions |
| Container | Docker Compose | Infrastructure |

## Quick Start

\`\`\`bash
# 1. Start cluster
docker-compose up -d

# 2. Run example job
make shell
spark-submit /opt/spark/work-dir/jobs/example.py

# 3. Verify output
ls data/output/
\`\`\`
```

## References

- Template: `~/.augment/skills/custom/create-readme/templates/README-template.md`
- [Standard Readme](https://github.com/RichardLitt/standard-readme)
- [Google README Guide](https://google.github.io/styleguide/docguide/READMEs.html)

## Anti-Patterns

- Verbose description (>2 sentences at top)
- Missing quick start section
- No tech stack table
- Broken links to docs
- Missing troubleshooting section
