//
//  ShowSocialViewController.m
//  myjam
//
//  Created by nazri on 1/22/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "ShowSocialViewController.h"
#import "SocialViewController.h"
#import "FontLabel.h"

@interface ShowSocialViewController ()

@end

@implementation ShowSocialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.navigationItem.title = @"Create";
        
        //TITLE
        self.title = @"Create";
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
    [DejalBezelActivityView removeViewAnimated:YES];
}

- (IBAction)createSocial:(id)sender
{
    SocialViewController *svc = [[SocialViewController alloc] init];
    
    if ([self.fbButton isTouchInside]) {
        svc.socialUrl = @"https://www.facebook.com/";
        svc.socialType = @"Facebook";
    }
    if ([self.twButton isTouchInside]) {
        svc.socialUrl = @"https://twitter.com/";
        svc.socialType = @"Twitter";
    }
    if ([self.fsquareButton isTouchInside]) {
        svc.socialUrl = @"https://foursquare.com/";
        svc.socialType = @"Foursquare";
    }
    if ([self.utubeButton isTouchInside]) {
        svc.socialUrl = @"http://www.youtube.com/";
        svc.socialType = @"Youtube";
    }
    [self.navigationController pushViewController:svc animated:YES];
    [svc release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
