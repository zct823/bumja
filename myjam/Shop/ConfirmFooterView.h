//
//  ConfirmFooterView.h
//  myjam
//
//  Created by Azad Johari on 2/17/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "checkOutFooterView.h"
@interface ConfirmFooterView : checkOutFooterView
@property (retain, nonatomic) IBOutlet UILabel *gTotalLabel;
@property (retain, nonatomic) IBOutlet UILabel *deliveryLabel;
@property (retain, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (retain, nonatomic) IBOutlet UIButton *checkOutButton;
@property (retain, nonatomic) IBOutlet UILabel *jambuFeePrice;

@property (retain, nonatomic) IBOutlet UILabel *jambuFeeLabel;
@end
