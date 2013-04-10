//
//  LoginViewController.h
//  myjam
//
//  Created by nazri on 11/15/12.
//  Copyright (c) 2012 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@interface LoginViewController : UIViewController<UITextFieldDelegate, UIApplicationDelegate>
{
    NSString *fb_userName;
    NSString *fb_userEmail;
    NSString *fb_id;
    NSString *fb_token;
}

@property (retain, nonatomic) IBOutlet UITextField *usernameTextField;
@property (retain, nonatomic) IBOutlet UITextField *passwordTextField;
@property CGFloat animatedDistance;
@property (retain, nonatomic) IBOutlet UILabel *showPasswordlabel;
@property (retain, nonatomic) IBOutlet UIButton *checkBox;
@property (nonatomic) NSInteger loginUsingFB;
@property (nonatomic, retain) NSString *fbSessionStatus;
@property (nonatomic, retain) NSString *fb_userName, *fb_userEmail, *fb_id, *fb_token;

- (IBAction)fbLoginAction:(id)sender;

- (IBAction)loginJambu:(id)sender;

@end
