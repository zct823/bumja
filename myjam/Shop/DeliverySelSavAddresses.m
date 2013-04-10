//
//  DeliverySelSavAddresses.m
//  myjam
//
//  Created by Mohd Zulhilmi on 21/03/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "DeliverySelSavAddresses.h"

@implementation DeliverySelSavAddresses

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (self != nil)
        {
            NSArray *theView =  [[NSBundle mainBundle] loadNibNamed:@"DeliverySelSavAddresses" owner:self options:nil];
            UIView *nv = [theView objectAtIndex:0];
            
            [self addSubview:nv];
        }
        return self;
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

@end
