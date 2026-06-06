# Coding Principles

Core code quality principles distilled from coding-standards. For comprehensive patterns, invoke the `coding-standards` skill.

---

## 1. Readability > Cleverness

- Code read more than written
- Clear names (verb-noun functions, descriptive variables)
- Self-documenting code > comments
- Comment WHY, not WHAT

## 2. KISS — Simplest Solution

- Avoid over-engineering
- No premature optimization
- No abstractions for single-use code
- No features before needed (YAGNI)

## 3. DRY — Extract on 3rd Repeat

- First use: inline
- Second use: note pattern
- Third use: extract function/component
- Avoid copy-paste

## 4. Immutability

Always use spread operators, never mutate:

```typescript
// PASS
const updated = { ...user, name: 'New' }
const newArray = [...items, newItem]

// FAIL
user.name = 'New'
items.push(newItem)
```

## 5. Explicit > Implicit

- Type everything (no `any`)
- Validate inputs with schemas (Zod)
- Early returns over nested ifs
- Named constants over magic numbers

## 6. Error Handling

- Try/catch async operations
- Fail fast with context
- Log errors with details
- User-facing errors generic, server logs detailed

## 7. Parallel When Possible

```typescript
// PASS
const [users, markets, stats] = await Promise.all([
  fetchUsers(),
  fetchMarkets(),
  fetchStats()
])

// FAIL (sequential when unnecessary)
const users = await fetchUsers()
const markets = await fetchMarkets()
```

## 8. Surgical Changes Only

- Touch only what request requires
- Remove imports/vars YOUR changes orphaned
- Don't "improve" adjacent code
- Don't refactor unrelated code
- Match existing style

## 9. Code Smells — Refactor Triggers

- Function > 50 lines → split
- Nesting > 3 levels → early returns
- Magic numbers → named constants
- Repeated logic → extract
- No types → add types

---

**For full patterns** (API design, React hooks, testing, file structure), invoke `coding-standards` skill.
