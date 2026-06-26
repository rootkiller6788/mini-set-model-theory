#!/bin/bash
# Lint script for mini-zfc-lite
set -e

echo "Linting mini-zfc-lite..."
lake build --no-build

echo "Lint complete."
