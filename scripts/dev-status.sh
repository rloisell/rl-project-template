#!/usr/bin/env bash
# scripts/dev-status.sh
# Ryan Loiselle — Developer / Architect
# GitHub Copilot — AI pair programmer / code generation
# <Month Year>
#
# Delegates to ~/dev-tools/dev-ctl (consolidated multi-project dev manager).
exec "$HOME/dev-tools/dev-ctl" status
