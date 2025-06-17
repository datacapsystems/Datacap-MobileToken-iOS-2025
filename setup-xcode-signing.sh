#!/bin/bash

echo "🔐 Setting up Xcode Code Signing"
echo "================================"
echo ""
echo "This script will guide you through setting up code signing in Xcode."
echo ""

# Open Xcode preferences
echo "📱 Opening Xcode..."
open -a Xcode

echo ""
echo "Please follow these steps in Xcode:"
echo ""
echo "1️⃣  Add your Apple Developer Account:"
echo "   • Go to Xcode → Settings (⌘,)"
echo "   • Click 'Accounts' tab"
echo "   • Click '+' button at bottom left"
echo "   • Choose 'Apple ID'"
echo "   • Sign in with your Apple Developer account"
echo "   • Wait for account to sync"
echo ""
read -p "Press ENTER when you've added your account..."

echo ""
echo "2️⃣  Now let's open the project and configure signing:"
echo ""

# Open the project
open DatacapMobileTokenDemo/DatacapMobileTokenDemo.xcodeproj

echo "In Xcode:"
echo "   • Select 'DatacapMobileTokenDemo' project in navigator"
echo "   • Select 'DatacapMobileTokenDemo' target"
echo "   • Go to 'Signing & Capabilities' tab"
echo "   • Check 'Automatically manage signing'"
echo "   • Select your Team from dropdown"
echo "   • Bundle ID should be: dsi.dcap.demo"
echo ""
read -p "Press ENTER when signing is configured..."

echo ""
echo "3️⃣  Let's try building again..."
echo ""

# Try to build again
xcodebuild archive \
  -project DatacapMobileTokenDemo/DatacapMobileTokenDemo.xcodeproj \
  -scheme DatacapMobileTokenDemo \
  -archivePath ~/Desktop/DatacapToken.xcarchive \
  -destination "generic/platform=iOS" \
  -allowProvisioningUpdates

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Archive created successfully!"
    echo "📍 Location: ~/Desktop/DatacapToken.xcarchive"
    echo ""
    echo "Opening Organizer..."
    open -a Xcode ~/Desktop/DatacapToken.xcarchive
else
    echo ""
    echo "❌ Build still failing. Let's try manual archive:"
    echo ""
    echo "In Xcode:"
    echo "1. Select 'Generic iOS Device' or 'Any iOS Device' as destination"
    echo "2. Go to Product → Archive"
    echo "3. Wait for archive to complete"
    echo "4. Organizer will open automatically"
    echo "5. Click 'Distribute App' → 'App Store Connect'"
fi