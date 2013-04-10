//
//  MapViewController.h
//  myjam
//
//  Created by nazri on 12/12/12.
//  Copyright (c) 2012 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <MessageUI/MessageUI.h>

@interface MapViewController : UIViewController<UIScrollViewDelegate, UITextFieldDelegate, UITextViewDelegate, UIAlertViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, MFMailComposeViewControllerDelegate>
{
    NSString *fullAddress;
    NSString *qrcodeId;
    SLComposeViewController *mySLComposerSheet;
    NSString *reqFieldName;
}

@property (retain, nonatomic) TPKeyboardAvoidingScrollView *scroller;
@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UIView *shareView;
@property (retain, nonatomic) IBOutlet UITextField *appTitleTextField;
@property (retain, nonatomic) IBOutlet UITextField *categoryTextField;
@property (retain, nonatomic) IBOutlet UITextField *mapNameTextField;
@property (retain, nonatomic) IBOutlet UITextView *mapDescTextField;
@property (retain, nonatomic) IBOutlet UITextField *addressTextField;
@property (retain, nonatomic) IBOutlet UITextField *cityTextField;
@property (retain, nonatomic) IBOutlet UITextField *postcodeTextField;
@property (retain, nonatomic) IBOutlet UITextField *stateTextField;
@property (retain, nonatomic) IBOutlet UITextField *countryTextField;
@property (retain, nonatomic) IBOutlet UIButton *previewButton;
@property (retain, nonatomic) IBOutlet UIButton *saveButton;

@property (retain, nonatomic) IBOutlet UIImageView *qrImageView;
@property (retain, nonatomic) IBOutlet UILabel *appTitileLabel;
@property (retain, nonatomic) IBOutlet UITextView *mapNameLabel;
@property (retain, nonatomic) IBOutlet UITextView *addressTextView;
@property (retain, nonatomic) NSString *fullAddress;

@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSMutableDictionary *categories;
@property (nonatomic, retain) NSString *categoryId;

@property (retain, nonatomic) IBOutlet UIButton *shareFBButton;
@property (retain, nonatomic) IBOutlet UIButton *shareTwitterButton;
@property (retain, nonatomic) IBOutlet UIButton *shareEmailButton;

- (void)updatePreview;
- (IBAction)previewMap:(id)sender;


@end
