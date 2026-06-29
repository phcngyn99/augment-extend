---
name: browse-skills
description: Use when user asks what optional skills are available in skills-lib or needs to discover advanced/specialized skills
---

# Browse Skills Library

Show catalog of optional skills in skills-lib/ when user needs specialized/advanced capabilities.

## When to Use

- User asks "what's in skills-lib?"
- User wants optional/advanced skills
- User needs capabilities beyond core skills

## How to Use

Read and display `~/.augment/skills-lib/README.md` — contains catalog of all optional skills with descriptions and triggers.

**Do NOT:**
- Read individual SKILL.md files (wastes tokens)
- Generate list dynamically
- Grep or ls the directory

**Single source of truth:** `~/.augment/skills-lib/README.md`

## Quick Reference

The README.md is located at `~/.augment/skills-lib/README.md`.

Read and display that file to show the catalog.

Simple. One file read. Done.
