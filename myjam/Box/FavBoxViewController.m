//
//  FavBoxViewController.m
//  myjam
//
//  Created by Mohd Zulhilmi on 1/03/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "FavBoxViewController.h"
#import "JambuCell.h"
#import "AppDelegate.h"
#import "MoreViewController.h"

@interface FavBoxViewController ()

@end

@implementation FavBoxViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self loadData];
}

- (NSString *)returnAPIURL
{
    return [NSString stringWithFormat:@"%@/api/qrcode_fav_list.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
}

// Overidden method to change API dataContent
- (NSString *)returnAPIDataContent
{
    //NSLog(@"box fav datacontent");
    return [NSString stringWithFormat:@"{\"page\":%d,\"perpage\":%d,\"fav_id\":\"%@\",\"keyword\":\"%@\"}",self.pageCounter, kListPerpage, self.selectedCategories, self.searchedText];
}

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

- (void) refreshTableItemsWithFilter:(NSString *)str andSearchedText:(NSString *)pattern
{
    //    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading ..." width:100];
    
    //NSLog(@"Filtering favbox list with searched text %@",str);
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

@end
