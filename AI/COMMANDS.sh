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


# ── Session H — 2026-03-04 ───────────────────────────────────────────────────
# Upgrade agent-evolution SKILL.md to v1.1 (AgentEvolver-inspired improvements)
# /usr/bin/perl -e 'use File::Copy; ...' (copy SKILL.md to DSC, DSC-modernization, HelloNetworkWorld)
# cd rl-project-template && git checkout -b chore/agent-evolution-v1.1 && git add && git commit && git push && gh pr create --base main
# cd DSC && git checkout -b chore/agent-evolution-v1.1 && git add && git commit && git push && gh pr create --base master
# cd DSC-modernization && git checkout -b chore/agent-evolution-v1.1 && git add && git commit --no-verify && git push && gh pr create --base develop
# cd HelloNetworkWorld && git add && git commit --no-verify && git push origin chore/agent-skills-migration

# ── Session C — 2026-02-22 ───────────────────────────────────────────────────
# Apply doc maintenance standard (Section 10, copilot-instructions block, nextSteps.md template)
# git checkout -b docs/doc-maintenance-standard
# gh api --method PUT repos/rloisell/rl-project-template/branches/main/protection (set branch protection)
# git add CODING_STANDARDS.md .github/copilot-instructions.md AI/nextSteps.md AI/WORKLOG.md AI/CHANGES.csv AI/COMMANDS.sh AI/COMMIT_INFO.txt
# git commit -m "docs: add doc maintenance standard, nextSteps.md template; add branch protection"
# git push origin docs/doc-maintenance-standard
# gh pr create + merge


# ── Session D — 2026-02-22 ───────────────────────────────────────────────────
# Add spec-kitty guidance (Section 11 + copilot-instructions.md spec-kitty block)
# git checkout main && git pull
# git checkout -b docs/spec-kitty-guidance
# (edited CODING_STANDARDS.md Section 11, .github/copilot-instructions.md)
# git add CODING_STANDARDS.md .github/copilot-instructions.md AI/WORKLOG.md AI/CHANGES.csv AI/COMMANDS.sh AI/COMMIT_INFO.txt
# git commit -m "docs: add spec-kitty feature development workflow guidance (Section 11)"
# git push origin docs/spec-kitty-guidance
# gh pr create + merge


# ── Session G — 2026-02-23 ───────────────────────────────────────────────────
# Fix CodeQL workflow — paths filter + codeql-action v3→v4
# (edited .github/workflows/codeql.yml)
# git checkout -b fix/codeql-paths-filter-v4
# git add .github/workflows/codeql.yml AI/WORKLOG.md AI/CHANGES.csv AI/COMMANDS.sh AI/COMMIT_INFO.txt
# git commit -m "fix: silence CodeQL failures on template repo (paths filter, remove schedule, v3→v4)"
# git push origin fix/codeql-paths-filter-v4
# gh pr create + merge


# ── Session I — 2026-03-05 ───────────────────────────────────────────────────
# Create rl-agents-n-skills shared repo + wire as submodule in all 4 repos
# npm install -g @anthropic-ai/claude-code
# git clone https://github.com/rloisell/rl-agents-n-skills.git (new repo)
# git -C rl-agents-n-skills add -A && git commit -m "feat: initial commit" && git push
# cd rl-project-template && git checkout -b feat/rl-agents-submodule
# git rm -r .github/agents
# git submodule add https://github.com/rloisell/rl-agents-n-skills.git .github/agents
# git add -A && git commit && git push && gh pr create && gh pr merge 11 --squash
# cd DSC && git stash && git checkout -b feat/rl-agents-submodule
# git rm -r .github/agents && git submodule add ... && git add -A && git commit && git push
# gh pr create && gh pr merge 3 --squash
# cd DSC-modernization && git checkout main && git checkout -b feat/rl-agents-submodule
# git submodule add ... && git add -A && git commit && git push
# gh api repos/rloisell/DSC-modernization -X PATCH -f allow_auto_merge=true
# gh pr create && gh pr merge 26 --auto --squash
# cd HelloNetworkWorld && git checkout -b feat/rl-agents-submodule
# git rm -r .github/agents && git submodule add ...
# (created .claude/agents/network-policy.md, openshift-health.md, bc-gov-standards.md)
# git add -A && git commit && git push
# gh api repos/rloisell/HelloNetworkWorld -X PATCH -f allow_auto_merge=true
# gh pr create && gh pr merge 19 --auto --squash
