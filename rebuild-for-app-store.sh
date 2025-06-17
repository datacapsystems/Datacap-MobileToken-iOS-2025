#!/bin/bash

echo "🔨 Rebuilding for App Store with Proper Architecture"
echo "==================================================="
echo ""

# Clean previous builds
echo "🧹 Cleaning previous builds..."
rm -rf ~/Library/Developer/Xcode/DerivedData/DatacapMobileTokenDemo-*
rm -rf ~/Desktop/DatacapToken.xcarchive
rm -rf ~/Desktop/DatacapToken_Export*
rm -rf ~/Desktop/DatacapToken_Upload*

cd DatacapMobileTokenDemo

# Clean the project
xcodebuild clean -project DatacapMobileTokenDemo.xcodeproj -scheme DatacapMobileTokenDemo

echo ""
echo "📱 Building archive for iOS devices..."
echo ""

# Build specifically for iOS devices with proper architectures
xcodebuild archive \
  -project DatacapMobileTokenDemo.xcodeproj \
  -scheme DatacapMobileTokenDemo \
  -configuration Release \
  -archivePath ~/Desktop/DatacapToken.xcarchive \
  -destination "generic/platform=iOS" \
  -sdk iphoneos \
  ONLY_ACTIVE_ARCH=NO \
  VALID_ARCHS="arm64" \
  ARCHS="arm64" \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  -allowProvisioningUpdates

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Archive created successfully!"
    echo ""
    
    # Check the binary
    echo "🔍 Verifying binary architectures..."
    BINARY_PATH=$(find ~/Desktop/DatacapToken.xcarchive -name "DatacapMobileTokenDemo" -type f | grep -v ".dSYM")
    
    if [ -f "$BINARY_PATH" ]; then
        echo "Binary found at: $BINARY_PATH"
        lipo -info "$BINARY_PATH"
        
        echo ""
        echo "📦 Exporting IPA..."
        
        EXPORT_DIR="$HOME/Desktop/DatacapToken_AppStore_Export"
        mkdir -p "$EXPORT_DIR"
        
        xcodebuild -exportArchive \
          -archivePath ~/Desktop/DatacapToken.xcarchive \
          -exportPath "$EXPORT_DIR" \
          -exportOptionsPlist ../ExportOptions.plist \
          -allowProvisioningUpdates
        
        if [ $? -eq 0 ]; then
            echo ""
            echo "✅ Export successful!"
            echo "📁 IPA Location: $EXPORT_DIR/DatacapMobileTokenDemo.ipa"
            
            # Verify the IPA
            echo ""
            echo "🔍 Verifying IPA contents..."
            cd "$EXPORT_DIR"
            unzip -l DatacapMobileTokenDemo.ipa | grep "Payload/DatacapMobileTokenDemo.app/DatacapMobileTokenDemo"
            
            echo ""
            echo "Ready to upload with Transporter!"
            open "$EXPORT_DIR"
        else
            echo "❌ Export failed"
        fi
    else
        echo "❌ Binary not found in archive!"
    fi
else
    echo ""
    echo "❌ Archive failed"
    echo ""
    echo "Try building manually in Xcode:"
    echo "1. Open Xcode"
    echo "2. Select 'Any iOS Device (arm64)' as destination"
    echo "3. Product → Archive"
fi