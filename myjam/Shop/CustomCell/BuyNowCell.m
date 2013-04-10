//
//  BuyNowCell.m
//  myjam
//
//  Created by Azad Johari on 2/24/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "BuyNowCell.h"

@implementation BuyNowCell

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
    [_button1 release];
    [_limitedLabel release];
    [_checkOutButton release];
    [_continueShoppingButton release];
    [super dealloc];
}
@end
