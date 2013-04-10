//
//  RegisterViewController.h
//  myjam
//
//  Created by nazri on 1/10/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "AppDelegate.h"
#import "FBAppDelegate.h"
#import "JSONKit.h"
#import "ASIWrapper.h"

@interface RegisterViewController : UIViewController<UIScrollViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>
{
    CGFloat animatedDistance;
    //UILabel *tncLink; -> keep reserved for future reference
    NSString *tncURL;
    NSString *reqFieldName;
}
//@property (retain, nonatomic) UIScrollView *scroller;
@property (retain, nonatomic) TPKeyboardAvoidingScrollView *scroller;
@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UITextField *usernameTextField;
@property (retain, nonatomic) IBOutlet UITextField *emailTextField;
@property (retain, nonatomic) IBOutlet UITextField *passwordTextField;
@property (retain, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (retain, nonatomic) IBOutlet UITextField *mobileNumTextField;
@property (retain, nonatomic) IBOutlet UIView *registeredView;
@property (nonatomic) NSInteger loginUsingFB;
@property (nonatomic, retain) NSString *fb_userName, *fb_userEmail, *fb_id, *fb_token;
//@property (nonatomic, retain) IBOutlet UILabel *tncLink; //termsNcondLink -> keep reserved for future reference

- (IBAction)loginWithFBAct:(id)sender;

@end
