//
//  AllViewController.h
//  myjam
//
//  Created by ME-Tech Mac User 2 on 2/28/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "JSONKit.h"
#import "PullRefreshTableViewController.h"
#import "ASIWrapper.h"

#define kListPerpage        5
#define kTableCellHeight    125
#define kExtraCellHeight    54

@interface AllViewController : PullRefreshTableViewController<ASIHTTPRequestDelegate, UIGestureRecognizerDelegate>
{
    NSString *responseData;
    int kDisplayPerscreen;
}

@property BOOL refreshDisabled;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *tableData;
@property (retain, nonatomic) NSString *selectedCategories;
@property (retain, nonatomic) NSString *searchedText;

- (void) refreshTableItemsWithFilter:(NSString *)str andSearchedText:(NSString *)pattern;

@end
