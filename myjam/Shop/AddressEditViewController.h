//
//  AddressEditViewController.h
//  myjam
//
//  Created by ME-Tech Mac User 2 on 2/15/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CoreViewController.h"
#import "DeliverySelSavAddrViewController.h"
#import "DeliveryDayChoiceViewController.h"
#import "DeliveryChoiceViewController.h"
#import "DeliveryOptionViewController.h"
#import "AppDelegate.h"
#import "MJModel.h"
#import "ASIWrapper.h"

@class TPKeyboardAvoidingScrollView;

@interface AddressEditViewController : UIViewController<UIScrollViewDelegate, UITextFieldDelegate, UIAlertViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSString *reqFieldName;
}

@property (retain, nonatomic) TPKeyboardAvoidingScrollView *scroller;
@property (retain, nonatomic) IBOutlet UIView *contentView;

@property int currTag;
@property (nonatomic, retain) UIPickerView *statePickerView;
@property (nonatomic, retain) UIPickerView *countryPickerView;
@property (nonatomic, retain) NSMutableArray *stateArray;
@property (nonatomic, retain) NSMutableArray *countryArray;
@property (nonatomic, retain) NSMutableDictionary *dictStates;
@property (nonatomic, retain) NSMutableDictionary *dictCountries;
@property (nonatomic, retain) NSString *stateId;
@property (nonatomic, retain) NSString *countryId;


@property (retain, nonatomic) IBOutlet UITextField *addressTextField;
@property (retain, nonatomic) IBOutlet UITextField *cityTextField;
@property (retain, nonatomic) IBOutlet UITextField *postcodeTextField;
@property (retain, nonatomic) IBOutlet UITextField *stateTextField;
@property (retain, nonatomic) IBOutlet UITextField *countryTextField;

@property (retain, nonatomic) IBOutlet UIButton *saveButton;

@property (nonatomic) NSInteger count;
@property (strong, nonatomic) NSString *cartId;
@property (nonatomic, retain) NSDictionary *addressInfo;
@property (nonatomic, retain) IBOutlet UILabel *addrLabel;


@end
