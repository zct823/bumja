//
//  DeliverySelSavAddrViewController.h
//  myjam
//
//  Created by Mohd Zulhilmi on 21/03/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "ASIWrapper.h"
#import "JSONKit.h"
#import "DeliverySelSavAddresses.h"
#import "DeliveryChoiceViewController.h"
#import "AppDelegate.h"

@interface DeliverySelSavAddrViewController : UIViewController

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) NSString *getCartID;
@property (nonatomic, retain) IBOutlet UIView *mainContentView;
@property (nonatomic, retain) IBOutlet UIView *nextBtnView;
@property (nonatomic,retain) NSDictionary *addressList;
@property (nonatomic) NSInteger tagID;

@end
