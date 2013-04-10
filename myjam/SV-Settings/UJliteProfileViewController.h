//
//  UJliteProfileViewController.h
//  myjam
//
//  Created by ME-Tech Mac User 2 on 2/14/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@class TPKeyboardAvoidingScrollView;

@interface UJliteProfileViewController : UIViewController<UIScrollViewDelegate, UITextFieldDelegate,UIAlertViewDelegate>

@property (retain, nonatomic) TPKeyboardAvoidingScrollView *scroller;
@property (retain, nonatomic) IBOutlet UIView *contentView;

@property (retain, nonatomic) IBOutlet UITextField *mobileTextField;
@property (retain, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (retain, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (retain, nonatomic) IBOutlet UITextField *dateOfBirthTextField;
@property (retain, nonatomic) IBOutlet UITextField *newEmailTextField;
@property (retain, nonatomic) IBOutlet UITextField *reNewEmailTextField;
@property (retain, nonatomic) IBOutlet UITextField *currPasswordTextField;
@property (retain, nonatomic) IBOutlet UITextField *newPasswordTextField;
@property (retain, nonatomic) IBOutlet UITextField *reNewPasswordTextField;
@property (retain, nonatomic) IBOutlet UIButton *mailButton;
@property (retain, nonatomic) IBOutlet UIButton *saveButton;

@property (retain, nonatomic) IBOutlet UIImageView *profileImage;
@property (retain, nonatomic) IBOutlet UILabel *changeImageLabel;
@property (retain, nonatomic) IBOutlet UILabel *fNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *emailLabel;
@property (retain, nonatomic) IBOutlet UILabel *maleLabel;
@property (retain, nonatomic) IBOutlet UILabel *femaleLabel;
@property (retain, nonatomic) IBOutlet UIButton *maleCheckBox;
@property (retain, nonatomic) IBOutlet UIButton *femaleCheckBox;

@property int currTag;
@property (retain, nonatomic) NSDate *selectedDate;
@property (nonatomic,retain) UIDatePicker *datePicker;
@property (nonatomic, retain) UIToolbar *dateToolbar;

@property (nonatomic, retain) NSString *flag;
@property (nonatomic, retain) NSString *mobile;
@property (nonatomic, retain) NSString *fName;
@property (nonatomic, retain) NSString *lName;
@property (nonatomic, retain) NSString *dOBirth;
@property (nonatomic, retain) NSString *gender;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *password;

@property (nonatomic, retain) NSString *address;
//@property (nonatomic, retain) NSArray *editAddressArray;
@property (nonatomic, retain) NSMutableArray *addressArray;

@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

- (IBAction)addMail:(id)sender;
- (IBAction)changeImaged:(id)sender;
- (void) reloadView;
- (void) removeMailView;

@end
