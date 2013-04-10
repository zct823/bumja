//
//  CustomHeaderCell.m
//  myjam
//
//  Created by Azad Johari on 3/6/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "CustomHeaderCell.h"

@implementation CustomHeaderCell

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

- (void)dealloc {
    [_viewAllButton release];
    [_catNameLabel release];
    [_middleLine release];
    [super dealloc];
}
@end
