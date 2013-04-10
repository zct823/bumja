//
//  AboutViewController.m
//  myjam
//
//  Created by ME-Tech Mac User 2 on 1/24/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "AboutViewController.h"
#import "AppDelegate.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"About";
        FontLabel *titleView = [[FontLabel alloc] initWithFrame:CGRectZero fontName:@"jambu-font.otf" pointSize:22];
        titleView.text = self.title;
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
    // Do any additional setup after loading the view from its nib.
    
    self.webView.delegate = self;
    [self.webView setHidden:YES];
    [[self.webView scrollView] setBounces:NO];
    [self loadWebPage];
}

- (void)loadWebPage
{
    NSString *urlAddress = @"http://jam-bu.com/api/content/about.php";
    
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [self.webView loadRequest:requestObj];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.webView setHidden:NO];
    NSLog(@"done");
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Failed: %@",error);
    [self.webView setHidden:YES];
    [self.loadingActivity setHidden:YES];
    self.label.text = @"Connection Error. Please tap to retry.";
    
    UITapGestureRecognizer *tapToReload = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadWebPage)];
    [self.view addGestureRecognizer:tapToReload];
    [tapToReload release];
}

- (void)reloadWebPage
{
    NSLog(@"reload");
    [self.loadingActivity setHidden:NO];
    self.label.text = @"Loading ...";
    
    [self loadWebPage];
}

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        //NSLog(@"NO :%@",inRequest);
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *mydelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    if (!mydelegate.isMustCloseSidebar) {
        [mydelegate openSidebar];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_loadingActivity release];
    [_label release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setLoadingActivity:nil];
    [self setLabel:nil];
    [super viewDidUnload];
}
@end
