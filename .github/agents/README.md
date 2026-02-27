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
| `session-workflow.agent.md` | Session Workflow Advisor | Session startup/shutdown discipline, AI file maintenance |
| `github-workflow.agent.md` | GitHub Workflow Advisor | Branch naming, PR lifecycle, CI diagnosis, gh CLI, rulesets |
| `diagram-generation.agent.md` | Diagram Generation Advisor | draw.io + PlantUML creation, folder structure, export commands |
| `bc-gov-devops.agent.md` | BC Gov DevOps Advisor | OpenShift Emerald, Artifactory, Helm, NetworkPolicy, ArgoCD |

Project-specific agents (e.g. `network-policy.agent.md`, `openshift-health.agent.md`)
live in the project's own `.github/agents/` folder and extend these generic ones.

---

## Gap Analysis — Why These Agents Exist

### Problem
After several development sessions across HelloNetworkWorld and DSC-modernization,
two patterns emerged:

1. **Re-discovery cost** — The same Emerald-specific facts (AVI InfraSettings,
   dataclass-low having no VIP, Artifactory approval steps, two-way NetworkPolicy
   rules) were being re-explained or re-discovered every other session. Each
   re-discovery consumes context, time, and risks introducing regressions.

2. **Session state loss** — AI has no memory between sessions. Without a structured
   startup protocol, sessions often began with outdated context or missed in-progress
   work recorded in `AI/nextSteps.md`.

### Resolution

Each agent was created to permanently encode a specific domain of knowledge so
it never has to be re-explained:

#### `session-workflow.agent.md`
**Gap addressed**: No formal protocol for session start and end.  
Sessions were inconsistently starting without reading orientation files, and ending
without committing AI session logs. The result was orphaned changes on local disk
and `AI/nextSteps.md` falling out of date.  
**Decision**: Encode the startup checklist (read nextSteps.md → git status → Dependabot
check) and shutdown protocol (WORKLOG/CHANGES/COMMANDS/COMMIT_INFO → commit → push)
as an always-available agent skill. The agent acts as a session conductor.

#### `github-workflow.agent.md`
**Gap addressed**: Branch protection rules and CI failure diagnosis required
re-learning each time.  
Two specific incidents drove this: (1) a ruleset status check name mismatch between
the workflow `name:` field and the ruleset context string caused phantom CI failures;
(2) making a repo public was required before rulesets enforced — this is non-obvious.  
**Decision**: Encode the complete PR lifecycle (branch → commit → PR → CI watch →
squash merge), the `gh` CLI patterns, and a CI failure diagnosis table so these
patterns are always available without re-research.

#### `diagram-generation.agent.md`
**Gap addressed**: No standard diagram workflow existed across projects.  
Projects had `diagrams/` folders with no structure, inconsistent use of draw.io
vs PlantUML, and no documented export commands. Diagram files were created ad-hoc
and SVG exports were often missing.  
**Decision**: Encode the standard folder structure (`drawio/svg/`, `plantuml/png/`,
`data-model/`), the 8 required diagram types, VS Code extension setup, and CLI
export commands as a permanent reference.

#### `bc-gov-devops.agent.md`
**Gap addressed**: BC Gov Emerald platform knowledge was scattered across docs
and re-discovered repeatedly.  
The AVI InfraSettings `dataclass-low` finding (no VIP on Emerald), the five-step
Artifactory project setup, and the two-NetworkPolicy-per-flow requirement were all
discovered operationally and needed to be persisted.  
**Decision**: Create a single BC Gov DevOps agent that serves as the canonical
Emerald platform reference — Containerfile patterns, Helm requirements, NetworkPolicy
templates, Artifactory steps, ArgoCD config, and health check patterns — all in
one place.

---

## Inheritance Model

```
rl-project-template/.github/agents/
├── session-workflow.agent.md    ← universal (every project)
├── github-workflow.agent.md     ← universal (every project)
├── diagram-generation.agent.md  ← universal (every project)
└── bc-gov-devops.agent.md       ← BC Gov projects on Emerald

<project>/.github/agents/
├── (inherited from template)
├── bc-gov-standards.agent.md    ← project-specific DataClass, design tokens
├── network-policy.agent.md      ← project-specific NetworkPolicy templates
├── openshift-health.agent.md    ← project-specific health endpoints + oc commands
└── spec-kitty.agent.md          ← project-specific spec status table
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
