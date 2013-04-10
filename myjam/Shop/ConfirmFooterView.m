//
//  ConfirmFooterView.m
//  myjam
//
//  Created by Azad Johari on 2/17/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "ConfirmFooterView.h"

@implementation ConfirmFooterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc {
    [_deliveryLabel release];
    [_gTotalLabel release];
    [_shopNameLabel release];
    [_checkOutButton release];
    [_jambuFeePrice release];
    [_jambuFeeLabel release];
    [super dealloc];
}
@end
