# Local Development Setup

> **Template** — replace this content with your project-specific setup instructions.

---

## dev-ctl — Consolidated Dev Manager

All projects on this machine are managed by `~/dev-tools/dev-ctl`.
Each project contributes a `.dev-env` file; `dev-ctl` auto-discovers it.

```bash
dev-ctl start  <project-id>   # start this project's services
dev-ctl stop   <project-id>   # stop non-shared services
dev-ctl status                # health table — all projects
dev-ctl install-monitor       # cron every 5 min + macOS alerts
```

**To scaffold this project:**
1. Copy `scripts/dev-env.template` to `.dev-env` in the project root
2. Fill in `DEV_PROJECT_ID`, ports, paths, and launch profile name
3. Run `dev-ctl status` — the project appears immediately

See `rl-agents-n-skills/local-dev/SKILL.md` for the full reference.

---

## Prerequisites

| Tool | Version | Notes |
|------|---------|-------|
| .NET SDK | 10.x | `dotnet --version` to verify |
| Node.js | 20.x LTS | `node --version` |
| MariaDB | 10.11+ | or Docker equivalent |
| draw.io | Desktop app | for diagram editing |
| PlantUML | 1.2026.x | `brew install plantuml` |

---

## Services & Ports

| Service | Port | Start Command |
|---------|------|---------------|
| API | `http://localhost:5005` | `dev-ctl start <project-id>` or `cd src/<Project>.Api && dotnet run` |
| Frontend | `http://localhost:5173` | `dev-ctl start <project-id>` or `cd src/<Project>.WebClient && npm run dev` |
| MariaDB | `3306` | shared — `dev-ctl` starts it once for all projects |

---

## Database Setup

```bash
# Apply EF Core migrations
dotnet ef database update --project src/<Project>.Api

# Seed test data (after API is running)
curl -X POST http://localhost:5005/api/admin/seed/test-data \
  -H "X-Admin-Token: local-admin-token"
```

---

## Environment Configuration

Copy the example settings and fill in your local values:

```bash
cp src/<Project>.Api/appsettings.Development.json.example \
   src/<Project>.Api/appsettings.Development.json
```

Key values to set:
- `ConnectionStrings:DefaultConnection` — MariaDB connection string
- `Admin:Token` — local admin token (any string for dev)

---

## Running Tests

```bash
dotnet test tests/<Project>.Tests/<Project>.Tests.csproj
```

---

## Persistent Services (macOS LaunchAgents)

Document any LaunchAgent plist files used to auto-start the API or database here.

Example plist location: `~/Library/LaunchAgents/com.<project>.api.plist`

---

## Known Issues

| Issue | Workaround |
|-------|-----------|
| — | — |
