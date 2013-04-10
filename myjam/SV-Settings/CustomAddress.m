//
//  CustomAddress.m
//  myjam
//
//  Created by ME-Tech Mac User 2 on 2/20/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "CustomAddress.h"

@implementation CustomAddress

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self != nil)
    {
        NSArray *theView =  [[NSBundle mainBundle] loadNibNamed:@"CustomAddress" owner:self options:nil];
        UIView *nv = [theView objectAtIndex:0];
        
        [self addSubview:nv];
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
