//
//  CustomHeader.m
//  jambu
//
//  Created by Azad Johari on 2/4/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "CustomHeader.h"

@implementation CustomHeader
@synthesize viewAll,catTitle;
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
    [catTitle release];
    [viewAll release];
    [super dealloc];
}
@end
