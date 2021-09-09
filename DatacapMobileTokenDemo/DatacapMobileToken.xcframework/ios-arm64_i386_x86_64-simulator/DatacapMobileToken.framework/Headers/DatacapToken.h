//
//  DatacapToken.h
//  DatacapMobileToken
//
//  Copyright © 2020 Datacap Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 DatacapToken class representing tokenized account data.
 */
@interface DatacapToken : NSObject

/**
 * Token of user-entered account data.
 */
@property (strong, nonatomic) NSString *Token;

/**
 * Card brand of account represented by token.
 */
@property (strong, nonatomic) NSString *Brand;

/**
 * Expiration month of account represented by token.
 */
@property (strong, nonatomic) NSString *ExpirationMonth;

/**
 * Expiration year of account represented by token.
 */
@property (strong, nonatomic) NSString *ExpirationYear;

/**
 * Last four digits of account represented by token.
 */
@property (strong, nonatomic) NSString *Last4;

@end
