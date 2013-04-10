//
//  BoxViewController.m
//  myjam
//
//  Created by nazri on 11/7/12.
//  Copyright (c) 2012 me-tech. All rights reserved.
//

#import "BoxViewController.h"
#import "MoreViewController.h"
#import "AppDelegate.h"

@interface BoxViewController ()

@end

@implementation BoxViewController

@synthesize scanv,sbvc,fbvc,cbvc;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        FontLabel *titleView = [[FontLabel alloc] initWithFrame:CGRectZero fontName:@"jambu-font.otf" pointSize:22];
        titleView.text = @"JAM-BU Box";
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

- (void)viewDidAppear:(BOOL)animated
{
//    [self performSelector:@selector(animateAds) withObject:nil afterDelay:2.0];
//    [self performSelectorInBackground:@selector(animateAds) withObject:nil];
    [self animateAds];
    //--- activating SwipeBottomBox
    
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    // Mark current page
    myDelegate.pageIndex = kBoxTab;
    
    myDelegate.swipeBottomEnabled = YES;
    myDelegate.swipeOptionString = @"scan";
    
    //--- end activating SwipeBottomBox
    
//    [tabBar showDefaults];
}

- (void)animateAds
{
    //NSLog(@"viewwillAappearHome: enable bottom view for news");
    AppDelegate *mydelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [mydelegate.bannerView animateFunction];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
//    [self.navigationController popToRootViewControllerAnimated:NO];
//    [self checkIsDetailsViewInStack];
	// Do any additional setup after loading the view, typically from a nib.
    
    scanv = [[JBoxViewController alloc] init];
    scanv.view.frame = innerViewFrame;
    
    sbvc = [[ShareBoxViewController alloc] init];
    sbvc.view.frame = innerViewFrame;
    
    fbvc = [[FavBoxViewController alloc] init];
    fbvc.view.frame = innerViewFrame;
    
    cbvc = [[CreateBoxViewController alloc] init];
    cbvc.view.frame = innerViewFrame;
    
    vc1 = [[[TBViewController alloc] init] autorelease];
    [vc1.view addSubview:scanv.view];
    vc2 = [[[TBViewController alloc] init] autorelease];
    [vc2.view addSubview:sbvc.view];
    vc3 = [[[TBViewController alloc] init] autorelease];
    [vc3.view addSubview:fbvc.view];
    vc4 = [[[TBViewController alloc] init] autorelease];
    [vc4.view addSubview:cbvc.view];
    
    TBTabButton *t1 = [[TBTabButton alloc] initWithTitle:@"Scan Box"];
    t1.viewController = vc1;
    TBTabButton *t2 = [[TBTabButton alloc] initWithTitle:@"Share Box"];
    t2.viewController = vc2;
    TBTabButton *t3 = [[TBTabButton alloc] initWithTitle:@"Fav Box"];
    t3.viewController = vc3;
    TBTabButton *t4 = [[TBTabButton alloc] initWithTitle:@"Create Box"];
    t4.viewController = vc4;
    NSArray *a = [NSArray arrayWithObjects:t1, t2, t3, t4, nil];
    
    tabBar = [[TBTabBar alloc] initWithItems:a];
    
    tabBar.delegate = self;
    [self.view addSubview:tabBar];
    [tabBar showDefaults];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    AppDelegate *mainVC = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    mainVC.swipeBottomEnabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)switchViewController:(UIViewController *)viewController {
    
    //NSLog(@"switch vc in box");
    
    AppDelegate *myDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(viewController == vc1)
    {
        myDel.swipeOptionString = @"scan";
    }
    else if(viewController == vc2)
    {
        myDel.swipeOptionString = @"share";
    }
    else if(viewController == vc3)
    {
        myDel.swipeOptionString = @"favourite";
    }
    else if(viewController == vc4)
    {
        myDel.swipeOptionString = @"create";
    }
    
    UIView *currentView = [self.view viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];
    [currentView removeFromSuperview];
    
    viewController.view.frame = CGRectMake(0,28,self.view.bounds.size.width, self.view.bounds.size.height-(tabBar.frame.size.height)-24);
    
    viewController.view.tag = SELECTED_VIEW_CONTROLLER_TAG;
    [self.view insertSubview:viewController.view belowSubview:tabBar];
    
}
@end
