#!/usr/bin/env bash
set -euo pipefail

echo "Building mini-compactness-completeness-lite..."

cd "$(dirname "$0")/.."

lake build

echo "Build complete."
