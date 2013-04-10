//
//  ForgotPassViewController.m
//  myjam
//
//  MemLeak:N/A
//
//  Created by Mohd Zulhilmi on 18/02/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "ForgotPassViewController.h"
#import "LoginViewController.h"
#import "CustomAlertView.h"
#import "AppDelegate.h"

#define kFrameHeightOnKeyboardUp 499.0f

@interface ForgotPassViewController ()

@end

@implementation ForgotPassViewController

@synthesize emailTextField,animatedDistance;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)animateDBAV:(NSString *)label
{
    AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [DejalBezelActivityView activityViewForView:mydelegate.window withLabel:label width:100];
    
}

- (void)deAnimateDBAV
{
    [DejalBezelActivityView removeViewAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImage *jambuLogo = [UIImage imageNamed:@"jambu_logo.png"];
    
    CGRect setImageFrame = CGRectMake(60, 50, jambuLogo.size.width, jambuLogo.size.height);
    
    UIImageView *setJambuLogoView = [[UIImageView alloc] initWithFrame:setImageFrame];
    
    setJambuLogoView.image = jambuLogo;
    setJambuLogoView.contentMode = UIViewContentModeCenter;
    
    
    FontLabel *forPassText = [[FontLabel alloc] initWithFrame:CGRectMake(70, 180, self.view.frame.size.width, 30) fontName:@"jambu-font.otf" pointSize:22];
    
    forPassText.text = @"Forgot Password?";
    forPassText.backgroundColor = [UIColor clearColor];
    forPassText.textColor = [UIColor colorWithHex:@"#5bac26"];
    forPassText.textAlignment = NSTextAlignmentCenter;

    
    FontLabel *emailText = [[FontLabel alloc] initWithFrame:CGRectMake(55, 240, self.view.frame.size.width, 30) fontName:@"jambu-font.otf" pointSize:15];
    
    emailText.text = @"Email";
    emailText.backgroundColor = [UIColor clearColor];
    emailText.textColor = [UIColor blackColor];
    emailText.textAlignment = NSTextAlignmentCenter;
    
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(80, 340, 70, 30);
    submitBtn.backgroundColor = [UIColor colorWithHex:@"#D22042"];
    [submitBtn setTitle:@"Submit" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    submitBtn.layer.borderColor = [UIColor blackColor].CGColor;
    submitBtn.layer.borderWidth = 0.5f;
    submitBtn.layer.cornerRadius = 10.0f;
    [submitBtn addTarget:self action:@selector(executingProcess) forControlEvents:UIControlEventTouchDown];
    submitBtn.userInteractionEnabled = YES;


    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(170, 340, 70, 30);
    cancelBtn.backgroundColor = [UIColor colorWithHex:@"#D22042"];
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    cancelBtn.layer.borderColor = [UIColor blackColor].CGColor;
    cancelBtn.layer.borderWidth = 0.5f;
    cancelBtn.layer.cornerRadius = 10.0f;
    [cancelBtn addTarget:self action:@selector(balikKeTempatAsal) forControlEvents:UIControlEventTouchDown];
    cancelBtn.userInteractionEnabled = YES;
    
    [self.view addSubview:setJambuLogoView];
    [self.view addSubview:forPassText];
    [self.view addSubview:emailText];
    [self.view addSubview:submitBtn];
    [self.view addSubview:cancelBtn];
    
    [setJambuLogoView release];
    [forPassText release];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //this is to hide keyboard after tapping done button.
    
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
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

- (void)executingProcess
{
    [self animateDBAV:@"Processing ..."];
    
    [self performSelector:@selector(hantarEmailKeRumahApi)];
    
    [self performSelector:@selector(deAnimateDBAV) withObject:nil afterDelay:0.2];
}

- (NSString *)tetapanRumahApi
{
    return [NSString stringWithFormat:@"%@/api/forgot_password.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
}

- (void)storeToServer:(NSString *)emailStr
{
    NSString *rumahApiURL = [self tetapanRumahApi];
    
    NSString *sendToServerParam = [NSString stringWithFormat:@"{\"email\":\"%@\"}",emailStr];
    
    NSString *wrappedDataFromServer = [ASIWrapper requestPostJSONWithStringURL:rumahApiURL andDataContent:sendToServerParam];
    
    //NSLog(@"Check wrapped data first: %@",wrappedDataFromServer);
    
    NSDictionary *wrappedDataToDictionary = [[wrappedDataFromServer objectFromJSONString] copy];
    
    NSString *currentStatus = nil;
    
    if([wrappedDataToDictionary count])
    {
        currentStatus = [wrappedDataToDictionary objectForKey:@"status"];
        NSString *message = [wrappedDataToDictionary objectForKey:@"message"];
        
        if ([currentStatus isEqualToString:@"ok"])
        {
            [self alertBox:@"Password reset link has been sent to your email."];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }
        else
        {
            //NSLog(@"Register failed");
            
            if ([message length] < 1) {
                //NSLog(@"Connection Error");
            }
            else
            {
                //NSLog(@"message: %@",message);
                [self alertBox:message];
            }
            
        }
    }
    
    
}

- (void)hantarEmailKeRumahApi
{
    [self.emailTextField endEditing:YES];
    //NSLog(@"HANTAREMEAL AND TEXFIELD: %@",self.emailTextField.text);
    
    if([self.emailTextField.text isEqualToString:@""])
    {
        [self alertBox:@"Email is required."];
    }
    else
    {
        [self storeToServer:self.emailTextField.text];
    }
    
}

- (void)alertBox:(NSString *)alertMsg
{
    CustomAlertView *alertView = [[CustomAlertView alloc]initWithTitle:@"Forgot Password?" message:alertMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

- (void)balikKeTempatAsal
{

    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
    
}

@end
