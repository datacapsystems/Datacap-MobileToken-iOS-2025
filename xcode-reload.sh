#!/bin/bash

echo "🔄 Xcode Reload Method"
echo "====================="
echo ""

# Kill any existing build processes
killall xcodebuild 2>/dev/null || true

# Open Xcode and trigger rebuild
echo "Opening project in Xcode..."
open DatacapMobileTokenDemo/DatacapMobileTokenDemo.xcodeproj

echo ""
echo "📱 To reload the app:"
echo ""
echo "1. In Xcode, press: ⌘+Shift+K (Clean Build Folder)"
echo "2. Then press: ⌘+R (Build and Run)"
echo ""
echo "Or use the menu:"
echo "• Product → Clean Build Folder"
echo "• Product → Run"
echo ""
echo "The app will automatically install and launch in your simulator."
echo ""
echo "✨ What's new:"
echo "• Help button (?) shows app information"
echo "• App Store description for both new and existing users"
echo "• Educational content about Datacap's services"