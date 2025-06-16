#!/bin/bash

# Debug script for DatacapMobileToken framework import issues

echo "=== DatacapMobileToken Framework Import Debugger ==="
echo

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Change to project directory
cd /Users/edcrotty/Documents/Datacap-MobileToken-iOS-2025/DatacapMobileTokenDemo

echo "1. Checking framework structure..."
if [ -d "DatacapMobileToken.xcframework" ]; then
    echo -e "${GREEN}✓ Framework found${NC}"
    echo "   Available architectures:"
    ls DatacapMobileToken.xcframework/
else
    echo -e "${RED}✗ Framework not found!${NC}"
    exit 1
fi

echo
echo "2. Checking module map..."
MODULEMAP="DatacapMobileToken.xcframework/ios-arm64_i386_x86_64-simulator/DatacapMobileToken.framework/Modules/module.modulemap"
if [ -f "$MODULEMAP" ]; then
    echo -e "${GREEN}✓ Module map found${NC}"
    echo "   Content:"
    cat "$MODULEMAP" | sed 's/^/   /'
else
    echo -e "${YELLOW}⚠ Module map not found${NC}"
fi

echo
echo "3. Analyzing header dependencies..."
HEADERS_DIR="DatacapMobileToken.xcframework/ios-arm64_i386_x86_64-simulator/DatacapMobileToken.framework/Headers"
echo "   Headers found:"
for header in "$HEADERS_DIR"/*.h; do
    basename "$header"
done

echo
echo "4. Checking for circular imports..."
for header in "$HEADERS_DIR"/*.h; do
    echo -e "\n   Checking $(basename $header):"
    grep -n "#import.*DatacapMobileToken/" "$header" 2>/dev/null | sed 's/^/      /'
done

echo
echo "5. Creating test project to isolate issue..."

# Create a minimal test project
cat > TestImport.m << 'EOF'
#import <Foundation/Foundation.h>

// Test direct header imports
#import "DatacapMobileToken.xcframework/ios-arm64_i386_x86_64-simulator/DatacapMobileToken.framework/Headers/DatacapTokenDelegate.h"
#import "DatacapMobileToken.xcframework/ios-arm64_i386_x86_64-simulator/DatacapMobileToken.framework/Headers/DatacapToken.h"

int main(int argc, char *argv[]) {
    @autoreleasepool {
        NSLog(@"Framework headers imported successfully!");
        return 0;
    }
}
EOF

echo "6. Attempting to compile test..."
clang -framework Foundation -F. TestImport.m -o TestImport 2>&1 | tee compile_output.txt

if [ ${PIPESTATUS[0]} -eq 0 ]; then
    echo -e "${GREEN}✓ Test compilation successful!${NC}"
else
    echo -e "${RED}✗ Test compilation failed${NC}"
    echo "   Error details:"
    cat compile_output.txt | grep -E "error:|warning:" | sed 's/^/   /'
fi

echo
echo "7. Testing with xcodebuild..."

# Create a simple xcconfig file to override settings
cat > Debug.xcconfig << 'EOF'
FRAMEWORK_SEARCH_PATHS = $(SRCROOT)
HEADER_SEARCH_PATHS = 
DEFINES_MODULE = NO
CLANG_ENABLE_MODULES = NO
EOF

echo "   Building with custom configuration..."
xcodebuild -project DatacapMobileTokenDemo.xcodeproj \
    -scheme DatacapMobileTokenDemo \
    -configuration Debug \
    -xcconfig Debug.xcconfig \
    -derivedDataPath build \
    clean build 2>&1 | tee xcodebuild_output.txt

# Check build result
if [ ${PIPESTATUS[0]} -eq 0 ]; then
    echo -e "${GREEN}✓ Build successful!${NC}"
else
    echo -e "${RED}✗ Build failed${NC}"
    echo
    echo "8. Analyzing build errors..."
    
    # Extract specific errors
    grep -A 5 "could not build module" xcodebuild_output.txt | sed 's/^/   /'
    
    echo
    echo "9. Attempting fix by creating custom module map..."
    
    # Create a custom module map that doesn't use framework syntax
    mkdir -p FixedFramework
    cat > FixedFramework/module.modulemap << 'EOF'
module DatacapMobileToken {
    header "DatacapTokenDelegate.h"
    header "DatacapTokenErrorCodes.h"
    header "DatacapToken.h"
    header "DatacapTokenizer.h"
    export *
}
EOF
    
    echo -e "${YELLOW}⚠ Custom module map created${NC}"
    
    echo
    echo "10. Suggested fixes:"
    echo "   a) Disable modules completely in build settings"
    echo "   b) Use direct header paths in bridging header"
    echo "   c) Create wrapper headers that don't use module imports"
fi

# Clean up
rm -f TestImport.m TestImport compile_output.txt Debug.xcconfig
rm -rf build

echo
echo "=== Debug Complete ==="