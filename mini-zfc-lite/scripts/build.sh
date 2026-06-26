#!/bin/bash
# Build script for mini-zfc-lite
set -e

echo "Building mini-zfc-lite..."
lake build

echo "Running smoke tests..."
lake env lean --run Test/Smoke.lean

echo "Build complete."
