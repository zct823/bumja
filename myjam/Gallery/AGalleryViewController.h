//
//  MoreViewController.h
//  myjam
//
//  Created by nazri on 12/20/12.
//  Copyright (c) 2012 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MData.h"
#import "Carousel.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <MessageUI/MessageUI.h>


@interface AGalleryViewController : UIViewController <MFMailComposeViewControllerDelegate>
{
    SLComposeViewController *mySLComposerSheet;
    BOOL popDisabled;
    NSString *errorMessage;
    CGFloat currentHeight;
}

@property BOOL noInternetConnection;
@property (retain, nonatomic) UILabel *providerLabel;
@property (nonatomic, retain) NSString *qrcodeId;
@property (nonatomic, retain) MData *detailsData;
@property (retain, nonatomic) UIScrollView *scroller;
@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) UIView *aDescriptionView;
@property (retain, nonatomic) NSMutableArray *aImages;

@property (retain, nonatomic) UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UIView *shareView;
@property (retain, nonatomic) IBOutlet UIButton *shareFBButton;
@property (retain, nonatomic) IBOutlet UIButton *shareTwitterButton;
@property (retain, nonatomic) IBOutlet UIButton *shareEmailButton;
@property (retain, nonatomic) IBOutlet UIView *blankView;
@property (retain, nonatomic) IBOutlet UILabel *label;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activity;


@end
