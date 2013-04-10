//
//  SideBarCartCell.m
//  myjam
//
//  Created by Azad Johari on 2/21/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "SideBarCartCell.h"

@implementation SideBarCartCell

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
    [_productImage release];
    [_productItem release];
    [_sizeImageView release];
    [_addButton release];
    [_minusButton release];
    [_priceLabel release];
    [_qtyLabel release];
    [_colorView release];
    [_sizeLabel release];
    [_quantityLabel release];
    [super dealloc];
}
@end
