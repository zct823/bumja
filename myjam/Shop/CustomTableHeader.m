//
//  CustomTableHeader.m
//  myjam
//
//  Created by Azad Johari on 2/11/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "CustomTableHeader.h"

@implementation CustomTableHeader
@synthesize catTitle;
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
-(void)dealloc{
    [catTitle release];
    [_middleLine release];
    [super dealloc];
}
@end
