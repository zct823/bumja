//
//  DetailProductViewController.h
//  myjam
//
//  Created by Azad Johari on 1/30/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Carousel.h"
#import "ProductRatingListViewController.h"
#import "AppDelegate.h"
#import "CheckoutViewController.h"
#import "CoreViewController.h"
#import "MJModel.h"
#import "SizeSelectView.h"
#import "ColorSelectView.h"
#import "SizeSelectionCell.h"
#import "ColorSelectionCell.h"
#import "ProductHeaderView.h"
#import "BuyNowCell.h"
#import "PurchaseVerificationCell.h"
#import "NSString+StripeHTML.h"
#import "SidebarView.h"
#import "ProductReportViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ReportSpamViewController.h"

@interface DetailProductViewController : CoreViewController<ImageSliderDelegate, SizeSelectViewDelegate,ColorSelectViewDelegate,UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate,UIWebViewDelegate,UIWebViewDelegate>
{
    Carousel *carousel;
    int imgCounter;
    CGFloat currentHeight;
    
}
@property (retain, nonatomic) NSString *productId;
@property (retain, nonatomic) NSString *orderId;

@property (retain, nonatomic) NSString *cartId;
@property (retain, nonatomic) ProductHeaderView *headerView;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet ColorSelectView *colorSelectView;
@property (retain, nonatomic) IBOutlet SizeSelectView *sizeView;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) NSMutableArray *aImages;
@property (retain, nonatomic) NSDictionary *productInfo;
@property (assign, nonatomic) int counter;
@property (retain, nonatomic) IBOutlet UITextView *productDesc;
@property (retain, nonatomic) NSString *selectedSize;
@property (retain, nonatomic) NSString *selectedColor;
@property (retain, nonatomic) NSString *buyButton;
@property (retain, nonatomic) NSMutableArray *tempColorsForSize;
@property (retain, nonatomic) NSMutableArray *tempSizesForColor;
@property (retain, nonatomic) NSString *purchasedString;
@property (retain, nonatomic) IBOutlet UILabel *descLabel;
@property (retain, nonatomic) IBOutlet UIView *bottomView;
- (IBAction)facebookPressed:(id)sender;
- (IBAction)twitterPressed:(id)sender;
- (IBAction)emailPressed:(id)sender;

-(IBAction)readReviews;
- (IBAction)reportProduct:(id)sender;

@end
