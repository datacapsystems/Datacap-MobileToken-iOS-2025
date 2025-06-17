#!/bin/bash

echo "📦 Manual Archive Export for App Store"
echo "====================================="
echo ""
echo "This script will export your archive for manual upload"
echo ""

# Check if archive exists
ARCHIVE_PATH="$HOME/Desktop/DatacapToken.xcarchive"

if [ ! -d "$ARCHIVE_PATH" ]; then
    echo "❌ Archive not found at: $ARCHIVE_PATH"
    echo "Please build the archive first using ./quick-app-store-build.sh"
    exit 1
fi

echo "✅ Found archive at: $ARCHIVE_PATH"
echo ""

# Create export directory
EXPORT_DIR="$HOME/Desktop/DatacapToken_Export_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$EXPORT_DIR"

# Export the archive
echo "📤 Exporting archive for App Store..."
xcodebuild -exportArchive \
  -archivePath "$ARCHIVE_PATH" \
  -exportPath "$EXPORT_DIR" \
  -exportOptionsPlist ExportOptions.plist \
  -allowProvisioningUpdates

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Export successful!"
    echo "📁 IPA Location: $EXPORT_DIR/DatacapMobileTokenDemo.ipa"
    echo ""
    echo "Next steps:"
    echo "1. Copy the .ipa file to a USB drive or cloud storage"
    echo "2. On another Mac without ThreatLocker:"
    echo "   - Download Transporter from Mac App Store"
    echo "   - Sign in with your Apple ID"
    echo "   - Drag the .ipa file into Transporter"
    echo "   - Click 'Deliver'"
    echo ""
    echo "Opening export folder..."
    open "$EXPORT_DIR"
else
    echo "❌ Export failed. Check the error messages above."
fi