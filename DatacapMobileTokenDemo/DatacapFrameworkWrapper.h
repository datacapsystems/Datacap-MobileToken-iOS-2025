//
//  DatacapFrameworkWrapper.h
//  DatacapMobileTokenDemo
//
//  Objective-C wrapper to avoid module import issues
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Forward declarations
@class DatacapToken;

// Re-declare the protocol to avoid import issues
@protocol DatacapTokenDelegate <NSObject>
@required
- (void)tokenRequestDidSucceed:(DatacapToken *)token;
- (void)tokenRequestDidFail:(DatacapToken *)token withError:(NSError *)error;
@optional
- (void)tokenRequestDidCancel:(DatacapToken *)token;
@end

// Wrapper class that will handle the framework imports internally
@interface DatacapFrameworkWrapper : NSObject

+ (void)requestTokenWithPublicKey:(NSString *)publicKey
                   isCertification:(BOOL)isCert
                          delegate:(id<DatacapTokenDelegate>)delegate
                overViewController:(UIViewController *)viewController;

@end