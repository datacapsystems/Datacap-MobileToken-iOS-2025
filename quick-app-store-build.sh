#!/bin/bash

# Quick App Store Build Script
echo "🚀 Building Datacap Token for App Store..."
echo "========================================="

# Navigate to project directory
cd DatacapMobileTokenDemo

# Clean build folder
echo "🧹 Cleaning build folder..."
xcodebuild clean -project DatacapMobileTokenDemo.xcodeproj -scheme DatacapMobileTokenDemo

# Create archive
echo "📦 Creating archive..."
xcodebuild archive \
  -project DatacapMobileTokenDemo.xcodeproj \
  -scheme DatacapMobileTokenDemo \
  -archivePath ~/Desktop/DatacapToken.xcarchive \
  -destination "generic/platform=iOS" \
  -allowProvisioningUpdates

if [ $? -eq 0 ]; then
    echo "✅ Archive created successfully!"
    echo "📍 Location: ~/Desktop/DatacapToken.xcarchive"
    echo ""
    echo "Next steps:"
    echo "1. Open Xcode Organizer: Window > Organizer"
    echo "2. Select your archive"
    echo "3. Click 'Distribute App'"
    echo "4. Choose 'App Store Connect'"
    echo "5. Follow the upload wizard"
    
    # Open organizer
    open -a Xcode ~/Desktop/DatacapToken.xcarchive
else
    echo "❌ Build failed. Please check the errors above."
fi