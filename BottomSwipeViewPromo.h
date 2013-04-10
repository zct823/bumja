//
//  BottomSwipeView.h
//  myjam
//
//  Created by nazri on 12/24/12.
//  Copyright (c) 2012 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomSwipeViewPromo : UIViewController<UITextFieldDelegate, UIGestureRecognizerDelegate>
{
//    NSMutableDictionary *checkedCategories;
    BOOL isSearchDisabled;
}
@property (retain, nonatomic) NSMutableDictionary *checkedPromoCategories;
@property (retain, nonatomic) NSMutableArray *codeType;
@property (retain, nonatomic) IBOutlet UIScrollView *scroller;
@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (retain, nonatomic) UIButton *continueButton;
@property (retain, nonatomic) IBOutlet UITextField *searchTextField;
@property (retain, nonatomic) IBOutlet UIButton *closeSwipeButton;

- (IBAction)clearButton:(id)sender;
- (void)setupCatagoryList;

@end
