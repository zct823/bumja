//
//  BoxViewController.h
//  myjam
//
//  Created by nazri on 11/7/12.
//  Copyright (c) 2012 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBTabBar.h"
#import "TBTabButton.h"
#import "JBoxViewController.h"
#import "ShareBoxViewController.h"
#import "FavBoxViewController.h"
#import "CreateBoxViewController.h"

@interface BoxViewController : UIViewController <TBTabBarDelegate> {
    TBTabBar *tabBar;
    TBViewController *vc1;
    TBViewController *vc2;
    TBViewController *vc3;
    TBViewController *vc4;
}

@property (nonatomic, retain) JBoxViewController *scanv;
@property (nonatomic, retain) ShareBoxViewController *sbvc;
@property (nonatomic, retain) FavBoxViewController *fbvc;
@property (nonatomic, retain) CreateBoxViewController *cbvc;

@end
