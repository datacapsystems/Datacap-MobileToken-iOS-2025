#!/bin/bash

echo "🔧 Fixing Provisioning Profile Issues"
echo "===================================="
echo ""

# Clean derived data
echo "1. Cleaning Xcode derived data..."
rm -rf ~/Library/Developer/Xcode/DerivedData/*

# Clean provisioning profiles
echo "2. Refreshing provisioning profiles..."
rm -rf ~/Library/MobileDevice/Provisioning\ Profiles/*

echo ""
echo "3. Now in Xcode:"
echo "   • Go to Xcode → Settings → Accounts"
echo "   • Select your Apple ID"
echo "   • Click 'Download Manual Profiles'"
echo "   • Try archiving again"
echo ""
echo "4. Alternative: Create profile manually"
echo "   • Go to https://developer.apple.com"
echo "   • Certificates, Identifiers & Profiles"
echo "   • Profiles → Add → App Store"
echo "   • Select app ID: dsi.dcap.demo"
echo "   • Download and double-click to install"