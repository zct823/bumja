//
//  checkOutFooterView.h
//  myjam
//
//  Created by Azad Johari on 2/17/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface checkOutFooterView : UIView
@property (retain, nonatomic) IBOutlet UILabel *totalPrice;
@property (retain, nonatomic) IBOutlet UILabel *adminFeeLabel;
@property (retain, nonatomic) IBOutlet UIButton *deliveryButton;

@end
