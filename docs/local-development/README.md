# Local Development Setup

> **Template** — replace this content with your project-specific setup instructions.

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
| API | `http://localhost:5005` | `cd src/<Project>.Api && dotnet run` |
| Frontend | `http://localhost:5173` | `cd src/<Project>.WebClient && npm run dev` |
| MariaDB | `3306` | system service or Docker |

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
