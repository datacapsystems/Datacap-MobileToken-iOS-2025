#!/bin/bash

# Clean up old file references from Xcode project

cd /Users/edcrotty/Documents/Datacap-MobileToken-iOS-2025/DatacapMobileTokenDemo

# Create a backup
cp DatacapMobileTokenDemo.xcodeproj/project.pbxproj DatacapMobileTokenDemo.xcodeproj/project.pbxproj.cleanup

# Remove build file entries
sed -i '' '/TestFramework\.swift in Sources/d' DatacapMobileTokenDemo.xcodeproj/project.pbxproj
sed -i '' '/DatacapTokenizerExtension\.swift in Sources/d' DatacapMobileTokenDemo.xcodeproj/project.pbxproj
sed -i '' '/DatacapFrameworkWrapper\.\(m\|h\) in Sources/d' DatacapMobileTokenDemo.xcodeproj/project.pbxproj
sed -i '' '/UIViewController+Datacap\.\(m\|h\) in Sources/d' DatacapMobileTokenDemo.xcodeproj/project.pbxproj

# Remove file reference entries
sed -i '' '/TestFramework\.swift.*= {isa = PBXFileReference/d' DatacapMobileTokenDemo.xcodeproj/project.pbxproj
sed -i '' '/DatacapTokenizerExtension\.swift.*= {isa = PBXFileReference/d' DatacapMobileTokenDemo.xcodeproj/project.pbxproj
sed -i '' '/DatacapFrameworkWrapper\.\(m\|h\).*= {isa = PBXFileReference/d' DatacapMobileTokenDemo.xcodeproj/project.pbxproj
sed -i '' '/UIViewController+Datacap\.\(m\|h\).*= {isa = PBXFileReference/d' DatacapMobileTokenDemo.xcodeproj/project.pbxproj

# Remove from groups
sed -i '' '/TestFramework\.swift/d' DatacapMobileTokenDemo.xcodeproj/project.pbxproj
sed -i '' '/DatacapTokenizerExtension\.swift/d' DatacapMobileTokenDemo.xcodeproj/project.pbxproj
sed -i '' '/DatacapFrameworkWrapper\.\(m\|h\)/d' DatacapMobileTokenDemo.xcodeproj/project.pbxproj
sed -i '' '/UIViewController+Datacap\.\(m\|h\)/d' DatacapMobileTokenDemo.xcodeproj/project.pbxproj

echo "Cleaned up project file"