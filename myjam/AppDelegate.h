//
//  AppDelegate.h
//  myjam
//
//  Created by nazri on 11/7/12.
//  Copyright (c) 2012 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTabBar.h"
#import "SidebarView.h"
#import "BottomSwipeView.h"
#import "BottomSwipeViewNews.h"
#import "BottomSwipeViewPromo.h"
#import "BottomSwipeViewScanBox.h"
#import "BottomSwipeViewShareBox.h"
#import "BottomSwipeViewFavBox.h"
#import "BottomSwipeViewCreateBox.h"
#import "BottomSwipeViewJShop.h"
#import "BottomSwipeViewJSPurchase.h"
#import "HomeViewController.h"
#import "Banner.h"
#import "CustomBadge.h"
#import "TutorialView.h"
#import "NMTabViewController.h"

//#import "ContactViewController.h"
@class SidebarView;
@interface AppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
	GTabBar *tabView;
    UIView *frontLayerView;
    int LayerOption;
    BOOL showCamera;
    UIView *blackView;
    CGRect screenBounds;
}

@property (nonatomic, retain) UINavigationController* shopNavController;
@property (nonatomic, retain) UINavigationController* scanNavController;
@property (nonatomic, retain) UINavigationController* boxNavController;
@property (nonatomic, retain) UINavigationController* homeNavController;
@property (nonatomic, retain) UINavigationController* otherNavController;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) SidebarView *sidebarController;
@property (nonatomic, retain) BottomSwipeView *bottomSVAll;
@property (nonatomic, retain) BottomSwipeViewNews *bottomSVNews;
@property (nonatomic, retain) BottomSwipeViewPromo *bottomSVPromo;
@property (nonatomic, retain) BottomSwipeViewScanBox *bottomSVScanBox;
@property (nonatomic, retain) BottomSwipeViewShareBox *bottomSVShareBox;
@property (nonatomic, retain) BottomSwipeViewFavBox *bottomSVFavBox;
@property (nonatomic, retain) BottomSwipeViewCreateBox *bottomSVCreateBox;
@property (nonatomic, retain) BottomSwipeViewJShop *bottomSVJShop;
@property (nonatomic, retain) BottomSwipeViewJSPurchase *bottomSVJSPurchase;
@property (nonatomic, retain) GTabBar *tabView;
@property (nonatomic, retain) Banner *bannerView;
@property (nonatomic, retain) TutorialView *tutorial;
@property (nonatomic, retain) NSString *swipeOptionString;
@property (nonatomic, retain) NSMutableArray *arrayTemp;
@property (nonatomic, retain) CustomBadge *cartCounter;
@property (nonatomic, retain) UIButton *nearMeBtn;

//For Near Me Use
@property (nonatomic) double currentLat;
@property (nonatomic) double currentLong;
@property (nonatomic) NSInteger withRadius;
@property (nonatomic) NSInteger currentDecDegree;

@property int indexTemp;
@property int swipeController;
@property int pageIndex;
@property BOOL isCheckoutFromSideBar;
@property BOOL isMustCloseSidebar;
@property BOOL isFromScannerTab;
@property BOOL isReturnFromPayment;
@property BOOL isShowPurchaseHistory;

@property BOOL isSetupDone;
@property BOOL sideBarOpen;
@property BOOL bottomViewOpen;
@property BOOL swipeBottomEnabled;

- (void)openSidebar;
- (void)closeSidebar;
- (void)setupViews;
- (void)handleTab5;
- (void)handleSwipeUp;
- (void)presentLoginPage;
- (void)clearViews;

- (void)closeSession; //fb login
- (void)removeCustomBadge;
- (void)setCustomBadgeWithText:(NSString *)text;
- (void)showUpdateProfileDialog;

@end
