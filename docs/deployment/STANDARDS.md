# Deployment Standards -- BC Gov Emerald OpenShift

**Author**: Ryan Loisell -- Developer / Architect  
**AI tool**: GitHub Copilot -- AI pair programmer / code generation  
**Established**: February 2026 (DSC-modernization project)  
**EA reference**: ISB *OPTION 2 -- Using GitHub Actions + GitOps in Emerald (preferred)*

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
| Max data sensitivity | Protected C -- storage and/or processing |
| Internet egress | Proxy only -- Docker Hub / GHCR not reachable at runtime |
| Cluster API access | SPANBC-internal only -- **no push-based deployment from GitHub Actions** |
| Deployment mechanism | ArgoCD (pull model / GitOps) -- mandatory on Emerald |

### Project Namespace Pattern

```
<license>-tools    <- build pipelines, image tools
<license>-dev      <- development
<license>-test     <- test / QA
<license>-prod     <- production
```

### Branch -> Environment -> Deployment Method

| Source Branch / Tag | GitOps File | Target Namespace | Deployment Method |
|---|---|---|---|
| `develop` | `deploy/dev_values.yaml` | `<license>-dev` | Direct commit (ArgoCD auto-sync) |
| `test` | `deploy/test_values.yaml` | `<license>-test` | Direct commit (ArgoCD auto-sync) |
| `main` or `v*` tag | `deploy/prod_values.yaml` | `<license>-prod` | **PR required** -- reviewer approval + merge |

---

## ISB EA Option 2 -- Three Mandatory Requirements

The following three requirements come from the ISB *OPTION 2* EA guidance and are
**mandatory** for all applications deploying to Emerald.

### 1. Datree Security Policy Enforcer (CI)

Every GitOps repo must run Datree in CI against Helm-rendered manifests before
code can merge to `main`. This validates that all workloads carry the correct ISB
labels (DataClass, environment, owner) and meet security baseline requirements.

**Correct implementation (Helm plugin, offline mode — no token required):**
- Create `.github/workflows/policy-enforcement.yaml` as a **standalone workflow file**
  (not a step inside `ci.yml`)
- Install the Datree Helm plugin and set offline mode: `helm datree config set offline local`
- Use `.github/policies.yaml` for policy identifiers (copy from another `tenant-gitops-*` repo)
- **No `DATREE_TOKEN` is required** — offline mode does not authenticate to the Datree cloud
- See `EmeraldDeploymentAnalysis.md` §7.2 for the complete `policy-enforcement.yaml` template

> **Incorrect pattern to avoid:** Using `datreeio/action-datree@main` as a step inside
> `ci.yml` with a `DATREE_TOKEN` secret does not match any active ISB tenant-gitops repo and
> should not be used.

### 2. Production Deployment via PR (Not Direct Commit)

Production changes must enter the gitops `main` branch through a reviewed and
approved PR -- never via a direct commit or automated push.

**Implementation:**
- `update-gitops` GitHub Actions job: runs for `develop` and `test` branches only
- `create-prod-pr` GitHub Actions job: triggers on `main` push or `v*` semver tag;
  creates a branch, commits the updated `prod_values.yaml`, opens a PR via `gh pr create`
- A team member reviews and merges the PR; ArgoCD syncs automatically on merge
- Enable branch protection on `main` in the GitOps repo (require PR review)

### 3. Semver Tags for Production Image Tags

Production image tags must use a semver version string (e.g., `v1.0.1`) -- not a
git SHA. Git SHAs are acceptable for dev/test environments.

**Implementation:**
- In the `build` job of `build-and-push.yml`, check `github.ref_type`:
  - `tag` -> image tag = `github.ref_name` (e.g., `v1.0.1`)
  - `branch` -> image tag = `git rev-parse --short HEAD`
- Tag releases using `git tag v1.0.1 && git push --tags` to trigger a clean prod PR

---

## New Project Setup Checklist

### Step 1 -- Platform Provisioning (human steps)

- [ ] Register in [Platform Product Registry](https://digital.gov.bc.ca/technology/cloud/private/products-tools/registry/) -- receive license plate
- [ ] Request Artifactory project + Docker repository (`<license>-docker-local`)
- [ ] Create Artifactory service account; store credentials as GitHub Secrets in the **app repo**:
  - `ARTIFACTORY_USERNAME`
  - `ARTIFACTORY_PASSWORD`
- [ ] Create `GITOPS_TOKEN` (GitHub PAT with `repo` write scope on the GitOps repo); store as GitHub Secret in the **app repo**
- [ ] Onboard to Vault; provision paths: `secret/<license>/<env>/<secret-name>`
- [ ] Enable ArgoCD for the project
- [ ] Add team members to OpenShift namespaces (edit/admin roles)
- [ ] Confirm `DataClass` label value with Information Security
- [ ] Enable branch protection on `main` in the GitOps repo (require PR review)

### Step 2 -- App Repo (this repo)

- [ ] Update `containerization/Containerfile.api` -- replace `<PROJECT_NAME>` placeholders
- [ ] Update `containerization/Containerfile.frontend` -- replace `<PROJECT_NAME>` placeholders
- [ ] Implement runtime config for the frontend (see Section 9.5 of CODING_STANDARDS.md)
- [ ] Verify `GET /health` and `GET /health/ready` endpoints exist and return 200
- [ ] Update `.github/workflows/build-and-push.yml` -- replace `<LICENSE>`, `<APP_NAME>`, `<GITOPS_REPO>` placeholders
- [ ] Remove hard-coded `localhost` references from `appsettings.json` (move to env vars)
- [ ] Add `.github/workflows/copilot-review.yml` to auto-request GitHub Copilot Code Review on every non-draft PR (see `EmeraldDeploymentAnalysis.md` §8.3)

### Step 3 -- GitOps Repo

- [ ] Copy `gitops/` skeleton from this template into a new, independent repository
- [ ] Name the new repo `<app-name>-gitops` (e.g., `dsc-gitops`)
- [ ] Replace all `<APP_NAME>` and `<LICENSE>` placeholders throughout
- [ ] Populate `deploy/dev_values.yaml`, `deploy/test_values.yaml`, `deploy/prod_values.yaml`
- [ ] Copy `.github/policies.yaml` from ISB or another `tenant-gitops-*` repo
- [ ] Create `.github/workflows/policy-enforcement.yaml` (Datree Helm plugin offline — see `EmeraldDeploymentAnalysis.md` §7.2)
- [ ] Grant ArgoCD SSH deploy key read access to the GitOps repo
- [ ] Apply ArgoCD Application CRDs: `kubectl apply -f applications/argocd/`

### Step 4 -- First Deployment Verification

- [ ] Build and push images: push the `develop` branch to trigger `build-and-push.yml`
- [ ] Confirm images appear in Artifactory with a real tag (not placeholder)
- [ ] Confirm `dev_values.yaml` in the GitOps repo has been updated by the workflow
- [ ] Create required Kubernetes Secrets in `<license>-dev` (DB credentials, pull secret, etc.)
- [ ] Verify ArgoCD syncs and all pods go green
- [ ] Hit the route URL and verify frontend loads
- [ ] Verify API health endpoint responds: `GET /health/ready` -> 200

### Step 5 -- Production Readiness

- [ ] Run `git tag v1.0.0 && git push --tags` on the app repo to trigger the prod PR flow
- [ ] Review and merge the auto-generated PR in the GitOps repo
- [ ] Confirm ArgoCD syncs to `<license>-prod`
- [ ] Confirm Datree CI step is passing in the GitOps repo
- [ ] Confirm GitHub Copilot Code Review is enabled on the org and auto-requested on PRs

---

## What Goes Where

| Artifact | Repo | Path |
|---|---|---|
| `Containerfile.api` | App repo | `containerization/Containerfile.api` |
| `Containerfile.frontend` | App repo | `containerization/Containerfile.frontend` |
| `nginx.conf` | App repo | `containerization/nginx.conf` |
| `podman-compose.yml` | App repo | `containerization/podman-compose.yml` |
| Build + push workflow | App repo | `.github/workflows/build-and-push.yml` |
| Secrets: `ARTIFACTORY_*`, `GITOPS_TOKEN` | App repo (GitHub Secrets) | Settings -> Secrets -> Actions |
| Helm chart | GitOps repo | `charts/<app>/` |
| Per-env values | GitOps repo | `deploy/*.yaml` |
| ArgoCD CRDs | GitOps repo | `applications/argocd/*.yaml` |
| Helm lint + Datree CI | GitOps repo | `.github/workflows/ci.yml` |
| Datree policy enforcement | GitOps repo | `.github/workflows/policy-enforcement.yaml` |
| Datree policy config | GitOps repo | `.github/policies.yaml` |
| Copilot code review workflow | App repo | `.github/workflows/copilot-review.yml` |

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
| Peer CI/CD Pattern (CORNET) | https://github.com/bcgov-c/JAG-JAM-CORNET |
| Peer CI/CD Pattern (LEA) | https://github.com/bcgov-c/JAG-LEA |
| Datree Helm action | https://github.com/datreeio/helm-datree |
