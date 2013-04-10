//
//  ShopHeaderView.m
//  myjam
//
//  Created by Azad Johari on 2/13/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "ShopHeaderView.h"

@implementation ShopHeaderView

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
    [_shopLabel release];
    [_topSellerLabel release];
    [super dealloc];
}
@end
