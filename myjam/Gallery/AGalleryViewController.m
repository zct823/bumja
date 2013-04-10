//
//  MoreViewController.m
//  myjam
//
//  Created by nazri on 12/20/12.
//  Copyright (c) 2012 me-tech. All rights reserved.
//

#import "AGalleryViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomAlertView.h"
#import "ASIWrapper.h"
#import "JSONKit.h"
#import "AppDelegate.h"
#import "ErrorViewController.h"
#import "PhotoViewController.h"
#import <AddContactAction.h>
#import <Twitter/Twitter.h>
#import <SDWebImage/UIImageView+WebCache.h>

#define kItemPerRow 3
#define kTextWidth 290
#define kLeftIndent 15
#define kSubtitleHeight 30
#define kMaxTextViewHeight 1600

@interface AGalleryViewController ()

@end

@implementation AGalleryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        FontLabel *titleView = [[FontLabel alloc] initWithFrame:CGRectZero fontName:@"jambu-font.otf" pointSize:22];
        titleView.text = @"Gallery";
        titleView.textAlignment = NSTextAlignmentCenter;
        titleView.backgroundColor = [UIColor clearColor];
        titleView.textColor = [UIColor whiteColor];
        [titleView sizeToFit];
        self.navigationItem.titleView = titleView;
        [titleView release];
        
        self.navigationItem.backBarButtonItem =
        [[[UIBarButtonItem alloc] initWithTitle:@"Back"
                                          style:UIBarButtonItemStyleBordered
                                         target:nil
                                         action:nil] autorelease];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    currentHeight = 12;
    
    //NSLog(@"Show gallery for id(%@)",self.qrcodeId);
    // Init scrollview
    self.scroller = (UIScrollView *)self.view;
    [self.scroller addSubview:self.blankView];
    
    self.blankView.userInteractionEnabled = YES;
    UITapGestureRecognizer *blankViewTapRecognizer;
    blankViewTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleLoading)];
    [self.blankView addGestureRecognizer:blankViewTapRecognizer];
    [self.activity setHidden:NO];
    self.detailsData = [[MData alloc] init];
    
    self.titleLabel = [[UILabel alloc] init];
    self.providerLabel = [[UILabel alloc] init];

    
}

- (void)viewDidAppear:(BOOL)animated
{
    if (popDisabled == YES) return;
    
    if ([self retrieveDataFromAPI])
    {
        [self performSelectorOnMainThread:@selector(setupViews) withObject:nil waitUntilDone:NO];
    }else{
        [self setupErrorPage];
    }
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (popDisabled == NO) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    
}

- (void)handleLoading
{
    [self.activity setHidden:NO];
    [self.label setText:@"Loading ..."];
    [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.2];
    
}

- (void)reloadData{
    if ([self retrieveDataFromAPI])
    {
        [self performSelectorOnMainThread:@selector(setupViews) withObject:nil waitUntilDone:YES];
    }else{
        [self setupErrorPage];
    }
}

- (void)setupErrorPage
{
    
    if ([errorMessage isEqualToString:@"Invalid request."])
    {
        ErrorViewController *errorpage = [[ErrorViewController alloc] init];
        errorpage.errorOption = kERROR_CONTENT_REMOVED;
        [self.view insertSubview:errorpage.view aboveSubview:self.blankView];
        [errorpage release];
        
    }else
    if(self.noInternetConnection){
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
    
    topTextView.frame = CGRectMake(kLeftIndent+15, currentHeight, kTextWidth-15, self.titleLabel.frame.size.height+self.providerLabel.frame.size.height);
    
    [topTextView addSubview:self.providerLabel];
    [self.providerLabel release];
    [topTextView addSubview:self.titleLabel];
    [self.titleLabel release];
    [self.view addSubview:topTextView];
    currentHeight = currentHeight + topTextView.frame.size.height;
    [topTextView release];
    
    // Add CollectionView
//    self.collectionView.frame = CGRectMake(kLeftIndent, currentHeight, kTextWidth, self.view.frame.size.height-80);
    UIView *gridView = [[UIView alloc] initWithFrame:CGRectMake(0, currentHeight, 320, 100)];
    
    
    int imagePerRow = 3;
    int row = 1;
    int col = 1;
    CGFloat imgSideLength = 93;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat colspan = 10;
    CGFloat rowspan = 10;
    for (int i = 0; i < [self.detailsData.imageArray count]; i++)
    {
        if (col == imagePerRow+1) {
            col = 1;
            x = 0;
            row++;
            y = y + rowspan + imgSideLength;
            
        }else if (col == 1)
        {
            y = y + rowspan;
        }
        
        x = x + colspan;
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, imgSideLength, imgSideLength)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        imgView.userInteractionEnabled = YES;
        imgView.tag = i;

        UITapGestureRecognizer *fullScreenTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageFullScreen:)];
        [imgView addGestureRecognizer:fullScreenTapGestureRecognizer];
        [fullScreenTapGestureRecognizer release];
        
        [imgView setImageWithURL:[NSURL URLWithString:[self.detailsData.imageArray objectAtIndex:i]]
         placeholderImage:[UIImage imageNamed:@"default_icon"]
                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                    if (!error) {
                        
                    }else{
                        //NSLog(@"error retrieve image: %@",error);
                    }
                    
                }];

        x = x + imgSideLength;
        col++;
        
        [gridView addSubview:imgView];
        [imgView release];
    }
    
    if (![self.detailsData.imageArray count]) {
        UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftIndent+15, 25, gridView.frame.size.width, 50)];
        [aLabel setText: @"No images found in gallery."];
        [aLabel setTextColor: [UIColor darkGrayColor]];
        [aLabel setBackgroundColor:[UIColor clearColor]];
        [aLabel setFont:[UIFont systemFontOfSize:15]];
        [aLabel setNumberOfLines:0];
        [aLabel sizeToFit];
        [gridView addSubview:aLabel];
        [aLabel release];
    }
    
    gridView.frame = CGRectMake(0, currentHeight, 320, y+imgSideLength+rowspan);
    [gridView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:gridView];
    
    // Y point calculated from bottom
    CGFloat shareViewYPoint2 = self.view.frame.size.height - self.shareView.frame.size.height - 64;
    
    // Y point calculated from top and content
    CGFloat shareViewYPoint = currentHeight + gridView.frame.size.height + 10;
    
    if (shareViewYPoint < shareViewYPoint2) {
        shareViewYPoint = shareViewYPoint2;
    }
    
    self.shareView.frame = CGRectMake(0, shareViewYPoint, self.shareView.frame.size.width, self.shareView.frame.size.height);
    [self.view addSubview:self.shareView];
    [self.shareView release];
    CGFloat scrollerHeight = shareViewYPoint + self.shareView.frame.size.height + 44 + 36;
    
    // Adjust view height according to content size
    [self.scroller setContentSize:CGSizeMake(self.contentView.frame.size.width, scrollerHeight)];
    
    if (scrollerHeight < self.view.frame.size.height) {
        scrollerHeight = self.view.frame.size.height;
    }
    self.contentView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, scrollerHeight);
    
    // Setup share button in shareVIew
    [self.shareFBButton addTarget:self action:@selector(shareImageOnFB) forControlEvents:UIControlEventTouchUpInside];
    [self.shareTwitterButton addTarget:self action:@selector(shareImageOnTwitter) forControlEvents:UIControlEventTouchUpInside];
    [self.shareEmailButton addTarget:self action:@selector(shareImageOnEmail) forControlEvents:UIControlEventTouchUpInside];
    
    [self.blankView removeFromSuperview];
    [gridView release];
}

- (void)handleImageFullScreen:(id)sender
{
    int index = [(UIGestureRecognizer *)sender view].tag;
    //NSLog(@"tapped on img %d",[(UIGestureRecognizer *)sender view].tag);
    PhotoViewController *photovc = [[PhotoViewController alloc] init];
//    photovc.aImages = self.detailsData.imageArray;
//    [self presentModalViewController:photovc animated:YES];
    AppDelegate *mydelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    mydelegate.arrayTemp = [self.detailsData.imageArray copy];
    mydelegate.indexTemp = index;
    [mydelegate.window addSubview:photovc.view];
}

#pragma mark -
#pragma mark retrieve all data by qrcodeId

- (BOOL)retrieveDataFromAPI
{
    BOOL success = YES;
    NSString *urlString = [NSString stringWithFormat:@"%@/api/qrcode_details.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
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
            self.detailsData.qrcodeId = self.qrcodeId;
            self.detailsData.category = [resultsDictionary objectForKey:@"category"];
            self.detailsData.labelColor = [resultsDictionary objectForKey:@"color"];
            self.detailsData.contentProvider = [resultsDictionary objectForKey:@"fullname"];
            self.detailsData.appTitle = [resultsDictionary objectForKey:@"app_title"];
            self.detailsData.date = [resultsDictionary objectForKey:@"date"];
            self.detailsData.abstract = [resultsDictionary objectForKey:@"description"];
            self.detailsData.type = [resultsDictionary objectForKey:@"type"];
            self.detailsData.fullText = [resultsDictionary objectForKey:@"full_description"];
            self.detailsData.linkType = [resultsDictionary objectForKey:@"link_type"];
            self.detailsData.linkURL = [resultsDictionary objectForKey:@"link_url"];
            self.detailsData.linkQrcodeId = [resultsDictionary objectForKey:@"link_qrcode_id"];
            self.detailsData.qrcodeType = [resultsDictionary objectForKey:@"qrcode_type"];
            
//            NSMutableArray *imageURLs = [resultsDictionary objectForKey:@"image"];
//            self.detailsData.imageArray = [[NSMutableArray alloc] initWithCapacity:[imageURLs count]];
//            
//            for (NSString *url in imageURLs) {
//                [self retrieveImages:url];
//            }
//            imageURLs = nil;
            
            self.detailsData.imageArray = [resultsDictionary objectForKey:@"image"];
            
        }else{
            success = NO;
            //NSLog(@"error retrieve all data");
        }
    }else{
        success = NO;
    }
    
    errorMessage = [resultsDictionary objectForKey:@"message"];
    
    [resultsDictionary release];
    
    return success;
}

- (void)retrieveImages: (NSString *)uri
{
//    ASIHTTPRequest *imageRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:uri]];
//    //NSLog(@"retrieve image ..");
//    [imageRequest startSynchronous];
//    [imageRequest setTimeOutSeconds:2];
//    NSError *error = [imageRequest error];
    
//    [ setImageWithURL:[NSURL URLWithString:uri]
//                   placeholderImage:[UIImage imageNamed:@"default_icon"]
//                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//                                  if (!error) {
//                                      [self.detailsData.imageArray addObject:image];
//                                  }else{
//                                      //NSLog(@"error retrieve image: %@",error);
//                                  }
//                              
//                              }];
    
//    UIImage *aImg = [[UIImage alloc] initWithData:[imageRequest responseData]];
    
//    if (!error) {
//        [self.detailsData.imageArray addObject:aImg];
//    }else{
//        //NSLog(@"error retrieve image: %@",error);
//    }
    
//    [aImg release];
//    [imageRequest release];
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_titleLabel release];
    [_shareView release];
    [_shareFBButton release];
    [_shareTwitterButton release];
    [_providerLabel release];
    [_shareEmailButton release];
    [_aDescriptionView release];
    [_detailsData release];
    [_blankView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTitleLabel:nil];
    [self setShareView:nil];
    [self setShareFBButton:nil];
    [self setShareTwitterButton:nil];
    [self setProviderLabel:nil];
    [self setShareEmailButton:nil];
    [self setADescriptionView:nil];
    [self setBlankView:nil];
    [super viewDidUnload];
}
@end
