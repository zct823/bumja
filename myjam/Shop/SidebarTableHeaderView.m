//
//  SidebarTableHeaderView.m
//  myjam
//
//  Created by Azad Johari on 2/27/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "SidebarTableHeaderView.h"

@implementation SidebarTableHeaderView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
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
    [_shopLogo release];
    [_shopName release];
    [super dealloc];
}
@end
