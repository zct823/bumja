//
//  NewsViewController.h
//  myjam
//
//  Created by nazri on 11/7/12.
//  Copyright (c) 2012 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
//#import "ASIHTTPRequest.h"
//#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "PullRefreshTableViewController.h"
#import "ASIWrapper.h"

#define kListPerpage        5
#define kTableCellHeight    125
//#define kDisplayPerscreen   3 // commented to support retina 4
#define kExtraCellHeight    54

@interface NewsViewController : PullRefreshTableViewController<ASIHTTPRequestDelegate, UIGestureRecognizerDelegate>
{
    NSString *responseData;
    int kDisplayPerscreen;
//    NSMutableArray *aQRcodeType;
}

@property BOOL refreshDisabled;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *tableData;
@property (retain, nonatomic) NSString *selectedCategories;
@property (retain, nonatomic) NSString *searchedText;

- (NSMutableArray *)loadMoreFromServer;
- (void)loadData;
- (void) addItemsToEndOfTableView;
- (void) refreshTableItemsWithFilter:(NSString *)str;
- (void) refreshTableItemsWithFilter:(NSString *)str andSearchedText:(NSString *)pattern;
@end
