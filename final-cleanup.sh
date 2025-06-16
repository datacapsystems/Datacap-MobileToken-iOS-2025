#!/bin/bash

# Final cleanup of Xcode project

cd /Users/edcrotty/Documents/Datacap-MobileToken-iOS-2025/DatacapMobileTokenDemo

# Create a backup
cp DatacapMobileTokenDemo.xcodeproj/project.pbxproj DatacapMobileTokenDemo.xcodeproj/project.pbxproj.final

# Remove DatacapFrameworkWrapper references from build files
sed -i '' '/269F1D142DFCC77200AF47E8.*DatacapFrameworkWrapper\.m in Sources/d' DatacapMobileTokenDemo.xcodeproj/project.pbxproj

# Remove DatacapFrameworkWrapper file references
sed -i '' '/269F1D122DFCC77200AF47E8.*DatacapFrameworkWrapper\.h.*= {isa = PBXFileReference/d' DatacapMobileTokenDemo.xcodeproj/project.pbxproj
sed -i '' '/269F1D132DFCC77200AF47E8.*DatacapFrameworkWrapper\.m.*= {isa = PBXFileReference/d' DatacapMobileTokenDemo.xcodeproj/project.pbxproj

# Remove from groups
sed -i '' '/269F1D122DFCC77200AF47E8.*DatacapFrameworkWrapper\.h/d' DatacapMobileTokenDemo.xcodeproj/project.pbxproj
sed -i '' '/269F1D132DFCC77200AF47E8.*DatacapFrameworkWrapper\.m/d' DatacapMobileTokenDemo.xcodeproj/project.pbxproj

# Add DatacapTokenService.swift to the main DatacapMobileDemo group
# First, find where ModernViewController.swift is in the children list and add after it
sed -i '' '/2637A06C2DFCBCB60075A9A0.*ModernViewController.swift/a\
\				60E7713CD663491AB32149D6 /* DatacapTokenService.swift */,
' DatacapMobileTokenDemo.xcodeproj/project.pbxproj

echo "Final cleanup complete"