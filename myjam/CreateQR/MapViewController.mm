//
//  MapViewController.m
//  myjam
//
//  Created by nazri on 12/12/12.
//  Copyright (c) 2012 me-tech. All rights reserved.
//

#import "MapViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Barcode.h"
#import "ShowMapViewController.h"
#import "CustomAlertView.h"
#import "ASIWrapper.h"
#import "SocialViewController.h"
#import "FontLabel.h"
#import <Twitter/Twitter.h>

#define kFrameHeight 815
#define kFrameHeightOri 1135

@interface MapViewController ()

@end

@implementation MapViewController {
    NSString *holdView;
}

@synthesize fullAddress;

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
        
        self.navigationItem.backBarButtonItem =
        [[[UIBarButtonItem alloc] initWithTitle:@"Back"
                                          style:UIBarButtonItemStyleBordered
                                         target:nil
                                         action:nil] autorelease];
        
        // Custom initialization
        self.scroller = (TPKeyboardAvoidingScrollView *)self.view;
        [self.scroller setContentSize:CGSizeMake(self.contentView.frame.size.width, kFrameHeight+44)];
        [self.scroller addSubview:self.contentView];
        
        self.mapDescTextField.layer.borderWidth = 1.0f;
        self.mapDescTextField.layer.borderColor = [[UIColor grayColor] CGColor];
        self.mapDescTextField.layer.cornerRadius = 8.0f;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStyleBordered target:self action:@selector(pickerCancelClicked)];
    
    [toolbar setItems:[NSArray arrayWithObjects:cancelButton, spacer, doneButton, nil]];
    
    self.categoryTextField.inputAccessoryView = toolbar;
    //set list of pickerView
    self.categoryTextField.inputView = self.pickerView;
    
    // Set textfield delegate to enable dismiss keyboard
    self.appTitleTextField.delegate = self;
    self.mapNameTextField.delegate = self;
    self.mapDescTextField.delegate = self;
    self.addressTextField.delegate = self;
    self.cityTextField.delegate = self;
    self.stateTextField.delegate = self;
    self.postcodeTextField.delegate = self;
    self.countryTextField.delegate = self;
    
    self.contentView.frame = CGRectMake(0, 0.0f, self.contentView.frame.size.width, kFrameHeightOri+44);
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
    holdView = @"";
    //NSLog(@"vda");
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    //NSLog(@"vwa");
//}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    //NSLog(@"not vwd");
//    if(![holdView isEqualToString:@"hold"])
//    {
//        //NSLog(@"vwd");
//        [self.scroller setContentOffset:CGPointMake(0, 0) animated:NO];
//        for (UITextField *aView in [self.contentView subviews]) {
//            if ([aView isKindOfClass:[UITextField class]]) {
//                aView.text = nil;
//            }
//        }
//        self.mapDescTextField.text = nil;
//        [self.previewButton setTitle:@"Preview" forState:UIControlStateNormal];
//        [self.previewButton setEnabled:YES];
//        [self.saveButton setEnabled:YES];
//        [self.shareView setHidden:YES];
//    }
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
#pragma mark textView delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    self.mapDescTextField.contentInset = UIEdgeInsetsZero;
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}

#pragma mark -
#pragma mark textField delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.scroller setContentSize:CGSizeMake(self.contentView.frame.size.width, kFrameHeight)];
    [self.scroller adjustOffsetToIdealIfNeeded];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.scroller setContentSize:CGSizeMake(self.contentView.frame.size.width, kFrameHeight+44)];
    
    if (textField.tag > 0) {
        // auto scroll to bottom
        CGPoint bottomOffset = CGPointMake(0, self.scroller.contentSize.height - self.scroller.bounds.size.height);
        [self.scroller setContentOffset:bottomOffset animated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
        UIImage *myImage = self.qrImageView.image;
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
    [twitter addImage:self.qrImageView.image];
    
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
        
        [mySLComposerSheet addImage:self.qrImageView.image];
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
            [self performSelector:@selector(processCreateMapQR) withObject:nil afterDelay:0.0];
//            [self processCreateMapQR];
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
    else if ([self.mapNameTextField.text length] == 0)
    {
        reqFieldName = @"Map Name";
        [self triggerRequiredAlert];
    }
    else if ([self.mapDescTextField.text length] == 0)
    {
        reqFieldName = @"Map Description";
        [self triggerRequiredAlert];
    }
    else if ([self.addressTextField.text length] == 0)
    {
        reqFieldName = @"Address";
        [self triggerRequiredAlert];
    }
    else if ([self.cityTextField.text length] == 0)
    {
        reqFieldName = @"City";
        [self triggerRequiredAlert];
    }
    else if ([self.postcodeTextField.text length] == 0)
    {
        reqFieldName = @"Postcode";
        [self triggerRequiredAlert];
    }
    else if ([self.stateTextField.text length] == 0)
    {
        reqFieldName = @"State";
        [self triggerRequiredAlert];
    }
    else if ([self.countryTextField.text length] == 0)
    {
        reqFieldName = @"Country";
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
    //NSLog(@"updatePreview");
    NSString *appTitle = [NSString stringWithFormat:@"%@",self.appTitleTextField.text];
    
    if ([appTitle length] && [self.mapNameTextField.text length] && [self.mapDescTextField.text length])
    {
        
        self.appTitileLabel.text = [NSString stringWithFormat:@"%@",appTitle];
        self.mapNameLabel.text = [NSString stringWithFormat:@"%@",self.mapNameTextField.text];
        self.self.fullAddress = [NSString stringWithFormat:@"%@",self.addressTextField.text];
        
        if ([self.cityTextField.text length]) {
            self.self.self.fullAddress = [self.fullAddress stringByAppendingFormat:@", %@",self.cityTextField.text];
        }
        
        if ([self.postcodeTextField.text length]) {
            self.fullAddress = [self.fullAddress stringByAppendingFormat:@", %@",self.postcodeTextField.text];
        }
        
        if ([self.stateTextField.text length]) {
            self.fullAddress = [self.fullAddress stringByAppendingFormat:@", %@",self.stateTextField.text];
        }
        
        if ([self.countryTextField.text length]) {
            self.fullAddress = [self.fullAddress stringByAppendingFormat:@", %@",self.countryTextField.text];
        }
        
        self.addressTextView.text = self.fullAddress;
        
//        Barcode *barcode = [[Barcode alloc] init];
//        [barcode setupQRCode:[NSString stringWithFormat:@"%@/preview/",APP_API_URL]];
//        self.qrImageView.image = barcode.qRBarcode;
//        [barcode release];
        
        self.qrImageView.image = [UIImage imageNamed:@"preview"];
        [self.previewButton setTitle:@"Update Preview" forState:UIControlStateNormal];
        
        // show results view at bottom
        self.contentView.frame = CGRectMake(0, 0.0f, self.contentView.frame.size.width, kFrameHeightOri+44);
        [self.scroller setContentSize:CGSizeMake(self.contentView.frame.size.width, kFrameHeightOri+44)];
        
        // auto scroll to bottom
        CGPoint bottomOffset = CGPointMake(0, self.scroller.contentSize.height - self.scroller.bounds.size.height);
        [self.scroller setContentOffset:bottomOffset animated:YES];
        
        CLLocationCoordinate2D cSearchLocation = [ShowMapViewController getLocationFromAddressString:self.fullAddress];
        //NSLog(@"lat %f lang %f",cSearchLocation.latitude, cSearchLocation.longitude);
    }
}

- (void)processCreateMapQR
{
    NSString *urlString = [NSString stringWithFormat:@"%@/api/qrcode_map.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
    
    NSString *dataContent = [NSString stringWithFormat:@"{\"app_title\":\"%@\",\"category_id\":\"%@\",\"map_name\":\"%@\",\"map_description\":\"%@\",\"map_address\":\"%@\",\"map_city\":\"%@\",\"map_postcode\":\"%@\",\"map_state\":\"%@\",\"map_country\":\"%@\"}",
                             self.appTitleTextField.text,
                             [self.categories objectForKey:self.categoryTextField.text],
                             self.mapNameTextField.text,
                             self.mapDescTextField.text,
                             self.addressTextField.text,
                             self.cityTextField.text,
                             self.postcodeTextField.text,
                             self.stateTextField.text,
                             self.countryTextField.text];
    
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
            //NSLog(@"Success submit contact");
            Barcode *barcode = [[Barcode alloc] init];
            [barcode setupQRCode:[NSString stringWithFormat:@"http://%@/scan/%@",SCAN_URL,qrcodeId]];
            self.qrImageView.image = barcode.qRBarcode;
            [barcode release];
            
            [self.previewButton setEnabled:NO];
            [self.saveButton setEnabled:NO];
            [self.shareView setHidden:NO];
        }
        else if([msg isEqualToString:@"Request timed out."])
        {
            CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Request Timed Out" message:@"Please check on the JAM-BU create box" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else{
            //NSLog(@"Submit contact error!");
            CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"JAM-BU Create" message:[resultsDictionary objectForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];        }
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)previewMap:(id)sender
{
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading ..." width:100];
    
    ShowMapViewController *smv = [[ShowMapViewController alloc] init];
    smv.mapAddress = self.fullAddress;
    holdView = @"hold";
    [self.navigationController pushViewController:smv animated:YES];
    [smv release];
    
    [DejalBezelActivityView removeViewAnimated:YES];
}

- (void)dealloc {
    [_appTitleTextField release];
    [_categoryTextField release];
    [_mapNameTextField release];
    [_mapDescTextField release];
    [_addressTextField release];
    [_cityTextField release];
    [_postcodeTextField release];
    [_stateTextField release];
    [_countryTextField release];
    [_previewButton release];
    [_qrImageView release];
    [_appTitileLabel release];
    [_mapNameLabel release];
    [_addressTextView release];
    [_saveButton release];
    [_shareView release];
    [_shareEmailButton release];
    [_shareFBButton release];
    [_shareTwitterButton release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setAppTitleTextField:nil];
    [self setCategoryTextField:nil];
    [self setMapNameTextField:nil];
    [self setMapDescTextField:nil];
    [self setAddressTextField:nil];
    [self setCityTextField:nil];
    [self setPostcodeTextField:nil];
    [self setStateTextField:nil];
    [self setCountryTextField:nil];
    [self setPreviewButton:nil];
    [self setQrImageView:nil];
    [self setAppTitileLabel:nil];
    [self setMapNameLabel:nil];
    [self setAddressTextView:nil];
    [self setSaveButton:nil];
    [self setShareView:nil];
    [self setShareEmailButton:nil];
    [self setShareFBButton:nil];
    [self setShareTwitterButton:nil];
    [super viewDidUnload];
}

@end
