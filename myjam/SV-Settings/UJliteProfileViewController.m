//
//  UJliteProfileViewController.m
//  myjam
//
//  Created by ME-Tech Mac User 2 on 2/14/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//
#import "UJliteProfileViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "AddMailViewController.h"
#import "EditMailViewController.h"
#import "SettingsViewController.h"
#import "ChangeImageViewController.h"
#import "CustomAddress.h"
#import "ASIWrapper.h"
#import "CustomAlertView.h"
#import "AppDelegate.h"
#import "MData.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>

#define kFrameHeightOnKeyboardUp 1095.0f
#define kStartAddressY 930.0f

@interface UJliteProfileViewController (){
    NSString *gen;
    NSString *reqFieldName;
    int addressIdTag;
    CGFloat kFrame;
}

@end

@implementation UJliteProfileViewController

@synthesize activityIndicator;

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
        
        // Init scrollview
        self.scroller = (TPKeyboardAvoidingScrollView *)self.view;
        [self.scroller setContentSize:self.contentView.frame.size];
        [self.scroller addSubview:self.contentView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[self loadData];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame = CGRectMake(20, 130, 130, 143);
    
    if ([self retrieveDataFromAPI])
    {
       // [self performSelectorOnMainThread:@selector(setupViews) withObject:nil waitUntilDone:NO];
    }else{
        //        [self setupErrorPage];
        NSLog(@"setupFailed");
    }
}

- (void)viewWillAppear:(BOOL)animated
{
//    [super viewWillAppear:animated];
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading..." width:100];
    [activityIndicator startAnimating];
    [self performSelector:@selector(loadData) withObject:self];
}

-(void)loadData
{
    //textfield delegate
    self.mobileTextField.delegate = self;
    self.firstNameTextField.delegate = self;
    self.lastNameTextField.delegate = self;
    self.dateOfBirthTextField.delegate = self;
    self.newEmailTextField.delegate = self;
    self.reNewEmailTextField.delegate = self;
    self.currPasswordTextField.delegate = self;
    self.newPasswordTextField.delegate = self;
    self.reNewPasswordTextField.delegate = self;
    
    //setup checkbox gender
    [self.maleCheckBox.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [self.maleCheckBox.layer setBorderWidth:1.0f];
    //[self.maleCheckBox addTarget:self action:@selector(mGender) forControlEvents:UIControlEventTouchUpInside];
    [self.femaleCheckBox.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [self.femaleCheckBox.layer setBorderWidth:1.0f];
    //[self.femaleCheckBox addTarget:self action:@selector(fGender) forControlEvents:UIControlEventTouchUpInside];
    
    //setup label change image
    self.changeImageLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapImageLabel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeImaged:)];
    [self.changeImageLabel addGestureRecognizer:tapImageLabel];
    
    //setup label gender
    self.maleLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *mTapCheckbox = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mGender)];
    [self.maleLabel addGestureRecognizer:mTapCheckbox];
    self.femaleLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *fTapCheckbox = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fGender)];
    [self.femaleLabel addGestureRecognizer:fTapCheckbox];
    
    //setup date picker
    self.datePicker = [[UIDatePicker alloc]init];
    [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.barStyle = UIBarStyleBlack;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneClicked:)];
    UIBarButtonItem *spacer = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    
    [toolbar setItems:[NSArray arrayWithObjects: spacer, doneButton, nil]];
    
    self.dateToolbar = toolbar;
    self.dateOfBirthTextField.inputView = self.datePicker;
    self.dateOfBirthTextField.inputAccessoryView = self.dateToolbar;
    
    [self.saveButton addTarget:self action:@selector(checkMandatoryFieldFirst) forControlEvents:UIControlEventTouchUpInside];
    
    //    self.contentView.frame = CGRectMake(0, 0.0f, self.contentView.frame.size.width, kFrameHeightOnKeyboardUp+44);
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"vda");
    
    if ([self retrieveDataFromAPI])
    {
        [self.contentView setHidden:NO];
        [self performSelectorOnMainThread:@selector(setupViews) withObject:nil waitUntilDone:NO];
    }else{
        NSLog(@"setupFailed");
        [self displayRequestProblemError];
    }

}

# pragma mark -
# pragma mark Error handle trigger

- (void)displayRequestProblemError
{
    CGRect frame = CGRectMake(0, -70, self.view.bounds.size.width, self.view.bounds.size.height);
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    
    label.text = @"Connection error. Please try again.";
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:label];
    [self.contentView setHidden:YES];
}

- (void)setupViews
{
    NSLog(@"setupViews");
    
    self.fNameLabel.text = [NSString stringWithFormat:@"%@ %@",self.fName,self.lName];
    self.emailLabel.text = self.email;
    self.mobileTextField.text = self.mobile;
    self.firstNameTextField.text = self.fName;
    self.lastNameTextField.text = self.lName;
    self.dateOfBirthTextField.text = [self formattedDate:self.dOBirth];
    if ([self.gender isEqualToString:@"M"]) {
        [self mGender];
    }
    else {
        [self fGender];
    }
    NSLog(@"ADDRESS :%@",self.addressArray);
    //setup address list view
    CGFloat aHeight = 0;
    int ind = 1;
    if ([self.addressArray isKindOfClass:[NSArray class]]) {
        for (id row in self.addressArray)
        {
            CustomAddress *addrs = [[CustomAddress alloc] initWithFrame:CGRectMake(0, kStartAddressY + aHeight, 320, 46)];
            aHeight = aHeight + addrs.frame.size.height;
            addrs.addressLabel.text = [NSString stringWithFormat:@"Address %d\n%@",ind++,[row objectForKey:@"address"]];
            
            if ([[row objectForKey:@"addressIsPrimary"] isEqualToString:@"Y"]) {
                [addrs.addressButton setImage:[UIImage imageNamed:@"checkbox_active"] forState:UIControlStateNormal];
                [addrs.primaryLabel setText:@"Primary"];
            } else {
                addrs.addressButton.tag = [[row objectForKey:@"addressId"] intValue];
                [addrs.addressButton addTarget:self action:@selector(setPrime:) forControlEvents:UIControlEventTouchUpInside];
            }
            addrs.addressLabel.userInteractionEnabled = YES;
            UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(deleteAddress:)];
            swipe.direction = UISwipeGestureRecognizerDirectionRight;
            swipe.numberOfTouchesRequired = 1;
            [addrs.addressLabel addGestureRecognizer:swipe];
            
            addrs.addressLabel.tag = [[row objectForKey:@"addressId"] intValue];
            UITapGestureRecognizer *tapEditMail = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editMail:)];
            [addrs.addressLabel addGestureRecognizer:tapEditMail];
            [tapEditMail release];
            [self.view addSubview:addrs];
            [addrs release];
        }
    }
    
    NSLog(@" height:%f",aHeight);
    //setup mailButton & saveButton
    CGFloat aHeightMail = kStartAddressY+aHeight;
    self.mailButton.frame = CGRectMake(0, aHeightMail, self.mailButton.frame.size.width, self.mailButton.frame.size.height);
    [self.view addSubview:self.mailButton];
    CGFloat aHeightSave = aHeightMail+self.mailButton.frame.size.height+10;
    self.saveButton.frame = CGRectMake(0, aHeightSave, self.saveButton.frame.size.width, self.saveButton.frame.size.height);
    [self.view addSubview:self.saveButton];
    
    //set scroller & content height
    [self.scroller setContentSize:CGSizeMake(self.contentView.frame.size.width, aHeightSave+self.saveButton.frame.size.height+46+60)];
    self.contentView.frame = CGRectMake(0, 0.0f, self.contentView.frame.size.width, aHeightSave+self.saveButton.frame.size.height+46+60);
    kFrame = self.contentView.frame.size.height;
}

- (void)checkMandatoryFieldFirst
{
    
    [self.view endEditing:YES];
    if ([self.mobileTextField.text length] == 0) {
        reqFieldName = @"Mobile number is required";
        [self triggerRequiredAlert];
    }
    else if ([self.firstNameTextField.text length] == 0) {
        reqFieldName = @"First Name is required";
        [self triggerRequiredAlert];
    }
    else if ([self.lastNameTextField.text length] == 0) {
        reqFieldName = @"Last Name is required";
        [self triggerRequiredAlert];
    }
    else if ([self.dateOfBirthTextField.text length] == 0) {
        reqFieldName = @"Date of birth is required";
        [self triggerRequiredAlert];
    }
    else if (([self.newEmailTextField.text length] != 0 || [self.reNewEmailTextField.text length] != 0) && (![self.newEmailTextField.text isEqualToString:self.reNewEmailTextField.text]))
    {
        reqFieldName = @"Email not match";
        [self triggerRequiredAlert];
    }
    else if ([self.currPasswordTextField.text length] != 0 || [self.newPasswordTextField.text length] != 0 || [self.reNewPasswordTextField.text length] != 0)
    {
        if ([self retrievePasswordFromAPI]) {
            reqFieldName = @"Wrong current password";
            [self triggerRequiredAlert];
        }
        else if (![self.newPasswordTextField.text isEqualToString:self.reNewPasswordTextField.text])
        {
            reqFieldName = @"New password and confirm password not match";
            [self triggerRequiredAlert];
        }
        else {
            [self saveChange];
        }
    }
    else
    {
        [self saveChange];
    }
}
- (void)triggerRequiredAlert
{
    NSString *reqMsg = [NSString stringWithFormat:@"%@.",reqFieldName];
    
    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Jambulite Profile" message:reqMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark -
#pragma mark retrieve all data

- (BOOL)retrieveDataFromAPI
{
    BOOL success = NO;
    self.flag = @"DEFAULT";
    NSString *urlString = [NSString stringWithFormat:@"%@/api/settings_jambulite_profile.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
    NSString *dataContent = [NSString stringWithFormat:@"{\"flag\":\"%@\"}",self.flag];
    
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
    //    NSLog(@"request %@\n%@\n\nresponse retrieveData: %@", urlString, dataContent, response);
    NSDictionary *resultsDictionary = [[response objectFromJSONString] mutableCopy];
    //    NSLog(@"dict %@",resultsDictionary);
    
    if([resultsDictionary count])
    {
        NSString *status = [resultsDictionary objectForKey:@"status"];
        NSDictionary* resultProfile;
        NSMutableArray* resultAddress;
        
        if ([status isEqualToString:@"ok"])
        {
            success = YES;
            resultProfile = [resultsDictionary objectForKey:@"profile"];
            self.mobile = [resultProfile objectForKey:@"mobileno"];
//            self.fName = [resultProfile objectForKey:@"fullname"];
            self.fName = [resultProfile objectForKey:@"first_name"];
            self.lName = [resultProfile objectForKey:@"last_name"];
            self.dOBirth = [resultProfile objectForKey:@"birth_date"];
            self.gender = [resultProfile objectForKey:@"gender"];
            self.email = [resultProfile objectForKey:@"email"];
            self.password = [resultProfile objectForKey:@"password"];
            NSString *urlImg = [resultProfile objectForKey:@"avatar_url"];
            NSLog(@"urlImg :%@",urlImg);
            [self.profileImage setImageWithURL:[NSURL URLWithString:urlImg]
                              placeholderImage:[UIImage imageNamed:@"blank_avatar.png"]];
            //     img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlImg]]];
            //      NSLog(@"urlImg :%@",img);
            //    [self.imgPro setImage:img];
            //            [img release];
            self.addressArray = nil;
            if (! [[resultsDictionary objectForKey:@"address"] isKindOfClass:[NSString class]]){
                //isKindOfClass: -> untuk check kalau [resultsDictionary objectForKey:@"address"] ni class apa? contohnya dekat sini, aku check kalau [resultsDictionary objectForKey:@"address"] bukan class string, baru check address. Sebab API kalau kosong dia return "" (string)
                resultAddress = [resultsDictionary objectForKey:@"address"];
                
                self.addressArray = resultAddress;
                NSLog(@"RESULTADDRESS :%@",resultAddress);
                for (id row in resultAddress)
                {
                    MData *aData = [[MData alloc] init];
                    
                    aData.addressId = [row objectForKey:@"addressId"];
                    aData.address = [row objectForKey:@"address"];
                    aData.city = [row objectForKey:@"city"];
                    aData.postcode = [row objectForKey:@"postcode"];
                    NSLog(@"%@", [[row objectForKey:@"state"] class]);
                    if ([[row objectForKey:@"state"] isKindOfClass:[NSNull class]]){
                    
                        aData.state = @"";
                        
                    }
                    else{
                        
                        aData.state = [row objectForKey:@"state"];
                    }
                     NSLog(@"%@", [aData.state class]);
                    aData.country = [row objectForKey:@"country"];
                    aData.addressIsPrimary = [row objectForKey:@"addressIsPrimary"];
                }
            }
        }
        //        [resultProfile release];
    }
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
    [DejalBezelActivityView removeViewAnimated:YES];
    [resultsDictionary release];
    return success;
}

- (BOOL)retrievePasswordFromAPI
{
    BOOL success = YES;
    self.flag = @"MD5";
    NSString *urlString = [NSString stringWithFormat:@"%@/api/settings_jambulite_profile.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
    NSString *dataContent = [NSString stringWithFormat:@"{\"flag\":\"%@\",\"passCurrent\":\"%@\"}",self.flag,self.currPasswordTextField.text];
    
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
    NSDictionary *resultsDictionary = [[response objectFromJSONString] mutableCopy];
    
    if([resultsDictionary count]) {
        NSString *status = [resultsDictionary objectForKey:@"status"];
        
        if ([status isEqualToString:@"ok"]) {
            success = NO;
        }
    }
    return success;
}

#pragma mark -
#pragma mark alertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == kAlertNoConnection) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else if(alertView.tag == kAlertSave){
        if (buttonIndex == 1) {
            [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading ..." width:100];
            NSLog(@"saved");
            [self performSelector:@selector(processSaveChange) withObject:nil afterDelay:0.0];
        }
    }else {
        if (buttonIndex == 1) {
            [DejalBezelActivityView activityViewForView:self.view withLabel:@"Deleting ..." width:100];
            NSLog(@"saved :%d",alertView.tag);
            [self performSelector:@selector(processDeleteAddress) withObject:nil afterDelay:0.0];
        }
    }
    
}

- (void)saveChange
{
    [self.view endEditing:YES];
    
    // If OK, go to alertview delegate
    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Save Settings" message:@"Press OK to continue." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    alert.tag = kAlertSave;
    [alert show];
    [alert release];
}

- (void)processSaveChange
{
    NSLog(@"process save");
    self.flag = @"SAVE_PROFILE";
    NSString *urlString = [NSString stringWithFormat:@"%@/api/settings_jambulite_profile.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];

    NSString *dataContent = @"";
    dataContent = [NSString stringWithFormat:@"{\"flag\":\"%@\",\"mobile\":\"%@\",\"name\":\"%@\",\"name2\":\"%@\",\"birthdate\":\"%@\",\"gender\":\"%@\"",
                             self.flag,
                             self.mobileTextField.text,
                             self.firstNameTextField.text,
                             self.lastNameTextField.text,
                             self.dateOfBirthTextField.text,
                             gen];
    if ([self.reNewEmailTextField.text length] > 0) {
        dataContent = [dataContent stringByAppendingFormat:@",\"email\":\"%@\"",self.reNewEmailTextField.text];
    }
    if ([self.currPasswordTextField.text length] > 0) {
        dataContent = [dataContent stringByAppendingFormat:@",\"passCurrent\":\"%@\"",self.currPasswordTextField.text];
    }
    if ([self.reNewPasswordTextField.text length] > 0) {
        dataContent = [dataContent stringByAppendingFormat:@",\"passNew\":\"%@\"",self.reNewPasswordTextField.text];
    }
    dataContent = [dataContent stringByAppendingFormat:@"}"];
    NSLog(@"Data :%@",dataContent);
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
    NSLog(@"abc: %@, def:%@",dataContent, response);
    NSDictionary *resultsDictionary = [[response objectFromJSONString] mutableCopy];
    NSLog(@"dict %@",resultsDictionary);
    if([resultsDictionary count])
    { NSLog(@"masuk2");
        NSString *status = [resultsDictionary objectForKey:@"status"];
        NSString *msg = [resultsDictionary objectForKey:@"message"];
        
        if ([status isEqualToString:@"ok"]) {
            NSLog(@"Successfully save change!");
            [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadView"object:self];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadImage"object:self];
        }
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Jambulite Profile" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    NSLog(@"end saved");
    [DejalBezelActivityView removeViewAnimated:YES];
}

- (void)changeImaged:(id)sender
{
    ChangeImageViewController *civc = [[ChangeImageViewController alloc] init];
    AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [mydelegate.otherNavController pushViewController:civc animated:YES];
    [civc release];
}

#pragma mark -
#pragma mark action Process

- (IBAction)addMail:(id)sender
{
    AddMailViewController *amvc = [[AddMailViewController alloc] init];
    AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [mydelegate.otherNavController pushViewController:amvc animated:YES];
    [amvc release];
}

- (void)editMail:(id)sender
{
    NSLog(@"ID sender :%d",[(UIGestureRecognizer *)sender view].tag);
    int ind = [(UIGestureRecognizer *)sender view].tag;
    for (id row in self.addressArray)
    {
        NSLog(@"loop edit address");
        if ([[row objectForKey:@"addressId"] intValue] == ind) {
            NSLog(@"editMailView");
            EditMailViewController *amvc = [[EditMailViewController alloc] init];
            amvc.addressId = [row objectForKey:@"addressId"];
            amvc.address = [row objectForKey:@"address"];
            amvc.city = [row objectForKey:@"city"];
            amvc.postcode = [row objectForKey:@"postcode"];
            amvc.state = [row objectForKey:@"state"];
            amvc.country = [row objectForKey:@"country"];
            AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [mydelegate.otherNavController pushViewController:amvc animated:YES];
            [amvc release];
            break;
        }
    }
    
}

- (void)setPrime:(id)sender
{
    UIButton* aid = (UIButton*) sender;
    NSLog(@"tag=%d",aid.tag);
    self.flag = @"SET_PRIMARY_ADDRESS";
    
    NSString *urlString = [NSString stringWithFormat:@"%@/api/settings_jambulite_profile.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
    NSString *dataContent = [NSString stringWithFormat:@"{\"flag\":\"%@\",\"addressId\":\"%ld\"}",
                             self.flag,
                             (long)aid.tag];
    
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
    NSLog(@"request %@\n%@\n\nresponse dataSetPrime: %@", urlString, dataContent, response);
    NSDictionary *resultsDictionary = [[response objectFromJSONString] mutableCopy];
    NSLog(@"dict %@",resultsDictionary);
    
    if([resultsDictionary count])
    {
        NSString *status = [resultsDictionary objectForKey:@"status"];
        NSString *msg = [resultsDictionary objectForKey:@"message"];
        
        if ([status isEqualToString:@"ok"]) {
            NSLog(@"Successfully set primary address!");
            [DejalBezelActivityView activityViewForView:self.view withLabel:@"Saving ..." width:100];
            [self performSelector:@selector(reloadView) withObject:nil afterDelay:0.2];
        }
        else {
            CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Jambulite Profile" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }
    NSLog(@"end saved");
}

- (void)deleteAddress:(id)sender
{
    [self.view endEditing:YES];
    NSLog(@"ID sent :%d",[(UIGestureRecognizer *)sender view].tag);
    int ind = [(UIGestureRecognizer *)sender view].tag;
    addressIdTag = ind;
    // If OK, go to alertview delegate
    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Delete Address" message:@"Press OK to continue." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    alert.tag = ind;
    [alert show];
    [alert release];
}

- (void)processDeleteAddress
{
    NSString *flag = @"DEL_ADDRESS";
    NSString *urlString = [NSString stringWithFormat:@"%@/api/settings_jambulite_profile.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
    NSString *dataContent = [NSString stringWithFormat:@"{\"flag\":\"%@\",\"addressId\":\"%d\"}",
                             flag,addressIdTag];
    
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
    NSLog(@"abc: %@, def:%@",dataContent, response);
    NSDictionary *resultsDictionary = [[response objectFromJSONString] mutableCopy];
    
    if([resultsDictionary count])
    {
        NSString *status = [resultsDictionary objectForKey:@"status"];
        NSString *msg = [resultsDictionary objectForKey:@"message"];
        
        if ([status isEqualToString:@"ok"]) {
            NSLog(@"Successfully delete address!");
            [self removeMailView];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadView"object:self];
        }
        else {
            CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Address Profile" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }
    [DejalBezelActivityView removeViewAnimated:YES];
}

#pragma mark -
#pragma mark notification Center

- (void) reloadView
{
    // All instances of TestClass will be notified
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadView"object:self];
}

- (id) init
{
    self = [super init];
    if (!self) return nil;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"reloadView"
                                               object:nil];
    return self;
}

- (void) receiveTestNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"reloadView"]) {
        NSLog (@"Successfully reload view!");
//        [self loadData];
        [self retrieveDataFromAPI];
        [self setupViews];
        [DejalBezelActivityView removeViewAnimated:YES];
    }
}

- (void) removeMailView
{
    for (UIView *aView in [self.view subviews]) {
        if ([aView isKindOfClass:[CustomAddress class]]) {
            [aView removeFromSuperview];
        }
    }
}

- (void)mGender
{
    NSLog(@"tapped MALE");
    gen = @"M";
    self.maleLabel.userInteractionEnabled = NO;
    self.femaleLabel.userInteractionEnabled = YES;
    [self.maleCheckBox setImage:[UIImage imageNamed:@"green_tick"] forState:UIControlStateNormal];
    [self.femaleCheckBox setImage:nil forState:UIControlStateNormal];
}

- (void)fGender
{
    NSLog(@"tapped FEMALE");
    gen = @"F";
    self.maleLabel.userInteractionEnabled = YES;
    self.femaleLabel.userInteractionEnabled = NO;
    [self.femaleCheckBox setImage:[UIImage imageNamed:@"green_tick"] forState:UIControlStateNormal];
    [self.maleCheckBox setImage:nil forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark textField delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.scroller setContentSize:CGSizeMake(self.contentView.frame.size.width, kFrame)];
    [self.scroller adjustOffsetToIdealIfNeeded];
    
    self.currTag = textField.tag;
    
    if (textField.tag > 1 && textField.tag < 6) {
        
        if (textField.tag >= 4) {
            self.datePicker.datePickerMode = UIDatePickerModeDate;
        }
    }
}

//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    [self.scroller setContentSize:CGSizeMake(self.contentView.frame.size.width, kFrame)];
//}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.scroller setContentSize:CGSizeMake(self.contentView.frame.size.width, kFrame)];
    self.currTag = textField.tag;
    if (self.currTag == 1) {
        // auto scroll to bottom
        NSLog(@"jeng :%f",self.scroller.bounds.size.height);
        CGPoint bottomOffset = CGPointMake(0, self.scroller.bounds.size.height - 50);
        [self.scroller setContentOffset:bottomOffset animated:YES];
    }
    else if (self.currTag == 2) {
        CGPoint bottomOffset = CGPointMake(0, self.scroller.bounds.size.height + 150);
        [self.scroller setContentOffset:bottomOffset animated:YES];
        NSLog(@"jeng2 :%f",self.scroller.contentSize.height - self.scroller.bounds.size.height);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark datePicker action

- (IBAction)pickerDoneClicked:(id)sender
{
    NSLog(@"currTag: %d",self.currTag);
    
    UITextField *currTextField = (UITextField *)[self.view viewWithTag:self.currTag];
    NSDate *newDate = [[NSDate alloc] init];
    
    if (self.selectedDate != nil) {
        newDate = self.selectedDate;
    }
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    if (self.currTag >= 4) {
        [format setDateFormat:@"dd-MM-yyyy"]; }
    
    currTextField.text = [format stringFromDate:newDate];
    
    NSLog(@"%@",currTextField.text);
    [format release];
    [currTextField resignFirstResponder];
}

- (void)dateChanged:(UIDatePicker *)datePicker
{
    self.selectedDate = datePicker.date;
}

- (NSString *)formattedDate:(NSString *)date
{
    NSString *rDate = @"";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *newDate = [dateFormatter dateFromString:date];
    [dateFormatter release];
    
    NSDateFormatter *stringFormatter = [[NSDateFormatter alloc] init];
    [stringFormatter setDateFormat:@"dd-MM-yyyy"];
    rDate = [stringFormatter stringFromDate:newDate];
    [stringFormatter release];
    
    return rDate;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_mobileTextField release];
    [_newEmailTextField release];
    [_reNewEmailTextField release];
    [_datePicker release];
    [_dateToolbar release];
    [_currPasswordTextField release];
    [_newPasswordTextField release];
    [_reNewPasswordTextField release];
    [_firstNameTextField release];
    [_lastNameTextField release];
    [_dateOfBirthTextField release];
    [_maleCheckBox release];
    [_maleLabel release];
    [_femaleCheckBox release];
    [_femaleLabel release];
    [_saveButton release];
    [_profileImage release];
    [_changeImageLabel release];
    [_fNameLabel release];
    [_emailLabel release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setMobileTextField:nil];
    [self setNewEmailTextField:nil];
    [self setReNewEmailTextField:nil];
    [self setDatePicker:nil];
    [self setDateToolbar:nil];
    [self setCurrPasswordTextField:nil];
    [self setNewPasswordTextField:nil];
    [self setReNewPasswordTextField:nil];
    [self setFirstNameTextField:nil];
    [self setLastNameTextField:nil];
    [self setDateOfBirthTextField:nil];
    [self setMaleCheckBox:nil];
    [self setMaleLabel:nil];
    [self setFemaleCheckBox:nil];
    [self setFemaleLabel:nil];
    [self setSaveButton:nil];
    [self setProfileImage:nil];
    [self setChangeImageLabel:nil];
    [self setFNameLabel:nil];
    [self setEmailLabel:nil];
    [super viewDidUnload];
}

@end
