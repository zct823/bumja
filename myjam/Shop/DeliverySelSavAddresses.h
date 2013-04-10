//
//  DeliverySelSavAddresses.h
//  myjam
//
//  Created by Mohd Zulhilmi on 21/03/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeliverySelSavAddresses : UIView

@property (nonatomic, retain) IBOutlet UILabel *bgColor;
@property (nonatomic, retain) IBOutlet UILabel *addressLabelNo;
@property (nonatomic, retain) IBOutlet UILabel *addressStreet;
@property (nonatomic, retain) IBOutlet UILabel *addressCity;
@property (nonatomic, retain) IBOutlet UILabel *addressState;
@property (nonatomic, retain) IBOutlet UILabel *addressCountry;
@property (nonatomic, retain) IBOutlet UIButton *selectedBtn;
@property (nonatomic, retain) IBOutlet UILabel *setAsPrimary;
@property (nonatomic, retain) NSString *stringAddr;

@end
