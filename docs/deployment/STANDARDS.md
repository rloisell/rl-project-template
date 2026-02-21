# Deployment Standards — BC Gov Emerald OpenShift

**Author**: Ryan Loiselle — Developer / Architect  
**AI tool**: GitHub Copilot — AI pair programmer / code generation  
**Established**: February 2026 (DSC-modernization project)

This document is the deployment companion to [CODING_STANDARDS.md](../../CODING_STANDARDS.md).
It captures the standards (Section 9 of CODING_STANDARDS.md) in a focused form, and provides
checklists and reference links for setting up a new project on the BC Gov Private Cloud PaaS.

For the full technical specification, see **Section 9** of [CODING_STANDARDS.md](../../CODING_STANDARDS.md).

---

## Quick Reference

### Emerald Tier Facts

| Item | Value |
|---|---|
| Cluster console URL | `console.apps.emerald.devops.gov.bc.ca` |
| Route URL pattern | `<app>-<license>-<env>.apps.emerald.devops.gov.bc.ca` |
| Image registry | `artifacts.developer.gov.bc.ca` (Artifactory) |
| Max data sensitivity | Protected C — storage and/or processing |
| Internet egress | Proxy only — Docker Hub / GHCR not reachable at runtime |
| Cluster API access | SPANBC-internal only — **no push-based deployment from GitHub Actions** |
| Deployment mechanism | ArgoCD (pull model / GitOps) — mandatory on Emerald |

### Project Namespace Pattern

```
<license>-tools    ← build pipelines, image tools
<license>-dev      ← development
<license>-test     ← test / QA
<license>-prod     ← production
```

---

## New Project Setup Checklist

### Step 1 — Platform Provisioning (human steps)

- [ ] Register in [Platform Product Registry](https://digital.gov.bc.ca/technology/cloud/private/products-tools/registry/) → receive license plate
- [ ] Request Artifactory project + Docker repository
- [ ] Create Artifactory service account; store credentials as GitHub Secrets:
  - `ARTIFACTORY_USERNAME`
  - `ARTIFACTORY_PASSWORD`
- [ ] Onboard to Vault; provision paths: `secret/<license>/<env>/<secret-name>`
- [ ] Enable ArgoCD for the project
- [ ] Add team members to OpenShift namespaces (edit/admin roles)
- [ ] Confirm `DataClass` label value with Information Security

### Step 2 — App Repo (this repo)

- [ ] Update `containerization/Containerfile.api` — replace `<PROJECT_NAME>` placeholders
- [ ] Update `containerization/Containerfile.frontend` — replace `<PROJECT_NAME>` placeholders
- [ ] Implement runtime config for the frontend (see Section 9.5 of CODING_STANDARDS.md)
- [ ] Verify `GET /health` and `GET /health/ready` endpoints exist and return 200
- [ ] Update `.github/workflows/build-and-push.yml` — replace `<LICENSE>` and `<APP_NAME>` placeholders
- [ ] Remove hard-coded `localhost` references from `appsettings.json` (move to env vars)

### Step 3 — GitOps Repo

- [ ] Copy `gitops/` skeleton from this template into a new, independent repository
- [ ] Name the new repo `<app-name>-gitops` (e.g., `dsc-gitops`)
- [ ] Replace all `<APP_NAME>` and `<LICENSE>` placeholders throughout
- [ ] Populate `deploy/dev_values.yaml`, `deploy/test_values.yaml`, `deploy/prod_values.yaml`
- [ ] Grant ArgoCD SSH deploy key read access to the GitOps repo
- [ ] Apply ArgoCD Application CRDs: `kubectl apply -f applications/argocd/`

### Step 4 — First Deployment Verification

- [ ] Build and push images manually (or trigger the workflow)
- [ ] Update `dev_values.yaml` with the Artifactory image tag
- [ ] Commit to GitOps repo; verify ArgoCD syncs
- [ ] Check pod startup in `<license>-dev` namespace
- [ ] Hit the route URL and verify frontend loads
- [ ] Verify API health endpoint responds

---

## What Goes Where

| Artifact | Repo | Path |
|---|---|---|
| `Containerfile.api` | App repo | `containerization/Containerfile.api` |
| `Containerfile.frontend` | App repo | `containerization/Containerfile.frontend` |
| `nginx.conf` | App repo | `containerization/nginx.conf` |
| `podman-compose.yml` | App repo | `containerization/podman-compose.yml` |
| Build + push workflow | App repo | `.github/workflows/build-and-push.yml` |
| Helm chart | GitOps repo | `charts/<app>/` |
| Per-env values | GitOps repo | `deploy/*.yaml` |
| ArgoCD CRDs | GitOps repo | `applications/argocd/*.yaml` |
| Helm lint CI | GitOps repo | `.github/workflows/ci.yml` |

---

## Reference Links

| Resource | URL |
|---|---|
| BC Gov Private Cloud Technical Docs | https://developer.gov.bc.ca/docs/default/component/platform-developer-docs |
| Hosting Tiers Table (Emerald) | https://developer.gov.bc.ca/docs/default/component/platform-developer-docs/docs/platform-architecture-reference/hosting-tiers-table/ |
| CI/CD Pipeline Templates | https://developer.gov.bc.ca/docs/default/component/platform-developer-docs/docs/automation-and-resiliency/cicd-pipeline-templates-for-private-cloud-teams/ |
| ArgoCD Usage | https://developer.gov.bc.ca/docs/default/component/platform-developer-docs/docs/automation-and-resiliency/argo-cd-usage/ |
| Platform Product Registry | https://digital.gov.bc.ca/technology/cloud/private/products-tools/registry/ |
| Artifactory Setup | https://developer.gov.bc.ca/docs/default/component/platform-developer-docs/docs/build-deploy-and-maintain-apps/setup-artifactory-service-account/ |
| Vault Getting Started | https://developer.gov.bc.ca/docs/default/component/platform-developer-docs/docs/secrets-management/vault-getting-started-guide/ |
| Provision New OpenShift Project | https://developer.gov.bc.ca/docs/default/component/platform-developer-docs/docs/openshift-projects-and-access/provision-new-openshift-project/ |
| OpenShift Network Policies | https://developer.gov.bc.ca/docs/default/component/platform-developer-docs/docs/platform-architecture-reference/openshift-network-policies/ |
| Security Pipeline Templates | https://github.com/bcgov/security-pipeline-templates |
| Reference App Repo | https://github.com/bcgov-c/jag-network-tools |
| Reference GitOps Repo | https://github.com/bcgov-c/tenant-gitops-be808f |
