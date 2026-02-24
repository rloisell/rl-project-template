# AI Worklog

> Record all AI-assisted work here, one dated section per session.
> Every section must be appended — never overwrite previous entries.
> See `CODING_STANDARDS.md` §3 (AI/ directory) for the required format.

---

## 2026-02-23 — Session G: Fix CodeQL workflow — paths filter + v4 upgrade

**Objective**: Diagnose and fix 20/20 CodeQL failures on rl-project-template; update to codeql-action v4.

### Actions taken
- Investigated run #20 logs — confirmed two failure causes:
  1. C# `autobuild` failure: no `.csproj`/`.sln` in template repo → "Could not auto-detect a suitable build method"
  2. JS/TS failure: no source `.js`/`.ts` files → "CodeQL detected GitHub Actions YAML but not JavaScript/TypeScript"
- Fixed `.github/workflows/codeql.yml`:
  - Added `paths` filters to push/PR triggers (`src/**`, `**.cs`, `**.js`, `**.ts`, `**.jsx`, `**.tsx`) — workflow skips on documentation-only pushes
  - Removed `schedule:` cron trigger — meaningless for a template repo with no source code
  - Upgraded `github/codeql-action` from `@v3` → `@v4` (addresses deprecation warning; also closes Dependabot PR #7)
  - Added prominent TEMPLATE NOTE block explaining the skeleton behaviour

### Files created or modified
- `.github/workflows/codeql.yml` — paths filter, removed schedule, v3→v4 upgrade, template note added

### Commits
- _(pending — branch `fix/codeql-paths-filter-v4`)_

### Outcomes / Notes
- After this fix, CodeQL will only fire in projects that have actual source code — no more false failures in the template repo itself
- DSC-modernization's `codeql.yml` also uses `@v3`; Dependabot PR already exists to bump it (Tier 4 in `AI/nextSteps.md`)

---

## 2026-02-23 — Session F: Dependabot PR Check Protocol

**Objective**: Add Dependabot PR check to session startup protocol in `copilot-instructions.md`.

### Actions taken
- Added "Dependabot PR Check" step to session startup table in `.github/copilot-instructions.md`
- Committed directly to `main` as `31d0ecb`

### Files created or modified
- `.github/copilot-instructions.md` — Dependabot check step added to startup protocol

### Commits
- `31d0ecb` — docs: add Dependabot PR check to session startup protocol

---

## 2026-02-23 — Session E: Emerald Deployment Learnings

**Objective**: Port all Emerald deployment learnings from DSC-modernization to the template.

### Actions taken
- Updated `docs/deployment/EmeraldDeploymentAnalysis.md` with DataClass/AVI label learnings, troubleshooting rows, and §16 Key Learnings
- Updated `docs/deployment/DEPLOYMENT_NEXT_STEPS.md`
- Updated `.github/copilot-instructions.md` with Emerald deployment context block
- Committed as `041d555`

### Files created or modified
- `docs/deployment/EmeraldDeploymentAnalysis.md` — §16 learnings, troubleshooting table
- `docs/deployment/DEPLOYMENT_NEXT_STEPS.md` — completion markers
- `.github/copilot-instructions.md` — Emerald context block

### Commits
- `041d555` — docs: add Emerald deployment learnings from DSC project (2026-02-23)

---

## 2026-02-22 — Session D: spec-kitty Guidance (Section 11 + copilot-instructions.md)

**Objective**: Add spec-kitty feature development workflow guidance to the template so all future projects follow spec-first development using spec-kitty.

### Actions taken
- Added `CODING_STANDARDS.md` Section 11 — spec-kitty Feature Development Workflow (§11.1–§11.7)
  - Overview of spec-first process
  - Directory structure (`kitty-specs/{NNN}-{slug}/`)
  - Setup commands (`spec-kitty init`, `agent feature create-feature`)
  - WP task file YAML frontmatter format
  - `spec.md` required sections
  - Validation (`spec-kitty validate-tasks --all`)
  - AI guardrails (ALWAYS/NEVER)
- Added spec-kitty workflow block to `.github/copilot-instructions.md` (between doc maintenance and Git Commit Format sections)
- Committed to branch `docs/spec-kitty-guidance`, pushed, PR merged to main

### Key Decisions
- Section 11 codifies the spec-kitty process established in DSC-modernization Session D
- copilot-instructions.md block keeps key workflow reminders live for AI pair programming sessions
- EF Core `List<string>` / LINQ gotcha explicitly documented in spec template guidance

---

## 2026-02-22 — Session C: Document Maintenance Standard

**Objective**: Apply the `AI/nextSteps.md` document maintenance standard (Section 10) established in DSC-modernization to this template repo; add branch protection to `main`.

### Actions taken
- Added `CODING_STANDARDS.md` Section 10 — AI/nextSteps.md Maintenance Standard (§10.1–10.5)
- Added doc maintenance guardrails block to `.github/copilot-instructions.md` before Git Commit Format section
- Created `AI/nextSteps.md` as a structured template following the new standard (Master TODO tiers, Todo Specifications, Session History)
- Set branch protection on `main`: require PR, dismiss stale reviews, no force pushes, no deletions, linear history required

### Files created or modified
- `CODING_STANDARDS.md` — Section 10 appended (~65 lines)
- `.github/copilot-instructions.md` — doc maintenance guardrails block added (~35 lines)
- `AI/nextSteps.md` — created from new template standard
- `AI/WORKLOG.md`, `AI/CHANGES.csv`, `AI/COMMANDS.sh`, `AI/COMMIT_INFO.txt` — tracking records updated

### Commits
- See `AI/COMMIT_INFO.txt` for merge commit hash

### Outcomes / Notes
- Branch protection configured on `main` via GitHub API (was previously unprotected)
- Standard is now consistent across DSC-modernization, DSC Java legacy, and this template repo

---

## Session 1 — YYYY-MM-DD

**Objective**: <what this session set out to accomplish>

### Actions taken
- <AI action 1>
- <AI action 2>

### Files created or modified
- `path/to/file.ext` — <what changed and why>

### Commits
- `<hash>` — <commit message>

### Outcomes / Notes
- <notable decisions, failures, deferrals, user overrides>
