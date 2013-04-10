//
//  PurchasedHistoryViewController.h
//  myjam
//
//  Created by Azad Johari on 2/23/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PurchasedViewCell.h"
#import "PurchasedHeaderView.h"
#import "MJModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DetailProductViewController.h"
#import "NSString+StripeHTML.h"
#import "PullRefreshTableViewController.h"
#define kListPerpage        5
#define kTableCellHeightX    120
//#define kDisplayPerscreen   3 // commented to support retina 4
#define kExtraCellHeight    54

@interface PurchasedHistoryViewController : PullRefreshTableViewController{
     int kDisplayPerscreen;
}

@property (nonatomic, retain) NSDictionary *purchasedHistory;
@property (retain, nonatomic) NSString *selectedCategories;
@property (retain, nonatomic) NSString *searchedText;
@property (retain, nonatomic) NSString *selectedStatus;
@property (retain, nonatomic) NSMutableArray *purchasedHistoryArray;
@property (retain, nonatomic) NSMutableArray *tempPurchasedArray;
- (void) refreshTableItemsWithFilter:(NSString *)str andSearchedText:(NSString *)pattern andOptions:(NSString*)optionData;
@end
