//
//  LoginViewController.m
//  myjam
//
//  Created by nazri on 11/15/12.
//  Copyright (c) 2012 me-tech. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "FBAppDelegate.h"
#import "ASIWrapper.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomAlertView.h"
#import "FontLabel.h"
#import "FontLabelStringDrawing.h"
#import "FontManager.h"
#import "RegisterViewController.h"
#import "ForgotPassViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize animatedDistance;
@synthesize loginUsingFB;
@synthesize fb_userName,fb_userEmail,fb_id,fb_token;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(triggerAutoFBLogin:) name:@"runFBlogin" object:nil];
    
    return self;
}

- (void)triggerAutoFBLogin:(NSNotification *)notification
{
    if([[notification name]isEqualToString:@"runFBlogin"])
    {
        [self runFBLoginAction];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if ([self.usernameTextField.text length] > 0 && [self.passwordTextField.text length] > 0)
    {
        [self loginJambu:nil];
    }
    
    
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    loginUsingFB = 0;
    
    //NSLog(@"Login FB: %d",loginUsingFB);
    
    // Setup screen for retina 4
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    if (screenBounds.size.height == 568) {
        // code for 4-inch screen
        self.view.frame = CGRectMake(0,0,self.view.bounds.size.width, 568);
    } else {
        // code for 3.5-inch screen
        self.view.frame = CGRectMake(0,0,self.view.bounds.size.width, 480);
    }

    // Setup checkbox
    [self.checkBox.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [self.checkBox.layer setBorderWidth:1.0f];
    
    [self.checkBox addTarget:self action:@selector(handleShowPassword) forControlEvents:UIControlEventTouchUpInside];
    
    self.showPasswordlabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapCheckbox = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleShowPassword)];
    [self.showPasswordlabel addGestureRecognizer:tapCheckbox];
    
    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    
    // Custom label
    FontLabel *label = [[FontLabel alloc] initWithFrame:CGRectMake(133, 395, 0, 0) fontName:@"jambu-font.otf" pointSize:25.0f];
	label.textColor = [UIColor colorWithHex:@"#D22042"];
	label.text = @"Register Now!";
	[label sizeToFit];
	label.backgroundColor = nil;
	label.opaque = NO;
    
    // Add tap recognizer to label
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapRegister = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushRegisterView)];
    [label addGestureRecognizer:tapRegister];
    
    //---FORGOT PASSWORD---//
    FontLabel *forgotPass = [[FontLabel alloc] initWithFrame:CGRectMake(133, 430, 0, 0) fontName:@"jambu-font.otf" pointSize:17.0f];
    forgotPass.textColor = [UIColor colorWithHex:@"#D22042"];
    forgotPass.text = @"Forgot Password";
    [forgotPass sizeToFit];
    forgotPass.backgroundColor = [UIColor clearColor];
    forgotPass.opaque = NO;
    forgotPass.userInteractionEnabled = YES;
    UIGestureRecognizer *forgotPassView = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(forgotPassView)];
    [forgotPass addGestureRecognizer:forgotPassView];
    
    /*
    //---LoginWithFB BTN---//
    UIButton *loginWithFBBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *loginWithFBImage = [UIImage imageNamed:@"login_fb_glossy.png"];
    CGRect btnFrame = CGRectMake(136, 180, loginWithFBImage.size.width-95, loginWithFBImage.size.height-15);
    
    loginWithFBBtn.frame = btnFrame;
    [loginWithFBBtn setBackgroundImage:loginWithFBImage forState:UIControlStateNormal];
    [loginWithFBBtn addTarget:self action:@selector(initFacebookLogin) forControlEvents:UIControlEventTouchUpInside];
    loginWithFBBtn.userInteractionEnabled = YES;
    */
     
    //--- OR Line ---//
    
    UIImage *orGreenLineImg = [UIImage imageNamed:@"login_or_w_greenline.png"];
    CGRect glineFrame = CGRectMake(136, 208, orGreenLineImg.size.width, orGreenLineImg.size.height);
    UIImageView *displayGreenLine = [[UIImageView alloc]initWithFrame:glineFrame];
    
    displayGreenLine.image = orGreenLineImg;
    
	[self.view addSubview:label];
    [self.view addSubview:forgotPass];
    //[self.view addSubview:loginWithFBBtn];
    [self.view addSubview:displayGreenLine];
    [tapRegister release];
    [forgotPassView release];
	[label release];
    [forgotPass release];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

# pragma mark -
# pragma mark FB Login Actions

- (IBAction)fbLoginAction:(id)sender
{
    FBAppDelegate *setDelegate = [[UIApplication sharedApplication]delegate];
    
    [setDelegate openSessionWithAllowLoginUI:YES];
    [self runFBLoginAction];
}

- (void)runFBLoginAction
{
    if(FBSession.activeSession.isOpen)
    {
        [self FBGetInfoNSendParam];
        
        AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [DejalBezelActivityView activityViewForView:mydelegate.window withLabel:@"Logging In..." width:100];
        
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
                
                [self performSelector:@selector(processLogin) withObject:nil afterDelay:1.0f];
            }
        }];

        
    }
    
}

# pragma -

- (void)pushRegisterView
{
    [self.view endEditing:YES];
    RegisterViewController *registerView = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerView animated:YES];
    [registerView release];
//    AppDelegate *mydelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [mydelegate.window addSubview:registerView.view];
//    [mydelegate.window bringSubviewToFront:registerView.view];
}

- (void)forgotPassView
{
    [self.view endEditing:YES];
    ForgotPassViewController *forgotPassVC = [[ForgotPassViewController alloc]init];
    forgotPassVC.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    [self presentViewController:forgotPassVC animated:YES completion:nil];
    [forgotPassVC release];
    
}

- (void)handleShowPassword
{
    self.passwordTextField.enabled = NO;
    if ([self.passwordTextField isSecureTextEntry]) {
        //NSLog(@"tapped NO");
        [self.passwordTextField setSecureTextEntry:NO];
        [self.checkBox setImage:[UIImage imageNamed:@"green_tick"] forState:UIControlStateNormal];
    }else{
        //NSLog(@"tapped YES");
        [self.passwordTextField setSecureTextEntry:YES];
        [self.checkBox setImage:nil forState:UIControlStateNormal];
    }
    self.passwordTextField.enabled = YES;

}

- (IBAction)loginJambu:(id)sender
{
    [self.view endEditing:YES];
    
    if ([self.usernameTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""]) {
        
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Login Error" message:@"Username and password are required" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading ..." width:100];
    
    [self performSelector:@selector(processLogin) withObject:nil afterDelay:0.0f];
    
}

- (void)processLogin
{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/api/login.php?",APP_API_URL];
    
    NSString *dataContent = [NSString stringWithFormat:@"{\"username\":\"%@\",\"password\":\"%@\"}",self.usernameTextField.text, self.passwordTextField.text];
    
    //NSLog(@"Recheck the value: Username is %@, email is %@, facebook_id is %@, and access token is %@",self.fb_userName,self.fb_userEmail,self.fb_id,self.fb_token);
    
    if (loginUsingFB == 1)
    {
        urlString = [NSString stringWithFormat:@"%@/api/facebook_connect.php?",APP_API_URL];

        dataContent = [NSString stringWithFormat:@"{\"username\":\"%@\",\"email\":\"%@\",\"facebook_id\":\"%@\",\"access_token\":\"%@\"}",self.fb_userName,self.fb_userEmail, self.fb_id, self.fb_token];
    }
    
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
        NSString *fname = [resultsDictionary objectForKey:@"first_name"];
        NSString *lname = [resultsDictionary objectForKey:@"last_name"];
        NSString *email = [resultsDictionary objectForKey:@"email"];
        NSString *mobile = [resultsDictionary objectForKey:@"mobileno"];
        
        //NSLog(@"token: %@, name %@",token, fname);
        if ([status isEqualToString:@"ok"])
        {
            [self handleSuccessLogin];
            
            // store token and remember-login in local cache
            NSUserDefaults *localData = [NSUserDefaults standardUserDefaults];
            [localData setObject:token forKey:@"tokenString"];
//            [localData setObject:fullname forKey:@"fullname"];
            if ([fname length] > 0) {
                [localData setObject:fname forKey:@"first_name"];
            }else{
                [localData setObject:fullname forKey:@"first_name"];
            }
            [localData setObject:lname forKey:@"last_name"];
            [localData setObject:email forKey:@"email"];
            [localData setObject:mobile forKey:@"mobile"];
            [localData setObject:[NSString stringWithFormat:@"YES"] forKey:@"islogin"];
//            [localData setObject:@"NO" forKey:@"isReloadNewsNeeded"];
            [localData setObject:@"YES" forKey:@"isDisplayTutorial"];
            
            if (![fname length]) {
                //NSLog(@"Profile not updated!");
                [localData setObject:@"NO" forKey:@"isProfileUpdated"];
            }
            
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

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
//    textField.contentInset = UIEdgeInsetsZero;
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if(heightFraction < 0.0){
        
        heightFraction = 0.0;
        
    }else if(heightFraction > 1.0){
        
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown){
        
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
        
    }else{
        
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_usernameTextField release];
    [_passwordTextField release];
    [_showPasswordlabel release];
    [_checkBox release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setUsernameTextField:nil];
    [self setPasswordTextField:nil];
    [self setShowPasswordlabel:nil];
    [self setCheckBox:nil];
    [super viewDidUnload];
}
@end
