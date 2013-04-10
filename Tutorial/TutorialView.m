//
//  TutorialView.m
//  myjam
//
//  Created by Mohd Hafiz on 1/31/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "TutorialView.h"
#import "AppDelegate.h"

@implementation TutorialView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Add Image view
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//        [imageView setImage:[UIImage imageNamed:@"tutorial"]];
        
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        
        if (screenBounds.size.height == 568) {
            // code for 4-inch screen
            [imageView setImage:[UIImage imageNamed:@"tutorial@2x"]];
        } else {
            // code for 3.5-inch screen
            [imageView setImage:[UIImage imageNamed:@"tutorial"]];
        }

        
        [self addSubview:imageView];
        [imageView release];
        
        UISwipeGestureRecognizer *swipeToLeft;
        swipeToLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(closeTutorial)];
        [swipeToLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
        [self addGestureRecognizer:swipeToLeft];
        [swipeToLeft release];
    }
    return self;
}

- (void)showTutorial
{
    self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self setHidden:NO];
    
    
    [UIView animateWithDuration:0.5f animations:^
     {
         [self setAlpha:1.0];
     }
                     completion:^(BOOL finished){}];
}

- (void)closeTutorial
{
    [UIView animateWithDuration:0.5f animations:^
     {
         self.frame = CGRectMake(-320, 0, self.frame.size.width, self.frame.size.height);
     }
                     completion:^(BOOL finished)
     {
         [self setAlpha:0.6];
         [self setHidden:YES];
         AppDelegate *mydelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
         mydelegate.swipeBottomEnabled = YES;
         [mydelegate showUpdateProfileDialog];
     }];
    
    
}

@end
