#!/bin/bash

echo "🚀 Force Installing to iPhone..."

# Find the app
APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData -name "DatacapMobileTokenDemo.app" -path "*/Debug-iphoneos/*" 2>/dev/null | head -1)

if [ -z "$APP_PATH" ]; then
    echo "❌ App not found. Please build in Xcode first (⌘B)"
    exit 1
fi

echo "📦 Found app at: $APP_PATH"

# Get device ID
DEVICE_ID="00008110-00020D4E3AFB801E"

echo "📱 Installing to iPhone (310)..."

# First, try to uninstall if it exists
echo "🗑️  Removing old version if exists..."
xcrun devicectl device uninstall app --device $DEVICE_ID com.dcap.DatacapMobileDemo 2>/dev/null || true

# Install the app
echo "📲 Installing fresh copy..."
xcrun devicectl device install app --device $DEVICE_ID "$APP_PATH"

if [ $? -eq 0 ]; then
    echo "✅ Installation successful!"
    
    # Launch the app
    echo "🎯 Launching app..."
    xcrun devicectl device process launch --device $DEVICE_ID com.dcap.DatacapMobileDemo
    
    echo ""
    echo "✨ App should now be running on your iPhone!"
    echo "   Look for 'Datacap Token' on your home screen"
else
    echo "❌ Installation failed"
    echo ""
    echo "Try these steps:"
    echo "1. Unlock your iPhone"
    echo "2. If prompted, trust this computer"
    echo "3. Check Settings → General → VPN & Device Management"
    echo "4. Trust your developer certificate if needed"
fi