#!/bin/bash

echo "🚀 Creating Working IPA for App Store"
echo "===================================="
echo ""

# Use the most recent working archive
ARCHIVE_PATH="/Users/edcrotty/Library/Developer/Xcode/Archives/2025-06-17/DatacapToken 6.xcarchive"

if [ ! -d "$ARCHIVE_PATH" ]; then
    echo "❌ Archive not found. Let's use a different one..."
    # Find any archive
    ARCHIVE_PATH=$(find ~/Library/Developer/Xcode/Archives/2025-06-17 -name "DatacapToken*.xcarchive" -type d | head -1)
fi

echo "📦 Using archive: $(basename "$ARCHIVE_PATH")"

# Create export directory
EXPORT_DIR="$HOME/Desktop/DatacapToken_Final_Export"
rm -rf "$EXPORT_DIR"
mkdir -p "$EXPORT_DIR"

# Create minimal export options
cat > "$EXPORT_DIR/ExportOptions.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store-connect</string>
    <key>teamID</key>
    <string>Q68NE4GJ3V</string>
    <key>thinning</key>
    <string>&lt;none&gt;</string>
</dict>
</plist>
EOF

echo ""
echo "📤 Exporting IPA..."

# Export with minimal options
xcodebuild -exportArchive \
    -archivePath "$ARCHIVE_PATH" \
    -exportPath "$EXPORT_DIR" \
    -exportOptionsPlist "$EXPORT_DIR/ExportOptions.plist"

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Export successful!"
    
    # Verify IPA
    IPA_PATH="$EXPORT_DIR/DatacapMobileTokenDemo.ipa"
    if [ -f "$IPA_PATH" ]; then
        # Quick check for binary
        unzip -l "$IPA_PATH" | grep -q "Payload/DatacapMobileTokenDemo.app/DatacapMobileTokenDemo"
        if [ $? -eq 0 ]; then
            echo "✅ IPA contains binary executable!"
            echo ""
            echo "📍 IPA ready at: $IPA_PATH"
            echo "📏 Size: $(ls -lh "$IPA_PATH" | awk '{print $5}')"
            echo ""
            echo "Upload this with Transporter!"
            
            # Copy to Desktop for easy access
            cp "$IPA_PATH" "$HOME/Desktop/DatacapMobileTokenDemo_Final.ipa"
            echo "Also copied to: ~/Desktop/DatacapMobileTokenDemo_Final.ipa"
            
            open "$EXPORT_DIR"
        else
            echo "❌ IPA missing binary!"
        fi
    fi
else
    echo "❌ Export failed. Let's try manual rebuild..."
    echo ""
    echo "Run this command:"
    echo "cd DatacapMobileTokenDemo && xcodebuild clean && xcodebuild archive -scheme DatacapMobileTokenDemo -destination 'generic/platform=iOS'"
fi