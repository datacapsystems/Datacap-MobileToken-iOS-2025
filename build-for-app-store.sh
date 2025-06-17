#!/bin/bash

# Build script for App Store distribution
# Make sure to update TEAM_ID and PROVISIONING_PROFILE_NAME before running

echo "🚀 Building Datacap Token Demo for App Store..."

# Configuration - UPDATE THESE VALUES
TEAM_ID="YOUR_TEAM_ID"  # Replace with your actual team ID
PROVISIONING_PROFILE="YOUR_PROVISIONING_PROFILE_NAME"  # Replace with your provisioning profile name

# Build configuration
PROJECT_PATH="DatacapMobileTokenDemo/DatacapMobileTokenDemo.xcodeproj"
SCHEME="DatacapMobileTokenDemo"
ARCHIVE_PATH="$HOME/Desktop/DatacapToken.xcarchive"
EXPORT_PATH="$HOME/Desktop/DatacapTokenExport"

# Clean build folder
echo "🧹 Cleaning build folder..."
xcodebuild clean -project "$PROJECT_PATH" -scheme "$SCHEME"

# Create archive
echo "📦 Creating archive..."
xcodebuild archive \
  -project "$PROJECT_PATH" \
  -scheme "$SCHEME" \
  -archivePath "$ARCHIVE_PATH" \
  -destination generic/platform=iOS \
  -configuration Release \
  CODE_SIGN_IDENTITY="Apple Distribution" \
  DEVELOPMENT_TEAM="$TEAM_ID"

# Check if archive was created successfully
if [ ! -d "$ARCHIVE_PATH" ]; then
    echo "❌ Archive creation failed!"
    exit 1
fi

echo "✅ Archive created successfully at: $ARCHIVE_PATH"

# Create ExportOptions.plist
echo "📝 Creating export options..."
cat > ExportOptions.plist <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store</string>
    <key>teamID</key>
    <string>$TEAM_ID</string>
    <key>uploadBitcode</key>
    <true/>
    <key>compileBitcode</key>
    <true/>
    <key>uploadSymbols</key>
    <true/>
    <key>signingCertificate</key>
    <string>Apple Distribution</string>
    <key>provisioningProfiles</key>
    <dict>
        <key>dsi.dcap.demo</key>
        <string>$PROVISIONING_PROFILE</string>
    </dict>
</dict>
</plist>
EOF

# Export for App Store
echo "📤 Exporting for App Store..."
xcodebuild -exportArchive \
  -archivePath "$ARCHIVE_PATH" \
  -exportPath "$EXPORT_PATH" \
  -exportOptionsPlist ExportOptions.plist

# Check if export was successful
if [ -d "$EXPORT_PATH" ]; then
    echo "✅ Export successful!"
    echo "📍 Archive location: $ARCHIVE_PATH"
    echo "📍 IPA location: $EXPORT_PATH/DatacapMobileTokenDemo.ipa"
    echo ""
    echo "🎯 Next steps:"
    echo "1. Open Xcode and go to Window > Organizer"
    echo "2. Select the archive and click 'Distribute App'"
    echo "3. Follow the App Store Connect upload wizard"
    echo ""
    echo "Or use Transporter app to upload the IPA directly."
else
    echo "❌ Export failed!"
    exit 1
fi

# Clean up
rm -f ExportOptions.plist