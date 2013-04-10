//
//  FBDelegate.h
//  myjam
//
//  Created by Mohd Zulhilmi on 19/02/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@class FBLogInViewController;

@interface FBDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, retain) UIWindow *setUIWindow;
@property (nonatomic, retain) FBLogInViewController *fvliVC;

@property (nonatomic, retain) FBSession *fbSession;


@end
