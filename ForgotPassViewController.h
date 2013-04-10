//
//  ForgotPassViewController.h
//  myjam
//
//  Created by Mohd Zulhilmi on 18/02/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "ASIWrapper.h"
#import "JSONKit.h"

@interface ForgotPassViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UITextField *emailTextField;
}

@property (nonatomic, retain) IBOutlet UIView *setView;
@property (nonatomic, retain) IBOutlet UITextField *emailTextField;
@property (nonatomic, retain) UIView *contentView;

@property CGFloat animatedDistance;

@end
