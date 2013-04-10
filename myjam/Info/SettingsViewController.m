//
//  SettingsViewController.m
//  myjam
//
//  Created by Mohd Zulhilmi on 14/02/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize tb1, tb2, s1, s2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        FontLabel *titleViewUsingFL = [[FontLabel alloc] initWithFrame:CGRectZero fontName:@"jambu-font.otf" pointSize:22];
        titleViewUsingFL.text = @"Settings";
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
    
    CGRect innerViewFrame = CGRectMake(0,15,self.view.frame.size.width, self.view.frame.size.height-(TBTB.frame.size.height)-62);
    
    s1 = [[NewsPreferenceViewController alloc] init];
    s1.view.frame = innerViewFrame;
    s2 = [[UJliteProfileViewController alloc] init];
    s2.view.frame = CGRectMake(0,15+85,self.view.frame.size.width, self.view.frame.size.height-(TBTB.frame.size.height)-62);
    
    tb1 = [[[TBViewController alloc] init]autorelease];
    [tb1.view addSubview:s1.view];
    tb2 = [[[TBViewController alloc] init] autorelease];
    [tb2.view addSubview:s2.view];
    
    TBTabButton *t1 = [[TBTabButton alloc] initWithTitle:@"JAM-BU News\n Preference"];
    t1.viewController = tb1;
    TBTabButton *t2 = [[TBTabButton alloc] initWithTitle:@"Update Jambulite\n Profile"];
    t2.viewController = tb2;
    
    NSArray *a = [NSArray arrayWithObjects:t1,t2, nil];
    
    TBTB = [[TBTabBar alloc] initWithFrame:CGRectMake(0, 0, 320, 50) andItems:a];
    
    TBTB.delegate = self;
    [self.view addSubview:TBTB];
    
    if (self.updateProfile) {
        [TBTB showViewControllerAtIndex:1];
    }else{
        [TBTB showDefaults];
    }
    
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
    
    //AppDelegate *delegasiDrpdApp = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    viewController.view.frame = CGRectMake(0,28,self.view.bounds.size.width, self.view.bounds.size.height-(TBTB.frame.size.height)-24);
    
    viewController.view.tag = SELECTED_VIEW_CONTROLLER_TAG;
    [self.view insertSubview:viewController.view belowSubview:TBTB];
}

@end
