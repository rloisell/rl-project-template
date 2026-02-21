# Coding Standards & AI Collaboration Guardrails

**Author**: Ryan Loiselle — Developer / Architect  
**AI tool**: GitHub Copilot — AI pair programmer / code generation  
**Established**: February 2026 (DSC-modernization project)

This document defines the coding conventions, commenting style, and AI collaboration expectations
for all projects that start from this template. It serves as both a human reference and a prompt
you can paste into any AI tool to bootstrap consistent behaviour.

---

## 1. Roles & Attribution

### Human role — Ryan Loiselle
- Architect and decision-maker for all structural, security, and business-logic choices
- Directs the AI: sets objectives, validates output, accepts or rejects suggestions
- Reviews every AI-generated block before it is committed

### AI role — GitHub Copilot
- Pair programmer and code generator
- Accelerates boilerplate, LINQ patterns, DTO mappings, and scaffolding
- Does **not** make architectural decisions autonomously

### Attribution in code
Every source file must open with a header block identifying both contributors:

**C# / Java / C / C++:**
```
/*
 * FileName.cs
 * Ryan Loiselle — Developer / Architect
 * GitHub Copilot — AI pair programmer / code generation
 * <Month Year>
 *
 * AI-assisted: <brief description of what Copilot generated>;
 * reviewed and directed by Ryan Loiselle.
 */
```

**JavaScript / TypeScript / React (.jsx/.tsx):**
```javascript
/*
 * FileName.jsx
 * Ryan Loiselle — Developer / Architect
 * GitHub Copilot — AI pair programmer / code generation
 * <Month Year>
 *
 * AI-assisted: <brief description of what Copilot generated>;
 * reviewed and directed by Ryan Loiselle.
 */
```

**Perl:**
```perl
#
# filename.pl
# Ryan Loiselle — Developer / Architect
# GitHub Copilot — AI pair programmer / code generation
# <Month Year>
#
# AI-assisted: <brief description of what Copilot generated>;
# reviewed and directed by Ryan Loiselle.
#
```

---

## 2. Comment Style

Comments should explain **purpose and intent**, not re-describe syntax.

### Section labels — ALL-CAPS banners

Use short ALL-CAPS labels to divide a file into logical sections:

```csharp
// ── QUERY ──────────────────────────────────────────────────────────────────

// ── MUTATIONS ──────────────────────────────────────────────────────────────

// ── HELPERS ────────────────────────────────────────────────────────────────
```

### Per-method purpose lines

Place a single `//` comment directly above each method explaining what it does,
what it returns, and any notable side effects or thrown exceptions:

```csharp
// returns all work items for a user, sorted newest first
public async Task<WorkItemDto[]> GetAllAsync(Guid? userId) { ... }

// throws ForbiddenException (403) if requester does not own the item and is not Admin/Manager
private async Task EnforceOwnershipAsync(WorkItem item, Guid? requesterId) { ... }

// returns true if the budget description contains "opex" or "expense" (case-insensitive)
private static bool IsExpenseBudget(string? description) { ... }
```

### End-of-block markers

Close every class and significant block with an end marker comment:

```csharp
} // end WorkItemService
} // end AuthService
```

```javascript
} // end ActivityPage
```

### Inline comments — use sparingly

Reserve inline `//` comments for non-obvious logic:

```csharp
// Resolve period to concrete date range
// Privileged users see all projects; regular users see only assignments
// DEBUGGING — remove before production
```

Do **not** comment self-evident code:
```csharp
// BAD: increments the counter
count++;

// GOOD — only if non-obvious:
// Offset by 1 because the sentinel head/tail nodes are not counted
count++;
```

---

## 3. File Organisation

### Root README.md
- Describes **what the product is**, not how it was built
- Sections: What is it, Features, Architecture (with diagram links), Getting Started, Documentation index
- Development session notes do **not** belong here — they go in `docs/development-history.md`

### docs/development-history.md
- Session-by-session record of what was built and why
- Links to `AI/WORKLOG.md` or equivalent for full detail

### docs/local-development/README.md
- Ports, services, credentials (dev only), LaunchAgent / Docker setup
- Known issues and workarounds

### AI/ directory (optional)
- `WORKLOG.md` — detailed, chronological build log
- `nextSteps.md` — feature backlog and completion status
- `securityNextSteps.md` — security hardening plan

---

## 4. Architecture Conventions

### Service layer (C# / .NET projects)
- Controllers are **thin** — no business logic, no direct DbContext access
- Business logic lives in scoped service classes implementing interfaces:
  `IWorkItemService`, `IReportService`, `IProjectService`, `IAuthService`
- Domain exceptions (`NotFoundException`, `ForbiddenException`, `BadRequestException`,
  `UnauthorizedException`) are thrown from services and caught by a global exception handler
  that returns RFC 7807 `ProblemDetails` responses

### Frontend (React / Vite projects)
- API calls are centralised in `src/api/` service files — no `fetch`/`axios` calls in components
- Server state managed with TanStack Query v5 via hooks in `src/hooks/`
- Auth headers centralised in `src/api/AuthConfig.js` — one source of truth
- Design system: B.C. Government Design System (BC Sans, design tokens) for BC Gov projects

### Database
- EF Core with Pomelo MariaDB provider
- `db.Database.Migrate()` on startup — never `EnsureCreated()` in production code
- Legacy field mappings preserved during incremental migrations

---

## 5. AI Behaviour Guardrails

These are the instructions passed to GitHub Copilot via `.github/copilot-instructions.md`.
Keep this section in sync with that file.

### ALWAYS
- Add a file header with author, AI attribution, and date when creating a new file
- Add a single-line purpose comment above every method
- Place ALL-CAPS section labels (`// ── QUERY ──`, `// ── HELPERS ──`) between logical groups
- Add `} // end ClassName` at the close of every class
- Use the service-layer pattern — controllers delegate to services, services own logic
- Name bool-returning helpers with a verb: `IsExpenseBudget()`, `HasValue()`, `CanAccess()`
- Follow existing naming conventions in the file before introducing new ones

### NEVER
- Add student IDs, course names, or academic metadata to file headers
- Make architectural decisions without direction from Ryan Loiselle
- Remove or rewrite existing comments unless specifically asked
- Add `// TODO`, `// FIXME`, or `// HACK` markers without explaining the reason
- Commit debug `console.log` or `Console.WriteLine` left from development
- Use `EnsureCreated()` in production startup code

### WHEN GENERATING NEW FILES
- Open with the standard header block (see Section 1)
- Match the indentation style of the surrounding codebase
- Prefer `var` inference for locals; use explicit types for public API signatures
- Prefer expression-body (`=>`) methods for single-line returns
- For C#: use primary constructors (`public MyClass(Dep dep) : ...`) where applicable

### FOR AI-GENERATED SECTIONS
- Mark complex generated blocks with a brief note: `// AI-assisted: <what was generated>`
- If a section was generated and then significantly modified by a human, remove the AI note

---

## 6. Git Conventions

### Commit message format
```
<type>: <short imperative description>

- bullet detail line 1
- bullet detail line 2
```

Types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`

### Branch strategy
- `main` — always deployable
- Feature branches: `feat/<short-description>`
- Bug fix branches: `fix/<short-description>`

### What not to commit
- Build output (`bin/`, `obj/`, `dist/`, `node_modules/`)
- Local secrets (`appsettings.Development.json` with real credentials)
- Vite build artifacts (`src/*/dist/`)

---

## 7. Diagrams

All architecture and flow diagrams are maintained in two formats:

| Format | Use |
|--------|-----|
| Draw.io (`.drawio`) | Primary — editable source, exported to SVG for GitHub rendering |
| PlantUML (`.puml`) | Secondary — text-based, exported to PNG |

**Export conventions:**
- Draw.io → SVG: `draw.io --export --format svg --embed-diagram --border 10`
- PlantUML → PNG: `plantuml -o ../png *.puml`
- SVG files use white background (`background="#ffffff"`) and strokeWidth=2 on edges

**Required diagrams for a new project:**
- Component diagram
- Domain/data model
- API architecture (middleware pipeline)
- Deployment topology
- Key sequence flows (one per major user-facing feature)

---

## 8. Security Defaults

- Auth headers: `X-User-Id` (user) and `X-Admin-Token` (admin) for dev; OIDC/Keycloak for production
- Rate limiting on all admin endpoints: 60 req/min per IP (fixed window)
- Health checks: `/api/health` (basic) and `/api/health/details` (DB probe)
- Passwords: ASP.NET Core `PasswordHasher` — never plain text or home-grown hashing
- CORS: named policies — wildcard `DevCors` for local; explicit origin list `ProdCors` for production
- `AI/securityNextSteps.md` documents the full hardening roadmap for every project
