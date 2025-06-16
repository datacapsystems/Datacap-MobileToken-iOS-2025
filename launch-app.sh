#!/bin/bash

echo "🚀 Launching Datacap Token Demo..."

# Kill any existing instances
xcrun simctl terminate booted com.dcap.DatacapMobileDemo 2>/dev/null || true

# Build fresh
echo "📦 Building app..."
xcodebuild -project DatacapMobileTokenDemo/DatacapMobileTokenDemo.xcodeproj \
  -scheme DatacapMobileTokenDemo \
  -configuration Debug \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
  -derivedDataPath build \
  clean build > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "✅ Build successful"
    
    # Install
    echo "📲 Installing app..."
    xcrun simctl install booted build/Build/Products/Debug-iphonesimulator/DatacapMobileTokenDemo.app
    
    # Launch
    echo "🎯 Launching app..."
    xcrun simctl launch booted com.dcap.DatacapMobileDemo
    
    echo "✨ App launched successfully!"
    echo ""
    echo "If the app crashes, check the Console app for logs:"
    echo "1. Open Console.app"
    echo "2. Select your simulator device"
    echo "3. Filter for 'DatacapMobileDemo'"
else
    echo "❌ Build failed"
    exit 1
fi