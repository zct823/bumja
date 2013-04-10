//
//  ProductTableViewCellwoCat.m
//  myjam
//
//  Created by Azad Johari on 2/12/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "ProductTableViewCellwoCat.h"

@implementation ProductTableViewCellwoCat

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
    [_button2 release];
    [_button3 release];
    [_priceLabel1 release];
    [_productLabel1 release];
    [_catLabel1 release];
    [_priceLabel2 release];
    [_productLabel2 release];
    [_catLabel2 release];
    [_priceLabel3 release];
    [_productLabel3 release];
    [_catLabel3 release];
    [_catNameLabel release];
    [_viewAllButton release];
    [_middleLine release];
    [_transView2 release];
    [_transView3 release];
    [_transView1 release];
    [super dealloc];
}
@end
