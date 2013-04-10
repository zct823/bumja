//
//  DeliveryOptionViewController.h
//  myjam
//
//  Created by Azad Johari on 2/3/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJModel.h"
#import "NSString+StripeHTML.h"
#import "AppDelegate.h"
#import "DeliveryChoiceViewController.h"
@interface DeliveryOptionViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIView *addressView1;
@property (retain, nonatomic) IBOutlet UILabel *address1;
@property (retain, nonatomic) IBOutlet UILabel *adressCity;
@property (retain, nonatomic) IBOutlet UILabel *addressState;
@property (retain, nonatomic) IBOutlet UILabel *addressCountry;
@property (retain, nonatomic) IBOutlet UIImageView *checkBox1;

@property (retain, nonatomic) IBOutlet UILabel *address2;
@property (retain, nonatomic) IBOutlet UILabel *addressCity2;
@property (retain, nonatomic) IBOutlet UILabel *addressState2;
@property (retain, nonatomic) IBOutlet UILabel *addressCountry2;
@property (retain, nonatomic) IBOutlet UIView *adressView2;
@property (retain, nonatomic) IBOutlet UIImageView *checkBox2;

@property (retain, nonatomic) IBOutlet UIView *addressView3;
@property (retain, nonatomic) IBOutlet UILabel *address3;
@property (retain, nonatomic) IBOutlet UILabel *addressState3;
@property (retain, nonatomic) IBOutlet UILabel *addressCity3;
@property (retain, nonatomic) IBOutlet UILabel *addressCountry3;
@property (retain, nonatomic) IBOutlet UIImageView *button1;
@property (retain, nonatomic) IBOutlet UIImageView *button2;
@property (retain, nonatomic) IBOutlet UIImageView *button3;
@property (retain, nonatomic) IBOutlet UIImageView *checkBox3;

- (IBAction)selectAddress:(id)sender;
@property (retain, nonatomic) NSDictionary* addressInfo;
@property (retain, nonatomic) IBOutlet UIScrollView* scrollView;
@property (retain, nonatomic) NSString* cartId;
@property (retain, nonatomic) NSNumber* selectedRow;
@end
