#!/bin/bash
# Script to replicate GitHub Actions CI locally using Docker
# This mimics the exact steps from .github/workflows/ci.yml

set -e

echo "========================================"
echo "Replicating GitHub Actions CI locally"
echo "========================================"

# Step 1: Install dependencies
echo ""
echo ">>> Step 1: Installing dependencies..."
flutter pub get

# Step 2: Run analyzer
echo ""
echo ">>> Step 2: Running analyzer..."
flutter analyze --no-fatal-infos

# Step 3: Run tests
echo ""
echo ">>> Step 3: Running tests..."
flutter test

# Step 4: Build web
echo ""
echo ">>> Step 4: Building web..."
flutter build web --release --base-href "/fashion_flow/"

echo ""
echo "========================================"
echo "All CI steps completed successfully!"
echo "========================================"
