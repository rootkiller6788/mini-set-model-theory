#!/bin/bash
# Build MiniSetCore
set -euo pipefail
echo "Building MiniSetCore..."
cd "$(dirname "$0")/.."
lake build "$@"
echo "MiniSetCore build complete."
