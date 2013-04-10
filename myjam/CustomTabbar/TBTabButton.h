//
//  TBTabButton.h
//  TweetBotTabBar
//
//  Created by Jerish Brown on 6/27/11.
//  Copyright 2011 i3Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBViewController.h"
#import "TBTabNotification.h"

@interface TBTabButton : NSObject {
    UIImage *icon;
    NSString *_title;
    UIImage *highlightedIcon;
    NSMutableArray *_notifications;
    TBViewController *_viewController;
    TBTabNotification *_light;
}

@property (retain) UIImage *icon;
@property (retain) NSString *title;
@property (retain) UIImage *highlightedIcon;
@property (retain, nonatomic) TBViewController *viewController;

-(id)initWithIcon:(UIImage*)icon;
-(id)initWithTitle:(NSString *)aTitle;

-(void)addNotification:(NSDictionary *)notif;
-(void)removeNotificationAtIndex:(NSUInteger)index;
-(void)clearNotifications;
-(NSInteger)notificationCount;

-(TBTabNotification*)notificationView;

@end
