#!/bin/bash

echo "📦 Export IPA from Xcode Archive"
echo "================================"
echo ""

# Find the latest archive
ARCHIVE_DIR="$HOME/Library/Developer/Xcode/Archives/2025-06-17"
LATEST_ARCHIVE=$(find "$ARCHIVE_DIR" -name "*.xcarchive" -type d -print0 | xargs -0 ls -t | head -1)

if [ -z "$LATEST_ARCHIVE" ]; then
    echo "❌ No archives found in $ARCHIVE_DIR"
    echo ""
    echo "Building a new archive..."
    
    cd DatacapMobileTokenDemo
    
    # Build archive with explicit settings
    xcodebuild archive \
        -project DatacapMobileTokenDemo.xcodeproj \
        -scheme DatacapMobileTokenDemo \
        -configuration Release \
        -archivePath "$HOME/Desktop/DatacapToken_Fresh.xcarchive" \
        -destination "generic/platform=iOS" \
        ONLY_ACTIVE_ARCH=NO \
        SKIP_INSTALL=NO \
        BUILD_LIBRARY_FOR_DISTRIBUTION=NO
    
    if [ $? -eq 0 ]; then
        LATEST_ARCHIVE="$HOME/Desktop/DatacapToken_Fresh.xcarchive"
        echo "✅ New archive created"
    else
        echo "❌ Archive failed"
        exit 1
    fi
else
    echo "✅ Found archive: $(basename "$LATEST_ARCHIVE")"
fi

# Check if binary exists in archive
BINARY_PATH="$LATEST_ARCHIVE/Products/Applications/DatacapMobileTokenDemo.app/DatacapMobileTokenDemo"
if [ ! -f "$BINARY_PATH" ]; then
    echo "❌ Binary not found in archive!"
    echo "Expected at: $BINARY_PATH"
    
    # List what's in the archive
    echo ""
    echo "Archive contents:"
    find "$LATEST_ARCHIVE" -name "*.app" -type d
    exit 1
fi

echo "✅ Binary found in archive"

# Create export directory
EXPORT_DIR="$HOME/Desktop/DatacapToken_Export_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$EXPORT_DIR"

echo ""
echo "📤 Exporting IPA with proper settings..."

# Create a temporary export options that ensures binary is included
cat > "$EXPORT_DIR/ExportOptions.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store-connect</string>
    <key>teamID</key>
    <string>Q68NE4GJ3V</string>
    <key>uploadSymbols</key>
    <true/>
    <key>compileBitcode</key>
    <false/>
    <key>thinning</key>
    <string>&lt;none&gt;</string>
    <key>signingStyle</key>
    <string>automatic</string>
</dict>
</plist>
EOF

# Export the archive
xcodebuild -exportArchive \
    -archivePath "$LATEST_ARCHIVE" \
    -exportPath "$EXPORT_DIR" \
    -exportOptionsPlist "$EXPORT_DIR/ExportOptions.plist" \
    -allowProvisioningUpdates

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Export successful!"
    
    # Verify the IPA contains the binary
    echo ""
    echo "🔍 Verifying IPA contents..."
    cd "$EXPORT_DIR"
    
    # Create temp directory for inspection
    TEMP_DIR="$EXPORT_DIR/temp_inspect"
    mkdir -p "$TEMP_DIR"
    
    # Extract IPA
    unzip -q DatacapMobileTokenDemo.ipa -d "$TEMP_DIR"
    
    # Check for binary
    if [ -f "$TEMP_DIR/Payload/DatacapMobileTokenDemo.app/DatacapMobileTokenDemo" ]; then
        echo "✅ Binary confirmed in IPA!"
        
        # Check architecture
        file "$TEMP_DIR/Payload/DatacapMobileTokenDemo.app/DatacapMobileTokenDemo" | grep -q "arm64"
        if [ $? -eq 0 ]; then
            echo "✅ ARM64 architecture confirmed!"
        else
            echo "⚠️  Architecture check failed"
        fi
    else
        echo "❌ Binary NOT found in IPA!"
    fi
    
    # Cleanup
    rm -rf "$TEMP_DIR"
    
    echo ""
    echo "📁 IPA Location: $EXPORT_DIR/DatacapMobileTokenDemo.ipa"
    echo ""
    echo "Ready to upload with Transporter!"
    open "$EXPORT_DIR"
else
    echo ""
    echo "❌ Export failed"
    echo ""
    echo "Check the error messages above"
fi