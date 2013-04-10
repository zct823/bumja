//
//  FAQViewController.h
//  myjam
//
//  Created by ME-Tech Mac User 2 on 1/24/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"

@interface FAQViewController : UIViewController <UIScrollViewDelegate, UIWebViewDelegate>

@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivity;
@property (retain, nonatomic) IBOutlet UILabel *label;

@end
