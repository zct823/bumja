//
//  HomeViewController.h
//  myjam
//
//  Created by nazri on 11/7/12.
//  Copyright (c) 2012 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBTabBar.h"
#import "TBTabButton.h"

//#import "StuffViewController.h"
//#import "EventsViewController.h"
#import "NewsViewController.h"
#import "AllViewController.h"
#import "PromotionsViewController.h"

@interface HomeViewController : UIViewController <TBTabBarDelegate> {
    TBTabBar *tabBar;
}

@property (retain, nonatomic) AllViewController *av;
@property (retain, nonatomic) NewsViewController *nv;
@property (retain, nonatomic) PromotionsViewController *pv;
@property (retain, nonatomic) TBViewController *vc1, *vc2, *vc3;

@end
