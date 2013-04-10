//
//  checkOutFooterView.m
//  myjam
//
//  Created by Azad Johari on 2/17/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "checkOutFooterView.h"

@implementation checkOutFooterView

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
    [_totalPrice release];
    [_adminFeeLabel release];
    [_deliveryButton release];
    [super dealloc];
}
@end
