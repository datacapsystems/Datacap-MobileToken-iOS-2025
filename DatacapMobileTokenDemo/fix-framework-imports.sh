#!/bin/bash

# Fix all framework import issues in the project
set -e

echo "Fixing framework import issues..."

# 1. Update ViewController.m to use the wrapper
echo "Updating ViewController.m imports..."
if grep -q "#import <DatacapMobileToken/DatacapMobileToken.h>" DatacapMobileDemo/ViewController.m 2>/dev/null; then
    sed -i '' 's/#import <DatacapMobileToken\/DatacapMobileToken.h>/#import "DatacapFramework.h"/' DatacapMobileDemo/ViewController.m
fi

# 2. Update DatacapFrameworkWrapper.m
echo "Updating DatacapFrameworkWrapper.m imports..."
cat > DatacapMobileDemo/DatacapFrameworkWrapper.m << 'EOF'
//
//  DatacapFrameworkWrapper.m
//  DatacapMobileTokenDemo
//
//  Objective-C wrapper implementation
//

#import "DatacapFrameworkWrapper.h"
#import "DatacapFramework.h"

@implementation DatacapFrameworkWrapper

+ (void)requestTokenWithPublicKey:(NSString *)publicKey
                   isCertification:(BOOL)isCert
                          delegate:(id<DatacapTokenDelegate>)delegate
                overViewController:(UIViewController *)viewController {
    
    // Create and configure the tokenizer
    DatacapTokenizer *tokenizer = [[DatacapTokenizer alloc] init];
    tokenizer.publicKey = publicKey;
    tokenizer.isCertification = isCert;
    tokenizer.delegate = delegate;
    
    // Show the tokenizer
    [tokenizer showInViewController:viewController];
}

@end
EOF

# 3. Update project's framework search paths
echo "Checking project settings..."
PROJ_FILE="DatacapMobileTokenDemo.xcodeproj/project.pbxproj"

# Check if framework search paths include the correct directory
if ! grep -q "FRAMEWORK_SEARCH_PATHS.*DatacapMobileTokenDemo" "$PROJ_FILE"; then
    echo "Note: You may need to add the framework search path in Xcode:"
    echo "  1. Select your project in Xcode"
    echo "  2. Go to Build Settings"
    echo "  3. Search for 'Framework Search Paths'"
    echo "  4. Add: \$(PROJECT_DIR)"
fi

# 4. Clean derived data
echo "Cleaning derived data..."
rm -rf ~/Library/Developer/Xcode/DerivedData/DatacapMobileTokenDemo-*

echo ""
echo "Import fixes complete!"
echo ""
echo "Next steps:"
echo "1. Open Xcode"
echo "2. Clean Build Folder (Cmd+Shift+K)"
echo "3. Build and Run (Cmd+R)"
echo ""
echo "If you still see import errors:"
echo "- Check that DatacapMobileToken.xcframework is in your project folder"
echo "- Ensure it's added to 'Frameworks, Libraries, and Embedded Content' as 'Embed & Sign'"
echo "- Verify Framework Search Paths includes \$(PROJECT_DIR)"