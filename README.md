# rl-project-template

A personal GitHub template repository containing coding standards, AI collaboration guardrails,
and project scaffolding that reflect the conventions established across Ryan Loiselle's development
projects. Fork or clone this repo as the starting point for any new project.

---

## What's in this template

| File / Directory | Purpose |
|---|---|
| `.github/copilot-instructions.md` | **Automatically read by GitHub Copilot** in any repo that contains it. Defines coding style, comment conventions, and AI behaviour guardrails without any manual setup. |
| `CODING_STANDARDS.md` | Human-readable reference document covering all the same rules in full detail. Share this with collaborators or paste into any AI tool as a system prompt. |
| `docs/local-development/README.md` | Skeleton template for documenting local environment setup — ports, services, credentials, known issues. |
| `docs/development-history.md` | Skeleton for recording session-by-session development notes (keeps the root README clean). |

---

## How to use this template

### Option A — GitHub "Use this template" button (recommended)

1. Go to `https://github.com/rloisell/rl-project-template`
2. Click **"Use this template"** → **"Create a new repository"**
3. Give the new repo a name and click **Create**
4. Clone your new repo and start building

> GitHub marks this repo as a template — forking is **not** required and is not recommended
> (forks stay linked to the parent; template repos create independent copies).

### Option B — Clone and re-init locally

```bash
git clone https://github.com/rloisell/rl-project-template.git my-new-project
cd my-new-project
rm -rf .git
git init
git add .
git commit -m "chore: initialise from rl-project-template"
# then push to your new remote
```

---

## What to do after creating a new repo from this template

1. **Update `README.md`** — replace this file with a product-focused description of your new project.
2. **Keep `.github/copilot-instructions.md` as-is** — it applies immediately; customise as needed.
3. **Fill in `docs/local-development/README.md`** — add your actual ports, services, and setup steps.
4. **Rename `docs/development-history.md`** — start adding session notes as you build.
5. **Review `CODING_STANDARDS.md`** — adjust any project-specific technology choices at the top.

---

## Where the standards came from

These conventions were established and refined during the development of the
[DSC-modernization](https://github.com/rloisell/DSC-modernization) project — a .NET 10 / React
modernization of a legacy Java time-tracking system. That project used GitHub Copilot extensively
as an AI pair programmer and the standards here reflect what worked well in practice:

- Consistent file header format (author, AI attribution, date)
- ALL-CAPS section labels in code bodies
- Single-line per-method purpose comments
- End-of-class / end-of-block markers
- Clean root README (product description) with session notes kept in `docs/`
- Diagram-first documentation using Draw.io and PlantUML

---

## Keeping the template up to date

When you refine a convention on a project, bring it back here:

```bash
cd /Users/rloisell/Documents/developer/rl-project-template
# edit CODING_STANDARDS.md and/or .github/copilot-instructions.md
git add -A && git commit -m "chore: update standards from <project-name>"
git push
```

Future projects created from the template will pick up the updated standards automatically.
