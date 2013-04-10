//
//  CartItemViewCell.m
//  myjam
//
//  Created by Azad Johari on 2/2/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "CartItemViewCell.h"

@implementation CartItemViewCell

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
    [_productName release];
    [_productImage release];
    [_productImage release];
    [_priceLabel release];
    [_qtyLabel release];
    [_buttonPlus release];
    [_buttonMinus release];
    [_colorView release];
    [_sizeImageView release];
    [_sizeLabel release];
    [_aSizeLabel release];
    [super dealloc];
}
@end
