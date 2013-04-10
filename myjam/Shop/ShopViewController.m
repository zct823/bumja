//
//  ShopViewController.m
//  myjam
//
//  Created by nazri on 11/7/12.
//  Copyright (c) 2012 me-tech. All rights reserved.
//

#import "ShopViewController.h"
#import "AppDelegate.h"
@interface ShopViewController ()

@end

@implementation ShopViewController

@synthesize sv, vc3, vc2, phv, tabBar;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"JAM-BU Shop";
        FontLabel *titleView = [[FontLabel alloc] initWithFrame:CGRectZero fontName:@"jambu-font.otf" pointSize:22];
        titleView.text = self.title;
        titleView.textAlignment = NSTextAlignmentCenter;
        titleView.backgroundColor = [UIColor clearColor];
        titleView.textColor = [UIColor whiteColor];
        [titleView sizeToFit];
        self.navigationItem.titleView = titleView;
        [titleView release];
//        self.tabBarItem.image = [UIImage imageNamed:@"apple"];
        
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
    //--- activating SwipeBottomBox
    
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    // Mark current page
    myDelegate.pageIndex = kShopTab;
    
    myDelegate.swipeBottomEnabled = YES;
    myDelegate.swipeOptionString = @"shop";
    
    //--- end activating SwipeBottomBox
    
//    [tabBar showDefaults];
}

- (void)viewDidLoad
{ // Setup screen for retina 4
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    if (screenBounds.size.height == 568) {
        // code for 4-inch screen
        self.view.frame = CGRectMake(0,0,self.view.bounds.size.width, 568);
    } else {
        // code for 3.5-inch screen
        self.view.frame = CGRectMake(0,0,self.view.bounds.size.width, 480);
    }
    
    CGRect innerViewFrame = CGRectMake(0,5,self.view.frame.size.width, self.view.frame.size.height-(tabBar.frame.size.height)-26);
    
    
   
    sv = [[ShopListViewController alloc] init];
    sv.view.frame = innerViewFrame;
    phv = [[PurchasedHistoryViewController alloc] init];
    phv.view.frame = innerViewFrame;
    

   vc2 = [[TBViewController alloc] init];
    [vc2.view addSubview:sv.view];
    vc3 = [[[TBViewController alloc] init] autorelease];
    [vc3.view addSubview:phv.view];
   
    TBTabButton *t2 = [[TBTabButton alloc] initWithTitle:@"Shop"];
    t2.viewController = vc2;
    TBTabButton *t3 = [[TBTabButton alloc] initWithTitle:@"Purchased"];
    t3.viewController = vc3;

    NSArray *a = [[NSArray alloc]initWithObjects:t2, t3, nil];
    
    tabBar = [[TBTabBar alloc] initWithItems:a];
    
    tabBar.delegate = self;
    [self.view addSubview:tabBar];
    [tabBar showDefaults];

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
//- (void)viewDidAppear:(BOOL)animated
//{   
//   // [tabBar showDefaults];
//
//}

- (void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *mydelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    mydelegate.swipeBottomEnabled = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    //NSLog(@"vwa shop");
    AppDelegate *mydelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    mydelegate.swipeBottomEnabled = YES;
//    [self.navigationController popToRootViewControllerAnimated:NO];
    [DejalBezelActivityView removeViewAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)switchViewController:(UIViewController *)viewController {
    
    //NSLog(@"switch vc in box");
    
    AppDelegate *myDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(viewController == vc2)
    {
        myDel.swipeOptionString = @"shop";
    }
    else if(viewController == vc3)
    {
        myDel.swipeOptionString = @"purchase";
    }
    
    UIView *currentView = [self.view viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];
        currentView = nil;
    [currentView removeFromSuperview];
    AppDelegate *mydelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    mydelegate.swipeBottomEnabled = YES;
    if (viewController == vc2) {
        //NSLog(@"Enable bottom view for Shops");
     //   mydelegate.currentPage = kShop;
        
    }else{
        //NSLog(@"Enable bottom view for Shops");
      //  mydelegate.currentPage = kPurchased;
    }
    
    viewController.view.frame = CGRectMake(0,22,self.view.bounds.size.width, self.view.bounds.size.height-(tabBar.frame.size.height)-24);
    
    viewController.view.tag = SELECTED_VIEW_CONTROLLER_TAG;
    [self.view insertSubview:viewController.view belowSubview:tabBar];
    
}
-(void)dealloc{
    [super dealloc];
    [sv release];
    [phv release];
    [vc3 release];
    [vc2 release];
}
@end
