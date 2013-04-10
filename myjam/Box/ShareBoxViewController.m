//
//  ShareBoxViewController.m
//  myjam
//
//  Created by ME-Tech Mac User1 on 22/01/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "ShareBoxViewController.h"
#import "JambuCell.h"
#import "AppDelegate.h"
#import "MoreViewController.h"


@interface ShareBoxViewController ()

@end

@implementation ShareBoxViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (NSString *)returnAPIURL
{
    return [NSString stringWithFormat:@"%@/api/qrcode_share_list.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
}

// Overidden method to change API dataContent
- (NSString *)returnAPIDataContent
{
    //NSLog(@"box share datacontent");
    return [NSString stringWithFormat:@"{\"page\":%d,\"perpage\":%d,\"keyword\":\"%@\"}",self.pageCounter, kListPerpage, self.searchedText];
}

#pragma mark -
#pragma mark didSelectRow extended action

- (NSString *)checkQRCodeType:(NSString *)qrcodeid
{
    NSString *urlString = [NSString stringWithFormat:@"%@/api/qrcode_type.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
    NSString *dataContent = [NSString stringWithFormat:@"{\"qrcode_id\":%@}",qrcodeid];
    
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
    //NSLog(@"request %@\n%@\n\nresponse data: %@", urlString, dataContent, response);
    NSDictionary *resultsDictionary = [[response objectFromJSONString] copy];
    //NSLog(@"dict %@",resultsDictionary);
    
    if([resultsDictionary count])
    {
        NSString *status = [resultsDictionary objectForKey:@"status"];
        if ([status isEqualToString:@"ok"])
        {
            NSString *type = [resultsDictionary objectForKey:@"qrcode_type"];
            
            if ([type isEqualToString:@"Product"]) {
                NSString *productid = [resultsDictionary objectForKey:@"product_id"];
                return productid;
            }
            
        }
    }
    
    return @"0"; // normal qrcode, other than product
}


- (void)processRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *productId = [self checkQRCodeType:[[self.tableData objectAtIndex:indexPath.row] qrcodeId]];
    
    if ([productId intValue] > 0)
    {
        // type of product
        DetailProductViewController *detailViewController = [[DetailProductViewController alloc] initWithNibName:@"DetailProductViewController" bundle:nil];
        //        NSString *prodId = productId;
        detailViewController.productInfo = [[MJModel sharedInstance] getProductInfoFor:productId];
        detailViewController.buyButton =  [[NSString alloc] initWithString:@"ok"];
        detailViewController.productId = [productId mutableCopy];
        AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [mydelegate.boxNavController pushViewController:detailViewController animated:YES];
        [detailViewController release];
    }
    else{
        MoreViewController *detailView = [[MoreViewController alloc] init];
        detailView.qrcodeId = [[self.tableData objectAtIndex:indexPath.row] qrcodeId];
        AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [mydelegate.boxNavController pushViewController:detailView animated:YES];
        [detailView release];
    }
}

//- (void)processRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    MoreViewController *detailView = [[MoreViewController alloc] init];
//    detailView.qrcodeId = [[self.tableData objectAtIndex:indexPath.row] qrcodeId];
//    AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [mydelegate.boxNavController pushViewController:detailView animated:YES];
//    [detailView release];
//}

- (void) refreshTableItemsWithFilter:(NSString *)str andSearchedText:(NSString *)pattern
{
    //    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading ..." width:100];
    
    //NSLog(@"Filtering sharebox list with searched text %@",str);
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
