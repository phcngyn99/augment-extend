# ADR-{NUMBER}: {Short Title of Decision}

**Status:** [Proposed | Accepted | Rejected | Deprecated | Superseded by ADR-{N}]  
**Date:** {YYYY-MM-DD}  
**Deciders:** {List of people who approved this decision}  
**Related:** {Links to related ADRs, docs, tickets}

---

## Context

What situation are we facing? What forces are at play (technical, business, organizational)? What constraints exist? What problem needs to be solved?

Write 2-4 sentences or a short narrative. Focus on **why** this decision is needed, not **what** the decision is yet.

## Decision

What did we decide to do? Be specific—name the technology, pattern, architecture, or approach.

State as **"We will..."** in active voice. Clear commitment.

Example: "We will use PostgreSQL as the primary database for user data storage."

## Consequences

What becomes easier or harder because of this decision? What trade-offs are we explicitly accepting?

List **positive, negative, and neutral** impacts. If only positives are listed, the ADR is incomplete—all decisions have trade-offs.

### Positive

- Benefit 1
- Benefit 2

### Negative

- Cost 1 (what becomes harder)
- Risk 1 (what could go wrong)

### Neutral

- Change that is neither good nor bad (e.g., "Requires team to learn X")

## Alternatives Considered

### Option 1: {Name}

**Why considered:** {Brief explanation}

**Pros:**
- Advantage 1
- Advantage 2

**Cons:**
- Disadvantage 1
- Disadvantage 2

**Rejected because:** {Clear reason}

### Option 2: {Name}

**Why considered:** {Brief explanation}

**Pros:**
- Advantage 1

**Cons:**
- Disadvantage 1

**Rejected because:** {Clear reason}

### Option 3: {Chosen Option} +

**Why chosen:** {Brief explanation}

**Pros:**
- Advantage 1 (why this option wins)

**Cons:**
- Disadvantage 1 (trade-offs accepted)

## References

- [Link to issue/ticket](...)
- [Link to design doc](...)
- [Link to standard/RFC](...)
- [Link to related ADR](...)

---

## Notes

- Keep ADRs to **1-2 pages max**. Longer content belongs in design docs.
- Write for **future maintainers** and onboarding engineers.
- **Never delete ADRs**—mark as Deprecated/Superseded instead.
- Store ADRs **in version control** alongside code.
- Review ADRs like code—peer review before acceptance.

**Template based on:** MADR (https://github.com/adr/madr) + Nygard (2011)
