# GitHub Copilot Instructions

These instructions are automatically read by GitHub Copilot in this repository.
They define coding style, comment conventions, and collaboration guardrails established
by Ryan Loiselle across his development projects.

For the full human-readable version of these standards, see `CODING_STANDARDS.md`.

---

## Identity & Attribution

- **Developer / Architect**: Ryan Loiselle — makes all structural and business-logic decisions
- **AI role**: GitHub Copilot — pair programmer and code generator; does not make
  architectural decisions autonomously

When creating a **new file**, always open with this header block:

```
/*
 * FileName.ext
 * Ryan Loiselle — Developer / Architect
 * GitHub Copilot — AI pair programmer / code generation
 * <Month Year>
 *
 * AI-assisted: <one sentence describing what Copilot contributed>;
 * reviewed and directed by Ryan Loiselle.
 */
```

Use `#` block comments for Perl; `//` block or `/* */` for C-family languages.
Omit student IDs, course names, and academic metadata — this is professional work.

---

## Comment Conventions

### Section labels
Divide classes into logical sections with ALL-CAPS banners:
```
// ── QUERY ──────────────────────────────────────────────────────────────────
// ── MUTATIONS ──────────────────────────────────────────────────────────────
// ── HELPERS ────────────────────────────────────────────────────────────────
```

### Per-method purpose comments
Place a single `//` line above every method. Describe what it does, what it returns,
and any exceptions thrown. Keep it to one line:
```csharp
// returns all work items for a user, sorted newest first
public async Task<WorkItemDto[]> GetAllAsync(Guid? userId) { ... }

// throws ForbiddenException (403) if requester does not own the item and is not Admin/Manager
private async Task EnforceOwnershipAsync(WorkItem item, Guid? requesterId) { ... }
```

### End-of-class markers
```csharp
} // end WorkItemService
} // end AuthController
```

### Inline comments
Only on non-obvious logic. Never on self-evident code.
Mark any large AI-generated block: `// AI-assisted: <what was generated>`

---

## Architecture Rules (C# / .NET projects)

- Controllers are **thin** — HTTP wiring only, no business logic, no direct DbContext
- All logic in scoped service classes implementing interfaces (`IWorkItemService`, etc.)
- Domain exceptions: `NotFoundException` (404), `ForbiddenException` (403),
  `BadRequestException` (400), `UnauthorizedException` (401)
- Global exception handler maps all domain exceptions to RFC 7807 ProblemDetails
- `db.Database.Migrate()` on startup — never `EnsureCreated()`
- EF Core with primary constructors: `public MyService(ApplicationDbContext db) { ... }`

## Architecture Rules (React / Vite frontend)

- All API calls in `src/api/` service files — never inline fetch/axios in components
- Server state via TanStack Query v5 hooks in `src/hooks/`
- Auth headers via a single `src/api/AuthConfig.js` — one source of truth
- B.C. Government Design System components for BC Gov projects

---

## Code Style

- C#: prefer expression-body (`=>`) for single-return members
- C#: use primary constructors where applicable
- C#: `var` for locals; explicit types for public signatures
- JS/JSX: `const`/arrow functions; named exports
- Match indentation and naming conventions already present in the file

---

## ALWAYS
- Add file header when creating a new file
- Add per-method purpose comment above every method
- Add ALL-CAPS section labels between logical groups
- Add `} // end ClassName` at end of every class
- Follow the service-layer pattern

## NEVER
- Add academic metadata (student IDs, course names)
- Make architectural decisions without direction
- Remove or rewrite existing comments unless asked
- Leave debug `console.log` / `Console.WriteLine` in committed code
- Use `EnsureCreated()` in startup
- Commit secrets or build output

---

## Git Commit Format
```
<type>: <short imperative description>

- detail line 1
- detail line 2
```
Types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`
