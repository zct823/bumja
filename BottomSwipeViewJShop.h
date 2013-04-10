//
//  BottomSwipeViewScanBox.h
//  myjam
//
//  Created by nazri on 12/24/12.
//  Copyright (c) 2012 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomSwipeViewJShop : UIViewController<UITextFieldDelegate, UIGestureRecognizerDelegate>
{
//    NSMutableDictionary *checkedCategories;
    NSMutableDictionary *qrcodeTypeDict;
    BOOL isSearchDisabled;
}
@property (retain, nonatomic) NSMutableDictionary *checkedCategories;
@property (retain, nonatomic) NSMutableDictionary *sortCategories;
@property (retain, nonatomic) IBOutlet UIScrollView *scroller;
@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (retain, nonatomic) UIButton *continueButton;
@property (retain, nonatomic) IBOutlet UITextField *searchTextField;
@property (retain, nonatomic) IBOutlet UIButton *closeSwipeButton;
@property (nonatomic, retain) UILabel* label;
@property (nonatomic, retain) UITextField *addNewFolder;
@property (nonatomic, retain) UITextField *editFolder;
@property (nonatomic) NSInteger lblTagToSendOnTapRec;
@property (nonatomic, retain) NSString *favFolderName;
@property (nonatomic) NSInteger count;

@property (nonatomic, retain) NSString *replaceLabel;

@property CGFloat animatedDistance;

@property (nonatomic, retain) NSString *contentSwitch; //two buttons

- (IBAction)clearButton:(id)sender;
- (void)setupCatagoryList;

- (IBAction)firstButton:(id)sender;
- (IBAction)secondButton:(id)sender;

@end
