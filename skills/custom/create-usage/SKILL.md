---
name: create-usage
description: >
  Use when user says "create usage guide", "document how to run", "write execution guide", or needs operational documentation for jobs/tests/scripts.
  Generates execution guide with prerequisites checklist, multiple execution patterns (basic/options/production),
  verification steps, monitoring info, troubleshooting, rollback procedures.
---

# create-usage

Generate execution guide with:
- Prerequisites checklist (tools, credentials, env vars)
- Multiple execution patterns (basic, with options, production)
- Expected output samples
- Verification steps
- Monitoring info (UIs, dashboards, logs)
- Troubleshooting quick checks
- Rollback procedures
- Common flags reference table

## Trigger

- "create usage guide"
- "document how to run"
- "write execution guide"
- "add usage doc"
- "document this job/test/script"

## Process

1. **Identify target** — what needs execution guide:
   - Spark job
   - Test suite
   - Script/tool
   - Service/daemon
2. **Analyze command** — extract:
   - Tool/binary name
   - Common flags/options
   - Input/output paths
   - Environment dependencies
3. **Ask for details:**
   - Prerequisites (tools, credentials, access)
   - Execution patterns (basic/options/production)
   - Expected duration
   - Monitoring endpoints (if applicable)
   - Common failure modes
4. **Generate USAGE.md** with:
   - Header (title, date, category, duration)
   - Prerequisites checklist
   - 3 execution patterns:
     - Pattern 1: Basic/Dry Run/Schema Only
     - Pattern 2: With Options/Sample Run/Limited Scope
     - Pattern 3: Production/Full Run/CI-CD Mode
   - Verification section (how to confirm success)
   - Monitor section (UIs, logs, dashboards)
   - Troubleshooting (quick checks)
   - Rollback section (undo procedures)
   - Common flags reference table
   - Related guides links
5. **Validate completeness:**
   - All patterns have expected output
   - Verification steps are concrete
   - Troubleshooting includes commands
   - Flag table complete

## Template Reference

Full template at: `~/.augment/skills/custom/create-usage/templates/USAGE-template.md`

## Quality Checklist

- [ ] Prerequisites checklist with versions
- [ ] 3 execution patterns documented
- [ ] Expected output shown for each pattern
- [ ] Exit codes documented
- [ ] Verification section with commands
- [ ] Monitoring info included (if applicable)
- [ ] Troubleshooting with diagnostic commands
- [ ] Rollback procedures present
- [ ] Flag reference table complete

## Example Output

```markdown
# Spark Job Execution Guide

**Last Updated:** 2025-05-18  
**Category:** jobs  
**Estimated Duration:** 30 min

Execute data transformation job with Delta Lake output.

## Prerequisites

- [ ] Spark cluster running (docker-compose up)
- [ ] AWS credentials in ~/.aws/credentials
- [ ] SPARK_MASTER_HOST environment variable set
- [ ] Input data available at s3://bucket/input/

## Execution Patterns

### Pattern 1: Dry Run

**When to use:** Validate job logic without writing output

\`\`\`bash
spark-submit \
  --master spark://localhost:7077 \
  --conf spark.sql.shuffle.partitions=10 \
  /opt/spark/work-dir/jobs/transform.py \
  --dry-run \
  --input s3://bucket/input/ \
  --output s3://bucket/output/
\`\`\`

**Expected output:**
\`\`\`
[DRY RUN] Would process 1000 records
[DRY RUN] Output schema: id, name, timestamp
[DRY RUN] Exit code: 0
\`\`\`

### Pattern 2: Sample Run

**When to use:** Test with limited data (100 records)

\`\`\`bash
spark-submit \
  --master spark://localhost:7077 \
  /opt/spark/work-dir/jobs/transform.py \
  --input s3://bucket/input/ \
  --limit 100 \
  --output s3://bucket/output/sample/
\`\`\`

## Verification

\`\`\`bash
# Check output exists
ls -lh /opt/spark/data/delta-tables/output/

# Verify record count
spark-sql -e "SELECT COUNT(*) FROM delta.\`/path/to/output\`"
\`\`\`

**Success criteria:**
- Output directory created
- Record count matches input
- Exit code = 0
```

## References

- Template: `~/.augment/skills/custom/create-usage/templates/USAGE-template.md`

## Anti-Patterns

- Missing prerequisites
- Only one execution pattern
- No expected output samples
- Missing verification steps
- No troubleshooting section
