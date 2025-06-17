#!/bin/bash

echo "🔄 Simple Reload - Datacap Token Demo"
echo "====================================="
echo ""

# Go to project directory
cd DatacapMobileTokenDemo

# Clean and build
echo "🧹 Cleaning..."
rm -rf ~/Library/Developer/Xcode/DerivedData/DatacapMobileTokenDemo-*

echo "🔨 Building..."
xcodebuild -project DatacapMobileTokenDemo.xcodeproj \
    -scheme DatacapMobileTokenDemo \
    -sdk iphonesimulator \
    build

# Find the app in DerivedData
echo "📱 Installing..."
APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData/DatacapMobileTokenDemo-*/Build/Products -name "DatacapMobileTokenDemo.app" | head -1)

if [ -z "$APP_PATH" ]; then
    echo "❌ Could not find app. Trying alternate location..."
    APP_PATH=$(find . -name "DatacapMobileTokenDemo.app" | head -1)
fi

if [ -n "$APP_PATH" ]; then
    echo "Found app at: $APP_PATH"
    
    # Remove old version
    xcrun simctl uninstall booted com.datacapsystems.DatacapMobileTokenDemo 2>/dev/null || echo "No previous version to remove"
    
    # Install new version
    xcrun simctl install booted "$APP_PATH" || echo "Install via booted failed, app may need manual install"
    
    # Launch
    xcrun simctl launch booted com.datacapsystems.DatacapMobileTokenDemo || echo "Launch failed - try tapping the app icon"
    
    echo ""
    echo "✅ Build complete!"
    echo ""
    echo "If the app didn't launch automatically:"
    echo "1. Look for 'Datacap Token' on your simulator home screen"
    echo "2. Tap to launch it"
else
    echo "❌ Build may have failed. Try building in Xcode instead."
fi