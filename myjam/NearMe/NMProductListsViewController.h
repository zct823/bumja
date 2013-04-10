//
//  NMProductListsViewController.h
//  myjam
//
//  Created by Mohd Zulhilmi on 1/04/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsViewController.h"
#import "MarqueeLabel.h"
#import "UIImage-Extensions.h"
#import <MapKit/MapKit.h>

@interface NMProductListsViewController : NewsViewController <CLLocationManagerDelegate>

@property (nonatomic) double currentLat;
@property (nonatomic) double currentLong;
@property (nonatomic) NSInteger withRadius;
//@property (nonatomic, retain) MarqueeLabel *shopeName;

@end
