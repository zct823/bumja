//
//  NMTabViewController.m
//  myjam
//
//  Created by Mohd Zulhilmi on 29/03/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "NMTabViewController.h"
#import "NearMeViewController.h"

@interface NMTabViewController ()

@end

@implementation NMTabViewController

@synthesize nmtab2, tb1, tb2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        FontLabel *titleViewUsingFL = [[FontLabel alloc] initWithFrame:CGRectZero fontName:@"jambu-font.otf" pointSize:22];
        titleViewUsingFL.text = @"Near Me";
        titleViewUsingFL.textAlignment = NSTextAlignmentCenter;
        titleViewUsingFL.backgroundColor = [UIColor clearColor];
        titleViewUsingFL.textColor = [UIColor whiteColor];
        [titleViewUsingFL sizeToFit];
        self.navigationItem.titleView = titleViewUsingFL;
        [titleViewUsingFL release];
        
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
    // Do any additional setup after loading the view from its nib.
    
    // CGRect for adjusting 3.5-inch and 4-inch support
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    if (screenBounds.size.height == 568) {
        // code for 4-inch screen
        self.view.frame = CGRectMake(0,0,self.view.bounds.size.width, 568);
    } else {
        // code for 3.5-inch screen
        self.view.frame = CGRectMake(0,0,self.view.bounds.size.width, 480);
    }
    
    CGRect innerViewFrame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height-(TBTB.frame.size.height)-60);
    
    NearMeViewController *nmtab1 = [[NearMeViewController alloc] init];
    nmtab1.view.frame = innerViewFrame;
    nmtab2 = [[NMProductListsViewController alloc] init];
    nmtab2.view.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height-(TBTB.frame.size.height)-60);
    
    tb1 = [[[TBViewController alloc] init]autorelease];
    [tb1.view addSubview:nmtab1.view];
    tb2 = [[[TBViewController alloc] init] autorelease];
    [tb2.view addSubview:nmtab2.view];
    
    TBTabButton *t1 = [[TBTabButton alloc] initWithTitle:@"Map"];
    t1.viewController = tb1;
    TBTabButton *t2 = [[TBTabButton alloc] initWithTitle:@"List"];
    t2.viewController = tb2;
    
    NSArray *a = [NSArray arrayWithObjects:t1,t2, nil];
    
    TBTB = [[TBTabBar alloc] initWithFrame:CGRectMake(0, 0, 330, 36) andItems:a];
    
    TBTB.delegate = self;
    [self.view addSubview:TBTB];
    [TBTB showDefaults];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    myDelegate.swipeOptionString = @"nearMe";
    myDelegate.swipeBottomEnabled = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)switchViewController:(UIViewController *)viewController
{
    UIView *currentView = [self.view viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];
    
    [currentView removeFromSuperview];
    
    viewController.view.frame = CGRectMake(0,28,self.view.bounds.size.width, self.view.bounds.size.height-(TBTB.frame.size.height)-24);
    
    viewController.view.tag = SELECTED_VIEW_CONTROLLER_TAG;
    [self.view insertSubview:viewController.view belowSubview:TBTB];
}

- (void)viewDidDisappear:(BOOL)animated
{
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    [myDelegate.nearMeBtn setHidden:NO];
    myDelegate.swipeBottomEnabled = NO;
}

@end
