//
//  PhotoViewController.m
//  myjam
//
//  Created by Mohd Hafiz on 2/27/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "PhotoViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"

#define VIEW_FOR_ZOOM_TAG (1)

@interface PhotoViewController ()

@end

@implementation PhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(20,30,50,20);
    backButton.clipsToBounds = YES;
    backButton.backgroundColor = [UIColor clearColor];
    [backButton setShowsTouchWhenHighlighted:YES];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [backButton setTintColor:[UIColor whiteColor]];
    [backButton addTarget:self action:@selector(handleBackButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backButton];
    AppDelegate *mydelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.aImages = [mydelegate.arrayTemp copy];

//    self.aImages = [[NSArray alloc] init];
    UIView *photoView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, 320, self.view.frame.size.height-50-60)];
//    [photoView setBackgroundColor:[UIColor greenColor]];
    
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:photoView.bounds];
    mainScrollView.pagingEnabled = YES;
    mainScrollView.bounces = NO;
    mainScrollView.bouncesZoom = NO;
    mainScrollView.alwaysBounceHorizontal = NO;
    mainScrollView.alwaysBounceVertical = NO;
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.showsVerticalScrollIndicator = NO;
    
    CGRect innerScrollFrame = mainScrollView.bounds;
    
//    NSArray *imageArray = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"default_icon"],[UIImage imageNamed:@"blank_avatar"], [UIImage imageNamed:@"error_scanning"], nil];
    
    CGRect imgFrame = CGRectMake(0, 20, 320, 320);
    
    for (NSInteger i = 0; i < [self.aImages count]; i++) {
        UIImageView *imageForZooming = [[UIImageView alloc] initWithFrame:imgFrame];
//        [imageForZooming setImage:[self.aImages objectAtIndex:i]];
        [imageForZooming setImageWithURL:[NSURL URLWithString:[self.aImages objectAtIndex:i]]
                placeholderImage:[UIImage imageNamed:@"default_icon"]
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                           if (!error) {
                               //NSLog(@"success image %d",i);
                           }else{
                               //NSLog(@"error retrieve image: %@",error);
                           }
                           
                       }];
        imageForZooming.tag = VIEW_FOR_ZOOM_TAG;
        
        UIScrollView *pageScrollView = [[UIScrollView alloc] initWithFrame:innerScrollFrame];
        pageScrollView.minimumZoomScale = 1.0f;
        pageScrollView.maximumZoomScale = 2.0f;
        pageScrollView.zoomScale = 1.0f;
        pageScrollView.contentSize = imageForZooming.bounds.size;
        pageScrollView.delegate = self;
        pageScrollView.showsHorizontalScrollIndicator = NO;
        pageScrollView.showsVerticalScrollIndicator = NO;
        [pageScrollView addSubview:imageForZooming];
        
        [mainScrollView addSubview:pageScrollView];
        
        if (i < [self.aImages count]-1) {
            innerScrollFrame.origin.x += innerScrollFrame.size.width;
        }
    }
    
    [self.aImages release];
    mainScrollView.contentSize = CGSizeMake(innerScrollFrame.origin.x +
                                            innerScrollFrame.size.width, mainScrollView.bounds.size.height);
    
    // set autoscroll to selected photo
    [mainScrollView setContentOffset:CGPointMake(innerScrollFrame.size.width*mydelegate.indexTemp,0.0) animated:NO];
    
    mydelegate.indexTemp = 0;
//    [mydelegate.arrayTemp removeAllObjects];
    
    [photoView addSubview:mainScrollView];
    [mainScrollView release];
    [self.view addSubview:photoView];
    [photoView release];

}

#pragma mark -
#pragma mark scrollview delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [scrollView viewWithTag:VIEW_FOR_ZOOM_TAG];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)handleBackButton
{
    [self.view removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
