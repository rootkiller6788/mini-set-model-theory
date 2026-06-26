#!/usr/bin/env bash
# Build script for mini-language-structure
set -e

echo "Building mini-language-structure..."
lake build

echo "Running smoke tests..."
lake env lean --run Test/Smoke.lean

echo "Running regression tests..."
lake env lean --run Test/Regression.lean

echo "Build complete."
