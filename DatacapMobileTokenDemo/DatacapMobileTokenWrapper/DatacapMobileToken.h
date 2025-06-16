//
//  DatacapMobileToken.h
//  DatacapMobileToken Framework Wrapper
//
//  This wrapper ensures proper module imports in modern Xcode
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Framework version information
FOUNDATION_EXPORT double DatacapMobileTokenVersionNumber;
FOUNDATION_EXPORT const unsigned char DatacapMobileTokenVersionString[];

// Import all public headers from the original framework
#import "../DatacapMobileToken.xcframework/ios-arm64_armv7/DatacapMobileToken.framework/Headers/DatacapTokenizer.h"
#import "../DatacapMobileToken.xcframework/ios-arm64_armv7/DatacapMobileToken.framework/Headers/DatacapToken.h"
#import "../DatacapMobileToken.xcframework/ios-arm64_armv7/DatacapMobileToken.framework/Headers/DatacapTokenDelegate.h"
#import "../DatacapMobileToken.xcframework/ios-arm64_armv7/DatacapMobileToken.framework/Headers/DatacapTokenErrorCodes.h"