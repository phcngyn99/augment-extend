---
name: compress
description: >
  Compress natural language memory files (.md, .txt) into caveman format
  to save input tokens. Preserves all technical substance, code, URLs, and structure.
  Trigger: /caveman:compress <filepath> or "compress memory file"
---

# Caveman Compress

## Purpose

Compress natural language files (.md, .txt) into caveman-speak to reduce input tokens. Original backed up as `<filename>.original.md`.

## Trigger

`/caveman:compress <filepath>` or when user asks to compress a memory file.

## Process

1. Read the target file
2. Run detect check: `python3 -c "from pathlib import Path; import sys; sys.path.insert(0, '<skills/caveman-compress>'); from scripts.detect import should_compress; print(should_compress(Path('<filepath>')))"` — skip if False
3. Back up original as `<filename>.original.md`
4. Compress the prose yourself (you ARE the LLM — no external API call needed)
5. Write compressed version to original path
6. Run validation: `python3 -c "from pathlib import Path; import sys; sys.path.insert(0, '<skills/caveman-compress>'); from scripts.validate import validate; r = validate(Path('<backup>'), Path('<compressed>')); print('valid:', r.is_valid); [print('  -', e) for e in r.errors]"`
7. If validation fails, fix the errors and re-validate (max 2 retries)
8. If still failing after retries, restore original from backup

DO NOT shell out to Claude API or `claude --print`. You are the model — compress inline.

## Compression Rules

### Remove
- Articles: a, an, the
- Filler: just, really, basically, actually, simply, essentially, generally
- Pleasantries, hedging, redundant phrasing
- Connective fluff: however, furthermore, additionally

### Preserve EXACTLY (never modify)
- Code blocks (fenced ``` and indented)
- Inline code (`backtick content`)
- URLs and links
- File paths, commands
- Technical terms, proper nouns
- Dates, version numbers, numeric values
- Environment variables

### Preserve Structure
- All markdown headings
- Bullet point hierarchy
- Numbered lists, tables
- Frontmatter/YAML headers

### Compress
- Short synonyms: "big" not "extensive", "fix" not "implement a solution for"
- Fragments OK: "Run tests before commit" not "You should always run tests before committing"
- Drop "you should", "make sure to", "remember to" — just state action
- Merge redundant bullets

CRITICAL: Anything inside ``` ... ``` copied EXACTLY. Inline code preserved EXACTLY.

## Boundaries

- ONLY compress natural language files (.md, .txt)
- NEVER modify: .py, .js, .ts, .json, .yaml, .yml, .toml, .env, .lock, .css, .html
- Mixed content (prose + code): compress ONLY prose
- Original backed up before overwriting
- Never compress FILE.original.md
