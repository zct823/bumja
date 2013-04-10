//
//  ColorSelectionCell.h
//  myjam
//
//  Created by Azad Johari on 2/20/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorSelectView.h"
@interface ColorSelectionCell : UITableViewCell
@property (retain, nonatomic) IBOutlet ColorSelectView *colorSelectView;
@property (retain, nonatomic) IBOutlet UILabel *colorSelectTitle;

@end
