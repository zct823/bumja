//
//  CoreViewController.m
//  jambu
//
//  Created by Azad Johari on 2/4/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "CoreViewController.h"

@interface CoreViewController ()

@end

@implementation CoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.backBarButtonItem =
        [[[UIBarButtonItem alloc] initWithTitle:@"Back"
                                          style:UIBarButtonItemStyleBordered
                                         target:nil
                                         action:nil] autorelease];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHex:@"#F8F8F8"]];
//    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
//    [self.view insertSubview:backgroundView atIndex:0];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setNavBarTitle:(NSString*)text{
    FontLabel *titleView = [[FontLabel alloc] initWithFrame:CGRectZero fontName:@"jambu-font.otf" pointSize:22];
    titleView.text = text;
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.backgroundColor = [UIColor clearColor];
    titleView.textColor = [UIColor whiteColor];
    [titleView sizeToFit];
    self.navigationItem.titleView = titleView;
    [titleView release];
}

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

- (void)shareImageOnEmailWithId:(NSString*)qrcodeId withImage:(UIImage*)image
{
    // popDisabled = YES;
    
    [self addShareItemtoServer:qrcodeId withShareType:@"email"];
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"JAM-BU App"];
        UIImage *myImage = image;
        NSData *imageData = UIImagePNGRepresentation(myImage);
        [mailer addAttachmentData:imageData mimeType:@"image/png" fileName:qrcodeId];
        NSString *emailBody = [NSString stringWithFormat:@"Scan this QR code. \n\nJAM-BU App: %@/?qrcode_id=%@",APP_API_URL,qrcodeId];
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

- (void)shareImageOnTwitterFor:(NSString*)qrcodeId andImage:(UIImage*)image
{
    //CHECK VERSION FIRST. Constant can refer from Constant.h
    if(SYSTEM_VERSION_EQUAL_TO(@"5.0") || SYSTEM_VERSION_EQUAL_TO(@"5.1"))
    {
        [self twitterAPIShareWith:qrcodeId ];
    }
    else
    {
        [self callAPIShare:kOPTION_TWITTER with:qrcodeId andImage:image];
    }
}

- (void)shareImageOnFBwith:(NSString*)qrcode andImage:(UIImage*)image
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
        [self callAPIShare:kOPTION_FB with:qrcode andImage:image];
    }
}

- (void)twitterAPIShareWith:(NSString*)qrcodeId //for iOS 5 and 5.1
{
    TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
    
    [twitter setInitialText:@""];
    //  [twitter addImage:[self.aImages lastObject]];
    
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
    
    [self addShareItemtoServer:qrcodeId withShareType:[@"Twitter" lowercaseString]];
}

- (void)callAPIShare:(int)option with:(NSString*)qrcodeId andImage:(UIImage*)image
{
    
    
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
        
        [mySLComposerSheet addImage:image];
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
    
    [self addShareItemtoServer:qrcodeId withShareType:[type lowercaseString]];
}
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


@end
