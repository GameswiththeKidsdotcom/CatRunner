#!/usr/bin/env bash
# C2 — SimulatorCurrentBuild: Build, install, and launch CatRunner on booted simulator.
# Run from repo root: npm run ios:simulator (or from ios/: ./run-simulator.sh)
# Ensures the simulator runs the latest built version. Default device: iPhone 16.

set -e
cd "$(dirname "$0")"
DEVICE="${1:-iPhone 16}"
APP_PATH="build/Build/Products/Debug-iphonesimulator/CatRunner.app"
BUNDLE_ID="com.catrunner.game"

echo "Building CatRunner for iOS Simulator ($DEVICE)..."
xcodebuild -scheme CatRunner \
  -destination "platform=iOS Simulator,name=$DEVICE,OS=latest" \
  -configuration Debug \
  -derivedDataPath build \
  build

if [ ! -d "$APP_PATH" ]; then
  echo "Build failed: $APP_PATH not found." >&2
  exit 1
fi

# Ensure simulator is booted (boot is idempotent)
echo "Booting simulator $DEVICE if needed..."
xcrun simctl boot "$DEVICE" 2>/dev/null || true

echo "Installing app on booted simulator..."
xcrun simctl install booted "$APP_PATH"

echo "Launching $BUNDLE_ID..."
xcrun simctl launch booted "$BUNDLE_ID"

echo "Done. Simulator is running the latest build."
