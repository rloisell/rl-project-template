# GitHub Copilot Instructions

These instructions are automatically read by GitHub Copilot in this repository.
They define coding style, comment conventions, and collaboration guardrails established
by Ryan Loiselle across his development projects.

For the full human-readable version of these standards, see `CODING_STANDARDS.md`.

---

## Session Startup Protocol

**At the start of every session, read the following files before responding to anything.**
Ryan does not paste these in manually — they are your standing briefing documents.

| Order | File | Why |
|-------|------|-----|
| 1 | `AI/nextSteps.md` | Primary orientation — MASTER TODO, what is in progress |
| 2 | `CODING_STANDARDS.md` | Full coding conventions, deployment standards (§9), AI guardrails |
| 3 | `docs/deployment/EmeraldDeploymentAnalysis.md` | Canonical Emerald platform reference — Artifactory approval flow, ISB EA Option 2, CI/CD patterns |
| 4 | `docs/deployment/STANDARDS.md` | Concise new-project deployment checklist |

After reading, open with a one-sentence summary of the current state from `AI/nextSteps.md`,
then proceed with the user's request.

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

For **Markdown documentation files** (`.md`), place immediately below the `# Title`:

```markdown
**Author**: Ryan Loiselle — Developer / Architect
**AI tool**: GitHub Copilot — AI pair programmer / code generation
**Updated**: <Month Year>
```

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
- **Update `AI/WORKLOG.md`** at the end of every session with a dated section summarising all actions taken, files changed, and commits made
- **Append to `AI/CHANGES.csv`** for every file the AI creates, modifies, or deletes
- **Append to `AI/COMMANDS.sh`** for every significant shell command run (compiles, migrations, deploys, git operations)
- **Update `AI/COMMIT_INFO.txt`** after any major commit or push with hash, branch, and outcome

## NEVER
- Add academic metadata (student IDs, course names)
- Make architectural decisions without direction
- Remove or rewrite existing comments unless asked
- Leave debug `console.log` / `Console.WriteLine` in committed code
- Use `EnsureCreated()` in startup
- Commit secrets or build output

---

## Deployment & Containerization (BC Gov Emerald OpenShift)

When generating Containerfiles, Helm charts, GitHub Actions workflows, or OpenShift
manifests for BC Gov projects, apply these standards:

### Containerfiles (app)
- Base images: `mcr.microsoft.com/dotnet/sdk:10.0` (build) → `aspnet:10.0` (runtime) for .NET API
- Base images: `node:22-alpine` (build) → `nginx:alpine` (runtime) for React/Vite frontend
- Expose **port 8080** — never 80, 443, or 5000/5005 in containers
- Set `ENV ASPNETCORE_URLS=http://+:8080` on .NET containers
- Always install curl (API) / wget (frontend) for health checks
- Create a non-root user (`appuser`/`appgroup`); end with `USER appuser`
- Drop all capabilities: `cap_drop: [ALL]`; add `security_opt: [no-new-privileges:true]`
- Include `HEALTHCHECK` instructions pointing at `/health`

### Frontend — VITE_API_URL
- **Never** bake `VITE_API_URL` at build time from an environment variable
- Serve a `/config.json` from Nginx that the app fetches on startup (`window.__env__`)
- This allows one image to run in dev, test, and prod with different API URLs

### Image registry
- Push images to Artifactory: `artifacts.developer.gov.bc.ca/<key>-docker-local/<image>:<git-sha>`
- Never reference Docker Hub or GHCR for images that will run on Emerald
- **Artifactory projects are not self-serve.** Before pushing: (1) apply `ArtifactoryProject` CRD
  in `<license>-tools`, (2) post in `#devops-artifactory` on Rocket.Chat for approval,
  (3) wait for `approval_status: nothing-to-approve`, (4) create `docker-local` repo in UI,
  (5) add `default-<license>-<sa-hash>` service account as Developer in UI.
  The pipeline logs in to Artifactory as step 1 — it fails immediately at login if steps 4–5
  are not complete.

### Helm charts (GitOps repo)
- Always include `podLabels.DataClass: "Medium"` (or higher) for Emerald pods — confirm value with InfoSec
- **AVI InfraSettings — route annotation:**
  - `aviinfrasetting.ako.vmware.com/name: "dataclass-medium"` → private VIP (VPN-accessible); correct for all internal workloads
  - `aviinfrasetting.ako.vmware.com/name: "dataclass-low"` → ⚠️ **DO NOT USE** — no registered VIP on Emerald; DNS times out on VPN (observed Feb 2026)
  - AKO re-adds this annotation within ~15s if removed — always keep it in Helm values
- **Pod `DataClass` label MUST match the route annotation suffix** (SDN enforces at the VIP layer):
  - `DataClass: Medium` + `dataclass-medium` → ✅ traffic flows
  - Mismatch → SDN silently drops traffic (`ERR_EMPTY_RESPONSE`)
- Use `storageClassName: netapp-file-standard` for PersistentVolumeClaims
- Include `NetworkPolicy` objects — Emerald default-deny blocks both Ingress **and** Egress
  - Every traffic flow requires **two** policies: Ingress on the receiver AND Egress on the sender
- Use `ClusterIP` services; expose via OpenShift `Route` with TLS edge termination
- Resource requests and limits are required on every container

### Secrets
- Secrets are never committed — Helm templates provide the Secret object shape only
- Real values live in Vault (`secret/<license>/<env>/<key>`)
- Reference via `secretKeyRef` in pod env or Vault Agent sidecar injection

### ArgoCD (deployment)
- One ArgoCD `Application` CRD per environment (dev, test, prod)
- `syncPolicy.automated.selfHeal: true` and `prune: true` on all environments
- `targetRevision` maps to the env branch or tag (`develop`, `test`, `main`)

---

## `AI/nextSteps.md` — Document Maintenance

### Required structure (always in this order)
1. Title + metadata
2. **MASTER TODO** — tier tables with Status column
3. Todo Specifications — one section per pending item
4. Session History — reverse chronological (newest first)

### MASTER TODO tier table format
Every tier table must have **Status as the first column**: `⬜` = pending, `✅` = done.
Completed rows use ~~strikethrough~~ on item text and append **DONE YYYY-MM-DD**.
Do not remove completed rows.

### Session History entry format
Prepend at the **top** of Session History:
```markdown
### YYYY-MM-DD — Session N: <objective>
**Commits:** `<hash>` description
**Files changed:** ...
**Key decisions:** ...
```

### ALWAYS (document maintenance)
- Mark completed todo rows `✅` + strikethrough immediately after merging to `main`
- Prepend new session history entry at end of every session
- Keep MASTER TODO tables as the first content in the document
- Keep the document under ~600 lines — condense history; narrative lives in `AI/WORKLOG.md`

### NEVER (document maintenance)
- Delete session history entries
- Let the file grow unbounded with verbose session notes (that belongs in WORKLOG.md)
- Restructure the document order without explicit direction from Ryan Loiselle

---

## spec-kitty Feature Development Workflow

All features follow a spec-first process using spec-kitty before any implementation code is written.

### Feature Directory Structure
```
kitty-specs/{NNN}-{slug}/
  spec.md        # requirements, user stories, success criteria
  plan.md        # phased implementation plan
  tasks/         # WP task files (WP01-title.md, WP02-title.md, ...)
  spec/fixtures/openapi/   # OpenAPI request/response example .json files
  spec/fixtures/db/        # SQL migration preview .sql files
```

### WP File Frontmatter (required fields)
```yaml
---
work_package_id: "WP01"
title: "Short description"
lane: "planned"
subtasks: ["WP01"]
phase: "Phase 1 — Name"
assignee: ""
agent: ""
history:
  - timestamp: "YYYY-MM-DDTHH:MM:SSZ"
    lane: "planned"
    agent: "system"
    action: "Created for feature spec"
---
```

### Initialization (new project)
```bash
spec-kitty init --here --ai copilot --non-interactive --no-git --force
spec-kitty agent feature create-feature --id 001 --name "feature-slug"
spec-kitty validate-tasks --all   # must show 0 mismatches before any code
```

### ALWAYS (spec-kitty)
- Write `spec.md` + `plan.md` + WP files **before** any implementation code
- Run `spec-kitty validate-tasks --all` after writing WP files; fix all mismatches
- Include OpenAPI fixtures for every new API endpoint
- Note in spec files: use `List<string>` for LINQ collection variables in EF Core (not `new[]`)
- Commit `.kittify/` and `kitty-specs/` to the repo; add `__pycache__/` to `.gitignore`
- Set `lane: "planned"` on all new WPs; advance lane as work progresses

### NEVER (spec-kitty)
- Start implementation code before the spec and WPs exist
- Leave WP files with inconsistent lane values without running validate-tasks
- Commit `__pycache__/` or `.pyc` files from spec-kitty scripts

---

## Git Commit Format
```
<type>: <short imperative description>

- detail line 1
- detail line 2
```
Types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`
