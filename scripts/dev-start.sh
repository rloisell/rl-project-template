#!/usr/bin/env bash
# scripts/dev-start.sh
# Ryan Loiselle — Developer / Architect
# GitHub Copilot — AI pair programmer / code generation
# <Month Year>
#
# Delegates to ~/dev-tools/dev-ctl (consolidated multi-project dev manager).
# Replace <project_id> with the DEV_PROJECT_ID value from .dev-env.
exec "$HOME/dev-tools/dev-ctl" start <project_id>
