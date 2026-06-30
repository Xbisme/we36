#!/usr/bin/env bash
# Create (or switch to) the git branch for the active feature.
# Derives the branch name from .specify/feature.json's feature_directory basename
# so the branch name ALWAYS equals the spec directory name (e.g. specs/002-networking-core
# -> branch 002-networking-core). Idempotent and safe to re-run.
#
# Intended to run as a speckit `after_specify` hook (see .specify/extensions.yml),
# i.e. right after /speckit.specify writes the spec — untracked spec files follow the
# checkout onto the new branch, so the spec lands on the feature branch instead of main.

set -e

JSON_MODE=false
[ "$1" = "--json" ] && JSON_MODE=true

SCRIPT_DIR="$(CDPATH="" cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

REPO_ROOT=$(get_repo_root) || { echo "Error: not in a repo" >&2; exit 1; }
cd "$REPO_ROOT"

# Must be a git repository
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Error: not a git repository — skipping branch creation" >&2
    exit 1
fi

FEATURE_DIR=$(read_feature_json_feature_directory "$REPO_ROOT")
if [ -z "$FEATURE_DIR" ]; then
    echo "Error: no feature_directory in .specify/feature.json — run /speckit.specify first" >&2
    exit 1
fi

BRANCH_NAME=$(basename "$FEATURE_DIR")
CURRENT=$(git branch --show-current 2>/dev/null || echo "")
ACTION=""

if [ "$CURRENT" = "$BRANCH_NAME" ]; then
    ACTION="already-on-branch"
elif git show-ref --verify --quiet "refs/heads/$BRANCH_NAME"; then
    git checkout "$BRANCH_NAME" >/dev/null 2>&1
    ACTION="switched-existing"
else
    git checkout -b "$BRANCH_NAME" >/dev/null 2>&1
    ACTION="created"
fi

if $JSON_MODE; then
    printf '{"BRANCH_NAME":"%s","ACTION":"%s","FEATURE_DIR":"%s"}\n' "$BRANCH_NAME" "$ACTION" "$FEATURE_DIR"
else
    echo "BRANCH_NAME: $BRANCH_NAME"
    echo "ACTION: $ACTION"
fi
