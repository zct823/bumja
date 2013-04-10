//
//  DeliveryDayChoiceViewController.h
//  myjam
//
//  Created by Azad Johari on 2/3/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJModel.h"
#import "CheckoutViewController.h"
@interface DeliveryDayChoiceViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIButton *button1;
@property (retain, nonatomic) IBOutlet UILabel *priceLabel;
@property (retain, nonatomic) IBOutlet UIButton *button2;
@property (retain, nonatomic) IBOutlet UIButton *nextButton;
@property (nonatomic, strong) NSDictionary *deliveryInfo;
@property (nonatomic, strong) NSString *deliverChoice;
@property (nonatomic, strong) NSString *cartId;
- (IBAction)nextButtonTapped:(id)sender;
- (IBAction)choiceTapped:(id)sender;

@end
