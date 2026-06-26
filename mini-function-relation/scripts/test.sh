#!/usr/bin/env bash
set -euo pipefail

# Run tests for the mini-function-relation package
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJ_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJ_DIR"

if command -v lake &> /dev/null; then
    lake exe test 2>/dev/null || echo "No test executable configured."
    echo "Run individual test files via: lake env lean Test/Smoke.lean"
else
    echo "Error: lake not found. Is Lean 4 installed?"
    exit 1
fi
