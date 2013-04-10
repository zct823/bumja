//
//  NMTabViewController.h
//  myjam
//
//  Created by Mohd Zulhilmi on 29/03/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBTabBar.h"
#import "TBTabButton.h"
#import "NMProductListsViewController.h"

@interface NMTabViewController : UIViewController <TBTabBarDelegate>
{
    TBTabBar *TBTB;
}

//@property (nonatomic, retain) NearMeViewController *nmtab1;
@property (nonatomic, retain) NMProductListsViewController *nmtab2;
@property (nonatomic, retain) TBViewController *tb1, *tb2;

@end

@class NearMeViewController ;
