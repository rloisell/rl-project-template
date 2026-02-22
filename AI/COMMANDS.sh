#!/bin/bash
# AI/COMMANDS.sh
# Record of significant shell commands run by the AI in this repository.
# Append one commented block per session. Do not remove previous entries.
# Format:
#
#   # YYYY-MM-DD — <brief purpose>
#   # <command line>
#
# Destructive operations (history rewrites, drops, force-pushes) must be
# prefixed with a WARNING comment explaining the impact.


# ── Session C — 2026-02-22 ───────────────────────────────────────────────────
# Apply doc maintenance standard (Section 10, copilot-instructions block, nextSteps.md template)
# git checkout -b docs/doc-maintenance-standard
# gh api --method PUT repos/rloisell/rl-project-template/branches/main/protection (set branch protection)
# git add CODING_STANDARDS.md .github/copilot-instructions.md AI/nextSteps.md AI/WORKLOG.md AI/CHANGES.csv AI/COMMANDS.sh AI/COMMIT_INFO.txt
# git commit -m "docs: add doc maintenance standard, nextSteps.md template; add branch protection"
# git push origin docs/doc-maintenance-standard
# gh pr create + merge
