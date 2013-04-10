//
//  Banner.m
//  myjam
//
//  Created by Mohd Hafiz on 1/29/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "Banner.h"
#import "ASIWrapper.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define kAnimateDuration 15

@implementation Banner

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        [self setup];
    }
    return self;
}

- (void)setup
{
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    imageView.userInteractionEnabled = YES;
//    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
    [imageView release];
    
    [NSTimer scheduledTimerWithTimeInterval:kAnimateDuration
                                     target:self
                                   selector:@selector(animateFunction)
                                   userInfo:nil
                                    repeats:YES];
}

-(void)animateFunction
{
    [self performSelectorInBackground:@selector(refreshBanner) withObject:nil];
}

- (void)refreshBanner
{
    NSString *urlString = [NSString stringWithFormat:@"%@/api/jambu_ads.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"] copy]];
    
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:@""];
//    //NSLog(@"request %@\n\nresponse data: %@", urlString, response);
    NSDictionary *resultsDictionary = [[response objectFromJSONString] copy];
//    //NSLog(@"dict %@",resultsDictionary);
    
    NSString *uri = @"";
    if([resultsDictionary count])
    {
        NSString *status = [resultsDictionary objectForKey:@"status"];
        if ([status isEqualToString:@"ok"])
        {
            uri = [resultsDictionary objectForKey:@"banner_image"];
            webURL = [resultsDictionary objectForKey:@"banner_url"];
            
//            ASIHTTPRequest *imageRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:uri]];
//            [imageRequest setDelegate:self];
//            [imageRequest startSynchronous];
//            [imageRequest setTimeOutSeconds:2];
//            
//            [imageRequest release];
            [imageView setImageWithURL:[NSURL URLWithString:uri]
                    placeholderImage:[UIImage imageNamed:@"ad4.png"]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                               if (!error) {
                                   [self addURLImage];
                               }else{
//                                   //NSLog(@"error retrieve image: %@",error);
                                   [self addURLImageDefault];
                               }
                               
                           }];
            
        }else{
//            //NSLog(@"Error retrieve api data");
            //            [imageView setImage:[UIImage imageNamed:@"ad4.png"]];
        }
    }

}

- (void)addURLImageDefault
{
    webURL = APP_API_URL;
    UITapGestureRecognizer *urlTapRecognizer;
    urlTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleClickAds)];
    [imageView addGestureRecognizer:urlTapRecognizer];
    
    [urlTapRecognizer release];
}

- (void)addURLImage
{
    
    UITapGestureRecognizer *urlTapRecognizer;
    urlTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleClickAds)];
    [imageView addGestureRecognizer:urlTapRecognizer];

    [urlTapRecognizer release];
}

- (void)handleClickAds
{
    NSURL *url = [NSURL URLWithString:webURL];
    
    if (![[UIApplication sharedApplication] openURL:url])
        NSLog(@"Failed to open url: %@",[url description]);
}

//#pragma mark -
//#pragma mark ASIHTTPRequestDelegate
//
//- (void)requestFinished:(ASIHTTPRequest *)request
//{
//    //NSLog(@"request done");
//    UIImage *aImg = [[UIImage alloc] initWithData:[request responseData]];
//    [imageView setImage:aImg];
//    
//    [self addURLImage];
//    
//    [aImg release];
//}

//- (void)requestFailed:(ASIHTTPRequest *)request
//{
//    NSError *error = [request error];
//    //NSLog(@"error retrieve image: %@",error);
//}

@end
