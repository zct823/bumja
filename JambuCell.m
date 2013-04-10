//
//  JambuCell.m
//  myjam
//
//  Created by nazri on 11/29/12.
//  Copyright (c) 2012 me-tech. All rights reserved.
//

#import "JambuCell.h"

@implementation JambuCell

@synthesize titleLabel, providerLabel, abstractLabel, thumbsView, dateLabel, labelView, categoryLabel, typeLabel;

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
    [providerLabel release];
    [dateLabel release];
    [abstractLabel release];
    [thumbsView release];
    [typeLabel release];
    [categoryLabel release];
    [labelView release];
    [titleLabel release];
    [_shareTypeImageView release];
    [super dealloc];
}
@end
