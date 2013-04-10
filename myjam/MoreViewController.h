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
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "Contact.h"
#import "FavFolderViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "UnFollowViewController.h"
#import "ReportSpamViewController.h"

@interface MoreViewController : UIViewController <ImageSliderDelegate, MFMailComposeViewControllerDelegate, EKEventEditViewDelegate>
{
    Carousel *carousel;
    int imgCounter;
    SLComposeViewController *mySLComposerSheet;
    Contact *aContact;
    BOOL popDisabled;
    NSString *errorMessage;
    CGFloat currentHeight;
    
//    NSInteger kStartSubtitleY; // subtitle
//    NSInteger kStartDescriptionY; //edited define hash
}

@property BOOL noInternetConnection;
@property (retain, nonatomic) UILabel *providerLabel;
@property (nonatomic, retain) NSString *newsId;
@property (nonatomic, retain) NSString *qrcodeId;
@property (nonatomic, retain) MData *detailsData;
@property (retain, nonatomic) UIScrollView *scroller;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (retain, nonatomic) IBOutlet UIView *contentView;
//@property (retain, nonatomic) IBOutlet UIView *aDescriptionView;
@property (retain, nonatomic) IBOutlet UIView *imageSliderView;

//@property (retain, nonatomic) IBOutlet UIView *aSubtitleView; // *subTitle
//@property (retain, nonatomic) IBOutlet UILabel *subTitle; // subtitle

@property (retain, nonatomic) UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
@property (retain, nonatomic) IBOutlet UILabel *description;
@property (retain, nonatomic) IBOutlet UIView *labelColorView;
@property (retain, nonatomic) IBOutlet UILabel *typeLabel;
@property (retain, nonatomic) IBOutlet UILabel *categoryLabel;
@property (retain, nonatomic) NSMutableArray *aImages;
@property (retain, nonatomic) IBOutlet UIView *imageCarouselView;
@property (retain, nonatomic) IBOutlet UIButton *leftButton;
@property (retain, nonatomic) IBOutlet UIButton *rightButton;
@property (retain, nonatomic) IBOutlet UIView *shareView;
@property (retain, nonatomic) IBOutlet UILabel *viewMoreLabel;
@property (retain, nonatomic) IBOutlet UIButton *shareFBButton;
@property (retain, nonatomic) IBOutlet UIButton *shareTwitterButton;
@property (retain, nonatomic) IBOutlet UIButton *shareEmailButton;
@property (nonatomic,retain) IBOutlet UIButton *btnUnfollow;
@property (nonatomic,retain) IBOutlet UIButton *btnFav;
@property (retain, nonatomic) IBOutlet UIView *blankView;
@property (retain, nonatomic) IBOutlet UILabel *label;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (retain, nonatomic) NSString *aAddress;


@property (nonatomic, retain) EKEventStore *eventStore;
@property (nonatomic, retain) EKCalendar *defaultCalendar;

- (IBAction)followBtn:(id)sender;
- (IBAction)favPostBtn:(id)sender;
- (IBAction)reportBtn:(id)sender;

@end
