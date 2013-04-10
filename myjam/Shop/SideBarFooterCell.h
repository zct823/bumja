//
//  SideBarFooterCell.h
//  myjam
//
//  Created by Azad Johari on 2/25/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideBarFooterCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *adminFeeLabel;
@property (retain, nonatomic) IBOutlet UILabel *totalLabel;
@property (retain, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (retain, nonatomic) IBOutlet UIButton *checkOutButton;

@end
