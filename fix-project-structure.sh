#!/bin/bash

# Fix duplicated lines in project file

cd /Users/edcrotty/Documents/Datacap-MobileToken-iOS-2025/DatacapMobileTokenDemo

# Create a backup
cp DatacapMobileTokenDemo.xcodeproj/project.pbxproj DatacapMobileTokenDemo.xcodeproj/project.pbxproj.fix

# Remove the duplicated DatacapTokenService.swift lines
sed -i '' '13d' DatacapMobileTokenDemo.xcodeproj/project.pbxproj
sed -i '' '43d' DatacapMobileTokenDemo.xcodeproj/project.pbxproj

# Also remove the framework from Frameworks section since we're not using it
sed -i '' '/ACD32107242D3ADB00694A06.*DatacapMobileToken.xcframework in Frameworks/d' DatacapMobileTokenDemo.xcodeproj/project.pbxproj
sed -i '' '/ACD32108242D3ADB00694A06.*DatacapMobileToken.xcframework in Embed Frameworks/d' DatacapMobileTokenDemo.xcodeproj/project.pbxproj

echo "Fixed project structure"