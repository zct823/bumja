//
//  SocialViewController.m
//  myjam
//
//  Created by nazri on 12/18/12.
//  Copyright (c) 2012 me-tech. All rights reserved.
//

#import "SocialViewController.h"
#import "ShowSocialViewController.h"
#import "Barcode.h"
#import "ASIWrapper.h"
#import "CustomAlertView.h"
#import "FontLabel.h"
#import <Twitter/Twitter.h>

#define kFrameHeightOnKeyboardUp 460.0f
#define kFrameHeightOnKeyboardDown 763.0f

@interface SocialViewController ()

@end

@implementation SocialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.navigationItem.title = @"Create";
        
        //TITLE
        self.title = @"Create";
        FontLabel *titleView = [[FontLabel alloc] initWithFrame:CGRectZero fontName:@"jambu-font.otf" pointSize:22];
        titleView.text = self.title;
        titleView.textAlignment = NSTextAlignmentCenter;
        titleView.backgroundColor = [UIColor clearColor];
        titleView.textColor = [UIColor whiteColor];
        [titleView sizeToFit];
        self.navigationItem.titleView = titleView;
        [titleView release];
        
        // Init scrollview
//        self.scroller = (TPKeyboardAvoidingScrollView *)self.view;
//        [self.scroller setContentSize:self.contentView.frame.size];
//        [self.scroller addSubview:self.contentView];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //NSLog(@"type: %@",self.socialType);
    //NSLog(@"url: %@",self.socialUrl);
    
    [self.previewButton addTarget:self action:@selector(checkMandatoryFieldFirst) forControlEvents:UIControlEventTouchUpInside];
    [self.saveButton addTarget:self action:@selector(saveCreatedQR) forControlEvents:UIControlEventTouchUpInside];
    
    self.categories = [[NSMutableDictionary alloc] init];
    // Setup pickerview
    self.pickerView = [[UIPickerView alloc] init];
    // Set pickerview delegate
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    // Set the picker's frame.
    self.pickerView.showsSelectionIndicator = YES;
    
    // Toolbar for pickerView
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.barStyle = UIBarStyleBlack;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneClicked:)];
    
    UIBarButtonItem *spacer = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    
//    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStyleBordered target:self action:@selector(pickerCancelClicked)];
    
    [toolbar setItems:[NSArray arrayWithObjects: spacer, doneButton, nil]];
    
    self.categoryTextField.inputAccessoryView = toolbar;
    //set list of pickerView
    self.categoryTextField.inputView = self.pickerView;
    
    //set url
    self.urlTextField.text = self.socialUrl;
    
    // Set textfield delegate to enable dismiss keyboard
    self.appTitleTextField.delegate = self;
    self.nameTextField.delegate = self;
    self.urlTextField.delegate = self;
    
    self.contentView.frame = CGRectMake(0, 0.0f, self.contentView.frame.size.width, kFrameHeightOnKeyboardUp+44);
    
    // Init scrollview
    self.scroller = (TPKeyboardAvoidingScrollView *)self.view;
    [self.scroller setContentSize:self.contentView.frame.size];
    [self.scroller addSubview:self.contentView];
    
    //hide shareView
    [self.shareView setHidden:YES];
    
    // Setup share button in shareVIew
    [self.shareFBButton addTarget:self action:@selector(shareImageOnFB) forControlEvents:UIControlEventTouchUpInside];
    [self.shareTwitterButton addTarget:self action:@selector(shareImageOnTwitter) forControlEvents:UIControlEventTouchUpInside];
    [self.shareEmailButton addTarget:self action:@selector(shareImageOnEmail) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (![self.dataArray count]) {
//        [self performSelectorInBackground:@selector(setupCategoryList) withObject:nil];
        [self setupCategoryList];
    }
    //NSLog(@"vda");
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    //NSLog(@"vwa");
//}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    //NSLog(@"vwdSocial");
//    [self.scroller setContentOffset:CGPointMake(0, 0) animated:NO];
//    for (UITextField *aView in [self.contentView subviews]) {
//        if ([aView isKindOfClass:[UITextField class]]) {
//            aView.text = nil;
//        }
//    }
//    [self.previewButton setTitle:@"Preview" forState:UIControlStateNormal];
//    [self.previewButton setEnabled:YES];
//    [self.saveButton setEnabled:YES];
//    [self.shareView setHidden:YES];
//}

- (void)setupCategoryList
{
    // Init the category data
    [self getCategoriesFromAPI];
    // Set list for pickerView
    self.dataArray = [[NSMutableArray alloc] initWithArray:[self.categories allKeys]];
    [self.dataArray sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

#pragma mark -
#pragma mark PickerView action button

- (void)getCategoriesFromAPI
{
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Please wait..." width:100];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/api/qrcode_category.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
    NSString *dataContent = [NSString stringWithFormat:@"{\"src\":\"\"}"];
    NSDictionary *cat;
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
    NSDictionary *resultsDictionary = [[response objectFromJSONString] mutableCopy];
    
    //NSLog(@"resp: %@",response);
    if([resultsDictionary count])
    {
        NSString *status = [resultsDictionary objectForKey:@"status"];
        
        if ([status isEqualToString:@"ok"])
        {
            cat = [resultsDictionary objectForKey:@"list"];
            
            for (id row in cat)
            {
                [self.categories setObject:[row objectForKey:@"category_id"] forKey:[row objectForKey:@"category_name"]];
            }
            
            [DejalBezelActivityView removeViewAnimated:YES];
        }
        else
        {
            CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Create Failed" message:@"Connection failure. Please try again later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.tag = kAlertNoConnection;
            [alert show];
            [alert release];
        }
        
    }
}

- (IBAction)pickerDoneClicked:(id)sender
{
    //    UITextField *catBox = (UITextField *)[self.view viewWithTag:10];
    if (![self.categoryTextField.text length]) {
        self.categoryTextField.text = [self.dataArray objectAtIndex:0];
    }
    
    self.categoryId = [self.categories objectForKey:self.categoryTextField.text];
    [self.categoryTextField resignFirstResponder];
}

- (IBAction)pickerCancelClicked
{
    self.categoryTextField.text = nil;
    [self.categoryTextField resignFirstResponder];
}

#pragma mark -
#pragma mark share action handler

- (void)addShareItemtoServer:(NSString *)aQRcodeId withShareType:(NSString *)aType
{
    NSString *urlString = [NSString stringWithFormat:@"%@/api/qrcode_share.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
    
    NSString *dataContent = [NSString stringWithFormat:@"{\"qrcode_id\":%@,\"share_type\":\"%@\"}",aQRcodeId,aType];
    
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
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"JAM-BU App"];
        UIImage *myImage = self.imagePreview.image;
        NSData *imageData = UIImagePNGRepresentation(myImage);
        [mailer addAttachmentData:imageData mimeType:@"image/png" fileName:qrcodeId];
        NSString *emailBody = [NSString stringWithFormat:@"Scan this QR code. \n\nJAM-BU App: %@/?qrcode_id=%@",APP_API_URL,qrcodeId];
        [mailer setMessageBody:emailBody isHTML:NO];
        [self presentModalViewController:mailer animated:YES];
        [mailer release];
        [self addShareItemtoServer:qrcodeId withShareType:@"email"];
    }
    else
    {
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Save" message:@"Please configure your mail in Mail Application" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
    else if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
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
    [twitter addImage:self.imagePreview.image];
    
    [self presentViewController:twitter animated:YES completion:nil];
    
    twitter.completionHandler = ^(TWTweetComposeViewControllerResult res) {
        
        if(res == TWTweetComposeViewControllerResultDone) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Successfully posted." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            
            [alert show];
            [alert release];
            
            [self addShareItemtoServer:qrcodeId withShareType:@"twitter"];
            
        }
        if(res == TWTweetComposeViewControllerResultCancelled) {
            /*
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Cancelled" message:@"You Cancelled posting the Tweet." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
             
             [alert show];
             */
        }
        [self dismissModalViewControllerAnimated:YES];
        
    };
    
    
}

- (void)callAPIShare:(int)option
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
        
        [mySLComposerSheet addImage:self.imagePreview.image];
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
                    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Save" message:output delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                    
                    [self addShareItemtoServer:qrcodeId withShareType:[type lowercaseString]];
                    
                    break;
                    [self dismissModalViewControllerAnimated:YES];
            }
            
        }];
        
        
        
    }else{
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Save" message:[NSString stringWithFormat:@"Please add your %@ account in IOS Device Settings and allow JAM-BU to access your %@ information.",type,type] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    
}

#pragma mark -
#pragma mark alertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == kAlertNoConnection) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        if (buttonIndex == 1) {
            [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading ..." width:100];
            //NSLog(@"saved");
            [self performSelector:@selector(processCreateSocialQR) withObject:nil afterDelay:0.0];
//            [self processCreateSocialQR];
        }
    }
    
}

- (void)saveCreatedQR
{
    [self.view endEditing:YES];
    
    // If OK, go to alertview delegate
    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Save" message:@"You cannot make any changes once it is saved. Press OK to continue." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    alert.tag = kAlertSave;
    [alert show];
    [alert release];
}

#pragma mark -
#pragma mark button preview

- (void)checkMandatoryFieldFirst
{
    
    [self.view endEditing:YES];
    
    if ([self.appTitleTextField.text length] == 0)
    {
        reqFieldName = @"JAM-BU App Title";
        [self triggerRequiredAlert];
    }
    else if ([self.categoryTextField.text length] == 0)
    {
        reqFieldName = @"Category";
        [self triggerRequiredAlert];
    }
    else if ([self.nameTextField.text length] == 0)
    {
        reqFieldName = @"Name";
        [self triggerRequiredAlert];
    }
    else if ([self.urlTextField.text length] == 0)
    {
        reqFieldName = @"URL";
        [self triggerRequiredAlert];
    }
    else
    {
        [self updatePreview];
    }
    
}

- (void)triggerRequiredAlert
{
    NSString *reqMsg = [NSString stringWithFormat:@"%@ is required.",reqFieldName];
    
    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"JAM-BU Register" message:reqMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)updatePreview
{
    [self.view endEditing:YES];
    
    NSString *appTitle = [NSString stringWithFormat:@"%@",self.appTitleTextField.text];
    
    NSString *sName = [NSString stringWithFormat:@"%@",self.nameTextField.text];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@",self.urlTextField.text];
    
    if ([self.appTitleTextField.text length] == 0 || [self.nameTextField.text length] == 0 || [self.categoryTextField.text length] == 0) {
        return;
    }
    else {
    
    //NSLog(@"update Preview");
    
    self.appTitleLabel.text = [NSString stringWithFormat:@"%@",appTitle];
    self.descTextView.text = [NSString stringWithFormat:@"Name: %@\nUrl: %@\n", sName, sUrl];
    //    NSString *qrcodeId = [self processCreateSocialQR];
    
//    Barcode *barcode = [[Barcode alloc] init];
//    [barcode setupQRCode:[NSString stringWithFormat:@"%@/preview/",APP_API_URL]];
//    self.imagePreview.image = barcode.qRBarcode;
//    [barcode release];
        
    self.imagePreview.image = [UIImage imageNamed:@"preview"];
    
    [self.previewButton setTitle:@"Update Preview" forState:UIControlStateNormal];
    
    // show the bottom view for the result
    self.contentView.frame = CGRectMake(0, 0.0f, self.contentView.frame.size.width, kFrameHeightOnKeyboardDown+44);
    [self.scroller setContentSize:CGSizeMake(self.contentView.frame.size.width, kFrameHeightOnKeyboardDown+44)];
    
    // auto scroll to bottom
    CGPoint bottomOffset = CGPointMake(0, self.scroller.contentSize.height - self.scroller.bounds.size.height);
    [self.scroller setContentOffset:bottomOffset animated:YES];
    }
}

- (void)processCreateSocialQR
{
    NSString *urlString = [NSString stringWithFormat:@"%@/api/qrcode_social.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
    
    NSString *dataContent = [NSString stringWithFormat:@"{\"app_title\":\"%@\",\"category_id\":\"%@\",\"social_type\":\"%@\",\"social_name\":\"%@\",\"social_url\":\"%@\"}",
                             self.appTitleTextField.text,
                             [self.categories objectForKey:self.categoryTextField.text],
                             self.socialType,
                             self.nameTextField.text,
                             self.urlTextField.text];
    
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
    //NSLog(@"abc: %@, def:%@",dataContent, response);
    NSDictionary *resultsDictionary = [[response objectFromJSONString] mutableCopy];
    
    if([resultsDictionary count])
    {
        NSString *status = [resultsDictionary objectForKey:@"status"];
        NSString *msg = [resultsDictionary objectForKey:@"message"];
        
        if ([status isEqualToString:@"ok"])
        {
            qrcodeId = [resultsDictionary objectForKey:@"qrcode_id"];
            //NSLog(@"Success submit social");
            Barcode *barcode = [[Barcode alloc] init];
            [barcode setupQRCode:[NSString stringWithFormat:@"http://%@/scan/%@",SCAN_URL,qrcodeId]];
            self.imagePreview.image = barcode.qRBarcode;
            [barcode release];
            
            [self.previewButton setEnabled:NO];
            [self.saveButton setEnabled:NO];
            [self.shareView setHidden:NO];
        }else if([msg isEqualToString:@"Request timed out."])
        {
            CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Request Timed Out" message:@"Please check on the JAM-BU create box" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else{
            //NSLog(@"Submit social error!");
            CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"JAM-BU Create" message:[resultsDictionary objectForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }
    [DejalBezelActivityView removeViewAnimated:YES];
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
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Save" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    
    // Remove the mail view
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UIPickerView Delegate
// Number of components.
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// Total rows in our component.
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.dataArray count];
}

// Display each row's data.
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.dataArray objectAtIndex: row];
}

// Do something with the selected row.
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    //NSLog(@"option selected %d", row);
    
    self.categoryTextField.text = [self.dataArray objectAtIndex:row];
}

#pragma mark -
#pragma mark textField delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.scroller setContentSize:CGSizeMake(self.contentView.frame.size.width, kFrameHeightOnKeyboardUp)];
    [self.scroller adjustOffsetToIdealIfNeeded];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.scroller setContentSize:CGSizeMake(self.contentView.frame.size.width, kFrameHeightOnKeyboardUp+44)];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_imagePreview release];
    [_contentView release];
    [_nameTextField release];
    [_categoryTextField release];
    [_appTitleTextField release];
    [_urlTextField release];
    [_appTitleLabel release];
    [_descTextView release];
    [_previewButton release];
    [_saveButton release];
    [_shareView release];
    [_socialType release];
    [_socialUrl release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setImagePreview:nil];
    [self setContentView:nil];
    [self setNameTextField:nil];
    [self setCategoryTextField:nil];
    [self setAppTitleTextField:nil];
    [self setUrlTextField:nil];
    [self setAppTitleLabel:nil];
    [self setDescTextView:nil];
    [self setPreviewButton:nil];
    [self setSaveButton:nil];
    [self setShareView:nil];
    [self setSocialType:nil];
    [self setSocialUrl:nil];
    [super viewDidUnload];
}

@end
