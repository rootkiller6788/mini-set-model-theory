#!/usr/bin/env bash
# MiniCardinalOrdinal — Linux/macOS build check
set -euo pipefail

echo "== MiniCardinalOrdinal Build Check =="

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_ROOT"

echo "[1/3] Checking lakefile..."
if [ -f "lakefile.lean" ]; then
    echo "  lakefile.lean found."
else
    echo "  ERROR: lakefile.lean not found!"
    exit 1
fi

echo "[2/3] Running lake build..."
lake build
echo "  Build succeeded."

echo "[3/3] Running smoke tests..."
lake env lean --run Test/Smoke.lean
echo "  Smoke tests passed."

echo "== All checks passed! =="
