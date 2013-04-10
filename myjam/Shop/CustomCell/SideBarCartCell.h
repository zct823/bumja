//
//  SideBarCartCell.h
//  myjam
//
//  Created by Azad Johari on 2/21/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideBarCartCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *productImage;
@property (retain, nonatomic) IBOutlet UILabel *productItem;
@property (retain, nonatomic) IBOutlet UIImageView *sizeImageView;
@property (retain, nonatomic) IBOutlet UIButton *addButton;
@property (retain, nonatomic) IBOutlet UIButton *minusButton;
@property (retain, nonatomic) IBOutlet UILabel *priceLabel;
@property (retain, nonatomic) IBOutlet UILabel *qtyLabel;
@property (retain, nonatomic) IBOutlet UIImageView *colorView;
@property (retain, nonatomic) IBOutlet UILabel *sizeLabel;
@property (retain, nonatomic) IBOutlet UILabel *quantityLabel;

@end
