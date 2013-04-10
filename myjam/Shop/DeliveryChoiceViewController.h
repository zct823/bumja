//
//  DeliveryChoiceViewController.h
//  myjam
//
//  Created by Azad Johari on 3/5/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJModel.h"
#import "CheckoutViewController.h"
#import "AppDelegate.h"
@interface DeliveryChoiceViewController : UIViewController<UIAlertViewDelegate>
@property (retain, nonatomic) IBOutlet UILabel *priceLabel;
@property (retain, nonatomic) IBOutlet UIButton *nextButton;
@property (nonatomic, strong) NSDictionary *deliveryInfo;
@property (nonatomic, strong) NSString *deliverChoice;
@property (nonatomic, strong) NSString *cartId;
@property (retain, nonatomic) IBOutlet UILabel *jambuFeeLabel;
@property (retain, nonatomic) IBOutlet UILabel *infoLabel;
@property (retain, nonatomic) IBOutlet UILabel *delConvenienceLabel;
@property (retain, nonatomic) IBOutlet UILabel *shipWithinLabel;
@property (retain, nonatomic) IBOutlet UILabel *jambueFeeLabel;
- (IBAction)nextButtonTapped:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andCartId:(NSString*)string;
@end
