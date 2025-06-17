#!/bin/bash

# Double-click this file to reload the app in simulator

cd "$(dirname "$0")"

echo "🔄 Reloading Datacap Token Demo..."
echo ""

# Quick build and install
cd DatacapMobileTokenDemo

# Get booted device
DEVICE=$(xcrun simctl list devices | grep Booted | head -1 | grep -oE '[0-9A-F-]{36}' || echo "")

if [ -z "$DEVICE" ]; then
    echo "❌ No simulator running. Starting iPhone 16 Pro..."
    open -a Simulator
    sleep 3
    xcrun simctl boot "iPhone 16 Pro"
    DEVICE=$(xcrun simctl list devices | grep Booted | head -1 | grep -oE '[0-9A-F-]{36}')
fi

echo "📱 Building for device: $DEVICE"

# Build
xcodebuild -project DatacapMobileTokenDemo.xcodeproj \
    -scheme DatacapMobileTokenDemo \
    -destination "id=$DEVICE" \
    -configuration Debug \
    -derivedDataPath ../build \
    build \
    CODE_SIGN_ALLOWED=NO

# Find and install
APP=$(find ../build -name "*.app" -type d | head -1)
xcrun simctl uninstall booted com.datacapsystems.DatacapMobileTokenDemo 2>/dev/null || true
xcrun simctl install booted "$APP"
xcrun simctl launch booted com.datacapsystems.DatacapMobileTokenDemo

# Activate simulator
osascript -e 'tell application "Simulator" to activate'

echo ""
echo "✅ App reloaded!"
echo ""
echo "Press any key to close..."
read -n 1