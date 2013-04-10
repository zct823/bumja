//
//  ProductViewAllViewController.h
//  myjam
//
//  Created by Azad Johari on 2/13/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

//#import "PullRefreshTableViewController.h"
//#import "ProductTableViewCell.h"
#import "ProductTableViewCellwoCat.h"
//#import "ShopHeaderView.h"
#import "CustomTableHeader.h"
#import "DetailProductViewController.h"
#import "ShopHeaderViewCell.h"
#import "ShopInfoButtonCell.h"
#import <SDWebImage/UIButton+WebCache.h>
@interface ProductViewAllViewController : UITableViewController
@property (strong, nonatomic) NSMutableArray *productAllArray;
@property (strong, nonatomic) NSMutableArray *productArray;
@property (retain, nonatomic) NSDictionary *shopInfo;
@property (strong, nonatomic) NSString *catName;
@property (retain, nonatomic) IBOutlet UITableView *tableView;

-(id)initWith:(NSDictionary*)shopInfo andCat:(NSString*)catName;
- (IBAction)locateStore:(id)sender;

@end
