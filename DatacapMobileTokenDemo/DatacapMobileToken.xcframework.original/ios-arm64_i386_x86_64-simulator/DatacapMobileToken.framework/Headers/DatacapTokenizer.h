//
//  DatacapTokenizer.h
//  DatacapMobileToken
//
//  Copyright © 2020 Datacap Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <DatacapMobileToken/DatacapTokenDelegate.h>

/**
 Datacap Tokenizer class for initiating account data entry and tokenization.
 */
@interface DatacapTokenizer : NSObject

/**
 Request a token with user-input account data.
 
 Calling this method with the appropriate parameters presents the user with 3 account data entry views, then tokenizes the data input by the user and calls the provided delegate with tokenization results.
 
 @param  publicKey A Datacap public key for authentication.
 @param  delegate A DatacapTokenDelegate object which to call with tokenization results.
 @param  parentViewController A UIViewController over which to display account data entry views.
 */
- (void)requestKeyedTokenWithPublicKey:(NSString *)publicKey
                           andDelegate:(NSObject<DatacapTokenDelegate> *)delegate
                    overViewController:(UIViewController *)parentViewController;

/**
 Request a token with user-input account data.
 
 Calling this method with the appropriate parameters presents the user with 3 account data entry views, then tokenizes the data input by the user and calls the provided delegate with tokenization results.
 
 @param  publicKey A Datacap public key for authentication.
 @param  isCert If the target processing environment is certification/test.
 @param  delegate A DatacapTokenDelegate object which to call with tokenization results.
 @param  parentViewController A UIViewController over which to display account data entry views.
 */
- (void)requestKeyedTokenWithPublicKey:(NSString *)publicKey
                        isCertification:(bool)isCert
                           andDelegate:(NSObject<DatacapTokenDelegate> *)delegate
                    overViewController:(UIViewController *)parentViewController;

@end
