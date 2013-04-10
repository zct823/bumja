//
//  JambuCell.h
//  myjam
//
//  Created by nazri on 11/29/12.
//  Copyright (c) 2012 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JambuCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *providerLabel;
@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
@property (retain, nonatomic) IBOutlet UILabel *abstractLabel;
@property (retain, nonatomic) IBOutlet UIImageView *thumbsView;
@property (retain, nonatomic) IBOutlet UILabel *typeLabel;
@property (retain, nonatomic) IBOutlet UILabel *categoryLabel;
@property (retain, nonatomic) IBOutlet UIView *labelView;
@property (retain, nonatomic) IBOutlet UIImageView *shareTypeImageView;

@end
