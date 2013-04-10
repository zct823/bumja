//
//  BottomSwipeViewShareBox.h
//  myjam
//
//  Created by Mohd Zulhilmi on 4/03/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomSwipeViewShareBox : UIViewController<UITextFieldDelegate, UIGestureRecognizerDelegate>
{
    //    NSMutableDictionary *checkedCategories;
    BOOL isSearchDisabled;
    CGFloat animatedDistance;
    CGRect originFrame;
}
@property (retain, nonatomic) NSMutableDictionary *checkedCategories;
@property (retain, nonatomic) IBOutlet UIScrollView *scroller;
@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (retain, nonatomic) UIButton *continueButton;
@property (retain, nonatomic) IBOutlet UITextField *searchTextField;
@property (retain, nonatomic) IBOutlet UIButton *closeSwipeButton;

@property (nonatomic, retain) NSString *contentSwitch; //two buttons

- (IBAction)clearButton:(id)sender;
- (void)setupCatagoryList;

- (IBAction)firstButton:(id)sender;
- (IBAction)secondButton:(id)sender;

@end
