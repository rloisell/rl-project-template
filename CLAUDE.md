# CLAUDE.md — rl-project-template

This file provides project-level instructions for Claude Code.
Base instructions (shared personas, skills, subagents) are in `.github/agents/CLAUDE.md`
via the rl-agents-n-skills plugin.

## Project purpose

`rl-project-template` is the **scaffold template** for new BC Gov .NET/React/OpenShift
projects owned by Ryan Loiselle. It contains:
- GitHub Actions CI/CD workflows (`.github/workflows/`)
- Helm chart templates (`gitops/charts/`)
- ArgoCD application definitions (`gitops/applications/`)
- Containerfile standards (`containerization/`)
- Coding standards (`CODING_STANDARDS.md`)
- Deployment documentation (`docs/deployment/`)

## This is a template repo — no application code here

When asked to implement features or business logic, redirect: those changes belong
in a project that has been scaffolded FROM this template, not here.

Changes to this repo should be:
- Improvements to the template scaffolding
- Updates to shared standards documents
- CI/CD workflow improvements
- Helm chart template updates
- Agent/skill updates (done via the rl-agents-n-skills submodule)

## Submodule: rl-agents-n-skills

Agents and skills live at `.github/agents/` which is a git submodule pointing to
`https://github.com/rloisell/rl-agents-n-skills`.

To update:
```bash
cd .github/agents && git pull origin main && cd ../..
git add .github/agents
git commit -m "chore: update rl-agents-n-skills submodule"
```

Do NOT edit files inside `.github/agents/` directly — make changes in the
`rl-agents-n-skills` repo instead.
