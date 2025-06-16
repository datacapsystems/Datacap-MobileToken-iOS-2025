#!/bin/bash

# Script to update DatacapMobileToken framework for modern Xcode compatibility
# This fixes module import issues and updates the framework structure

echo "=== Updating DatacapMobileToken Framework for Modern Xcode ==="
echo

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Change to project directory
cd /Users/edcrotty/Documents/Datacap-MobileToken-iOS-2025/DatacapMobileTokenDemo

# Backup original framework
if [ ! -d "DatacapMobileToken.xcframework.original" ]; then
    echo "Creating backup of original framework..."
    cp -R DatacapMobileToken.xcframework DatacapMobileToken.xcframework.original
    echo -e "${GREEN}✓ Backup created${NC}"
fi

echo
echo "1. Fixing Info.plist..."
# Fix the Info.plist to have correct library paths
cat > DatacapMobileToken.xcframework/Info.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>AvailableLibraries</key>
    <array>
        <dict>
            <key>LibraryIdentifier</key>
            <string>ios-arm64_armv7</string>
            <key>LibraryPath</key>
            <string>DatacapMobileToken.framework</string>
            <key>SupportedArchitectures</key>
            <array>
                <string>arm64</string>
                <string>armv7</string>
            </array>
            <key>SupportedPlatform</key>
            <string>ios</string>
        </dict>
        <dict>
            <key>LibraryIdentifier</key>
            <string>ios-arm64_i386_x86_64-simulator</string>
            <key>LibraryPath</key>
            <string>DatacapMobileToken.framework</string>
            <key>SupportedArchitectures</key>
            <array>
                <string>arm64</string>
                <string>i386</string>
                <string>x86_64</string>
            </array>
            <key>SupportedPlatform</key>
            <string>ios</string>
            <key>SupportedPlatformVariant</key>
            <string>simulator</string>
        </dict>
    </array>
    <key>CFBundlePackageType</key>
    <string>XFWK</string>
    <key>XCFrameworkFormatVersion</key>
    <string>1.0</string>
</dict>
</plist>
EOF
echo -e "${GREEN}✓ Info.plist updated${NC}"

echo
echo "2. Fixing header imports..."

# Function to fix imports in a header file
fix_header_imports() {
    local file=$1
    echo "   Fixing $(basename $file)..."
    
    # Create temp file
    cp "$file" "$file.tmp"
    
    # Replace module imports with direct imports
    sed -i '' 's/#import <DatacapMobileToken\/\(.*\)>/#import "\1"/g' "$file.tmp"
    
    # Move temp file back
    mv "$file.tmp" "$file"
}

# Fix simulator headers
for header in DatacapMobileToken.xcframework/ios-arm64_i386_x86_64-simulator/DatacapMobileToken.framework/Headers/*.h; do
    fix_header_imports "$header"
done

# Fix device headers
for header in DatacapMobileToken.xcframework/ios-arm64_armv7/DatacapMobileToken.framework/Headers/*.h; do
    fix_header_imports "$header"
done

echo -e "${GREEN}✓ Headers fixed${NC}"

echo
echo "3. Creating enhanced module maps..."

# Create enhanced module map for simulator
cat > DatacapMobileToken.xcframework/ios-arm64_i386_x86_64-simulator/DatacapMobileToken.framework/Modules/module.modulemap << 'EOF'
framework module DatacapMobileToken {
    umbrella header "DatacapMobileToken.h"
    
    explicit module Token {
        header "DatacapToken.h"
        export *
    }
    
    explicit module Tokenizer {
        header "DatacapTokenizer.h"
        export *
    }
    
    explicit module Delegate {
        header "DatacapTokenDelegate.h"
        export *
    }
    
    explicit module ErrorCodes {
        header "DatacapTokenErrorCodes.h"
        export *
    }
    
    export *
    module * { export * }
    
    link framework "Foundation"
    link framework "UIKit"
}
EOF

# Copy to device architecture
cp DatacapMobileToken.xcframework/ios-arm64_i386_x86_64-simulator/DatacapMobileToken.framework/Modules/module.modulemap \
   DatacapMobileToken.xcframework/ios-arm64_armv7/DatacapMobileToken.framework/Modules/module.modulemap

echo -e "${GREEN}✓ Module maps updated${NC}"

echo
echo "4. Creating clean wrapper header..."

# Create a clean import header for the framework
cat > DatacapMobileDemo/DatacapFramework.h << 'EOF'
//
//  DatacapFramework.h
//  DatacapMobileTokenDemo
//
//  Clean import header for DatacapMobileToken framework
//

#ifndef DatacapFramework_h
#define DatacapFramework_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Import framework headers without module syntax
#if __has_include(<DatacapMobileToken/DatacapMobileToken.h>)
    #import <DatacapMobileToken/DatacapTokenErrorCodes.h>
    #import <DatacapMobileToken/DatacapToken.h>
    #import <DatacapMobileToken/DatacapTokenDelegate.h>
    #import <DatacapMobileToken/DatacapTokenizer.h>
    #import <DatacapMobileToken/DatacapMobileToken.h>
#else
    // Fallback to direct imports
    #import "DatacapTokenErrorCodes.h"
    #import "DatacapToken.h"
    #import "DatacapTokenDelegate.h"
    #import "DatacapTokenizer.h"
    #import "DatacapMobileToken.h"
#endif

#endif /* DatacapFramework_h */
EOF

echo -e "${GREEN}✓ Wrapper header created${NC}"

echo
echo "5. Updating bridging header..."

# Update the bridging header to use the clean import
cat > DatacapMobileDemo/DatacapMobileDemo-Bridging-Header.h << 'EOF'
//
//  DatacapMobileDemo-Bridging-Header.h
//  DatacapMobileTokenDemo
//
//  Copyright © 2025 Datacap Systems, Inc. All rights reserved.
//

// Use the clean framework import
#import "DatacapFramework.h"
#import "ViewController.h"
EOF

echo -e "${GREEN}✓ Bridging header updated${NC}"

echo
echo "6. Creating build settings file..."

# Create xcconfig file with proper settings
cat > ModernBuild.xcconfig << 'EOF'
// Modern build settings for DatacapMobileToken
FRAMEWORK_SEARCH_PATHS = $(inherited) $(PROJECT_DIR) $(PROJECT_DIR)/DatacapMobileToken.xcframework
HEADER_SEARCH_PATHS = $(inherited)
ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES = YES
DEFINES_MODULE = YES
CLANG_ENABLE_MODULES = YES
SWIFT_VERSION = 5.0
IPHONEOS_DEPLOYMENT_TARGET = 13.0

// Exclude deprecated architectures
EXCLUDED_ARCHS[sdk=iphonesimulator*] = i386
EXCLUDED_ARCHS[sdk=iphoneos*] = armv7

// Module settings
CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES = YES
SWIFT_OBJC_BRIDGING_HEADER = DatacapMobileDemo/DatacapMobileDemo-Bridging-Header.h
EOF

echo -e "${GREEN}✓ Build settings created${NC}"

echo
echo "7. Clearing caches..."
rm -rf ~/Library/Developer/Xcode/DerivedData/DatacapMobileTokenDemo-*
rm -rf ~/Library/Developer/Xcode/DerivedData/ModuleCache.noindex
echo -e "${GREEN}✓ Caches cleared${NC}"

echo
echo -e "${GREEN}=== Framework Update Complete ===${NC}"
echo
echo "Next steps:"
echo "1. Open DatacapMobileTokenDemo.xcodeproj in Xcode"
echo "2. Clean Build Folder (Cmd+Shift+K)"
echo "3. Build and Run (Cmd+R)"
echo
echo "If you still have issues:"
echo "- Check that 'DatacapFramework.h' is added to the project"
echo "- Ensure Framework Search Paths includes \$(PROJECT_DIR)"
echo "- Try building for a simulator first"
echo
echo -e "${YELLOW}Note: The original framework is backed up as DatacapMobileToken.xcframework.original${NC}"