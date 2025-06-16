#!/bin/bash

# Add DatacapTokenService.swift to Xcode project

cd /Users/edcrotty/Documents/Datacap-MobileToken-iOS-2025/DatacapMobileTokenDemo

# Generate UUIDs for the new file
FILE_REF_UUID=$(uuidgen | tr -d '-' | cut -c1-24)
BUILD_FILE_UUID=$(uuidgen | tr -d '-' | cut -c1-24)

# Get the main group UUID
MAIN_GROUP_UUID=$(grep -A1 "DatacapMobileDemo =" DatacapMobileTokenDemo.xcodeproj/project.pbxproj | grep -E "[A-F0-9]{24}" | head -1 | awk '{print $1}')

# Get the Sources build phase UUID
SOURCES_UUID=$(grep -B2 "isa = PBXSourcesBuildPhase" DatacapMobileTokenDemo.xcodeproj/project.pbxproj | grep -E "[A-F0-9]{24}" | head -1 | awk '{print $1}')

# Create a backup
cp DatacapMobileTokenDemo.xcodeproj/project.pbxproj DatacapMobileTokenDemo.xcodeproj/project.pbxproj.backup

# Add file reference
sed -i '' "/\/\* DatacapMobileDemo \*\/ = {/,/};/ s/children = (/&\n\t\t\t\t$FILE_REF_UUID \/* DatacapTokenService.swift *\/,/" DatacapMobileTokenDemo.xcodeproj/project.pbxproj

# Add PBXFileReference
sed -i '' "/\/\* Begin PBXFileReference section \*\//a\\
\t\t$FILE_REF_UUID \/* DatacapTokenService.swift *\/ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = DatacapTokenService.swift; sourceTree = \"<group>\"; };
" DatacapMobileTokenDemo.xcodeproj/project.pbxproj

# Add to build phase
sed -i '' "/\/\* Begin PBXBuildFile section \*\//a\\
\t\t$BUILD_FILE_UUID \/* DatacapTokenService.swift in Sources *\/ = {isa = PBXBuildFile; fileRef = $FILE_REF_UUID \/* DatacapTokenService.swift *\/; };
" DatacapMobileTokenDemo.xcodeproj/project.pbxproj

# Add to Sources build phase
sed -i '' "/$SOURCES_UUID \/\* Sources \*\/ = {/,/};/ s/files = (/&\n\t\t\t\t$BUILD_FILE_UUID \/* DatacapTokenService.swift in Sources *\/,/" DatacapMobileTokenDemo.xcodeproj/project.pbxproj

echo "Added DatacapTokenService.swift to project"