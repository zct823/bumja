//
//  CreateBoxViewController.m
//  myjam
//
//  Created by ME-Tech Mac User1 on 22/01/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "CreateBoxViewController.h"
#import "JambuCell.h"
#import "AppDelegate.h"
#import "MoreViewController.h"

@interface CreateBoxViewController ()

@end

@implementation CreateBoxViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selectedApp = @"";
	// Do any additional setup after loading the view.
}

- (NSString *)returnAPIURL
{
    return [NSString stringWithFormat:@"%@/api/qrcode_create_list.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
}

// Overidden method to change API dataContent
- (NSString *)returnAPIDataContent
{
    //NSLog(@"box create datacontent");
    return [NSString stringWithFormat:@"{\"page\":%d,\"perpage\":%d,\"keyword\":\"%@\",\"app_type\":\"%@\"}",self.pageCounter, kListPerpage,self.searchedText,self.selectedCategories];
}

- (void) refreshTableItemsWithFilter:(NSString *)str andSearchedText:(NSString *)pattern
{
    //    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading ..." width:100];
    
    //NSLog(@"Filtering Createbox list with searched text %@",str);
    self.selectedCategories = @"";
    self.selectedCategories = str;
    self.searchedText = @"";
    self.searchedText = pattern;
    self.pageCounter = 1;
    [self.tableData removeAllObjects];
    self.tableData = [[self loadMoreFromServer] mutableCopy];
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero animated:YES];
    
    [DejalBezelActivityView removeViewAnimated:YES];
    
}


//- (void)refreshTableItemsWithFilterApp:(NSString *)str andSearchedText:(NSString *)pattern
//{
//    //    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading ..." width:100];
//    
//    //NSLog(@"Filtering Createbox list with searched app %@",str);
//    self.selectedApp = @"";
//    self.selectedApp = str;
//    self.searchedText = @"";
//    self.searchedText = pattern;
//    self.pageCounter = 1;
//    [self.tableData removeAllObjects];
//    self.tableData = [[self loadMoreFromServer] mutableCopy];
//    [self.tableView reloadData];
//    [self.tableView setContentOffset:CGPointZero animated:YES];
//    
//    [DejalBezelActivityView removeViewAnimated:YES];
//    
//}

#pragma mark -
#pragma mark didSelectRow extended action

- (void)processRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoreViewController *detailView = [[MoreViewController alloc] init];
    detailView.qrcodeId = [[self.tableData objectAtIndex:indexPath.row] qrcodeId];
    AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [mydelegate.boxNavController pushViewController:detailView animated:YES];
    [detailView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
