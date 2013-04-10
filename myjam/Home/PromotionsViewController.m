//
//  PromotionsViewController.m
//  myjam
//
//  Created by ME-Tech Mac User 2 on 2/28/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "PromotionsViewController.h"
#import "JambuCell.h"
#import "AppDelegate.h"
#import "MoreViewController.h"

@interface PromotionsViewController ()

@end

@implementation PromotionsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self loadData];
	// Do any additional setup after loading the view.
}

// Overidden method to change API dataContent
- (NSString *)returnAPIDataContent
{
    NSString *feed_type = @"promotion";
    return [NSString stringWithFormat:@"{\"page\":%d,\"perpage\":%d,\"category_id\":\"%@\",\"search\":\"%@\",\"feed_type\":\"%@\"}",self.pageCounter, kListPerpage, self.selectedCategories, self.searchedText,feed_type];
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    
//}

#pragma mark -
#pragma mark didSelectRow extended action

- (void)processRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoreViewController *detailView = [[MoreViewController alloc] init];
    detailView.qrcodeId = [[self.tableData objectAtIndex:indexPath.row] qrcodeId];
    AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [mydelegate.homeNavController pushViewController:detailView animated:YES];
    [detailView release];
}

- (void) refreshTableItemsWithFilter:(NSString *)str andSearchedText:(NSString *)pattern
{
    //    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading ..." width:100];
    
    //NSLog(@"Filtering PROMOTIONS list with searched text %@",str);
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
    [super dealloc];
}

@end
