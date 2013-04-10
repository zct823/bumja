//
//  ShopDetailListingViewController.h
//  myjam
//
//  Created by Azad Johari on 1/30/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailProductViewController.h"
#import "AppDelegate.h"
#import "ProductTableViewCell.h"
#import "CustomHeader.h"
#import "MJModel.h"
#import "ProductViewAllViewController.h"
#import "ShopHeaderView.h"
#import "ShopAddressViewController.h"
#import <SDWebImage/UIButton+WebCache.h>
@interface ShopDetailListingViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *productArray;
@property (retain, nonatomic) NSDictionary *shopInfo;
- (IBAction)locateStore:(id)sender;
@end
