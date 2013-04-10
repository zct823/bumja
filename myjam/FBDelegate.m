//
//  FBDelegate.m
//  myjam
//
//  Created by Mohd Zulhilmi on 19/02/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "FBDelegate.h"
#import "FBLogInViewController.h"

@implementation FBDelegate

@synthesize setUIWindow = _setUIWindow;
@synthesize fvliVC = _fvliVC;
@synthesize fbSession = _fbSession;

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [self.fbSession handleOpenURL:url];
}

- (void)applicationWillTerminate:(UIApplication *)application {

    [self.fbSession close];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.fvliVC = [[FBLogInViewController alloc] initWithNibName:@"SLViewController_iPhone" bundle:nil];
    }
    self.window.rootViewController = self.fvliVC;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBSession.activeSession handleDidBecomeActive];
}


@end
