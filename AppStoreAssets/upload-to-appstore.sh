#!/bin/bash

# App Store Connect Upload Helper

echo "App Store Connect Upload Process"
echo "================================"

# Build and Archive
echo "1. Building and archiving app..."
xcodebuild -project ../DatacapMobileTokenDemo/DatacapMobileTokenDemo.xcodeproj \
  -scheme DatacapMobileTokenDemo \
  -configuration Release \
  -destination 'generic/platform=iOS' \
  -archivePath DatacapMobileTokenDemo.xcarchive \
  clean archive

# Export for App Store
echo "2. Exporting for App Store..."
xcodebuild -exportArchive \
  -archivePath DatacapMobileTokenDemo.xcarchive \
  -exportOptionsPlist ExportOptions.plist \
  -exportPath AppStoreExport

# Validate
echo "3. Validating app..."
xcrun altool --validate-app \
  -f AppStoreExport/DatacapMobileTokenDemo.ipa \
  -t ios \
  --apiKey YOUR_API_KEY \
  --apiIssuer YOUR_ISSUER_ID

# Upload
echo "4. Uploading to App Store Connect..."
xcrun altool --upload-app \
  -f AppStoreExport/DatacapMobileTokenDemo.ipa \
  -t ios \
  --apiKey YOUR_API_KEY \
  --apiIssuer YOUR_ISSUER_ID

echo "Upload complete! Check App Store Connect for processing status."
