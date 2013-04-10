//
//  SettingsViewController.h
//  myjam
//
//  Created by Mohd Zulhilmi on 14/02/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBTabBar.h"
#import "TBTabButton.h"

#import "NewsPreferenceViewController.h"
#import "UJliteProfileViewController.h"
#import "AppDelegate.h"

@interface SettingsViewController : UIViewController <TBTabBarDelegate> {
    TBTabBar *TBTB;
}

@property (nonatomic, retain) UJliteProfileViewController *s2;
@property (nonatomic, retain) NewsPreferenceViewController *s1;
@property (nonatomic, retain) TBViewController *tb1, *tb2;
@property BOOL updateProfile;

@end
