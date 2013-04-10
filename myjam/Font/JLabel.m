//
//  JLabel.m
//  myjam
//
//  Created by nazri on 1/3/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "JLabel.h"

@implementation JLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder: decoder])
    {
        [self setFont: [UIFont fontWithName: @"jambu-font.otf" size: self.font.pointSize]];
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
