//
//  HomeViewController.m
//  myjam
//
//  Created by nazri on 11/7/12.
//  Copyright (c) 2012 me-tech. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize av, nv, pv, vc1, vc2, vc3;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        FontLabel *titleView = [[FontLabel alloc] initWithFrame:CGRectZero fontName:@"jambu-font.otf" pointSize:22];
        titleView.text = @"JAM-BU Feed";
        titleView.textAlignment = NSTextAlignmentCenter;
        titleView.backgroundColor = [UIColor clearColor];
        titleView.textColor = [UIColor whiteColor];
        [titleView sizeToFit];
        self.navigationItem.titleView = titleView;
        [titleView release];

        
        self.navigationItem.backBarButtonItem =
        [[[UIBarButtonItem alloc] initWithTitle:@"Back"
                                          style:UIBarButtonItemStyleBordered
                                         target:nil
                                         action:nil] autorelease];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Setup screen for retina 4
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    if (screenBounds.size.height == 568) {
        // code for 4-inch screen
        self.view.frame = CGRectMake(0,0,self.view.bounds.size.width, 568);
    } else {
        // code for 3.5-inch screen
        self.view.frame = CGRectMake(0,0,self.view.bounds.size.width, 480);
    }
    
    CGRect innerViewFrame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height-(tabBar.frame.size.height)-26);
    
    av = [[AllViewController alloc] init];
    av.view.frame = innerViewFrame;
    nv = [[NewsViewController alloc] init];
    nv.view.frame = innerViewFrame;
    pv = [[PromotionsViewController alloc] init];
    pv.view.frame = innerViewFrame;
    
    vc1 = [[[TBViewController alloc] init] autorelease];
    [vc1.view addSubview:av.view];
    vc2 = [[[TBViewController alloc] init] autorelease];
    [vc2.view addSubview:nv.view];
    vc3 = [[[TBViewController alloc] init] autorelease];
    [vc3.view addSubview:pv.view];
    
    TBTabButton *t1 = [[TBTabButton alloc] initWithTitle:@"All"];
    t1.viewController = vc1;
    TBTabButton *t2 = [[TBTabButton alloc] initWithTitle:@"News"];
    t2.viewController = vc2;
    TBTabButton *t3 = [[TBTabButton alloc] initWithTitle:@"Promotions"];
    t3.viewController = vc3;

    NSArray *a = [NSArray arrayWithObjects:t1, t2, t3, nil];
    
    tabBar = [[TBTabBar alloc] initWithItems:a];
    
    tabBar.delegate = self;
    [self.view addSubview:tabBar];
    [tabBar showDefaults];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)switchViewController:(UIViewController *)viewController {
    UIView *currentView = [self.view viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];
//    currentView = nil;
    [currentView removeFromSuperview];
    AppDelegate *mydelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (viewController == vc1 || viewController == vc2 || viewController == vc3) {
        //NSLog(@"Enable bottom view for JAM-BU Feed");
        mydelegate.swipeBottomEnabled = YES;
        if (viewController == vc1) {
            //NSLog(@"ALL");
            mydelegate.swipeController = kAll;
            mydelegate.swipeOptionString = @"home-all";
        } else if (viewController == vc2) {
            mydelegate.swipeController = kNews;
            mydelegate.swipeOptionString = @"home-news";
        } else if (viewController == vc3) {
            mydelegate.swipeController = kPromotion;
            mydelegate.swipeOptionString = @"home-promo";
        }
    }else{
        //NSLog(@"Bottom view disabled");
        mydelegate.swipeBottomEnabled = NO;
    }

    viewController.view.frame = CGRectMake(0,28,self.view.bounds.size.width, self.view.bounds.size.height-(tabBar.frame.size.height)-24);
    
    viewController.view.tag = SELECTED_VIEW_CONTROLLER_TAG;
    [self.view insertSubview:viewController.view belowSubview:tabBar];
    
}

//- (void)viewWillAppear:(BOOL)animated{
//    [self.navigationController popToRootViewControllerAnimated:NO];
//}

- (void)viewDidAppear:(BOOL)animated{
    
    AppDelegate *mydelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    mydelegate.swipeBottomEnabled = YES;
    // Mark current page
    mydelegate.pageIndex = kHomeTab;

//    [tabBar showDefaults];
    [self animateAds];
    
    [DejalBezelActivityView removeViewAnimated:YES];
    
    NSUserDefaults *localData = [NSUserDefaults standardUserDefaults];
    NSString *isDisplay = [localData objectForKey:@"isDisplayTutorial"];
    
    NSString *counterKey = [NSString stringWithFormat:@"counter%@",[localData objectForKey:@"tokenString"]];
    NSString *counter = [localData objectForKey:counterKey];
    int countI = [counter intValue];
    //NSLog(@"Home counter: %@",counter);
    
    if ([isDisplay isEqualToString:@"YES"] && countI < 500)
    {
        [self displayTutorial];
        [localData setObject:@"NO" forKey:@"isDisplayTutorial"];
    }
    else{
        // Show if less then 5th times
        if (countI <= 5) {
//            [self performSelector:@selector(displayTutorial) withObject:nil afterDelay:0.3];
            [self displayTutorial];
            [localData setObject:[NSString stringWithFormat:@"%d",++countI] forKey:counterKey];
        }
        else{
            [mydelegate showUpdateProfileDialog];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
//    [self.navigationController popToRootViewControllerAnimated:NO];
    
    AppDelegate *myDel = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    myDel.swipeOptionString = nil;
}

- (void)displayTutorial
{
    AppDelegate *mydelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    mydelegate.swipeBottomEnabled = NO;
    [mydelegate.tutorial showTutorial];
}

- (void)animateAds
{
    //NSLog(@"viewwillAappearHome: enable bottom view for news");
    AppDelegate *mydelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [mydelegate.bannerView animateFunction];
}

- (void)viewDidDisappear:(BOOL)animated{
    //NSLog(@"viewwilldisappearHome: disable bottom view");
    AppDelegate *mydelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    mydelegate.swipeBottomEnabled = NO;
}

@end
