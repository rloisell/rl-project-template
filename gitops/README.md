# gitops/
# Ryan Loiselle — Developer / Architect
# GitHub Copilot — AI pair programmer / code generation
# February 2026

# GitOps Repo Skeleton — BC Gov Emerald OpenShift / ArgoCD

This directory is a **skeleton for a separate GitOps repository** that should be
moved into its own independent GitHub repo (e.g., `<app-name>-gitops`) at project start.

---

## Why a separate repo?

ArgoCD watches the GitOps repo via SSH from inside the Emerald cluster. It pulls
changes and applies Helm-rendered manifests to the target namespace automatically.
Keeping it separate from the app repo:

- Gives ArgoCD a clean, minimal surface to watch
- Keeps deployment config (values, resource limits, replicas) separated from application code
- Allows CI to update only the image tag in the GitOps repo, triggering a deploy

---

## Structure

```
<app>-gitops/
├── charts/
│   └── <app>/              ← Helm chart for the whole application
│       ├── Chart.yaml
│       ├── values.yaml     ← defaults
│       └── templates/
│           ├── _helpers.tpl
│           ├── deployment.yaml
│           ├── service.yaml
│           ├── route.yaml
│           ├── configmap.yaml
│           ├── secret.yaml
│           ├── networkpolicies.yaml
│           ├── hpa.yaml
│           └── serviceaccount.yaml
├── deploy/
│   ├── dev_values.yaml
│   ├── test_values.yaml
│   └── prod_values.yaml
├── applications/
│   └── argocd/
│       ├── app-dev.yaml
│       ├── app-test.yaml
│       └── app-prod.yaml
└── .github/
    └── workflows/
        └── ci.yml          ← Helm lint all charts across all envs
```

---

## Getting started

1. Copy this `gitops/` folder contents into a new repository
2. Replace all `<APP_NAME>` and `<LICENSE>` placeholders
3. Populate `deploy/dev_values.yaml` (image registry path, route hostname, resource limits)
4. Grant ArgoCD SSH deploy key read access to the new repo
5. Apply ArgoCD Application CRDs: `kubectl apply -f applications/argocd/`

See `docs/deployment/STANDARDS.md` for the full checklist.
