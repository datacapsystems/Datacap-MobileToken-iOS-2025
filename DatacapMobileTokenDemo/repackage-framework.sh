#!/bin/bash

# Complete framework repackaging solution for modern Xcode compatibility
set -e

echo "=== DatacapMobileToken Framework Repackaging Tool ==="
echo "This will create a fixed version of the framework that works with modern Xcode"
echo ""

# Create working directory
WORK_DIR="DatacapMobileToken-Fixed"
rm -rf "$WORK_DIR"
mkdir -p "$WORK_DIR"

echo "Step 1: Copying framework structure..."
cp -R DatacapMobileToken.xcframework "$WORK_DIR/"

echo "Step 2: Fixing header imports in all framework headers..."

# Function to fix imports in a header file
fix_header_imports() {
    local file="$1"
    echo "  Fixing: $file"
    
    # Create temp file
    local temp_file="${file}.tmp"
    
    # Replace module imports with direct quotes imports
    sed -E 's/#import <DatacapMobileToken\/(.+)>/#import "\1"/g' "$file" > "$temp_file"
    
    # Move temp file back
    mv "$temp_file" "$file"
}

# Fix headers in both architectures
for arch_dir in "ios-arm64_armv7" "ios-arm64_i386_x86_64-simulator"; do
    HEADERS_DIR="$WORK_DIR/DatacapMobileToken.xcframework/$arch_dir/DatacapMobileToken.framework/Headers"
    
    echo "Processing $arch_dir headers..."
    
    # Fix each header file
    for header in "$HEADERS_DIR"/*.h; do
        if [ -f "$header" ]; then
            fix_header_imports "$header"
        fi
    done
done

echo "Step 3: Creating proper module maps..."

# Create module map for both architectures
for arch_dir in "ios-arm64_armv7" "ios-arm64_i386_x86_64-simulator"; do
    MODULE_DIR="$WORK_DIR/DatacapMobileToken.xcframework/$arch_dir/DatacapMobileToken.framework/Modules"
    mkdir -p "$MODULE_DIR"
    
    cat > "$MODULE_DIR/module.modulemap" << 'EOF'
framework module DatacapMobileToken {
    umbrella header "DatacapMobileToken.h"
    
    export *
    module * { export * }
    
    link framework "Foundation"
    link framework "UIKit"
}
EOF
done

echo "Step 4: Updating Info.plist..."
cat > "$WORK_DIR/DatacapMobileToken.xcframework/Info.plist" << 'EOF'
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

echo "Step 5: Creating backup and replacing original..."
if [ ! -d "DatacapMobileToken.xcframework.original" ]; then
    mv DatacapMobileToken.xcframework DatacapMobileToken.xcframework.original
fi

mv "$WORK_DIR/DatacapMobileToken.xcframework" .

echo "Step 6: Updating project header imports..."

# Update DatacapFramework.h to use module imports now that they're fixed
cat > DatacapMobileDemo/DatacapFramework.h << 'EOF'
//
//  DatacapFramework.h
//  DatacapMobileTokenDemo
//
//  Wrapper header to properly import DatacapMobileToken framework
//

#ifndef DatacapFramework_h
#define DatacapFramework_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Now we can use module imports since they're fixed
#import <DatacapMobileToken/DatacapMobileToken.h>
#import <DatacapMobileToken/DatacapTokenizer.h>
#import <DatacapMobileToken/DatacapToken.h>
#import <DatacapMobileToken/DatacapTokenDelegate.h>
#import <DatacapMobileToken/DatacapTokenErrorCodes.h>

#endif /* DatacapFramework_h */
EOF

# Clean up
rm -rf "$WORK_DIR"

echo ""
echo "=== Framework Repackaging Complete! ==="
echo ""
echo "The framework has been fixed and should now work with modern Xcode."
echo ""
echo "Next steps:"
echo "1. Clean derived data: rm -rf ~/Library/Developer/Xcode/DerivedData/DatacapMobileTokenDemo-*"
echo "2. Open Xcode"
echo "3. Clean Build Folder (Cmd+Shift+K)"
echo "4. Build and Run (Cmd+R)"
echo ""
echo "Original framework backed up to: DatacapMobileToken.xcframework.original"