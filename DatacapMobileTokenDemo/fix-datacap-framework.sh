#!/bin/bash

# Fix DatacapMobileToken.xcframework for modern Xcode
# This script corrects module import issues

set -e

echo "Fixing DatacapMobileToken.xcframework..."

# Backup original if not already done
if [ ! -f "DatacapMobileToken.xcframework/Info.plist.original" ]; then
    cp DatacapMobileToken.xcframework/Info.plist DatacapMobileToken.xcframework/Info.plist.original
fi

# Fix Info.plist (already done but included for completeness)
cat > DatacapMobileToken.xcframework/Info.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>AvailableLibraries</key>
	<array>
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
	</array>
	<key>CFBundlePackageType</key>
	<string>XFWK</string>
	<key>XCFrameworkFormatVersion</key>
	<string>1.0</string>
</dict>
</plist>
EOF

# Create enhanced module maps for both architectures
for arch_dir in "ios-arm64_armv7" "ios-arm64_i386_x86_64-simulator"; do
    MODULE_PATH="DatacapMobileToken.xcframework/$arch_dir/DatacapMobileToken.framework/Modules/module.modulemap"
    
    # Backup original module map
    if [ ! -f "$MODULE_PATH.original" ]; then
        cp "$MODULE_PATH" "$MODULE_PATH.original"
    fi
    
    # Create enhanced module map
    cat > "$MODULE_PATH" << 'EOF'
framework module DatacapMobileToken {
  umbrella header "DatacapMobileToken.h"
  
  export *
  module * { export * }
  
  link framework "Foundation"
  link framework "UIKit"
}
EOF
done

# Update the umbrella header to ensure all imports work correctly
for arch_dir in "ios-arm64_armv7" "ios-arm64_i386_x86_64-simulator"; do
    HEADER_PATH="DatacapMobileToken.xcframework/$arch_dir/DatacapMobileToken.framework/Headers/DatacapMobileToken.h"
    
    # Backup original header
    if [ ! -f "$HEADER_PATH.original" ]; then
        cp "$HEADER_PATH" "$HEADER_PATH.original"
    fi
    
    # Create updated umbrella header
    cat > "$HEADER_PATH" << 'EOF'
//
//  DatacapMobileToken.h
//  DatacapMobileToken
//
//  Copyright © 2020 Datacap Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//! Project version number for DatacapMobileToken.
FOUNDATION_EXPORT double DatacapMobileTokenVersionNumber;

//! Project version string for DatacapMobileToken.
FOUNDATION_EXPORT const unsigned char DatacapMobileTokenVersionString[];

// DatacapMobileToken public headers
#import <DatacapMobileToken/DatacapTokenizer.h>
#import <DatacapMobileToken/DatacapToken.h>
#import <DatacapMobileToken/DatacapTokenDelegate.h>
#import <DatacapMobileToken/DatacapTokenErrorCodes.h>

// Ensure symbols are exported properly
#if defined(__cplusplus)
#define DATACAP_EXTERN extern "C" __attribute__((visibility("default")))
#else
#define DATACAP_EXTERN extern __attribute__((visibility("default")))
#endif

EOF
done

# Clean derived data to ensure fresh build
echo "Cleaning derived data..."
rm -rf ~/Library/Developer/Xcode/DerivedData/DatacapMobileTokenDemo-*

echo "Framework fix complete!"
echo ""
echo "Next steps:"
echo "1. Open the project in Xcode"
echo "2. Clean build folder (Cmd+Shift+K)"
echo "3. Build and run (Cmd+R)"
echo ""
echo "If you still encounter issues:"
echo "- Remove the framework from 'Frameworks, Libraries, and Embedded Content'"
echo "- Re-add it and ensure it's set to 'Embed & Sign'"