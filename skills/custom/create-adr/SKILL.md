---
name: create-adr
description: >
  Use when user says "create adr", "document decision", "write architecture decision", or needs to capture technical decisions.
  Generates Architecture Decision Record (ADR) with context, decision statement, consequences (positive/negative/neutral),
  alternatives considered with pros/cons, and references. Based on MADR + Nygard (2011).
---

# create-adr

Generate Architecture Decision Record (ADR) with:
- Status (Proposed/Accepted/Rejected/Deprecated/Superseded)
- Context (situation, forces, constraints, problem)
- Decision statement ("We will...")
- Consequences (positive, negative, neutral)
- Alternatives considered (with pros/cons/rejection reason)
- References (issues, design docs, RFCs, related ADRs)

## Trigger

- "create adr"
- "document decision"
- "write architecture decision"
- "add adr"
- "record this decision"

## Process

1. **Detect decision context** — analyze conversation for:
   - Technology choices (database, framework, library)
   - Architecture patterns (microservices, monolith, event-driven)
   - Process changes (deployment, testing, branching)
   - Standards/conventions (coding style, API design)
2. **Ask for details:**
   - Short title (e.g., "Use PostgreSQL for User Data")
   - Status (Proposed/Accepted)
   - Deciders (who approved)
   - Related links (issues, docs)
3. **Generate ADR** with:
   - **Header:** ADR-{NUMBER}, Status, Date, Deciders, Related
   - **Context:** 2-4 sentences (why this decision is needed)
   - **Decision:** "We will..." statement (active voice, specific)
   - **Consequences:**
     - Positive (benefits)
     - Negative (costs, risks, what becomes harder)
     - Neutral (neither good nor bad)
   - **Alternatives Considered:**
     - Option 1: {name} — pros/cons, rejected because...
     - Option 2: {name} — pros/cons, rejected because...
     - Option 3: {chosen} + — pros/cons, why chosen
   - **References:** Links to issues, docs, standards
   - **Notes:** ADR best practices reminder
4. **Number ADR** — scan `docs/adr/` for existing ADRs, assign next number (e.g., ADR-003)
5. **Save location:** `docs/adr/ADR-{NUMBER}-{slug}.md`
6. **Update ADR index** — append to `docs/adr/README.md` if exists

## Template Reference

Full template at: `~/.augment/skills/custom/create-adr/templates/ADR-template.md`

## Quality Checklist

- [ ] Status field present (Proposed/Accepted)
- [ ] Context explains **why** decision is needed (not what)
- [ ] Decision uses "We will..." format
- [ ] Consequences include positive AND negative
- [ ] At least 2 alternatives considered
- [ ] Each alternative has rejection reason
- [ ] Chosen option marked with +
- [ ] References included
- [ ] ADR ≤2 pages

## Example Output

```markdown
# ADR-003: Use PostgreSQL for User Data Storage

**Status:** Accepted  
**Date:** 2025-05-18  
**Deciders:** Engineering Team  
**Related:** [Issue #42](link), [Design Doc](link)

---

## Context

Our application needs persistent storage for user profiles, authentication tokens, and session data. We require ACID transactions, support for complex queries (joins, aggregations), and horizontal scaling capability. Current in-memory storage does not survive restarts and cannot handle 10K+ concurrent users.

## Decision

We will use PostgreSQL 16 as the primary database for all user data storage.

## Consequences

### Positive

- ACID transactions ensure data consistency
- Rich query capabilities (joins, window functions, CTEs)
- Proven scalability with read replicas
- Strong ecosystem (ORMs, monitoring tools)

### Negative

- Adds infrastructure dependency (requires hosted DB or self-managed instance)
- Team must learn SQL optimization and indexing strategies
- Write scaling limited without sharding (acceptable for current scale)

### Neutral

- Requires migration from current in-memory store (one-time cost)

## Alternatives Considered

### Option 1: MongoDB

**Why considered:** NoSQL flexibility, horizontal scaling

**Pros:**
- Schema flexibility
- Built-in sharding

**Cons:**
- Weaker transaction guarantees (before 4.0)
- Team has no MongoDB experience
- Overkill for structured user data

**Rejected because:** User data is highly structured; ACID guarantees more important than schema flexibility

### Option 2: SQLite

**Why considered:** Zero configuration, embedded

**Pros:**
- No external dependency
- Simple setup

**Cons:**
- Single-writer limitation
- Cannot scale horizontally
- No built-in replication

**Rejected because:** Cannot handle 10K+ concurrent users (write bottleneck)

### Option 3: PostgreSQL +

**Why chosen:** Best balance of ACID guarantees, query power, and scaling

**Pros:**
- ACID transactions
- Read replicas for scaling
- Team has SQL experience

**Cons:**
- Infrastructure overhead (acceptable trade-off)

## References

- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Issue #42: Database Selection](link)
- [Design Doc: User Data Schema](link)
```

## References

- Template: `~/.augment/skills/custom/create-adr/templates/ADR-template.md`
- [MADR](https://github.com/adr/madr)
- [Michael Nygard (2011)](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions)

## Anti-Patterns

- Only listing positives (all decisions have trade-offs)
- Missing alternatives considered
- Context explains **what** instead of **why**
- Decision statement too vague ("We will improve performance")
- ADR >2 pages (move detail to design docs)
