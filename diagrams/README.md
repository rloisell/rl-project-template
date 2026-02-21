# diagrams/

Architecture diagrams for this project, maintained in multiple formats for broad
tool support and easy GitHub rendering.

## Format Convention

| Format | File extension | Purpose |
|--------|----------------|---------|
| Mermaid (inline Markdown) | `.md` in `docs/diagrams/` | Quick in-repo diagrams, GitHub native rendering |
| Draw.io | `.drawio` | Primary editable source — open in [draw.io](https://app.diagrams.net) or VS Code Draw.io extension |
| PlantUML | `.puml` | Text-based alternative — version-control friendly, renderable in GitHub |

## Folder Structure

```
docs/diagrams/        <- Mermaid diagrams (inline in README.md)
diagrams/
  drawio/             <- Draw.io source files
    svg/              <- Exported SVGs (committed; used in docs and GitHub rendering)
  plantuml/           <- PlantUML source files
    png/              <- Exported PNGs (committed)
  data-model/         <- ERD and schema diagrams
    erd-current.drawio
    erd-current.puml
    svg/
    png/
```

## Required Diagrams (Full UML Suite + Data Model)

Per `CODING_STANDARDS.md` §7, every project must produce the complete set below.
Diagrams marked _scales with features_ should have one instance per major use case
or lifecycle, not one globally.

| # | Diagram | UML Type | Perspective | Requirement |
|---|---------|----------|-------------|-------------|
| 1 | System architecture | Component | Structural | **Required** |
| 2 | Domain class model | Class | Structural | **Required** |
| 3 | Package / module organisation | Package | Structural | **Required** |
| 4 | Use case overview | Use Case | Behavioural | **Required** |
| 5 | Key sequence flows | Sequence | Behavioural | One per major user-facing feature |
| 6 | Key workflows | Activity | Behavioural | One per complex multi-step workflow |
| 7 | Entity lifecycle | State | Behavioural | For entities with non-trivial state transitions |
| 8 | Entity-Relationship Diagram (ERD) | ERD | Data | **Required** |
| 9 | Physical schema | Schema | Data | **Required** |
| 10 | Deployment topology | Deployment | Infrastructure | **Required** |

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
