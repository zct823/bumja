//
//  ShopInfoViewController.h
//  myjam
//
//  Created by Mohd Zulhilmi on 5/04/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ASIWrapper.h"
#import "CoreViewController.h"
#import "PrevMapNMViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ShopInfoViewController : CoreViewController <UIWebViewDelegate>

@property (nonatomic, retain) IBOutlet UIImageView *headerImg;
@property (nonatomic, retain) IBOutlet UIWebView *addressView;
@property (nonatomic, retain) IBOutlet UIButton *firstMS;
@property (nonatomic, retain) IBOutlet UIButton *secondMS;
@property (nonatomic, retain) IBOutlet UILabel *prevMapLbl;
@property (nonatomic, retain) IBOutlet UILabel *visitJSLbl;
@property (nonatomic, retain) IBOutlet UIButton *shareFBBtn;
@property (nonatomic, retain) IBOutlet UIButton *shareTWBtn;
@property (nonatomic, retain) IBOutlet UIButton *shareEMBtn;
@property (nonatomic, retain) IBOutlet UILabel *distanceLabel;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic) NSInteger shopID;
@property (nonatomic) NSInteger currentUserDegree;
@property (nonatomic) float shopCoordLat;
@property (nonatomic) float shopCoordLong;
@property (nonatomic) NSInteger shopDistance;

@end
