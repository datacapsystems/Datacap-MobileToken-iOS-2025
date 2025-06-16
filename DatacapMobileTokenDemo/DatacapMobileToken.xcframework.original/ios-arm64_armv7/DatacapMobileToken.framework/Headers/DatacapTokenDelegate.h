//
//  DatacapTokenDelegate.h
//  DatacapMobileToken
//
//  Copyright © 2020 Datacap Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DatacapMobileToken/DatacapToken.h>

/**
 DatacapTokenizer Result Protocol
 */
@protocol DatacapTokenDelegate <NSObject>

/**
 Called when DatacapTokenizer begins tokenizing user-input account data.
 
 Where implemented, this method will be called from a DatacapTokenizer has begun tokenzing user-input account data.
 */
- (void)tokenLoading;

/**
 Called when DatacapTokenizer successfully tokenizes user-input account data.
 
 Where implemented, this method will be called from a DatacapTokenizer that has successfully tokenized user-input account data.
 
 @param  token A DatacapToken object containing the token properties of the tokenized user-entered account data.
 */
- (void)tokenCreated:(DatacapToken *)token;

/**
 Called when DatacapTokenizer fails to tokenize user-input account data.
 
 Where implemented, this method will be called from a DatacapTokenizer that has failed to tokenized user-input account data.
 
 @param  error An NSError object containing details of the tokenization failure.
 */
- (void)tokenizationError:(NSError *)error;

/**
 Called when user cancels DatacapTokenizer account data input process.
 
 Where implemented, this method will be called from a DatacapTokenizer from which user has cancelled the account data input process.
 */
- (void)tokenizationCancelled;

@end
