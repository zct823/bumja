//
//  CartItemViewCell.h
//  myjam
//
//  Created by Azad Johari on 2/2/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartItemViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *productName;
@property (retain, nonatomic) IBOutlet UIImageView *productImage;
@property (retain, nonatomic) IBOutlet UILabel *priceLabel;
@property (retain, nonatomic) IBOutlet UILabel *qtyLabel;
@property (retain, nonatomic) IBOutlet UIButton *buttonPlus;
@property (retain, nonatomic) IBOutlet UIButton *buttonMinus;
@property (retain, nonatomic) IBOutlet UIImageView *colorView;
@property (retain, nonatomic) IBOutlet UIImageView *sizeImageView;
@property (retain, nonatomic) IBOutlet UILabel *sizeLabel;
@property (retain, nonatomic) IBOutlet UILabel *aSizeLabel;


@end
