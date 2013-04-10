//
//  ShopViewAllViewController.h
//  myjam
//
//  Created by Azad Johari on 2/11/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTableHeader.h"
#import "ShopTableViewCellwoCat.h"
#import "ShopDetailListingViewController.h"
#import "PullRefreshTableViewController.h"
#import <SDWebImage/UIButton+WebCache.h>
@interface ShopViewAllViewController : UITableViewController
@property (strong, nonatomic) NSMutableArray *catAllArray;
@end
