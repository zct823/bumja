//
//  ShopTableViewCell.m
//  myjam
//
//  Created by Azad Johari on 1/30/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "ShopTableViewCellwoCat.h"

@implementation ShopTableViewCellwoCat

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
    [_topLabel1 release];
    [_topLabel2 release];
    [_topLabel3 release];
    [_shopLabel1 release];
    [_shopLabel2 release];
    [_shopLabel3 release];
    [_catLabel1 release];
    [_catLabel2 release];
    [_catLabel3 release];

    [_catLabel release];
   

    [super dealloc];
}
@end
