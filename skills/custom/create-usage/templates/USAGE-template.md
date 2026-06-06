# {Execution Guide Title}

**Last Updated:** {YYYY-MM-DD}  
**Category:** {jobs|tests|scripts|examples}  
**Estimated Duration:** {5 min|30 min|1 hour}

{One-sentence description of what this guide helps you execute}

## Prerequisites

- [ ] {Service or tool requirement (with version)}
- [ ] {Credential or permission requirement}
- [ ] {Environment variable requirement}
- [ ] {Access to resource}

## Execution Patterns

### Pattern 1: {Use Case Name} (e.g., Basic, Dry Run, Schema Only)

**When to use:** {Brief description of when this pattern applies}

```bash
{TOOL} {COMMAND} \
  --{flag1}={value1} \
  --{flag2}={value2} \
  {input/path} \
  --{output-flag}={output/path}
```

**Expected output:**
```
{Sample output showing success}
```

**Exit code:** `0` = success, `1` = {error condition}

---

### Pattern 2: {Use Case Name} (e.g., With Options, Sample Run, Limited Scope)

**When to use:** {Brief description}

```bash
{TOOL} {COMMAND} \
  --{flag1}={value1} \
  --{flag2}={value2} \
  {input/path} \
  --{limit-flag}={N} \
  --{output-flag}={output/path}
```

**Expected output:**
```
{Sample output}
```

---

### Pattern 3: {Use Case Name} (e.g., Production, Full Run, CI/CD Mode)

**When to use:** {Brief description}

```bash
{TOOL} {COMMAND} \
  --{flag1}={value1} \
  --{flag2}={value2} \
  {input/path} \
  --{output-flag}={output/path}
```

**Expected output:**
```
{Sample output}
```

## Verification

**How to confirm successful execution:**

```bash
# Check output exists
ls -lh {output/path}

# Verify content
{verification-command}
```

**Success criteria:**
- {Expected file/directory created}
- {Expected metric or log message}
- {Exit code = 0}

## Monitor (if applicable)

- {Service UI}: http://localhost:{port} (e.g., Spark UI while running)
- {Dashboard}: http://localhost:{port} (e.g., Grafana)
- {Logs}: `docker logs {container-name}`

## Troubleshooting

**Quick checks:**
```bash
# Issue 1: {Description of common error}
{diagnostic-command}
{fix-command}

# Issue 2: {Description of common error}
{diagnostic-command}
{fix-command}
```

**Detailed troubleshooting:** See [docs/troubleshooting/{guide-name}.md](../docs/troubleshooting/{guide-name}.md)

## Rollback (if applicable)

**How to undo if something goes wrong:**

```bash
# Stop process
{stop-command}

# Clean up artifacts
rm -rf {output/path}

# Reset state
{reset-command}
```

## Common Flags Reference

| Flag | Type | Description | Default |
|------|------|-------------|---------|
| `--{flag1}` | {STRING|INT|BOOLEAN} | {What this flag does} | `{default-value}` |
| `--{flag2}` | {STRING|INT|BOOLEAN} | {What this flag does} | `{default-value}` |
| `--{flag3}` | {STRING|INT|BOOLEAN} | {What this flag does} | `{default-value}` |

## Related Guides

- [{Related guide 1}]({path/to/guide})
- [{Related guide 2}]({path/to/guide})
- [Root README](../../README.md)

---

**Owner:** {Team or person responsible}
