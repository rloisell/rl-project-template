# GitHub Copilot Agents — rl-project-template

**Author**: Ryan Loiselle — Developer / Architect  
**AI tool**: GitHub Copilot — AI pair programmer / code generation  
**Updated**: February 2026

This folder contains GitHub Copilot **agent skill files** (`.agent.md`) that define
specialized AI personas for common development workflows. These agents are
inherited by all projects that use `rl-project-template` as their starting point.

---

## What Are Agent Skills?

Agent skill files (`.github/agents/*.agent.md`) are read by GitHub Copilot in agent
mode. Each file defines a named persona with:
- A specific scope and role
- Core rules and constraints
- Ready-to-use templates, commands, and patterns
- A **Self-Learning** knowledge base where new discoveries are appended over time

Rather than re-explaining the same context at the start of every session, these
agents encode hard-won operational knowledge permanently.

---

## Agent Inventory

| File | Skill Name | Scope |
|------|-----------|-------|
| `session-workflow.agent.md` | Session Workflow Advisor | Session startup/shutdown, AI file maintenance (WORKLOG/CHANGES/COMMANDS/COMMIT_INFO) |
| `github-workflow.agent.md` | GitHub Workflow Advisor | Branch naming, PR lifecycle, CI diagnosis, gh CLI, rulesets |
| `diagram-generation.agent.md` | Diagram Generation Advisor | draw.io + PlantUML + Mermaid, 10-diagram UML suite, folder structure, export commands |
| `ci-cd-pipeline.agent.md` | CI/CD Pipeline Advisor | 5-workflow files, ISB EA Option 2 GitOps pattern, image tagging, yq updates, Trivy, placeholder substitution |
| `local-dev.agent.md` | Local Development Advisor | podman-compose, EF Core migration commands, MariaDB setup, port conventions, env config, troubleshooting |
| `spec-kitty.agent.md` | Spec-Kitty Advisor | Spec-first development, WP YAML format, spec.md/plan.md required sections, validate-tasks, Linux LINQ gotcha |
| `ef-core.agent.md` | EF Core Advisor | Pomelo/MariaDB patterns, migration workflow, startup Migrate(), primary constructors, Linux LINQ overload, service layer |
| `bc-gov-devops.agent.md` | BC Gov DevOps Advisor | OpenShift Emerald, Artifactory, Helm, NetworkPolicy, ArgoCD |

Project-specific agents (e.g. `network-policy.agent.md`, `openshift-health.agent.md`)
live in the project's own `.github/agents/` folder and extend these generic ones.

---

## Gap Analysis — Why These Agents Exist

### Problem
After several development sessions across HelloNetworkWorld and DSC-modernization,
two patterns emerged:

1. **Re-discovery cost** — The same platform facts, CLI patterns, and workflow steps
   were being re-explained every other session. Each re-discovery consumes context,
   time, and risks introducing regressions.

2. **Session state loss** — AI has no memory between sessions. Without a structured
   startup protocol, sessions often began with outdated context or missed in-progress
   work recorded in `AI/nextSteps.md`.

### Resolution

Each agent was created to permanently encode a specific domain of knowledge:

#### `session-workflow.agent.md`
No formal protocol for session start and end. Sessions were starting without reading
orientation files and ending without committing AI session logs. Encodes the startup
checklist and shutdown protocol as an always-available conductor.

#### `github-workflow.agent.md`
Branch protection rules and CI failure diagnosis required re-learning each time.
Two incidents drove this: a ruleset status check name mismatch, and the non-obvious
requirement to make a repo public before rulesets enforce on free GitHub plans.

#### `diagram-generation.agent.md`
No standard diagram workflow existed. Projects had unstructured `diagrams/` folders
and inconsistent draw.io/PlantUML usage. Encodes the 10-type full UML suite from
CODING_STANDARDS §7, folder structure, and CLI export commands.

#### `ci-cd-pipeline.agent.md`
Five workflow files (build-and-test, build-and-push, codeql, copilot-review,
publish-on-tag) are complex and template-driven. The ISB EA Option 2 GitOps
pattern (develop→direct dev commit, main→prod PR) is non-obvious. The image
tagging strategy, yq GitOps update, Trivy scanning, and placeholder substitution
all needed to be documented in one place.

#### `local-dev.agent.md`
The podman-compose setup, EF Core migration commands, `appsettings.Development.json.example`
pattern, socket vs TCP auth differences for macOS MariaDB, and common local dev
failures were all spread across READMEs with no single reference.

#### `spec-kitty.agent.md`
CODING_STANDARDS §11 covers three pages of spec-kitty workflow. Only HNW had a
spec-kitty agent, and it was project-specific. The template needed a generic version
with the full WP YAML frontmatter, `spec.md` required sections, init commands,
validate-tasks, and the Linux EF Core LINQ gotcha (applicable to any project).

#### `ef-core.agent.md`
The Pomelo/MariaDB connection pattern, `db.Database.Migrate()` on startup (vs the
dangerous `EnsureCreated()`), primary constructor pattern, migration naming conventions,
and the Linux `ReadOnlySpan<string>.Contains()` overload bug were all scattered
across project docs and discovered operationally. Centralised here as a reference.

#### `bc-gov-devops.agent.md`
Emerald-specific platform facts (AVI InfraSettings, dataclass-low having no VIP,
five-step Artifactory project setup, two-policy-per-flow NetworkPolicy requirement)
were discovered through failures and needed to be persisted permanently.

---

## Inheritance Model

```
rl-project-template/.github/agents/
├── session-workflow.agent.md      ← universal (every project)
├── github-workflow.agent.md       ← universal (every project)
├── diagram-generation.agent.md    ← universal (every project)
├── ci-cd-pipeline.agent.md        ← projects using the template CI/CD workflows
├── local-dev.agent.md             ← .NET + React/Vite projects with MariaDB
├── spec-kitty.agent.md            ← all projects using spec-first development
├── ef-core.agent.md               ← .NET projects using EF Core + Pomelo/MariaDB
└── bc-gov-devops.agent.md         ← BC Gov projects on Emerald OpenShift

<project>/.github/agents/
├── (inherited from template — copy relevant files at project init)
├── bc-gov-standards.agent.md      ← project-specific DataClass, design tokens, namespaces
├── network-policy.agent.md        ← project-specific NetworkPolicy templates
├── openshift-health.agent.md      ← project-specific health endpoints + oc commands
└── spec-kitty.agent.md            ← override with project-specific spec status table
```

Generic agents in this template provide the foundation. Projects add specialised
agents for their specific namespace, tech stack, and feature set.

---

## Self-Learning Pattern

Every agent has a `*_KNOWLEDGE` section at the bottom for appending new discoveries.
When a new Emerald quirk, CLI pattern, or workflow improvement is found operationally,
it is appended there with a date and source. This turns live incident resolution into
permanent knowledge. Format:

```
- YYYY-MM-DD: [source] <finding>
```

---

## Adding a New Agent

1. Create `<skill-name>.agent.md` in `.github/agents/`
2. Use the structure:
   - Header comment block (file, author, AI, date, purpose)
   - `## Identity` — who the agent is and what it does
   - Scope sections with templates, rules, commands
   - `## *_KNOWLEDGE — Self-Learning` section at the bottom
3. Register it in the table above
4. For project-specific agents, note in the project's `copilot-instructions.md`
   which agents are available

---

## Related Files

| File | Purpose |
|------|---------|
| `.github/copilot-instructions.md` | Standing AI instructions (read every session) |
| `AI/nextSteps.md` | MASTER TODO and session history |
| `AI/WORKLOG.md` | Detailed session logs |
| `CODING_STANDARDS.md` | Full coding conventions |
