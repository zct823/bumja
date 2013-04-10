//
//  ShopViewController.h
//  myjam
//
//  Created by nazri on 11/7/12.
//  Copyright (c) 2012 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBTabBar.h"
#import "TBTabButton.h"

//#import "NewsViewController.h"
#import "ShopListViewController.h"
#import "PurchasedHistoryViewController.h"
@class ShopListViewController;
@class PurchasedHistoryViewController;
@interface ShopViewController : UIViewController <TBTabBarDelegate>{
//    TBTabBar *tabBar;
}

@property (retain, nonatomic) TBTabBar *tabBar;
//@property (retain, nonatomic) NewsViewController *nv;
@property (retain, nonatomic) ShopListViewController *sv;
@property (retain, nonatomic) PurchasedHistoryViewController *phv;
@property (retain, nonatomic) TBViewController *vc3;
@property (retain, nonatomic) TBViewController *vc2;

@end
