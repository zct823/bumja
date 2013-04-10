//
//  SocialViewController.h
//  myjam
//
//  Created by nazri on 12/18/12.
//  Copyright (c) 2012 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <MessageUI/MessageUI.h>

@interface SocialViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIAlertViewDelegate, MFMailComposeViewControllerDelegate>
{
    NSString *qrcodeId;
    SLComposeViewController *mySLComposerSheet;
    NSString *reqFieldName;
}
@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSMutableDictionary *categories;
@property (nonatomic, retain) NSString *categoryId;
@property (nonatomic, retain) NSString *socialType;
@property (nonatomic, retain) NSString *socialUrl;

@property (retain, nonatomic) TPKeyboardAvoidingScrollView *scroller;
@property (retain, nonatomic) IBOutlet UIImageView *imagePreview;
@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UITextField *appTitleTextField;
@property (retain, nonatomic) IBOutlet UITextField *categoryTextField;
@property (retain, nonatomic) IBOutlet UITextField *nameTextField;
@property (retain, nonatomic) IBOutlet UITextField *urlTextField;
@property (retain, nonatomic) IBOutlet UIButton *previewButton;
@property (retain, nonatomic) IBOutlet UIButton *saveButton;
@property (retain, nonatomic) IBOutlet UILabel *appTitleLabel;
@property (retain, nonatomic) IBOutlet UITextView *descTextView;

@property (retain, nonatomic) IBOutlet UIView *shareView;
@property (retain, nonatomic) IBOutlet UIButton *shareFBButton;
@property (retain, nonatomic) IBOutlet UIButton *shareTwitterButton;
@property (retain, nonatomic) IBOutlet UIButton *shareEmailButton;

- (void)updatePreview;

@end
