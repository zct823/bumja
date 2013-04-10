//
//  FeedbackViewController.h
//  myjam
//
//  Created by ME-Tech Mac User 2 on 1/24/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"

@interface FeedbackViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate>
{
    NSString *reqFieldName;
}

@property (retain, nonatomic) TPKeyboardAvoidingScrollView *scroller;
@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UITextField *nameTextField;
@property (retain, nonatomic) IBOutlet UITextField *emailTextField;
@property (retain, nonatomic) IBOutlet UITextField *mobileTextField;
@property (retain, nonatomic) IBOutlet UITextView *commentTextView;
@property (retain, nonatomic) IBOutlet UIButton *saveButton;

@end
