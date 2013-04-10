//
//  MoreViewController.m
//  myjam
//
//  Created by nazri on 12/20/12.
//  Copyright (c) 2012 me-tech. All rights reserved.
//

#import "MoreViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomAlertView.h"
#import "ASIWrapper.h"
#import "JSONKit.h"
#import "AppDelegate.h"
#import "ShowMapViewController.h"
#import "ErrorViewController.h"
#import "AGalleryViewController.h"
#import <AddContactAction.h>
#import <Twitter/Twitter.h>

#define kTextWidth 256
#define kLeftIndent 35
//#define kDateY 434
//#define kStartDescriptionY 770
#define kSubtitleHeight 30
#define kMaxTextViewHeight 1600

@interface MoreViewController ()

@end

@implementation MoreViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.navigationItem.backBarButtonItem =
        [[[UIBarButtonItem alloc] initWithTitle:@"Back"
                                          style:UIBarButtonItemStyleBordered
                                         target:nil
                                         action:nil] autorelease];
    }
    return self;
}

//- (id) init
//{
//    self = [super init];
//
//    if(!self)return nil;
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNSNCNotify:) name:@"notifyClose" object:nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNSNCNotify:) name:@"notifyUnfollowProcess" object:nil];
//
//    return self;
//}

- (void)setNSNCNotify:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"notifyClose"])
    {
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    }
    else if([[notification name] isEqualToString:@"notifyUnfollowProcess"])
    {
        [self saveToServer];
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNSNCNotify:) name:@"notifyClose" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNSNCNotify:) name:@"notifyUnfollowProcess" object:nil];
    
    AppDelegate *mydelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([mydelegate.swipeOptionString isEqualToString:@"scan"] || [mydelegate.swipeOptionString isEqualToString:@"share"] || [mydelegate.swipeOptionString isEqualToString:@"favourite"] || [mydelegate.swipeOptionString isEqualToString:@"create"])
    {
        //NSLog(@"Hiding unfollow and favourite btn");
        [self.btnFav setHidden:YES];
        [self.btnUnfollow setHidden:YES];
    }
    else
    {
        //NSLog(@"Staying unfollow and favourite btn");
        [self.btnFav setHidden:NO];
        [self.btnUnfollow setHidden:NO];
    }
    
    HomeViewController *home = [mydelegate.homeNavController.viewControllers objectAtIndex:0];
    home.nv.refreshDisabled = YES;
    
    currentHeight = 12;
    //    self.navigationItem.title = @"JAM-BU Details";
    
    // Initialize an event store object with the init method. Initilize the array for events.
	self.eventStore = [[[EKEventStore alloc] init] autorelease];
	// Get the default calendar from store.
	self.defaultCalendar = [self.eventStore defaultCalendarForNewEvents];
    
    //NSLog(@"Show details for id(%@)",self.qrcodeId);
    // Init scrollview
    self.scroller = (UIScrollView *)self.view;
    
    [self.scroller addSubview:self.blankView];
    
    self.blankView.userInteractionEnabled = YES;
    UITapGestureRecognizer *blankViewTapRecognizer;
    blankViewTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleLoading)];
    [self.blankView addGestureRecognizer:blankViewTapRecognizer];
    [self.activity setHidden:NO];
    
    self.detailsData = [[MData alloc] init];
    aContact = [[Contact alloc] init];
    self.titleLabel = [[UILabel alloc] init];
    self.providerLabel = [[UILabel alloc] init];
}

- (void)viewDidAppear:(BOOL)animated
{
    
    if (popDisabled == YES) return;
    
    
    if ([self retrieveDataFromAPI])
    {
        //        [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading ..." width:100];
        [self performSelectorOnMainThread:@selector(setupViews) withObject:nil waitUntilDone:NO];
        //        [self performSelectorInBackground:@selector(setupViews) withObject:nil];
    }else{
        //        [self performSelector:@selector(setupErrorPage) withObject:nil];
        if (![self.detailsData.qrcodeType isEqualToString:@"Gallery"]) {
            [self setupErrorPage];
        }
        
    }
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (popDisabled == NO) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

# pragma mark - Favourite This Post button

- (IBAction)favPostBtn:(id)sender
{
    FavFolderViewController *favFolderVC = [[FavFolderViewController alloc]init];
    
    favFolderVC.qrcodeId = self.qrcodeId;
    [self presentPopupViewController:favFolderVC animationType:MJPopupViewAnimationFade];
    
}

# pragma mark - Follow Button & its Process

- (IBAction)followBtn:(id)sender {
    
    //NSLog(@"Get Category for this post: %@",self.detailsData.contentProviderUID);
    
    UnFollowViewController *unFollowVC = [[UnFollowViewController alloc]init];
    
    unFollowVC.categoryName = self.detailsData.contentProvider;
    
    [self presentPopupViewController:unFollowVC animationType:MJPopupViewAnimationFade];
    
}

- (void)saveToServer
{
    NSString *urlString = [NSString stringWithFormat:@"%@/api/settings_news_preference.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
    NSString *dataContent = [NSString stringWithFormat:@"{\"flag\":\"UNFOLLOW_CP\",\"cp_id\":\"%@\"}",self.detailsData.contentProviderUID];
    
    //NSLog(@"Data Content: %@",dataContent);
    
    //=== WRAPPING DATA IN NSSTRING ===//
    NSString *wrappedDefaultDataFromServer = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
    
    //NSLog(@"Check response for dataContent: %@",wrappedDefaultDataFromServer);
    
    NSDictionary* wrappedDefaultDataToDictionary = [[wrappedDefaultDataFromServer objectFromJSONString] copy];
    
    NSString *currentStatus = nil;
    
    if([wrappedDefaultDataToDictionary count])
    {
        currentStatus = [wrappedDefaultDataToDictionary objectForKey:@"status"];
        
        if ([currentStatus isEqual: @"ok"])
        {
            [self performSelector:@selector(backToHomeVC) withObject:self afterDelay:0.2];
        }
    }
    
}

-(void)backToHomeVC
{
    NewsViewController *newsVC = [[NewsViewController alloc] init];
    
    // Manually change the selected tabButton
    AppDelegate *mydelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [mydelegate.tabView activateController:0];
    
    for (int i = 0; i < [mydelegate.tabView.tabItemsArray count]; i++) {
        if (i == 0) {
            [[mydelegate.tabView.tabItemsArray objectAtIndex:i] toggleOn:YES];
        } else {
            [[mydelegate.tabView.tabItemsArray objectAtIndex:i] toggleOn:NO];
        }
    }
    
    [mydelegate.homeNavController pushViewController:newsVC animated:NO];
}

# pragma mark - Report Button

- (IBAction)reportBtn:(id)sender
{
    popDisabled = YES;
    
    ReportSpamViewController *detailView = [[ReportSpamViewController alloc] init];
    detailView.qrcodeId = self.qrcodeId;
    detailView.newsId = self.newsId;
    detailView.qrTitle = self.detailsData.appTitle;
    detailView.qrProvider = self.detailsData.contentProvider;
    detailView.qrDate = self.detailsData.date;
    detailView.qrAbstract = self.detailsData.abstract;
    detailView.qrType = self.detailsData.type;
    detailView.qrCategory = self.detailsData.category;
    detailView.qrLabelColor = self.detailsData.labelColor;
    detailView.qrImage = [self.aImages objectAtIndex:0];
    [self.navigationController pushViewController:detailView animated:YES];
    [detailView release];
    
}

# pragma mark -

- (void)handleLoading
{
    
    
    
    [self.activity setHidden:NO];
    [self.label setText:@"Loading ..."];
    
    [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.2];
    
}

- (void)reloadData{
    
    
    NSString *productId = [self checkQRCodeType:self.qrcodeId];
    if ([productId intValue] > 0) { // type of product
        popDisabled = NO;
        DetailProductViewController *detailViewController = [[DetailProductViewController alloc] init];
        detailViewController.productInfo = [[MJModel sharedInstance] getProductInfoFor:productId];
        detailViewController.productId = [productId mutableCopy];
        //NSLog(@"prod id %@",detailViewController.productId);
        detailViewController.buyButton =  [[NSString alloc] initWithString:@"ok"];
        AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [self.navigationController popToRootViewControllerAnimated:NO];
        [mydelegate.boxNavController pushViewController:detailViewController animated:NO];
        //        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
        
        return;
    }
    //    else{
    if ([self retrieveDataFromAPI])
    {
        //        [self performSelectorOnMainThread:@selector(setupViews) withObject:nil waitUntilDone:YES];
        [self setupViews];
    }else{
        //        [self performSelector:@selector(setupErrorPage) withObject:nil afterDelay:0.0];
        [self setupErrorPage];
    }
    //    }
}

- (void)setupErrorPage
{
    
    if ([errorMessage isEqualToString:@"Invalid request."])
    {
        ErrorViewController *errorpage = [[ErrorViewController alloc] init];
        errorpage.errorOption = kERROR_CONTENT_REMOVED;
        [self.view insertSubview:errorpage.view aboveSubview:self.blankView];
        [errorpage release];
        
    }else if(self.noInternetConnection){
        self.label.text = @"JAM-BU requires an internet connection. Please try again later!";
        [self.activity setHidden:YES];
    }
    else if([errorMessage isEqualToString:@"Connection failure occured."]){
        [self.label setText:@"Connection Failed. Tap to reload."];
        [self.activity setHidden:YES];
    }
    else if([errorMessage isEqualToString:@"Request timed out."]){
        [self.label setText:@"Request timed out. Tap to reload."];
        [self.activity setHidden:YES];
    }
    else{
        [self.label setText:errorMessage];
        [self.activity setHidden:YES];
    }
}

- (void)setupViews
{
    //NSLog(@"Setting up detail view");
    
    FontLabel *titleView = [[FontLabel alloc] initWithFrame:CGRectZero fontName:@"jambu-font.otf" pointSize:22];
    if ([self.detailsData.qrcodeType isEqualToString:@"News"]) {
        titleView.text = @"JAM-BU Feed";
    }else{
        titleView.text = @"JAM-BU Box";
    }
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.backgroundColor = [UIColor clearColor];
    titleView.textColor = [UIColor whiteColor];
    [titleView sizeToFit];
    self.navigationItem.titleView = titleView;
    [titleView release];
    
    
    [self.scroller addSubview:self.contentView];
    UIView *topTextView = [[UIView alloc] init];
    [topTextView setBackgroundColor:[UIColor clearColor]];
    
    self.providerLabel.frame = CGRectMake(0, 0, kTextWidth, self.providerLabel.frame.size.height);
    
    [self.providerLabel setText:self.detailsData.contentProvider];
    [self.providerLabel setBackgroundColor:[UIColor clearColor]];
    [self.providerLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [self.providerLabel setNumberOfLines:0];
    [self.providerLabel sizeToFit];
    
    self.titleLabel.frame = CGRectMake(0, self.providerLabel.frame.size.height, kTextWidth, self.titleLabel.frame.size.height);
    
    [self.titleLabel setText:self.detailsData.appTitle];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [self.titleLabel setNumberOfLines:0];
    [self.titleLabel sizeToFit];
    
    topTextView.frame = CGRectMake(kLeftIndent, currentHeight, kTextWidth, self.titleLabel.frame.size.height+self.providerLabel.frame.size.height);
    
    [topTextView addSubview:self.providerLabel];
    [self.providerLabel release];
    [topTextView addSubview:self.titleLabel];
    [self.titleLabel release];
    [self.view addSubview:topTextView];
    currentHeight = currentHeight + topTextView.frame.size.height;
    [topTextView release];
    
    self.imageSliderView.frame = CGRectMake(0, currentHeight, self.imageSliderView.frame.size.width, self.imageSliderView.frame.size.height);
    
    currentHeight = currentHeight + self.imageSliderView.frame.size.height;
    
    self.dateLabel.text = self.detailsData.date;
    self.aImages = self.detailsData.imageArray;
    
    self.labelColorView.backgroundColor = [UIColor colorWithHex:self.detailsData.labelColor];
    self.categoryLabel.text = self.detailsData.category;
    self.typeLabel.text = self.detailsData.type;
    
    // Setup carousel
    carousel = [[Carousel alloc] initWithFrame:CGRectMake(0, 0, 236, 236)];
    carousel.delegate = self;
    // Add some images to carousel
    [carousel setImages:self.aImages];
    
    imgCounter = 0;
    [self.leftButton setHidden:YES];
    if ([self.aImages count] == 1) {
        [self.rightButton setHidden:YES];
    }
    
    CGPoint aOffset = CGPointMake(carousel.scroller.frame.size.width*imgCounter,0);
    [carousel.scroller setContentOffset:aOffset animated:YES];
    
    // Add carousel to view
    [self.imageCarouselView addSubview:carousel];
    
    // Add carousel side buttons
    [self.leftButton addTarget:self action:@selector(handleLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton addTarget:self action:@selector(handleRightButton) forControlEvents:UIControlEventTouchUpInside];
    
    // setup subtitle before fulltext inside UIView
    UILabel *subTitle = [[UILabel alloc] initWithFrame:CGRectMake(15,0,kTextWidth,10)];
    
    // setup description / fulltext inside UIView
    self.description = [[UILabel alloc] initWithFrame: CGRectMake(15,0, kTextWidth, 50)];
    
    if ([self.detailsData.qrcodeType isEqualToString:@"News"] || [self.detailsData.qrcodeType isEqualToString:@"Contact"] || [self.detailsData.qrcodeType isEqualToString:@"Social"] || [self.detailsData.qrcodeType isEqualToString:@"Url"] || [self.detailsData.qrcodeType isEqualToString:@"Map"] || [self.detailsData.qrcodeType isEqualToString:@"Calendar"] || [self.detailsData.qrcodeType isEqualToString:@"Text"] || [self.detailsData.qrcodeType isEqualToString:@"Phone"] ||  [self.detailsData.qrcodeType isEqualToString:@"Email"])
    {
        [self.description setText:self.detailsData.fullText];
        //NSLog(@"here 3");
        //        //NSLog(@"xxx %@",self.detailsData.fullText);
    }
    
    UIView *aDescriptionView = [[UIView alloc] initWithFrame:CGRectMake(20, currentHeight, self.description.frame.size.width, self.description.frame.size.height+30)];
    
    // Add subtitle for contact
    if ([self.detailsData.qrcodeType isEqualToString:@"Contact"] || [self.detailsData.qrcodeType isEqualToString:@"Calendar"] || [self.detailsData.qrcodeType isEqualToString:@"Phone"])
    {
        
        if ([self.detailsData.subTitleString length]) {
            
            UIView *aSubtitleView = [[UIView alloc] initWithFrame:CGRectMake(20, currentHeight, subTitle.frame.size.width, subTitle.frame.size.height+30)];
            
            [subTitle setText:self.detailsData.subTitleString];
            [subTitle setBackgroundColor:[UIColor clearColor]];
            [subTitle setFont:[UIFont boldSystemFontOfSize:14]];
            [subTitle setNumberOfLines:0];
            [subTitle sizeToFit];
            
            [aSubtitleView addSubview:subTitle];
            [subTitle release];
            [self.view addSubview:aSubtitleView];
            [aSubtitleView release];
            //            self.aDescriptionView = [[UIView alloc] initWithFrame:CGRectMake(20, currentHeight+kSubtitleHeight, self.description.frame.size.width, self.description.frame.size.height+30)];
            aDescriptionView.frame = CGRectMake(20, currentHeight+kSubtitleHeight, self.description.frame.size.width, self.description.frame.size.height+30);
            //NSLog(@"here 2");
            
        }
    }
    
    if ([self.description.text length]) {
        [self.description setBackgroundColor:[UIColor clearColor]];
        [self.description setFont:[UIFont systemFontOfSize:13]];
        [self.description setNumberOfLines:0];
        [self.description sizeToFit];
        [aDescriptionView addSubview:self.description];
        [self.description release];
        //NSLog(@"here");
        
        if ([self.detailsData.qrcodeType isEqualToString:@"Contact"] || [self.detailsData.qrcodeType isEqualToString:@"Calendar"])
        {
            currentHeight += 40;
        }
    }
    
    //NSLog(@"xxx %@",self.description.text);
    
    [self.view addSubview:aDescriptionView];
    [aDescriptionView release];
    // Setup shareView at bottom
    CGFloat shareViewYPoint = currentHeight + self.description.frame.size.height;
    
    self.shareView.frame = CGRectMake(0, shareViewYPoint, self.shareView.frame.size.width, self.shareView.frame.size.height);
    [self.view addSubview:self.shareView];
    [self.shareView release];
    CGFloat scrollerHeight = currentHeight + self.description.frame.size.height + self.shareView.frame.size.height + 50;
    
    // Adjust view height according to content size
    [self.scroller setContentSize:CGSizeMake(self.contentView.frame.size.width, scrollerHeight)];
    self.contentView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, scrollerHeight);
    
    // Initially set view more link to hidden
    [self.viewMoreLabel setHidden:YES];
    
    // Add URL link on share view
    if ([self.detailsData.qrcodeType isEqualToString:@"Url"] || [self.detailsData.linkType isEqualToString:@"Url"] || [self.detailsData.qrcodeType isEqualToString:@"Social"])
    {
        if ([self.detailsData.linkURL length])
        {
            if (![self.detailsData.linkURL hasPrefix:@"http://"]) {
                self.detailsData.linkURL = [NSString stringWithFormat:@"http://%@",self.detailsData.linkURL];
            }
            
            [self.viewMoreLabel setHidden:NO];
            self.viewMoreLabel.userInteractionEnabled = YES;
            UITapGestureRecognizer *urlTapRecognizer;
            urlTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleOpenBrowser)];
            [self.viewMoreLabel addGestureRecognizer:urlTapRecognizer];
            [urlTapRecognizer release];
        }
        
    } // Add link to another details page
    else if([self.detailsData.linkType isEqualToString:@"Link"])
    {
        if (![self.detailsData.linkQrcodeId isEqualToString:@"0"])
        {
            [self.viewMoreLabel setHidden:NO];
            //NSLog(@"Push another details view for id(%@)",self.detailsData.linkQrcodeId);
            
            self.viewMoreLabel.userInteractionEnabled = YES;
            self.viewMoreLabel.text = @"Go to link";
            UITapGestureRecognizer *urlTapRecognizer;
            urlTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleOpenAnotherId)];
            [self.viewMoreLabel addGestureRecognizer:urlTapRecognizer];
            [urlTapRecognizer release];
        }
        
    }
    else if([self.detailsData.qrcodeType isEqualToString:@"Email"])
    {
        [self.viewMoreLabel setHidden:NO];
        self.viewMoreLabel.userInteractionEnabled = YES;
        self.viewMoreLabel.text = @"Send Email";
        UITapGestureRecognizer *urlTapRecognizer;
        urlTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSendEmail)];
        [self.viewMoreLabel addGestureRecognizer:urlTapRecognizer];
        [urlTapRecognizer release];
        
    }
    
    // Add QR code add contact link
    if ([self.detailsData.qrcodeType isEqualToString:@"Contact"])
    {
        self.viewMoreLabel.userInteractionEnabled = YES;
        [self.viewMoreLabel setHidden:NO];
        self.viewMoreLabel.text = @"Add to Contact";
        UITapGestureRecognizer *urlTapRecognizer;
        urlTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleAddContact)];
        [self.viewMoreLabel addGestureRecognizer:urlTapRecognizer];
        [urlTapRecognizer release];
        
    } // Add QR code view map link
    else if ([self.detailsData.qrcodeType isEqualToString:@"Map"])
    {
        self.viewMoreLabel.userInteractionEnabled = YES;
        [self.viewMoreLabel setHidden:NO];
        self.viewMoreLabel.text = @"Preview Map";
        UITapGestureRecognizer *urlTapRecognizer;
        urlTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleViewMap)];
        [self.viewMoreLabel addGestureRecognizer:urlTapRecognizer];
        [urlTapRecognizer release];
        
    }
    else if ([self.detailsData.qrcodeType isEqualToString:@"Calendar"])
    {
        self.viewMoreLabel.userInteractionEnabled = YES;
        [self.viewMoreLabel setHidden:NO];
        self.viewMoreLabel.text = @"Add to Calendar";
        UITapGestureRecognizer *urlTapRecognizer;
        urlTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleAddEvent)];
        [self.viewMoreLabel addGestureRecognizer:urlTapRecognizer];
        [urlTapRecognizer release];
        
    }
    
    // Setup share button in shareVIew
    [self.shareFBButton addTarget:self action:@selector(shareImageOnFB) forControlEvents:UIControlEventTouchUpInside];
    [self.shareTwitterButton addTarget:self action:@selector(shareImageOnTwitter) forControlEvents:UIControlEventTouchUpInside];
    [self.shareEmailButton addTarget:self action:@selector(shareImageOnEmail) forControlEvents:UIControlEventTouchUpInside];
    
    
    //    self.contentView.frame = CGRectMake(0, kDateY, self.contentView.frame.size.width, self.contentView.frame.size.height-kDateY);
    //    [self.scroller setContentSize:CGSizeMake(self.contentView.frame.size.width, self.contentView.frame.size.height)];
    //    self.contentView.frame = CGRectMake(0, kDateY, self.contentView.frame.size.width, self.contentView.frame.size.height);
    [self.blankView removeFromSuperview];
    
}

- (void)handleSendEmail
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
//        NSLog(@"%@--",self.detailsData.aEmail);
        [mailer setToRecipients:[NSArray arrayWithObjects:self.detailsData.aEmail, nil]];
        [mailer setSubject:self.detailsData.aSubject];
        [mailer setMessageBody:self.detailsData.aBody isHTML:NO];
        [self presentModalViewController:mailer animated:YES];
        [mailer release];
    }
    else
    {
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"JAM-BU Email" message:@"Please configure your mail in Mail Application" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)handleOpenAnotherId
{
    popDisabled = YES;
    
    MoreViewController *detailView = [[MoreViewController alloc] init];
    detailView.qrcodeId = self.detailsData.linkQrcodeId;
    [self.navigationController pushViewController:detailView animated:YES];
    [detailView release];
}

- (void)handleViewMap
{
    popDisabled = YES;
    
    ShowMapViewController *mapPreview = [[ShowMapViewController alloc] init];
    mapPreview.mapAddress = self.aAddress;
    [self.navigationController pushViewController:mapPreview animated:YES];
    [mapPreview release];
}

- (void)handleAddContact
{
    popDisabled = YES;
    
    NSArray *phoneNums = [NSArray arrayWithObjects:aContact.phoneNumbers, nil];
    
    AddContactAction *act = [AddContactAction actionWithName:aContact.name
                                                phoneNumbers:phoneNums
                                                       email:aContact.email
                                                         url:aContact.url
                                                     address:aContact.address
                                                        note:@""
                                                organization:aContact.organization
                                                    jobTitle:@""];
    
    //    AppDelegate *mydelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [act performActionWithController:self shouldConfirm:YES];
    //    [act addContactWithNavigationController:mydelegate.scanNavController];
}

- (void)handleAddEvent
{
    popDisabled = YES;
    //    EKEventStore *eventStore = [[[EKEventStore alloc] init] autorelease];
    if([self.eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
        // iOS 6 and later
        [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (granted){
                // Here when user allow your app to access theirs' calendar.
                // Should perform on mainthread to prevent deadlock
                [self performSelectorOnMainThread:
                 @selector(presentCalendar:)
                                       withObject:self.eventStore
                                    waitUntilDone:NO];
                
                
            }else
            {
                // codes here when user NOT allow your app to access the calendar.
                //NSLog(@"User not allow to open calendar app");
            }
        }];
    }
    else {
        // codes here for IOS < 6.0.
    }
}


- (void)presentCalendar:(EKEventStore *)eventStore
{
    EKEventEditViewController *addController = [[EKEventEditViewController alloc] init];
    addController.editViewDelegate = self;
    EKEvent *event = [EKEvent eventWithEventStore:eventStore];
    //NSLog(@"start timestamp %@, end %@",self.detailsData.startTimestamp,self.detailsData.endTimestamp);
    [event setTitle:self.detailsData.title];
    [event setStartDate:self.detailsData.startTimestamp];
    [event setEndDate:self.detailsData.endTimestamp];
    [event setNotes:self.detailsData.notes];
    [event setCalendar:[self.eventStore defaultCalendarForNewEvents]];
    [event setLocation:self.detailsData.location];
    addController.event = event;
    // set the addController's event store to the current event store.
    addController.eventStore = eventStore;
    [self presentModalViewController:addController animated:YES];
    [addController release];
}
#pragma mark -
#pragma mark retrieve all data by qrcodeId

- (NSString *)checkQRCodeType:(NSString *)qrcodeid
{
    NSString *urlString = [NSString stringWithFormat:@"%@/api/qrcode_type.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
    NSString *dataContent = [NSString stringWithFormat:@"{\"qrcode_id\":%@}",self.qrcodeId];
    
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
    //NSLog(@"request %@\n%@\n\nresponse data: %@", urlString, dataContent, response);
    NSDictionary *resultsDictionary = [[response objectFromJSONString] copy];
    //NSLog(@"dict %@",resultsDictionary);
    
    if([resultsDictionary count])
    {
        NSString *status = [resultsDictionary objectForKey:@"status"];
        if ([status isEqualToString:@"ok"])
        {
            NSString *type = [resultsDictionary objectForKey:@"qrcode_type"];
            
            if ([type isEqualToString:@"Product"]) {
                NSString *productid = [resultsDictionary objectForKey:@"product_id"];
                return productid;
            }
            
        }
    }
    
    return @"0"; // normal qrcode, other than product
}

- (BOOL)retrieveDataFromAPI
{
    BOOL success = YES;
    
    NSString *urlString = [NSString stringWithFormat:@"%@/api/qrcode_details.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
    NSString *dataContent = [NSString stringWithFormat:@"{\"qrcode_id\":%@}",self.qrcodeId];
    
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
    //NSLog(@"request %@\n%@\n\nresponse data: %@", urlString, dataContent, response);
    NSDictionary *resultsDictionary = [[response objectFromJSONString] copy];
    NSLog(@"dict %@",resultsDictionary);
    
    if([resultsDictionary count])
    {
        NSString *status = [resultsDictionary objectForKey:@"status"];
        if ([status isEqualToString:@"ok"])
        {
            self.detailsData.qrcodeId = self.qrcodeId;
            self.detailsData.category = [resultsDictionary objectForKey:@"category"];
            self.detailsData.labelColor = [resultsDictionary objectForKey:@"color"];
            self.detailsData.contentProvider = [resultsDictionary objectForKey:@"fullname"];
            self.detailsData.contentProviderUID = [resultsDictionary objectForKey:@"userid"];
            self.newsId = [resultsDictionary objectForKey:@"news_id"];
            self.detailsData.appTitle = [resultsDictionary objectForKey:@"app_title"];
            self.detailsData.date = [resultsDictionary objectForKey:@"date"];
            self.detailsData.abstract = [resultsDictionary objectForKey:@"description"];
            self.detailsData.type = [resultsDictionary objectForKey:@"type"];
            self.detailsData.fullText = [resultsDictionary objectForKey:@"full_description"];
            self.detailsData.linkType = [resultsDictionary objectForKey:@"link_type"];
            self.detailsData.linkURL = [resultsDictionary objectForKey:@"link_url"];
            self.detailsData.linkQrcodeId = [resultsDictionary objectForKey:@"link_qrcode_id"];
            self.detailsData.qrcodeType = [resultsDictionary objectForKey:@"qrcode_type"];
            //NSLog(@"type is --- %@",self.detailsData.qrcodeType);
            if ([self.detailsData.qrcodeType isEqualToString:@"Gallery"])
            {
                // Redirecting to AGalleryViewController
                AppDelegate *mydelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [self.navigationController popToRootViewControllerAnimated:NO];
                AGalleryViewController *gallery = [[AGalleryViewController alloc] init];
                gallery.qrcodeId = self.detailsData.qrcodeId;
                [mydelegate.boxNavController pushViewController:gallery animated:NO];
                [gallery release];
                return NO;
            }
            
            else if ([self.detailsData.qrcodeType isEqualToString:@"Text"])
            {
                self.detailsData.fullText = [resultsDictionary objectForKey:@"text_text"];
            }
            else if ([self.detailsData.qrcodeType isEqualToString:@"Email"])
            {
//                self.detailsData.fullText = [NSString stringWithFormat:@"Email:\n%@",[resultsDictionary objectForKey:@"email_email"]];
                
                self.detailsData.aSubject = [resultsDictionary valueForKey:@"email_subject"];
                self.detailsData.aBody = [resultsDictionary valueForKey:@"email_description"];
                self.detailsData.aQRdesc = [resultsDictionary valueForKey:@"email_qrdescription"];
                self.detailsData.aEmail = [resultsDictionary valueForKey:@"email_email"];
                
                NSMutableString *emailContent = [NSMutableString stringWithFormat:@""];
                if ([self.detailsData.aSubject length]) {
                    [emailContent appendFormat:@"Subject\n%@",self.detailsData.aSubject];
                }
                if ([self.detailsData.aBody length]) {
                    [emailContent appendFormat:@"\n\nEmail Body\n%@",self.detailsData.aBody];
                }
                if ([self.detailsData.aQRdesc length]) {
                    [emailContent appendFormat:@"\n\nEmail QR Description\n%@",self.detailsData.aQRdesc];
                }
                if ([self.detailsData.aEmail length]) {
                    [emailContent appendFormat:@"\n\nEmail\n%@",self.detailsData.aEmail];
                }
                self.detailsData.fullText = emailContent;
            }
            else if ([self.detailsData.qrcodeType isEqualToString:@"Phone"])
            {
                //                self.detailsData.subTitleString = [resultsDictionary objectForKey:@"phone_name"];
                self.detailsData.fullText = [NSString stringWithFormat:@"%@\n\nPhone Number:\n%@",[resultsDictionary objectForKey:@"phone_name"], [resultsDictionary objectForKey:@"phone_phone"]];
            }
            else if ([self.detailsData.qrcodeType isEqualToString:@"Contact"]) {
                
                
                NSString *orgString = [resultsDictionary objectForKey:@"contact_organization"];
                
                NSString *mobString = [resultsDictionary objectForKey:@"contact_mobile_phone_number"];
                
                NSString *phoString = [resultsDictionary objectForKey:@"contact_phone_number"];
                
                NSString *emaString = [resultsDictionary objectForKey:@"contact_email"];
                
                NSString *addString = [resultsDictionary objectForKey:@"contact_address"];
                
                NSString *citString = [resultsDictionary objectForKey:@"contact_city"];
                
                NSString *staString = [resultsDictionary objectForKey:@"contact_state"];
                
                NSString *posString = [resultsDictionary objectForKey:@"contact_postcode"];
                
                NSString *couString = [resultsDictionary objectForKey:@"contact_country"];
                
                NSString *urllString = [resultsDictionary objectForKey:@"contact_url"];
                
                if (orgString.length == 0){orgString = @"";}
                if (mobString.length == 0){mobString = @"";}
                if (phoString.length == 0){phoString = @"";}
                if (emaString.length == 0){emaString = @"";}
                if (addString.length == 0){addString = @"";}
                if (citString.length == 0){citString = @"";}
                if (staString.length == 0){staString = @"";}
                if (posString.length == 0){posString = @"";}
                if (couString.length == 0){couString = @"";}
                if (urllString.length == 0){urllString = @"";}
                
                
                NSMutableString *addressFull = [[NSMutableString alloc] init];
                if ([addString length] > 0) {
                    [addressFull appendString:addString];
                }
                if ([citString length] > 0) {
                    [addressFull appendFormat:@"\n%@",citString];
                }
                if ([staString length] > 0) {
                    [addressFull appendFormat:@"\n%@",staString];
                }
                if ([posString length] > 0) {
                    [addressFull appendFormat:@"\n%@",posString];
                }
                if ([couString length] > 0) {
                    [addressFull appendFormat:@"\n%@",couString];
                }
                
                self.detailsData.subTitleString = [NSString stringWithFormat:@"%@",[resultsDictionary objectForKey:@"contact_name"]]; //subtitle
                
                self.detailsData.fullText = [NSString stringWithFormat:@"Organization: \n%@\n\nMobile Number: \n%@\n\nPhone Number: \n%@\n\nEmail: \n%@\n\nAddress: \n%@\n\nURL: \n%@\n",
                                             orgString,mobString,phoString,emaString,addressFull, urllString];
                [addressFull release];
                [aContact setName:[resultsDictionary objectForKey:@"contact_name"]];
                [aContact setOrganization:[resultsDictionary objectForKey:@"contact_organization"]];
                [aContact setAddress:[resultsDictionary objectForKey:@"contact_address"]];
                [aContact setPhoneNumbers:[resultsDictionary objectForKey:@"contact_mobile_phone_number"]];
            }
            else if ([self.detailsData.qrcodeType isEqualToString:@"Url"]) {
                self.detailsData.fullText = [NSString stringWithFormat:@"%@\n\n%@",
                                             [resultsDictionary objectForKey:@"url_name"],
                                             [resultsDictionary objectForKey:@"url_url"]];
                self.detailsData.linkURL = [resultsDictionary objectForKey:@"url_url"];
            }
            else if ([self.detailsData.qrcodeType isEqualToString:@"Social"]) {
                self.detailsData.fullText = [NSString stringWithFormat:@"%@: %@\n\n\n%@",
                                             [resultsDictionary objectForKey:@"social_type"],
                                             [resultsDictionary objectForKey:@"social_name"],
                                             [resultsDictionary objectForKey:@"social_url"]];
                
                self.detailsData.linkURL = [resultsDictionary objectForKey:@"social_url"];
            }
            else if ([self.detailsData.qrcodeType isEqualToString:@"Map"]) {
                
                NSString *kAddress = [NSString stringWithFormat:@"%@",[resultsDictionary objectForKey:@"map_address"]];
                NSString *kCity = [NSString stringWithFormat:@"%@",[resultsDictionary objectForKey:@"map_city"]];
                NSString *kState = [NSString stringWithFormat:@"%@",[resultsDictionary objectForKey:@"map_state"]];
                NSString *kPostcode = [NSString stringWithFormat:@"%@",[resultsDictionary objectForKey:@"map_postcode"]];
                NSString *kCountry = [NSString stringWithFormat:@"%@",[resultsDictionary objectForKey:@"map_country"]];
                
                
                self.detailsData.fullText = [NSString stringWithFormat:@"%@\n\nAddress: %@\nCity: %@\nState: %@\nPostcode: %@\nCountry: %@\nDescription: %@",
                                             [resultsDictionary objectForKey:@"map_name"],
                                             kAddress,
                                             kCity,
                                             kState,
                                             kPostcode,
                                             kCountry,
                                             [resultsDictionary objectForKey:@"map_description"]];
                
                NSMutableString *searchAddress = [[NSMutableString alloc] initWithString:kAddress];
                
                if ([kCity length]) {
                    [searchAddress appendFormat:@", %@",kCity];
                }
                if ([kState length]) {
                    [searchAddress appendFormat:@", %@",kState];
                }
                if ([kPostcode length]) {
                    [searchAddress appendFormat:@", %@",kPostcode];
                }
                if ([kCountry length]) {
                    [searchAddress appendFormat:@", %@",kCountry];
                }
                
                self.aAddress = [NSString stringWithString:searchAddress];
                [searchAddress release];
                
                //NSLog(@"%@", self.aAddress);
            }
            else if ([self.detailsData.qrcodeType isEqualToString:@"Calendar"]) {
                
                //                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                //                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                //                [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"MYT"]];
                
                NSDate *startTime = [self reformatDateFromString: [resultsDictionary objectForKey:@"calendar_start_timestampt"]];
                
                NSDate *endTime = [self reformatDateFromString: [resultsDictionary objectForKey:@"calendar_end_timestampt"]];
                
                NSString *sTime = [resultsDictionary objectForKey:@"calendar_start_time"];
                NSString *eTime = [resultsDictionary objectForKey:@"calendar_end_time"];
                NSString *sDate = [resultsDictionary objectForKey:@"calendar_start_date"];
                NSString *eDate = [resultsDictionary objectForKey:@"calendar_end_date"];
                
                self.detailsData.title = [NSString stringWithFormat:@"%@",[resultsDictionary objectForKey:@"calendar_event_name"]];
                self.detailsData.notes = [NSString stringWithFormat:@"%@",[resultsDictionary objectForKey:@"calendar_event_description"]];
                self.detailsData.location = [NSString stringWithFormat:@"%@",[resultsDictionary objectForKey:@"calendar_location"]];
                
                self.detailsData.fullText = [NSString stringWithFormat:@"%@\n\nStart Time:\n%@\n%@\n\nEnd Time:\n%@\n%@\n\nLocation:\n%@",
                                             self.detailsData.notes,
                                             sDate,
                                             sTime,
                                             eDate,
                                             eTime,
                                             self.detailsData.location
                                             ];
                self.detailsData.subTitleString = self.detailsData.title;
                self.detailsData.startTimestamp = startTime;
                self.detailsData.endTimestamp = endTime;
            }
            
            NSMutableArray *imageURLs = [resultsDictionary objectForKey:@"images"];
            self.detailsData.imageArray = [[NSMutableArray alloc] initWithCapacity:[imageURLs count]];
            
            for (NSString *url in imageURLs) {
                [self retrieveImages:url];
            }
            imageURLs = nil;
            
        }else{
            success = NO;
            //            //NSLog(@"error retrieve all data");
        }
    }else{
        success = NO;
    }
    
    errorMessage = [resultsDictionary objectForKey:@"message"];
    
    [resultsDictionary release];
    
    if (success == NO) {
        errorMessage = [resultsDictionary objectForKey:@"message"];
        popDisabled = NO;
    }
    //    }
    
    return success;
}

//- (NSString *)reformatStringFromDate:(NSDate *)date
//{
////    NSDate *myDate = [[NSDate alloc] init];
////    myDate = date;
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"d MMM yyyy\nhh:mm a"];
//    NSString *str = [formatter stringFromDate:date];
//
//    [formatter release];
//    return str;
//}

- (NSDate *)reformatDateFromString:(NSString *)aString
{
    NSDate *newDate = [[[NSDate alloc] init] autorelease];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"MYT"]];
    newDate = [formatter dateFromString:aString];
    [formatter release];
    return newDate;
}

- (void)retrieveImages: (NSString *)uri
{
    ASIHTTPRequest *imageRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:uri]];
    
    [imageRequest startSynchronous];
    [imageRequest setTimeOutSeconds:2];
    NSError *error = [imageRequest error];
    
    UIImage *aImg = [[UIImage alloc] initWithData:[imageRequest responseData]];
    
    if (!error) {
        [self.detailsData.imageArray addObject:aImg];
    }else{
        //NSLog(@"error retrieve image: %@",error);
    }
    
    [aImg release];
    [imageRequest release];
}

#pragma mark -
#pragma mark share action handler

- (void)addShareItemtoServer:(NSString *)qrcodeId withShareType:(NSString *)aType
{
    NSString *urlString = [NSString stringWithFormat:@"%@/api/qrcode_share.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
    
    NSString *dataContent = [NSString stringWithFormat:@"{\"qrcode_id\":%@,\"share_type\":\"%@\"}",qrcodeId,aType];
    
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
    //NSLog(@"abc: %@, def:%@",dataContent, response);
    NSDictionary *resultsDictionary = [[response objectFromJSONString] mutableCopy];
    
    if([resultsDictionary count])
    {
        NSString *status = [resultsDictionary objectForKey:@"status"];
        
        if ([status isEqualToString:@"ok"])
        {
            //NSLog(@"Success share");
        }
        else{
            //NSLog(@"share error!");
        }
    }
    
}

- (void)shareImageOnEmail
{
    popDisabled = YES;
    
    [self addShareItemtoServer:self.detailsData.qrcodeId withShareType:@"email"];
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"JAM-BU App"];
        UIImage *myImage = [self.aImages lastObject];
        NSData *imageData = UIImagePNGRepresentation(myImage);
        [mailer addAttachmentData:imageData mimeType:@"image/png" fileName:self.detailsData.qrcodeId];
        NSString *emailBody = [NSString stringWithFormat:@"Scan this QR code. \n\nJAM-BU App: %@/?qrcode_id=%@",APP_API_URL,self.detailsData.qrcodeId];
        [mailer setMessageBody:emailBody isHTML:NO];
        [self presentModalViewController:mailer animated:YES];
        [mailer release];
    }
    else
    {
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"JAM-BU Share" message:@"Please configure your mail in Mail Application" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)shareImageOnTwitter
{
    //CHECK VERSION FIRST. Constant can refer from Constant.h
    if(SYSTEM_VERSION_EQUAL_TO(@"5.0") || SYSTEM_VERSION_EQUAL_TO(@"5.1"))
    {
        [self twitterAPIShare];
    }
    else
    {
        [self callAPIShare:kOPTION_TWITTER];
    }
}

- (void)shareImageOnFB
{
    //check version first and then call method
    if(SYSTEM_VERSION_EQUAL_TO(@"5.0") || SYSTEM_VERSION_EQUAL_TO(@"5.1"))
    {
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Unsupported iOS Version" message:@"Sorry. Your iOS version doesn't support Facebook Share." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
    {
        [self callAPIShare:kOPTION_FB];
    }
}

- (void)twitterAPIShare //for iOS 5 and 5.1
{
    TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
    
    [twitter setInitialText:@""];
    [twitter addImage:[self.aImages lastObject]];
    
    [self presentViewController:twitter animated:YES completion:nil];
    
    twitter.completionHandler = ^(TWTweetComposeViewControllerResult res) {
        
        if(res == TWTweetComposeViewControllerResultDone) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Successfully posted." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
            
            [alert show];
            [alert release];
            
        }
        if(res == TWTweetComposeViewControllerResultCancelled) {
            /*
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Cancelled" message:@"You Cancelled posting the Tweet." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
             
             [alert show];
             */
        }
        [self dismissModalViewControllerAnimated:YES];
        
    };
    
    [self addShareItemtoServer:self.detailsData.qrcodeId withShareType:[@"Twitter" lowercaseString]];
}

- (void)callAPIShare:(int)option
{
    popDisabled = YES;
    
    NSString *serviceType = nil;
    NSString *type = nil;
    if (option == kOPTION_FB) {
        serviceType = SLServiceTypeFacebook;
        type = @"Facebook";
    }else if (option == kOPTION_TWITTER){
        serviceType = SLServiceTypeTwitter;
        type = @"Twitter";
    }
    
    mySLComposerSheet = [[SLComposeViewController alloc] init];
    mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:serviceType];
    
    if([SLComposeViewController isAvailableForServiceType:serviceType]) //check if account is linked
    {
        
        [mySLComposerSheet addImage:[self.aImages lastObject]];
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
        
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            NSString *output;
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    output = @"Action Cancelled";
                    [self dismissModalViewControllerAnimated:YES];
                    break;
                case SLComposeViewControllerResultDone:
                    output = @"Post Successful";
                    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"JAM-BU Share" message:output delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                    [self dismissModalViewControllerAnimated:YES];
                    break;
                default:
                    break;
            }
            
        }];
        
    }else{
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"JAM-BU Share" message:[NSString stringWithFormat:@"Please add your %@ account in IOS Device Settings and allow JAM-BU to access your %@ information.",type,type] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    [self addShareItemtoServer:self.detailsData.qrcodeId withShareType:[type lowercaseString]];
}

- (void)handleOpenBrowser
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", self.detailsData.linkURL]];
    
    if (![[UIApplication sharedApplication] openURL:url])
        NSLog(@"Failed to open url: %@",[url description]);
}

- (void)handleLeftButton
{
    imgCounter--;
    CGPoint aOffset = CGPointMake(carousel.scroller.frame.size.width*imgCounter,0);
    [carousel.scroller setContentOffset:aOffset animated:YES];
    
    if(imgCounter == 0)
    {
        [self.leftButton setHidden:YES];
    }
    
    if(imgCounter == [self.aImages count]-2)
    {
        [self.rightButton setHidden:NO];
    }
}

- (void)handleRightButton
{
    imgCounter++;
    CGPoint aOffset = CGPointMake(carousel.scroller.frame.size.width*imgCounter,0);
    [carousel.scroller setContentOffset:aOffset animated:YES];
    
    if(imgCounter == 1)
    {
        [self.leftButton setHidden:NO];
    }
    
    if(imgCounter == [self.aImages count]-1)
    {
        [self.rightButton setHidden:YES];
    }
}

#pragma mark -
#pragma mark MFMail delegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    NSString *msg;
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            msg = @"";
            break;
        case MFMailComposeResultSaved:
            //NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            msg = [NSString stringWithFormat:@"Email has been saved to draft"];
            break;
        case MFMailComposeResultSent:
            //NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            msg = [NSString stringWithFormat:@"Email has been successfully sent"];
            break;
        case MFMailComposeResultFailed:
            //NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            msg = [NSString stringWithFormat:@"Email was not sent, possibly due to an error"];
            break;
        default:
            //NSLog(@"Mail not sent.");
            break;
    }
    
    if (![msg isEqualToString:@""]) {
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"JAM-BU Share" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    
    // Dismiss the mail view
    [controller dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Carousel delegate

- (void)didScrollToPage:(int)page
{
    // Check currentpage
    
    imgCounter = page;
    if(imgCounter == 0)
    {
        [self.leftButton setHidden:YES];
    }
    
    if(imgCounter == [self.aImages count]-2)
    {
        [self.rightButton setHidden:NO];
    }
    
    if(imgCounter == 1)
    {
        [self.leftButton setHidden:NO];
    }
    
    if(imgCounter == [self.aImages count]-1)
    {
        [self.rightButton setHidden:YES];
    }
}


#pragma mark -
#pragma mark EKEventEditViewDelegate

// Overriding EKEventEditViewDelegate method to update event store according to user actions.
- (void)eventEditViewController:(EKEventEditViewController *)controller
          didCompleteWithAction:(EKEventEditViewAction)action {
	
	NSError *error = nil;
    //	EKEvent *thisEvent = controller.event;
	
	switch (action) {
		case EKEventEditViewActionCanceled:
			// Edit action canceled, do nothing.
            //NSLog(@"Event Canceled");
			break;
			
		case EKEventEditViewActionSaved:
			//NSLog(@"Event Saved");
            [controller.eventStore saveEvent:controller.event span:EKSpanThisEvent error:&error];
			break;
			
		case EKEventEditViewActionDeleted:
            
			break;
			
		default:
			break;
	}
	// Dismiss the modal view controller
	[controller dismissModalViewControllerAnimated:YES];
	
}


// Set the calendar edited by EKEventEditViewController to our chosen calendar - the default calendar.
- (EKCalendar *)eventEditViewControllerDefaultCalendarForNewEvents:(EKEventEditViewController *)controller {
	EKCalendar *calendarForEdit = self.defaultCalendar;
	return calendarForEdit;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [super dealloc];
    
    //    [_titleLabel release];
    [_dateLabel release];
    //    [_description release];
    [_labelColorView release];
    [_typeLabel release];
    [_categoryLabel release];
    [_imageCarouselView release];
    [_leftButton release];
    [_rightButton release];
    //    [_shareView release];
    //    [_viewMoreLabel release];
    [_shareFBButton release];
    [_shareTwitterButton release];
    //    [_providerLabel release];
    [_shareEmailButton release];
    //    [_aDescriptionView release];
    [_detailsData release];
    [_blankView release];
    [_imageSliderView release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}



@end
