//
//  ProductReportViewController.h
//  myjam
//
//  Created by Azad Johari on 3/5/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJModel.h"
#import "CoreViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"
@interface ProductReportViewController : CoreViewController<UITextViewDelegate,UIPickerViewDelegate>
@property (nonatomic, retain) NSString* productId;
@property (nonatomic, retain) NSDictionary *reviewInfo;
@property (nonatomic, retain) NSString *reportId;
@property (retain, nonatomic) IBOutlet UILabel *productNameLabel;
- (IBAction)submitButtonPressed:(id)sender;
- (IBAction)buttonTapped:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *typeReportButton;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIImageView *productImage;
@property (retain, nonatomic) IBOutlet UITextView *remarksLabel;
@end
