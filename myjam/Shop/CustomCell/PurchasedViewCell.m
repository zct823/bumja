//
//  PurchasedViewCell.m
//  myjam
//
//  Created by Azad Johari on 2/23/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "PurchasedViewCell.h"

@implementation PurchasedViewCell
@synthesize imageView;
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
    [imageView release];
    [_productName release];
    [_colorLabel release];
    [_sizeLabel release];
    [_qtyLabel release];
    [_priceLabel release];
    [_dateLabel release];
    [_statusLabel release];
    [super dealloc];
}
@end
