//
//  ReportSpamViewController.h
//  myjam
//
//  Created by ME-Tech Mac User 2 on 2/26/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//
#import "TPKeyboardAvoidingScrollView.h"
#import "MData.h"
#import <UIKit/UIKit.h>

@interface ReportSpamViewController : UIViewController<UIScrollViewDelegate, UITextFieldDelegate, UITextViewDelegate, UIAlertViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSString *reqFieldName;
}

@property (retain, nonatomic) TPKeyboardAvoidingScrollView *scroller;
@property (retain, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic, retain) NSString *orderItemId;
@property (nonatomic, retain) NSString *productId;
@property (nonatomic, retain) NSString *newsId;
@property (nonatomic, retain) NSString *qrcodeId;
@property (nonatomic, retain) NSString *qrTitle;
@property (nonatomic, retain) NSString *qrProvider;
@property (nonatomic, retain) NSString *qrDate;
@property (nonatomic, retain) NSString *qrAbstract;
@property (nonatomic, retain) NSString *qrType;
@property (nonatomic, retain) NSString *qrCategory;
@property (nonatomic, retain) NSString *qrLabelColor;
@property (nonatomic, retain) UIImage *qrImage;
//@property (nonatomic, retain) MData *detailsData;

@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *providerLabel;
@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
@property (retain, nonatomic) IBOutlet UILabel *abstractLabel;
@property (retain, nonatomic) IBOutlet UIImageView *thumbsView;
@property (retain, nonatomic) IBOutlet UILabel *typeLabel;
@property (retain, nonatomic) IBOutlet UILabel *categoryLabel;
@property (retain, nonatomic) IBOutlet UIView *labelView;

@property (retain, nonatomic) IBOutlet UITextField *reportTypeTextField;
@property (retain, nonatomic) IBOutlet UITextView *remarksTextView;
@property (retain, nonatomic) IBOutlet UIButton *submitButton;

@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSMutableDictionary *reportTypes;
@property (nonatomic, retain) NSString *reportTypeId;

@end
