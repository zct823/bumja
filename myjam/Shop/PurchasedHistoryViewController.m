//
//  PurchasedHistoryViewController.m
//  myjam
//
//  Created by Azad Johari on 2/23/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "PurchasedHistoryViewController.h"

#define kCellHeaderHeight 50


@interface PurchasedHistoryViewController ()

@end

@implementation PurchasedHistoryViewController
@synthesize purchasedHistory;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selectedCategories = @"";
    self.searchedText = @"";
    self.selectedStatus = @"";

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTable:) name:@"refreshPurchaseHistory" object:nil];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        // code for 4-inch screen
        kDisplayPerscreen = 4;
    } else {
        // code for 3.5-inch screen
        kDisplayPerscreen = 3;
    }
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    AppDelegate *mydelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    mydelegate.swipeBottomEnabled = YES;
    [DejalBezelActivityView removeViewAnimated:YES];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *mydelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    mydelegate.swipeBottomEnabled = NO;
}

-(NSMutableArray *)groupByOrderId:(NSMutableArray *)orders
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    NSMutableArray *tempOrderArray = [[NSMutableArray alloc] init];
    
    NSString *tempId = [[orders objectAtIndex:0] valueForKey:@"order_no"];
    for (int i = 0; i<[orders count]; i++){
        //NSLog(@"%@",tempId);
        //NSLog(@"%@",[[orders objectAtIndex:i] valueForKey:@"order_no" ] );
        //NSLog(@"%c", [[NSString stringWithFormat:@"%@",[[orders objectAtIndex:i] valueForKey:@"order_no" ] ]isEqualToString:tempId]);
        //NSLog(@"i=%d",i);
        if ( [[NSString stringWithFormat:@"%@",[[orders objectAtIndex:i] valueForKey:@"order_no" ] ]isEqualToString:tempId]){
            
            [tempOrderArray addObject:[orders objectAtIndex:i]];
            //NSLog(@"same");
        }else{
            //NSLog(@"%@",tempOrderArray);
            //NSLog(@"%d",[tempOrderArray count]);
            [tempArray addObject:tempOrderArray];
            //NSLog(@"%d",[tempArray count]);
            //NSLog(@"%@",tempArray);
            tempOrderArray = [NSMutableArray array];
            //NSLog(@"%@",tempArray);
            [tempOrderArray addObject:[orders objectAtIndex:i]];
            
            tempId = [[orders objectAtIndex:i] valueForKey:@"order_no" ];
            //NSLog(@"tempArray:%@",tempArray);
            //NSLog(@"tempOrderArray:%@",tempOrderArray);
            
        }
    }
    //NSLog(@"last object: %@",tempArray );
    //NSLog(@"last object: %@",[tempArray lastObject]);
    //NSLog(@"%@",tempId);
    if (![[[[tempArray lastObject] lastObject] valueForKey:@"order_no"] isEqualToString:tempId])
    {
        [tempArray addObject:tempOrderArray];
        //NSLog(@"tempArray:%@",tempArray);
        //NSLog(@"tempOrderArray:%@",tempOrderArray);
    }
    return tempArray;
}
- (void)loadData
{
    [self.activityIndicator startAnimating];
    //    [self performSelectorOnMainThread:@selector(setupView) withObject:nil waitUntilDone:YES];
    [self performSelectorInBackground:@selector(setupView) withObject:nil];
}

- (void)setupView
{
    self.selectedCategories = @"";
    self.searchedText = @"";
    self.selectedStatus = @"";
    
    self.purchasedHistory = [[NSDictionary alloc] initWithDictionary:[[MJModel sharedInstance] getPurchasedHistoryItems]];
    
    if ([[self.purchasedHistory valueForKey:@"list"] count]) {
        
        self.purchasedHistoryArray = [[NSMutableArray alloc] initWithArray:[self groupByOrderId:[self.purchasedHistory valueForKey:@"list"]]];
        self.tempPurchasedArray = [[NSMutableArray alloc] initWithArray:[self.purchasedHistory valueForKey:@"list"]];
        //NSLog(@"----\n\n\n\n\n\n%@\n\n\n\n\n-----",self.tempPurchasedArray);
        
        self.totalPage = [self.purchasedHistory valueForKey:@"pagecount"];
        
        NSString *isLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"islogin"]copy];
        
        // check if login is remembered in local cache
        if ([isLogin isEqualToString:@"YES"]) {
            
            int nextPage = (int)[self.purchasedHistory valueForKey:@"page"] +1;
            NSDictionary *result = [[MJModel sharedInstance] getPurchasedHistoryFor:self.searchedText cats:self.searchedText arrangedBy:self.selectedStatus forPage:[NSString stringWithFormat:@"%d",nextPage ]];
            
            if ([[result valueForKey:@"list" ] count]  > 0) {
                self.purchasedHistory = result;
            }
            
            
        }
        
        [self.tableView reloadData];
        [self.activityIndicator stopAnimating];
        [self.activityIndicatorView setHidden:YES];
    }
    else{
        [self.activityIndicator setHidden:YES];
        self.loadingLabel.text = [NSString stringWithFormat:@"No records. Pull to refresh"];
        [self.loadingLabel setTextAlignment:NSTextAlignmentCenter];
        self.loadingLabel.textColor = [UIColor grayColor];
    }
}

#pragma mark -
#pragma mark Bottom Loadmore action

- (void) addItemsToEndOfTableView{
    //    [super addItemsToEndOfTableView];
    [UIView animateWithDuration:0.3 animations:^{
        if (self.pageCounter >= self.totalPage)
        {
            CGPoint bottomOffset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.bounds.size.height-kExtraCellHeight+5);
            [self.tableView setContentOffset:bottomOffset animated:YES];
            
            //            if (([self.purchasedHistoryArray count] > kDisplayPerscreen))
            //            {
            //                //NSLog(@"here=");
            //                [self.tableView setContentOffset:CGPointMake(0, (([self.purchasedHistoryArray count]-kDisplayPerscreen)*(kTableCellHeight+kCellHeaderHeight)+kExtraCellHeight)];
            //            }else{
            //
            //                CGRect screenBounds = [[UIScreen mainScreen] bounds];
            //                if (screenBounds.size.height != 568) {
            //                    // code for non 4-inch screen
            //                    [self.tableView setContentOffset:CGPointMake(0, (([self.purchasedHistoryArray count]-kDisplayPerscreen)*(kTableCellHeight+kCellHeaderHeight)+kExtraCellHeight)];
            //                }
            //            }
            
        }else if (self.pageCounter < self.totalPage){
            self.pageCounter++;
            [self loadMoreFromServer2];
            
            /*  if ([list count] > 0) {
             [self.purchasedHistoryArray addObjectsFromArray:list];
             }*/
            
        }
    }];
}

- (void)loadMoreFromServer2
{
    
    NSDictionary *resultsDictionary =  [[MJModel sharedInstance] getPurchasedHistoryFor:self.searchedText cats:self.selectedCategories arrangedBy:self.selectedStatus forPage:[NSString stringWithFormat:@"%d",self.pageCounter+1]];
    if([resultsDictionary count])
    {
        NSString *status = [resultsDictionary objectForKey:@"status"];
        NSMutableArray* resultArray = nil;
        NSMutableArray *tempArray = [NSMutableArray array];
        if ([status isEqualToString:@"ok"])
        {
            self.totalPage = [[resultsDictionary objectForKey:@"pagecount"] intValue];
            
            resultArray = [resultsDictionary objectForKey:@"list"];
            
            for (id row in resultArray)
            {
                [tempArray addObject:row];
                
            }
            [self.tempPurchasedArray addObjectsFromArray:tempArray];
            //NSLog(@"%d",[self.tempPurchasedArray count]);
            //NSLog(@"%@",self.tempPurchasedArray);
            self.purchasedHistoryArray = [[NSMutableArray alloc] initWithArray:[self groupByOrderId: self.tempPurchasedArray ]];
            
        }
        if (![resultArray count] || self.totalPage == 0)
        {
            [self.activityIndicator setHidden:YES];
            
            NSString *aMsg = [resultsDictionary objectForKey:@"message"];
            
            if([aMsg length] < 1)
            {
                if (self.selectedCategories.length > 0)
                {
                    aMsg = @"No data matched.";
                }
            }
            
            
            self.loadingLabel.text = [NSString stringWithFormat:@"%@",aMsg];
            [self.loadingLabel setTextAlignment:NSTextAlignmentCenter];
            self.loadingLabel.textColor = [UIColor grayColor];
            
        }
        
        //NSLog(@"page now is %d",self.pageCounter);
        //NSLog(@"totpage %d",self.totalPage);
        
        if (self.totalPage == self.pageCounter) {
            self.loadingLabel.text = @"";
            CGPoint bottomOffset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.bounds.size.height-kExtraCellHeight+5);
            [self.tableView setContentOffset:bottomOffset animated:YES];
        }else{
            
            // if data is less, then hide the loading view
            if (([[resultsDictionary valueForKey:@"list"] count] > 0 && [[resultsDictionary valueForKey:@"list"] count] < kListPerpage)) {
                //NSLog(@"here xx");
                [self.activityIndicatorView setHidden:YES];
                
            }
            
            
            if ([status isEqualToString:@"error"]) {
                [self.activityIndicatorView setHidden:NO];
                [self.activityIndicator setHidden:YES];
                
                NSString *errorMsg = [resultsDictionary objectForKey:@"message"];
                
                if([errorMsg length] < 1)
                    errorMsg = @"Failed to retrieve data.";
                
                self.loadingLabel.text = [NSString stringWithFormat:@"%@",errorMsg];
                [self.loadingLabel setTextAlignment:NSTextAlignmentCenter];
                self.loadingLabel.textColor = [UIColor grayColor];
                
            }
            
            if ([status isEqualToString:@"ok"] && self.totalPage == 0) {
                //NSLog(@"empty");
                [self.activityIndicatorView setHidden:NO];
                [self.activityIndicator setHidden:YES];
                self.loadingLabel.text = [NSString stringWithFormat:@"No records. Pull to refresh"];
                [self.loadingLabel setTextAlignment:NSTextAlignmentCenter];
                self.loadingLabel.textColor = [UIColor grayColor];
            }
            
            if ([status isEqualToString:@"ok"] && self.totalPage > 1 && ![[resultsDictionary objectForKey:@"list"] count]) {
                //NSLog(@"data empty");
                [self.activityIndicatorView setHidden:YES];
                //        [self.tableView setContentOffset:CGPointMake(0, (([self.tableData count]-kDisplayPerscreen)*kTableCellHeight)+kExtraCellHeight)];
            }
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return [[self purchasedHistoryArray] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [[[self purchasedHistoryArray ] objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    PurchasedViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell  = [[[NSBundle mainBundle] loadNibNamed:@"PurchasedViewCell" owner:nil options:nil]  objectAtIndex:0];
        
    }
    [self createCellForIndex:indexPath cell:cell];
    return cell;
}

-(void)createCellForIndex:(NSIndexPath*)indexPath cell:(PurchasedViewCell*)cell{
    cell.productName.text =[[[self.purchasedHistoryArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"product_name"];
    cell.priceLabel.text =[[[self.purchasedHistoryArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]
                           valueForKey:@"price"];
    cell.dateLabel.text =[[[self.purchasedHistoryArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]valueForKey:@"date_purchased"];
    cell.qtyLabel.text =[[[self.purchasedHistoryArray objectAtIndex:indexPath.section]  objectAtIndex:indexPath.row]valueForKey:@"quantity"];
    if (![[[[[ self.purchasedHistoryArray objectAtIndex:indexPath.section]  objectAtIndex:indexPath.row]valueForKey:@"size_name"] class] isEqual:[NSNull class]]){
        cell.sizeLabel.text = [[[self.purchasedHistoryArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]valueForKey:@"size_name"];
    }
    
    cell.statusLabel.text = [[[[self.purchasedHistoryArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]valueForKey:@"order_status"] stringByStrippingHTML];
    if (![[[[[self.purchasedHistoryArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]valueForKey:@"product_image"] class] isEqual:[NSNull class]]){
        [cell.imageView setImageWithURL:[NSURL URLWithString:[[[self.purchasedHistoryArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]valueForKey:@"product_image"]] placeholderImage:[UIImage imageNamed:@"default_icon.png"]];
    }
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading ..." width:100];
    [self performSelector:@selector(showDetailsProductForIndexPath:) withObject:indexPath afterDelay:0.1];
}

- (void)showDetailsProductForIndexPath:(NSIndexPath *)indexPath
{
    DetailProductViewController *detailViewController = [[DetailProductViewController alloc] initWithNibName:@"DetailProductViewController" bundle:nil];
    detailViewController.productInfo = [[MJModel sharedInstance] getPuchasedInfoForId:[[[self.purchasedHistoryArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"order_item_id"]];
    //    //NSLog(@"--- %@",detailViewController.productInfo);
    detailViewController.buyButton = [[NSString alloc] initWithString:@"not-ok"];
    detailViewController.orderId = [[[self.purchasedHistoryArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]valueForKey:@"order_item_id"];
    detailViewController.productId = [[[self.purchasedHistoryArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]valueForKey:@"product_id"];
    //NSLog(@"--- %@",detailViewController.orderId);
    detailViewController.purchasedString = @"purchased";
    AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [mydelegate.shopNavController pushViewController:detailViewController animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableCellHeightX;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PurchasedHeaderView *header = [[[NSBundle mainBundle] loadNibNamed:@"PurchasedHeaderView" owner:self options:nil]objectAtIndex:0];
    header.sellerName.text= [[[self.purchasedHistoryArray objectAtIndex:section] objectAtIndex:0]valueForKey:@"shop_name"];
    header.orderNo.text=[[[self.purchasedHistoryArray objectAtIndex:section] objectAtIndex:0]valueForKey:@"order_no"];
    CGSize expectedLabelSize  = [[[[self.purchasedHistoryArray objectAtIndex:section] objectAtIndex:0]valueForKey:@"shop_name"] sizeWithFont:[UIFont fontWithName:@"Verdana" size:12.0] constrainedToSize:CGSizeMake(150.0, header.sellerName.frame.size.height) lineBreakMode:UILineBreakModeWordWrap];
    
    
    CGRect newFrame = header.sellerName.frame;
    newFrame.size.width = expectedLabelSize.width;
    
    header.sellerName.frame = newFrame;
    
    header.middleLine.frame = CGRectMake(expectedLabelSize.width+50,header.middleLine.frame.origin.y,230-expectedLabelSize.width-50, 1);
    [self.tableView bringSubviewToFront:header];
    [self.tableView setNeedsDisplay];
    //    header.frame = CGRectMake(0, 0, header.bounds.size.width, 50);
    //    [header setBackgroundColor:[UIColor whiteColor]];
    return  header;
}
- (void) refreshTableItemsWithFilter:(NSString *)str andSearchedText:(NSString *)pattern andOptions:(NSString*)optionData{
    
    //NSLog(@"Filtering news list with searched text %@",str);
    self.purchasedHistory =  [[NSDictionary alloc] initWithDictionary:[[MJModel sharedInstance] getPurchasedHistoryFor:pattern cats:str arrangedBy:optionData forPage:@"1"]];
    
    [[super tableView] reloadData];
    [DejalBezelActivityView removeViewAnimated:YES];
    
    
}
-(void)refreshTable:(NSNotification*)notification{
    self.purchasedHistory = [[NSDictionary alloc] initWithDictionary:[[MJModel sharedInstance] getPurchasedHistoryItems]];
    self.purchasedHistoryArray = [[NSMutableArray alloc] initWithArray:[self groupByOrderId:[self.purchasedHistory valueForKey:@"list"]]];
    self.tempPurchasedArray = [[NSMutableArray alloc] initWithArray:[self.purchasedHistory valueForKey:@"list"]];
    
    [self refreshTableItemsWithFilter:@"" andSearchedText:@"" andOptions:@""];
    
}


- (void)viewDidUnload {
    self.activityIndicator=nil;
    self.activityIndicatorView=nil;
    self.footerActivityIndicator=nil;
    self.tableView=nil;
    
    [super viewDidUnload];
}


- (void)dealloc {
    [self.tableView release];
    [[self activityIndicator] release];
    [[self activityIndicatorView] release];
    [[self footerActivityIndicator] release];
    [super dealloc];
}

@end
