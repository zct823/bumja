//
//  SizeSelectionCell.h
//  myjam
//
//  Created by Azad Johari on 2/20/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SizeSelectView.h"
@interface SizeSelectionCell : UITableViewCell
@property (retain, nonatomic) IBOutlet SizeSelectView *sizeSelectView;
@property (retain, nonatomic) IBOutlet UILabel *sizeSelectLabel;

@end
