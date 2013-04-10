//
//  ProductRatingListViewController.h
//  myjam
//
//  Created by Azad Johari on 2/1/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentViewCell.h"
#import "WriteReviewViewController.h"
#import "AppDelegate.h"
#import "MJModel.h"
#import "CoreViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ProductRatingListViewController : CoreViewController <UITableViewDataSource, UITableViewDelegate>
{
    CGRect screenBounds;
}
@property (nonatomic, strong) NSMutableArray *reviewList;
@property (retain, nonatomic) IBOutlet UILabel *productLabel;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *shopName;
@property (nonatomic, strong) NSDictionary *reviewInfo;
@property (retain, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
- (IBAction)reviewAction:(id)sender;
- (IBAction)viewShop:(id)sender;
@end
