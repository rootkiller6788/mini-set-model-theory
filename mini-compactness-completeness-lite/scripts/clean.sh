#!/usr/bin/env bash
set -euo pipefail

echo "Cleaning mini-compactness-completeness-lite..."

cd "$(dirname "$0")/.."

lake clean

echo "Clean complete."
