#!/usr/bin/env bash
# Smoke check script for mini-order-equivalence
echo "mini-order-equivalence check..."
lake build 2>&1
if [ $? -eq 0 ]; then echo "BUILD OK"; else echo "BUILD FAILED"; fi
