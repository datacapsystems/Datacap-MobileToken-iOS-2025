#!/bin/bash

echo "🚀 Upload to App Store using altool"
echo "==================================="
echo ""
echo "This method bypasses Xcode's upload mechanism"
echo ""

# First, export the archive to get an IPA
ARCHIVE_PATH="$HOME/Desktop/DatacapToken.xcarchive"
EXPORT_DIR="$HOME/Desktop/DatacapToken_Upload"

if [ ! -d "$ARCHIVE_PATH" ]; then
    echo "❌ Archive not found. Build it first with ./quick-app-store-build.sh"
    exit 1
fi

# Export to IPA
echo "📦 Exporting archive to IPA..."
mkdir -p "$EXPORT_DIR"

xcodebuild -exportArchive \
  -archivePath "$ARCHIVE_PATH" \
  -exportPath "$EXPORT_DIR" \
  -exportOptionsPlist ExportOptions.plist \
  -allowProvisioningUpdates

if [ $? -ne 0 ]; then
    echo "❌ Export failed"
    exit 1
fi

IPA_PATH="$EXPORT_DIR/DatacapMobileTokenDemo.ipa"
echo "✅ IPA created at: $IPA_PATH"
echo ""

# Get Apple ID credentials
echo "Please enter your Apple ID credentials:"
read -p "Apple ID Email: " APPLE_ID
read -s -p "App-Specific Password: " APP_PASSWORD
echo ""
echo ""

echo "📤 Uploading to App Store Connect..."
echo "(This may take several minutes)"

# Use altool to upload
xcrun altool --upload-app \
  -f "$IPA_PATH" \
  -t ios \
  -u "$APPLE_ID" \
  -p "$APP_PASSWORD" \
  --verbose

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Upload successful!"
    echo "Check your email for processing confirmation"
    echo "The build will appear in App Store Connect in 5-30 minutes"
else
    echo ""
    echo "❌ Upload failed"
    echo ""
    echo "Troubleshooting:"
    echo "1. Make sure you're using an app-specific password"
    echo "2. Generate one at: https://appleid.apple.com/account/manage"
    echo "3. Under Security → App-Specific Passwords → Generate"
fi