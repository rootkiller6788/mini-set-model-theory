#!/bin/bash
# Clean MiniSetCore build artifacts
set -euo pipefail
echo "Cleaning MiniSetCore..."
cd "$(dirname "$0")/.."
lake clean
echo "MiniSetCore clean complete."
