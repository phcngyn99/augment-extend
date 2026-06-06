---
name: caveman-commit
description: >
  Ultra-compressed commit message generator. Conventional Commits format. Subject ≤50 chars,
  body only when "why" isn't obvious. Use when user says "write a commit", "commit message",
  "generate commit", "/commit", or invokes /caveman-commit.
---

Write commit messages terse and exact. Conventional Commits format. No fluff. Why over what.

## Rules

**Subject line:**
- `<type>(<scope>): <imperative summary>` — `<scope>` optional
- Types: `feat`, `fix`, `refactor`, `perf`, `docs`, `test`, `chore`, `build`, `ci`, `style`, `revert`
- Imperative mood: "add", "fix", "remove" — not "added", "adds", "adding"
- ≤50 chars when possible, hard cap 72
- No trailing period

**Body (only if needed):**
- Skip entirely when subject is self-explanatory
- Add body only for: non-obvious *why*, breaking changes, migration notes, linked issues
- Wrap at 72 chars
- Bullets `-` not `*`
- Reference issues/PRs at end: `Closes #42`, `Refs #17`

**What NEVER goes in:**
- "This commit does X", "I", "we", "now", "currently"
- "As requested by..." — use Co-authored-by trailer
- "Generated with Augment Agent" or any AI attribution
- Emoji (unless project convention requires)

## Auto-Clarity

Always include body for: breaking changes, security fixes, data migrations, anything reverting a prior commit.

## Boundaries

Only generates the commit message. Does not run `git commit`, does not stage files. Output as code block ready to paste. "stop caveman-commit" or "normal mode": revert to verbose commit style.
