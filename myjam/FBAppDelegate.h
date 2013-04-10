//
//  FBAppDelegate.h
//  myjam
//
//  Note:
//  This is AppDelegate specific for Facebook only
//  by using UIResponder handler interface.
//  Purposes of this file are to shut up the Warning Issue mouth
//  and to give proper UX Facebook support.
//
//  Created by Mohd Zulhilmi on 20/02/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FBAppDelegate : UIResponder <UIApplicationDelegate>

extern NSString *const FBSessionStateChangedNotification;

@property (nonatomic, retain) NSString *fbStatus; // fb status

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI; // fb login

@end
