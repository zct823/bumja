//
//  ShopHeaderViewCell.m
//  myjam
//
//  Created by Azad Johari on 3/5/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "ShopHeaderViewCell.h"

@implementation ShopHeaderViewCell

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
    [_shopLabel release];
    [_topSellerLabel release];
    [super dealloc];
}
@end
