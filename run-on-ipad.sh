#!/bin/bash

echo "📱 Running Datacap Token on iPad Simulator"
echo "========================================="
echo ""

# List available iPad simulators
echo "Available iPad Simulators:"
xcrun simctl list devices | grep -i "ipad" | grep -v "unavailable"

echo ""
echo "Launching on iPad Pro 13-inch..."

# Build and run on iPad
cd DatacapMobileTokenDemo

xcodebuild -project DatacapMobileTokenDemo.xcodeproj \
  -scheme DatacapMobileTokenDemo \
  -destination 'platform=iOS Simulator,name=iPad Pro 13-inch (M4)' \
  -configuration Debug \
  build

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Build successful!"
    
    # Install and launch
    APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData -name "DatacapMobileTokenDemo.app" -type d | head -1)
    
    if [ -n "$APP_PATH" ]; then
        # Boot the iPad simulator
        xcrun simctl boot "iPad Pro 13-inch (M4)" 2>/dev/null || true
        
        # Install the app
        xcrun simctl install "iPad Pro 13-inch (M4)" "$APP_PATH"
        
        # Launch the app
        xcrun simctl launch "iPad Pro 13-inch (M4)" dsi.dcap.demo
        
        echo "✅ App launched on iPad!"
    fi
else
    echo "❌ Build failed"
    echo ""
    echo "Alternative: Open in Xcode"
    echo "1. Open Xcode"
    echo "2. Select an iPad simulator from the device menu"
    echo "3. Press ⌘+R to run"
fi