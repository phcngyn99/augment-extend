# Security Principles

Core security rules for ALL code. For comprehensive checklists, invoke the `security-review` skill.

---

## 1. Never Hardcode Secrets

```typescript
// FAIL
const apiKey = "sk-proj-xxxxx"

// PASS
const apiKey = process.env.OPENAI_API_KEY
if (!apiKey) throw new Error('OPENAI_API_KEY not configured')
```

**Check:**
- All secrets in env vars
- `.env.local` in .gitignore
- No secrets in git history

## 2. Validate All Input

```typescript
import { z } from 'zod'

const schema = z.object({
  email: z.string().email(),
  age: z.number().int().min(0).max(150)
})

const validated = schema.parse(userInput)
```

**Check:**
- Whitelist validation (not blacklist)
- File uploads: size, type, extension
- No direct user input in queries

## 3. Parameterized Queries Only

```typescript
// FAIL — SQL injection
const query = `SELECT * FROM users WHERE email = '${email}'`

// PASS
await supabase.from('users').select('*').eq('email', email)
```

**Never concatenate SQL.**

## 4. Auth & Authorization

**Tokens:**
- httpOnly cookies (not localStorage)
- Secure, SameSite=Strict flags

**Authorization:**
- Check permissions BEFORE operations
- Row Level Security in Supabase
- Role-based access control

## 5. XSS Prevention

- Sanitize user HTML (DOMPurify)
- Use React's built-in escaping
- Content Security Policy headers
- No `dangerouslySetInnerHTML` without sanitization

## 6. CSRF Protection

- CSRF tokens on state-changing operations
- SameSite=Strict on cookies
- Double-submit cookie pattern

## 7. Rate Limiting

- All API endpoints rate-limited
- Stricter limits on expensive operations (search, AI)
- IP-based + user-based limits

## 8. Sensitive Data

**Logging:**
- Never log passwords, tokens, secrets
- Redact card numbers, SSNs, PII

**Errors:**
- Generic messages to users
- Detailed logs server-side only
- No stack traces exposed

## 9. HTTPS & Headers

- Enforce HTTPS in production
- Security headers: CSP, X-Frame-Options, HSTS
- CORS properly configured

## 10. Dependencies

- `npm audit` clean before deploy
- Lock files committed
- Dependabot enabled
- Regular updates

---

## Pre-Deployment Gate

Before ANY production deploy, verify:
- [ ] No hardcoded secrets
- [ ] Input validation on all endpoints
- [ ] Parameterized queries
- [ ] Auth checks in place
- [ ] Rate limiting enabled
- [ ] HTTPS enforced
- [ ] Security headers configured
- [ ] No sensitive data in logs/errors
- [ ] Dependencies up-to-date, no CVEs

**For full security checklist** (blockchain, file uploads, testing), invoke `security-review` skill.
