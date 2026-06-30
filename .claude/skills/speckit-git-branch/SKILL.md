---
name: "speckit-git-branch"
description: "Create or switch to the git branch for the active feature (branch name = spec directory name). Runs automatically as a speckit after_specify hook, or on demand."
compatibility: "Requires spec-kit project structure with .specify/ directory and a git repository"
metadata:
  author: "we36-project"
  source: ".claude/claude-app/dev-workflow.md"
user-invocable: true
disable-model-invocation: false
---

# speckit-git-branch

Create (or switch to) the git branch for the active feature so spec work lands on a feature branch instead of the protected `main`.

This is wired as a **mandatory `after_specify` hook** in `.specify/extensions.yml`, so it runs automatically right after `/speckit.specify` writes the spec. It can also be invoked manually at any time.

## Steps

1. Run the branch script from the repo root and capture its JSON:

   ```bash
   bash .specify/scripts/bash/create-feature-branch.sh --json
   ```

   The script reads `.specify/feature.json`, derives the branch name from the `feature_directory` basename (e.g. `specs/002-networking-core` → `002-networking-core` — so the branch name **always equals the spec directory name**), and:
   - if already on that branch → no-op (`already-on-branch`);
   - if the branch exists → switches to it (`switched-existing`);
   - otherwise → creates and switches to it (`created`).

   Untracked spec files written by `/speckit.specify` follow the checkout onto the new branch, so the spec lands on the feature branch.

2. Report the `BRANCH_NAME` and `ACTION` from the JSON to the user in one short line.

3. If the script errors (not a git repo, or no `feature_directory` yet), surface the message and continue — do **not** abort the surrounding `/speckit.specify` run; just tell the user the branch must be created manually.

## Notes

- Idempotent and safe to re-run.
- Does not push or commit — branch creation only (committing/pushing is done only when the user asks).
- `main` is push-protected; this keeps every feature on its own `NNN-feature-name` branch per `.claude/claude-app/dev-workflow.md`.