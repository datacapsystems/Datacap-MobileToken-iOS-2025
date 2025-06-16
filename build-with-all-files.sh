#!/bin/bash

# Build the project with all Swift files explicitly

cd /Users/edcrotty/Documents/Datacap-MobileToken-iOS-2025/DatacapMobileTokenDemo

# First, create a combined Swift file temporarily
cat > AllFiles.swift << 'EOF'
// Temporary combined file for build testing
EOF

# Append all Swift files
cat DatacapTokenService.swift >> AllFiles.swift
echo "" >> AllFiles.swift
cat ModernViewController.swift >> AllFiles.swift  
echo "" >> AllFiles.swift
cat GlassMorphismExtensions.swift >> AllFiles.swift

# Try to compile just the Swift files to see errors
swiftc -sdk $(xcrun --sdk iphonesimulator --show-sdk-path) \
    -target arm64-apple-ios15.6-simulator \
    -import-objc-header DatacapMobileDemo/DatacapMobileDemo-Bridging-Header.h \
    AllFiles.swift \
    -parse 2>&1 | head -50

rm AllFiles.swift