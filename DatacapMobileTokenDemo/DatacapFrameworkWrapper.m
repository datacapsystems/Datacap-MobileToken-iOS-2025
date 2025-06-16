//
//  DatacapFrameworkWrapper.m
//  DatacapMobileTokenDemo
//
//  Objective-C wrapper implementation
//

#import "DatacapFrameworkWrapper.h"

// Import the framework headers here, in the implementation file
#import "../DatacapMobileToken.xcframework/ios-arm64_i386_x86_64-simulator/DatacapMobileToken.framework/Headers/DatacapToken.h"
#import "../DatacapMobileToken.xcframework/ios-arm64_i386_x86_64-simulator/DatacapMobileToken.framework/Headers/DatacapTokenizer.h"
#import "../DatacapMobileToken.xcframework/ios-arm64_i386_x86_64-simulator/DatacapMobileToken.framework/Headers/DatacapTokenErrorCodes.h"

@implementation DatacapFrameworkWrapper

+ (void)requestTokenWithPublicKey:(NSString *)publicKey
                   isCertification:(BOOL)isCert
                          delegate:(id<DatacapTokenDelegate>)delegate
                overViewController:(UIViewController *)viewController {
    
    DatacapTokenizer *tokenizer = [[DatacapTokenizer alloc] init];
    [tokenizer requestKeyedTokenWithPublicKey:publicKey
                               isCertification:isCert
                                  andDelegate:delegate
                           overViewController:viewController];
}

@end