//
//  JambuCellNML.h
//  myjam
//
//  Created by nazri on 11/29/12.
//  Copyright (c) 2012 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JambuCellNML : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *providerLabel;
@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
@property (retain, nonatomic) IBOutlet UILabel *abstractLabel;
@property (retain, nonatomic) IBOutlet UIImageView *thumbsView;
@property (retain, nonatomic) IBOutlet UILabel *kmLabel;
@property (retain, nonatomic) IBOutlet UILabel *categoryLabel;
@property (retain, nonatomic) IBOutlet UIView *labelView;
@property (nonatomic, retain) IBOutlet UIView *transView;

@end
