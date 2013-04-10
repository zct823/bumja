//
//  RegisterViewController.m
//  myjam
//
//  Created by nazri on 1/10/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "RegisterViewController.h"
#import "FontLabel.h"
#import "FontLabelStringDrawing.h"
#import "FontManager.h"
#import "CustomAlertView.h"
#import "ASIWrapper.h"

#define kFrameHeightOnKeyboardUp 540.0f

@interface RegisterViewController ()

@end

@implementation RegisterViewController

@synthesize loginUsingFB;

//@synthesize tncLink;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // TITLE
        self.title = @"Register";
        FontLabel *titleView = [[FontLabel alloc] initWithFrame:CGRectZero fontName:@"jambu-font.otf" pointSize:22];
        titleView.text = self.title;
        titleView.textAlignment = NSTextAlignmentCenter;
        titleView.backgroundColor = [UIColor clearColor];
        titleView.textColor = [UIColor whiteColor];
        [titleView sizeToFit];
        self.navigationItem.titleView = titleView;
        [titleView release];
        
         
        // Custom initialization
        
        self.scroller = (TPKeyboardAvoidingScrollView *)self.view;
        
        // Add form view
        [self.scroller setContentSize:self.contentView.frame.size];
        [self.scroller addSubview:self.contentView];
        
        // Custom label
        FontLabel *getLabel = [[FontLabel alloc] initWithFrame:CGRectMake(26, 33, 0, 0) fontName:@"jambu-font.otf" pointSize:32.0f];
        getLabel.textColor = [UIColor colorWithHex:@"#00a99d"];
        getLabel.text = @"Get";
        [getLabel sizeToFit];
        getLabel.backgroundColor = [UIColor clearColor];
        getLabel.opaque = NO;
        
        [self.contentView addSubview:getLabel];
        [getLabel release];

        //=-=-=-=-=-=-=-= tncLabel with Link =-=-=-=-=-=-=-=
        
        CGRect tncLabelFrame = CGRectMake(32, 461, 280, 15);
        
        FontLabel *preTNC = [[FontLabel alloc] initWithFrame:tncLabelFrame fontName:@"jambu-font.otf" pointSize:12];
        
        preTNC.text = @"By joining, you acknowledge acceptance of the";
        preTNC.textAlignment = NSTextAlignmentCenter;
        preTNC.backgroundColor = [UIColor clearColor];
        
        tncLabelFrame = CGRectMake(100, 480, 120, 15);
        
        UITapGestureRecognizer *setUserInteract = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(triggerTnCWebPage)];
        
        FontLabel *tncLinkCustom = [[FontLabel alloc] initWithFrame:tncLabelFrame fontName:@"jambu-font.otf" pointSize:12];
        
        tncLinkCustom.text = @"Terms and Conditions";
        tncLinkCustom.textAlignment = NSTextAlignmentCenter;
        tncLinkCustom.userInteractionEnabled = YES;
        tncLinkCustom.textColor = [UIColor redColor];
        tncLinkCustom.backgroundColor = [UIColor clearColor];
        
        tncLabelFrame = CGRectMake(100, 491, 120, 1);
        
        UIView *horizontalLine = [[UIView alloc] initWithFrame:tncLabelFrame];
        horizontalLine.backgroundColor = [UIColor redColor];
        
        [tncLinkCustom addGestureRecognizer:setUserInteract];
        
        [self.contentView addSubview:preTNC];
        [self.contentView addSubview:tncLinkCustom];
        [self.contentView addSubview:horizontalLine];
        [tncLinkCustom release];
        [horizontalLine release];
        
        //=-=-=-=-=-=-=-= end Edited TNC label =-=-=-=-=-=-=-=
        
        //=-=-=-=-=-=-=-=-=- or line =-=-=-=-=-=-=-=-=-
        
        UIImage *orLineImg = [UIImage imageNamed:@"or_line.png"];
        UIImageView *orLineDisp = [[UIImageView alloc]initWithImage:orLineImg];
        orLineDisp.frame = CGRectMake(0, 110, self.view.bounds.size.width, orLineImg.size.height-22);
        
        [self.contentView addSubview:orLineDisp];
        [orLineDisp release];
        
        //=-=-=-=-=-=-=-= ended or line =-=-=-=-=-=-=-=
        
        loginUsingFB = 0;
        
        //join button style
        UIButton *joinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        joinButton.frame = CGRectMake((self.view.bounds.size.width/2)-(120/2), self.contentView.frame.size.height-60, 120, 48);    //your desired size
        joinButton.clipsToBounds = YES;
        joinButton.layer.cornerRadius = 18.0f;
        joinButton.backgroundColor = [UIColor colorWithHex:@"#D22042"];
        [joinButton setShowsTouchWhenHighlighted:YES];
        [joinButton setTitle:@"Join!" forState:UIControlStateNormal];
        [joinButton.titleLabel setFont:[UIFont boldSystemFontOfSize:28]];
        [joinButton setTintColor:[UIColor whiteColor]];
        [joinButton addTarget:self action:@selector(handleJoinButton) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:joinButton];
        
        
        // Success registered view
        
        // setup screen for retina 4
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        CGFloat yPoint;
        if (screenBounds.size.height == 568) {
            // code for 4-inch screen
            self.registeredView.frame = CGRectMake(0,0,self.view.bounds.size.width, 568);
            yPoint = 180;
        } else {
            // code for 3.5-inch screen
            self.registeredView.frame = CGRectMake(0,0,self.view.bounds.size.width, 480);
            yPoint = 180.0f;
        }
        
        
        // Custom label
        FontLabel *label = [[FontLabel alloc] initWithFrame:CGRectMake(20, yPoint, 0, 0) fontName:@"jambu-font.otf" pointSize:24.0f];
        label.textColor = [UIColor colorWithHex:@"#00a99d"];
        label.text = @"\nYAY!\n\nPlease check your email\nto verify your account.\n\nSee you soon!";
        label.numberOfLines = 0;
        [label sizeToFit];
        label.backgroundColor = nil;
        label.opaque = NO;
        
        [self.registeredView addSubview:label];
        [label release];
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Setup screen for retina 4
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    if (screenBounds.size.height == 568) {
        // code for 4-inch screen
        self.view.frame = CGRectMake(0,0,self.view.bounds.size.width, 568);
    } else {
        // code for 3.5-inch screen
        self.view.frame = CGRectMake(0,0,self.view.bounds.size.width, 480);
    }
    
    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.confirmPasswordTextField.delegate = self;
    self.emailTextField.delegate = self;
    self.mobileNumTextField.delegate = self;
    
    
}

#pragma mark -


- (IBAction)loginWithFBAct:(id)sender {

    FBAppDelegate *setDelegate = [[UIApplication sharedApplication]delegate];
    
    [setDelegate openSessionWithAllowLoginUI:YES];
    
    if(FBSession.activeSession.isOpen)
    {
        [self FBGetInfoNSendParam];
        
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"Logging In..." width:100];
        
    }
    
}

- (void)FBGetInfoNSendParam
{
    loginUsingFB = 1;
    //NSLog(@"LoginUsingFB: %d",loginUsingFB);
    if(FBSession.activeSession.isOpen)
    {
        //NSLog(@"Facebook is logged");
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
            if (!error)
            {
                //NSLog(@"Username: %@",user.name);
                //NSLog(@"User Email: %@",[user objectForKey:@"email"]);
                //NSLog(@"User ID: %@",[user objectForKey:@"id"]);
                //NSLog(@"User Access Token: %@",[[FBSession activeSession]accessToken]);
                
                self.fb_userName = user.name;
                self.fb_userEmail = [user objectForKey:@"email"];
                self.fb_id = [user objectForKey:@"id"];
                self.fb_token = [[FBSession activeSession]accessToken];
                
                [self performSelector:@selector(processLoginUsingFB) withObject:nil afterDelay:1.0f];
            }
        }];
    }
}

-(void)processLoginUsingFB
{
    NSString *urlString = [NSString stringWithFormat:@"%@/api/facebook_connect.php?",APP_API_URL];
    
    NSString *dataContent = [NSString stringWithFormat:@"{\"username\":\"%@\",\"email\":\"%@\",\"facebook_id\":\"%@\",\"access_token\":\"%@\"}",self.fb_userName,self.fb_userEmail, self.fb_id, self.fb_token];
    
    //NSLog(@"Recheck the value: Username is %@, email is %@, facebook_id is %@, and access token is %@",self.fb_userName,self.fb_userEmail,self.fb_id,self.fb_token);
    
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
    //NSLog(@"resp %@, data %@",response, dataContent);
    NSDictionary *resultsDictionary = [[response objectFromJSONString] mutableCopy];
    
    [DejalBezelActivityView removeViewAnimated:YES];
    
    if([resultsDictionary count])
    {
        NSString *status = [resultsDictionary objectForKey:@"status"];
        NSString *message = [resultsDictionary objectForKey:@"message"];
        NSString *token = [resultsDictionary objectForKey:@"token"];
        NSString *fullname = [resultsDictionary objectForKey:@"fullname"];
        NSString *email = [resultsDictionary objectForKey:@"email"];
        NSString *mobile = [resultsDictionary objectForKey:@"mobileno"];
        
        //NSLog(@"token: %@, name %@",token, fullname);
        if ([status isEqualToString:@"ok"])
        {
            [self handleSuccessLogin];
            
            // store token and remember-login in local cache
            NSUserDefaults *localData = [NSUserDefaults standardUserDefaults];
            [localData setObject:token forKey:@"tokenString"];
            [localData setObject:fullname forKey:@"fullname"];
            [localData setObject:email forKey:@"email"];
            [localData setObject:mobile forKey:@"mobile"];
            [localData setObject:[NSString stringWithFormat:@"YES"] forKey:@"islogin"];
//            [localData setObject:@"NO" forKey:@"isReloadNewsNeeded"];
            [localData setObject:@"YES" forKey:@"isDisplayTutorial"];
            
            NSString *counterKey = [NSString stringWithFormat:@"counter%@",token];
            NSString *counter = [localData objectForKey:counterKey];
            if (counter == nil) {
                //NSLog(@"Create counter for newly logged in user");
                [localData setObject:@"1" forKey:counterKey];
            }
            
            [localData synchronize];
        }else{
            //NSLog(@"Login failed");
            
            if ([message length] < 1) {
                //NSLog(@"Connection Error");
            }else{
                //NSLog(@"message: %@",message);
                CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"JAM-BU Login" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
        }
    }
    
    [resultsDictionary release];

}

- (void)handleSuccessLogin
{
    //NSLog(@"Login success");
    [UIView animateWithDuration:0.6f animations:^
     {
         self.view.alpha=0.0f;
     }
                     completion:^(BOOL finished)
     {
         [self.view removeFromSuperview];
         [self.navigationController.view removeFromSuperview];
     }];
    
    AppDelegate *mydelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (![mydelegate isSetupDone]) {
        //NSLog(@"re-setup all views");
        [mydelegate setupViews];
    }else{
        //NSLog(@"Clear and re-setup all views");
        [mydelegate clearViews];
        [mydelegate setupViews];
    }
    
    [mydelegate.tabView activateController:0];
    [mydelegate.tabView activateTabItem:0];
}


#pragma mark -


- (void)triggerTnCWebPage
{
    tncURL = [NSString stringWithFormat:@"%@/t&c",APP_API_URL];
    //NSLog(@"initiating URL string in HandleOpenSafari: %@",tncURL);
    
    NSURL *url = [NSURL URLWithString:tncURL];
    
    if (![[UIApplication sharedApplication] openURL:url])
        NSLog(@"Failed to open url: %@",[url description]);
}

- (void)handleJoinButton
{
    [self.view endEditing:YES];
    
    if ([self.usernameTextField.text isEqualToString:@""])
    {
        reqFieldName = @"Username";
        [self triggerRequiredAlert];
    }
    else if ([self.emailTextField.text isEqualToString:@""])
    {
        reqFieldName = @"Email";
        [self triggerRequiredAlert];
    }
    else if ([self.passwordTextField.text isEqualToString:@""])
    {
        reqFieldName = @"Password";
        [self triggerRequiredAlert];
    }
    else if ([self.confirmPasswordTextField.text isEqualToString:@""])
    {
        reqFieldName = @"Confirm Password";
        [self triggerRequiredAlert];
    }
    else{
        
        if (![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text])
        {
            CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"JAM-BU Register" message:@"Confirm password does not match" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else{
            [self.view endEditing:YES];
            [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading ..." width:100];
            [self performSelector:@selector(processRegister) withObject:nil afterDelay:0.0f];
//            [self processRegister];
//            [self performSelectorOnMainThread:@selector(processRegister) withObject:nil waitUntilDone:YES];
            
        }
    }
}

- (void)triggerRequiredAlert
{
    NSString *reqMsg = [NSString stringWithFormat:@"%@ is required.",reqFieldName];
    
    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"JAM-BU Register" message:reqMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)processRegister
{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/api/register.php?",APP_API_URL];
    NSString *dataContent = [NSString stringWithFormat:@"{\"username\":\"%@\",\"email\":\"%@\",\"password\":\"%@\",\"mobileno\":\"%@\"}",self.usernameTextField.text, self.emailTextField.text, self.passwordTextField.text, self.mobileNumTextField.text];
    
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
    //NSLog(@"%@",dataContent);
    NSDictionary *resultsDictionary = [[response objectFromJSONString] mutableCopy];
    
    [DejalBezelActivityView removeViewAnimated:YES];
    
    if([resultsDictionary count])
    {
        NSString *status = [resultsDictionary objectForKey:@"status"];
        NSString *message = [resultsDictionary objectForKey:@"message"];
        
        if ([status isEqualToString:@"ok"])
        {
            //NSLog(@"Register success");
            
            // Add form view
            [self.scroller addSubview:self.registeredView];
            [self.scroller setContentSize:self.registeredView.frame.size];
            [self.scroller setScrollEnabled:NO];
            [self.contentView removeFromSuperview];
        }
        else{
            //NSLog(@"Register failed");
            
            if ([message length] < 1) {
                //NSLog(@"Connection Error");
            }else{
                //NSLog(@"message: %@",message);
                CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"JAM-BU Register" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
        }
    }
    
   // [resultsDictionary release];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.scroller setContentOffset:CGPointMake(0, 0) animated:NO];
    for (UITextField *aView in [self.contentView subviews]) {
        if ([aView isKindOfClass:[UITextField class]]) {
            aView.text = nil;
        }
    }
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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

- (void)dealloc {
    [_scroller release];
    [_usernameTextField release];
    [_emailTextField release];
    [_passwordTextField release];
    [_confirmPasswordTextField release];
    [_mobileNumTextField release];
    [_contentView release];
    [_registeredView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setUsernameTextField:nil];
    [self setEmailTextField:nil];
    [self setPasswordTextField:nil];
    [self setConfirmPasswordTextField:nil];
    [self setMobileNumTextField:nil];
    [self setContentView:nil];
    [self setRegisteredView:nil];
    [super viewDidUnload];
}
@end
