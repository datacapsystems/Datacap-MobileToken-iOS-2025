//
//  DatacapMobileToken.h
//  DatacapMobileToken
//
//  Copyright © 2020 Datacap Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//! Project version number for DatacapMobileToken.
FOUNDATION_EXPORT double DatacapMobileTokenVersionNumber;

//! Project version string for DatacapMobileToken.
FOUNDATION_EXPORT const unsigned char DatacapMobileTokenVersionString[];

// DatacapMobileToken public headers
#import <DatacapMobileToken/DatacapTokenizer.h>
#import <DatacapMobileToken/DatacapToken.h>
#import <DatacapMobileToken/DatacapTokenDelegate.h>
#import <DatacapMobileToken/DatacapTokenErrorCodes.h>

// Ensure symbols are exported properly
#if defined(__cplusplus)
#define DATACAP_EXTERN extern "C" __attribute__((visibility("default")))
#else
#define DATACAP_EXTERN extern __attribute__((visibility("default")))
#endif

