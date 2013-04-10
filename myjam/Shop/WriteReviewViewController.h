//
//  WriteReviewViewController.h
//  myjam
//
//  Created by Azad Johari on 2/1/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "MJModel.h"
#import "CoreViewController.h"
#import "RateView.h"
#import "AppDelegate.h"
#import "MarqueeLabel.h"


@interface WriteReviewViewController : CoreViewController<UITextViewDelegate,RateViewDelegate>
@property (retain, nonatomic) NSDictionary *productInfo;
@property (retain, nonatomic) NSString *ratingValue;

@property (retain, nonatomic) IBOutlet UILabel *shopName;
@property (retain, nonatomic) IBOutlet UIImageView *lineMiddle;

@property (retain, nonatomic) IBOutlet UILabel *productName;
@property (retain, nonatomic) IBOutlet UITextView *productReview;
//@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet RateView *rateView;

@property (nonatomic, retain) IBOutlet UIView *scrollView;
@property (nonatomic, retain) TPKeyboardAvoidingScrollView *scroller;

- (IBAction)submitReview:(id)sender;
- (IBAction)visitShop:(id)sender;
@end
