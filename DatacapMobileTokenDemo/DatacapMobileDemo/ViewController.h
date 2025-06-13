//
//  ViewController.h
//  DatacapMobileTokenDemo
//
//  Copyright © 2020 Datacap Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DatacapMobileToken/DatacapMobileToken.h>

@interface ViewController : UIViewController <DatacapTokenDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *aiLoadingSpinner;
@property (weak, nonatomic) IBOutlet UIButton *btnGetAToken;

- (IBAction)btnGetAToken_Pressed:(id)sender;

@end

