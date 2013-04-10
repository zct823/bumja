//
//  PurchaseVerificationCell.m
//  myjam
//
//  Created by Azad Johari on 2/24/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "PurchaseVerificationCell.h"

@implementation PurchaseVerificationCell
@synthesize webView;
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
    [_orderLabel release];
    [_modelLabel release];
    [_qtyLabel release];
    [_statusLabel release];
    [_submitButton release];
    [webView release];
    [super dealloc];
}
@end
