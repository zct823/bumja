//
//  PurchasedViewCell.h
//  myjam
//
//  Created by Azad Johari on 2/23/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PurchasedViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) IBOutlet UILabel *productName;
@property (retain, nonatomic) IBOutlet UILabel *colorLabel;
@property (retain, nonatomic) IBOutlet UILabel *sizeLabel;
@property (retain, nonatomic) IBOutlet UILabel *qtyLabel;
@property (retain, nonatomic) IBOutlet UILabel *priceLabel;
@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
@property (retain, nonatomic) IBOutlet UILabel *statusLabel;

@end
