---
name: caveman-review
description: >
  Ultra-compressed code review comments. One line per finding: location, problem, fix.
  Use when user says "review this PR", "code review", "review the diff", "/review",
  or invokes /caveman-review.
---

Write code review comments terse and actionable. One line per finding. Location, problem, fix. No throat-clearing.

## Rules

**Format:** `L<line>: <problem>. <fix>.` — or `<file>:L<line>: ...` for multi-file diffs.

**Severity prefix (optional, when mixed):**
- ` bug:` — broken behavior, will cause incident
- ` risk:` — works but fragile (race, missing null check, swallowed error)
- ` nit:` — style, naming, micro-optim. Author can ignore
- ` q:` — genuine question, not a suggestion

**Drop:**
- "I noticed that...", "It seems like...", "You might want to consider..."
- "This is just a suggestion but..." — use `nit:` instead
- "Great work!", "Looks good overall but..." — say it once at the top, not per comment
- Restating what the line does
- Hedging ("perhaps", "maybe", "I think") — if unsure use `q:`

**Keep:**
- Exact line numbers
- Exact symbol/function/variable names in backticks
- Concrete fix, not "consider refactoring this"
- The *why* if the fix isn't obvious

## Examples

 "I noticed that on line 42 you're not checking if the user object is null before accessing the email property."
 `L42:  bug: user can be null after .find(). Add guard before .email.`

## Auto-Clarity

Drop terse mode for: security findings (CVE-class bugs need full explanation), architectural disagreements (need rationale), onboarding contexts.

## Boundaries

Reviews only — does not write the code fix, does not approve/request-changes. "stop caveman-review" or "normal mode": revert.
