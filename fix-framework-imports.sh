#!/bin/bash

# Script to fix DatacapMobileToken framework import issues

echo "=== Fixing DatacapMobileToken Framework Imports ==="
echo

cd /Users/edcrotty/Documents/Datacap-MobileToken-iOS-2025/DatacapMobileTokenDemo

# Create wrapper headers that don't use module imports
echo "1. Creating wrapper headers..."
mkdir -p DatacapMobileDemo/FrameworkWrappers

# Create a wrapper for DatacapToken.h
cat > DatacapMobileDemo/FrameworkWrappers/DatacapToken_Wrapper.h << 'EOF'
#ifndef DatacapToken_Wrapper_h
#define DatacapToken_Wrapper_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Forward declarations
@protocol DatacapTokenDelegate;

// Include the actual header without module syntax
#import "../../DatacapMobileToken.xcframework/ios-arm64_i386_x86_64-simulator/DatacapMobileToken.framework/Headers/DatacapToken.h"

#endif
EOF

# Create a wrapper for DatacapTokenDelegate.h
cat > DatacapMobileDemo/FrameworkWrappers/DatacapTokenDelegate_Wrapper.h << 'EOF'
#ifndef DatacapTokenDelegate_Wrapper_h
#define DatacapTokenDelegate_Wrapper_h

#import <Foundation/Foundation.h>

// Forward declare DatacapToken to break circular dependency
@class DatacapToken;

// Define the protocol directly to avoid import issues
@protocol DatacapTokenDelegate <NSObject>
@required
- (void)tokenRequestDidSucceed:(DatacapToken *)token;
- (void)tokenRequestDidFail:(DatacapToken *)token withError:(NSError *)error;
@optional
- (void)tokenRequestDidCancel:(DatacapToken *)token;
@end

#endif
EOF

# Create wrapper for DatacapTokenizer.h
cat > DatacapMobileDemo/FrameworkWrappers/DatacapTokenizer_Wrapper.h << 'EOF'
#ifndef DatacapTokenizer_Wrapper_h
#define DatacapTokenizer_Wrapper_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Forward declarations
@protocol DatacapTokenDelegate;

// Define the interface directly
@interface DatacapTokenizer : NSObject

- (void)requestKeyedTokenWithPublicKey:(NSString *)publicKey
                           andDelegate:(NSObject<DatacapTokenDelegate> *)delegate
                    overViewController:(UIViewController *)parentViewController;

- (void)requestKeyedTokenWithPublicKey:(NSString *)publicKey
                        isCertification:(bool)isCert
                           andDelegate:(NSObject<DatacapTokenDelegate> *)delegate
                    overViewController:(UIViewController *)parentViewController;

@end

#endif
EOF

# Update the bridging header to use our wrappers
echo "2. Updating bridging header..."
cat > DatacapMobileDemo/DatacapMobileDemo-Bridging-Header.h << 'EOF'
//
//  DatacapMobileDemo-Bridging-Header.h
//  DatacapMobileTokenDemo
//
//  Copyright © 2025 Datacap Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Use wrapper headers to avoid module import issues
#import "FrameworkWrappers/DatacapTokenDelegate_Wrapper.h"
#import "FrameworkWrappers/DatacapToken_Wrapper.h"
#import "FrameworkWrappers/DatacapTokenizer_Wrapper.h"

// Import error codes directly
#import "../DatacapMobileToken.xcframework/ios-arm64_i386_x86_64-simulator/DatacapMobileToken.framework/Headers/DatacapTokenErrorCodes.h"

// Import the actual implementation
#import "../DatacapMobileToken.xcframework/ios-arm64_i386_x86_64-simulator/DatacapMobileToken.framework/Headers/DatacapTokenizer.h"
#import "../DatacapMobileToken.xcframework/ios-arm64_i386_x86_64-simulator/DatacapMobileToken.framework/Headers/DatacapToken.h"

#import "ViewController.h"
EOF

echo "3. Building with fixed imports..."
xcodebuild -project DatacapMobileTokenDemo.xcodeproj \
    -scheme DatacapMobileTokenDemo \
    -configuration Debug \
    -sdk iphonesimulator \
    -derivedDataPath build \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGNING_ALLOWED=NO \
    build 2>&1 | tee build_output.txt

# Check if build succeeded
if grep -q "BUILD SUCCEEDED" build_output.txt; then
    echo
    echo -e "\033[0;32m✓ Build successful with wrapper headers!\033[0m"
    echo
    echo "4. Files created:"
    echo "   - DatacapMobileDemo/FrameworkWrappers/DatacapToken_Wrapper.h"
    echo "   - DatacapMobileDemo/FrameworkWrappers/DatacapTokenDelegate_Wrapper.h"
    echo "   - DatacapMobileDemo/FrameworkWrappers/DatacapTokenizer_Wrapper.h"
    echo "   - Updated: DatacapMobileDemo/DatacapMobileDemo-Bridging-Header.h"
    echo
    echo "5. Next steps:"
    echo "   a) Add the FrameworkWrappers folder to your Xcode project"
    echo "   b) Clean and rebuild in Xcode"
else
    echo
    echo -e "\033[0;31m✗ Build still failing. Checking errors...\033[0m"
    grep -A 5 "error:" build_output.txt | head -20
fi

# Clean up
rm -rf build build_output.txt

echo
echo "=== Fix Complete ==="