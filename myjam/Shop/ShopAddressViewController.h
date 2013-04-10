//
//  ShopAddressViewController.h
//  myjam
//
//  Created by Azad Johari on 2/28/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "MJModel.h"
#import "CoreViewController.h"
#import "ShopDetailListingViewController.h"

@interface ShopAddressViewController : CoreViewController<UIWebViewDelegate>
@property (retain, nonatomic) IBOutlet UIImageView *shopLogo;
@property (retain, nonatomic) IBOutlet UIWebView *shopAddress;
@property (retain, nonatomic) NSDictionary *shopAddInfo;
@property (retain, nonatomic) IBOutlet UIButton *visitButton;
@property (retain, nonatomic) NSString *shopId;
@property (retain, nonatomic) IBOutlet UIView *socialView;
@property (retain, nonatomic) IBOutlet UIScrollView *scroller;
- (IBAction)visitShop:(id)sender;
- (IBAction)facebookPressed:(id)sender;
- (IBAction)twitterPressed:(id)sender;
- (IBAction)emailPressed:(id)sender;
@end
