# diagrams/

Architecture diagrams for this project, maintained in two formats for broad tool
support and easy GitHub rendering.

## Format Convention

| Format | File extension | Purpose |
|--------|----------------|---------|
| Draw.io | `.drawio` | Primary editable source — open in [draw.io](https://app.diagrams.net) or VS Code Draw.io extension |
| PlantUML | `.puml` | Text-based alternative — version-control friendly, renderable in GitHub |

## Folder Structure

```
diagrams/
  drawio/           <- Draw.io source files
    svg/            <- Exported SVGs (committed; used in docs and GitHub rendering)
  plantuml/         <- PlantUML source files
    png/            <- Exported PNGs (committed)
  data-model/       <- ERD diagrams (separate because they have distinct tooling)
    erd-current.drawio
    erd-current.puml
    svg/
    png/
```

## Required Diagrams (New Project)

Per `CODING_STANDARDS.md` §7, every new project must have:

- [ ] **Component diagram** — shows all containers/services and their relationships
- [ ] **Domain/data model** — Entity-Relationship Diagram (ERD) for the database
- [ ] **API architecture** — middleware pipeline, DI wiring, request lifecycle
- [ ] **Deployment topology** — pods, services, routes, namespaces, ArgoCD
- [ ] **Sequence flows** — one per major user-facing feature (time entry, reporting, admin CRUD, etc.)

Use-case and service-layer diagrams are optional but recommended for complex domains.

## Export Commands

```bash
# Draw.io -> SVG (requires draw.io CLI or VS Code extension export)
draw.io --export --format svg --embed-diagram --border 10 diagrams/drawio/*.drawio \
  --output diagrams/drawio/svg/

# PlantUML -> PNG
plantuml -o ../png diagrams/plantuml/*.puml
```

SVG files should use `background="#ffffff"` and `strokeWidth=2` on edges for
consistent GitHub rendering. Set these via Draw.io: Edit → XML → adjust attributes.
