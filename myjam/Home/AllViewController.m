//
//  AllViewController.m
//  myjam
//
//  Created by ME-Tech Mac User 2 on 2/28/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "AllViewController.h"
#import "JambuCell.h"
#import "AppDelegate.h"
#import "MoreViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface AllViewController ()

@end

@implementation AllViewController


- (void)viewDidLoad
{
    //NSLog(@"viewDidLoad All");
    [super viewDidLoad];
    self.selectedCategories = @"";
    self.searchedText = @"";
    //    aQRcodeType = [[NSMutableArray alloc] init];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        // code for 4-inch screen
        kDisplayPerscreen = 4;
    } else {
        // code for 3.5-inch screen
        kDisplayPerscreen = 3;
    }
    
    UIPanGestureRecognizer *slideRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:nil];
    slideRecognizer.delegate = self;
    [self.tableView addGestureRecognizer:slideRecognizer];
    [self loadData];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    if (!self.refreshDisabled)
    {
        AppDelegate *mydelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (![mydelegate.bottomSVAll.searchTextField.text isKindOfClass:[NSString class]]) {
            mydelegate.bottomSVAll.searchTextField.text = @"";
        }
        if (![self.selectedCategories isKindOfClass:[NSString class]]) {
            self.selectedCategories = @"";
        }
        //[mydelegate.bottomSVAll.checkedCategories removeAllObjects];
        //mydelegate.bottomSVAll.searchTextField.text = @"";
        //self.selectedCategories = @"";
        //self.searchedText = @"";
        
        [self.tableData removeAllObjects];
        //        [aQRcodeType removeAllObjects];
        [self.tableView reloadData];
        [self.loadingLabel setText:@"Loading ..."];
        [self.activityIndicator setHidden:NO];
        [self.activityIndicatorView setHidden:NO];
        [self loadData];
        
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }else{
        self.refreshDisabled = NO;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self.view];
    //NSLog(@"YES %f - %f",translation.y, translation.x);
    
    if(gestureRecognizer.numberOfTouches == 2){
        //NSLog(@"2");
        if (translation.y < 0) {
            //NSLog(@"slide up now");
            AppDelegate *mydelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [mydelegate handleSwipeUp];
            return YES;
        }
    }
    else{
        //NSLog(@"%d",gestureRecognizer.numberOfTouches);
    }
    
    //NSLog(@"NO");
    return NO;
}


- (void)loadData
{
    [self.activityIndicator startAnimating];
//    [self performSelectorOnMainThread:@selector(setupView) withObject:nil waitUntilDone:YES];
    [self performSelector:@selector(setupView) withObject:nil afterDelay:0.0];
//    [self setupView];
//    [self performSelectorInBackground:@selector(setupView) withObject:nil];
    
}

- (void)setupView
{
    //self.selectedCategories = @"";
    if (![self.searchedText isKindOfClass:[NSString class]]) {
        self.searchedText = @"";
    }
    
    NSString *isLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"islogin"]copy];
    
    // check if login is remembered in local cache
    if ([isLogin isEqualToString:@"YES"]) {
        
        self.pageCounter = 1;
//        NSArray *list = [self loadMoreFromServer];
//        
//        if ([list count] > 0) {
//            [self.tableData addObjectsFromArray:list];
//        }
//        
//        self.tableData = [list mutableCopy];
        
        self.tableData = [self loadMoreFromServer];
    }
    
    if ([self.tableData count]) {
        [self.tableView reloadData];
        [self.activityIndicator stopAnimating];
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
            //            if (([self.tableData count] > kDisplayPerscreen)) {
            //                [self.tableView setContentOffset:CGPointMake(0, (([self.tableData count]-kDisplayPerscreen)*kTableCellHeight)+kExtraCellHeight)];
            //            }else{
            //
            //                CGRect screenBounds = [[UIScreen mainScreen] bounds];
            //                if (screenBounds.size.height != 568) {
            //                    // code for 4-inch screen
            //                    [self.tableView setContentOffset:CGPointMake(0, (([self.tableData count]-kDisplayPerscreen)*kTableCellHeight)+kExtraCellHeight)];
            //                }
            //            }
            
        }else if (self.pageCounter < self.totalPage){
            self.pageCounter++;
            NSArray *list = [self loadMoreFromServer];
            
            if ([list count] > 0) {
                [self.tableData addObjectsFromArray:list];
            }
            
        }
    }];
}

- (NSString *)returnAPIURL
{
    return [NSString stringWithFormat:@"%@/api/qrcode_news_list.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]copy]];
}

- (NSString *)returnAPIDataContent
{
    NSString *feed_type = @"all";
    return [NSString stringWithFormat:@"{\"page\":%d,\"perpage\":%d,\"category_id\":\"%@\",\"search\":\"%@\",\"feed_type\":\"%@\"}",self.pageCounter, kListPerpage, self.selectedCategories, self.searchedText,feed_type];
}

- (NSMutableArray *)loadMoreFromServer
{
    NSString *urlString = [self returnAPIURL];
    
    NSString *dataContent = [self returnAPIDataContent];
    
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
    //NSLog(@"dataContent: %@\nresponse listing: %@", dataContent,response);
    NSMutableArray *newData = [[NSMutableArray alloc] init];
    NSDictionary *resultsDictionary = [[response objectFromJSONString] copy];
    
    NSString *status = nil;
    NSMutableArray* list = nil;
    
    if([resultsDictionary count])
    {
        status = [resultsDictionary objectForKey:@"status"];
        list = [resultsDictionary objectForKey:@"list"];
        NSMutableArray* resultArray;
        
        if ([status isEqualToString:@"ok"] && [list count])
        {
            self.totalPage = [[resultsDictionary objectForKey:@"pagecount"] intValue];
            
            resultArray = [resultsDictionary objectForKey:@"list"];
            
            for (id row in resultArray)
            {
                MData *aData = [[MData alloc] init];
                
                aData.qrcodeId = [row objectForKey:@"qrcode_id"];
                aData.category = [row objectForKey:@"category"];
                aData.labelColor = [row objectForKey:@"color"];
                aData.contentProvider = [row objectForKey:@"fullname"];
                aData.title = [row objectForKey:@"title"];
                aData.date = [row objectForKey:@"date"];
                aData.abstract = [row objectForKey:@"description"];
                aData.type = [row objectForKey:@"type"];
                aData.imageURL = [row objectForKey:@"image"];
                aData.shareType = [row objectForKey:@"share_type"];
                
                // request image
                
                //                ASIHTTPRequest *imageRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:aData.imageURL]];
                //                [imageRequest startSynchronous];
                //                NSError *error = [imageRequest error];
                //                if (!error) {
                //                    aData.thumbImage = [[UIImage alloc] initWithData:[imageRequest responseData]];
                //                }else{
                //                    //NSLog(@"error retrieve cell thumbs: %@",error);
                //                    ASIHTTPRequest *imageRequest2 = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:aData.imageURL]];
                //                    [imageRequest2 startSynchronous];
                //                    if (!error) {
                //                        aData.thumbImage = [[UIImage alloc] initWithData:[imageRequest2 responseData]];
                //                    }else{
                //                        aData.thumbImage = [UIImage imageNamed:@"default_icon"];
                //                    }
                //                    [imageRequest2 release];
                //                }
                //                [imageRequest release];
                id objnul = aData.category;
                
                if (objnul != [NSNull null] && aData.labelColor && aData.qrcodeId && aData.title && aData.date && aData.type) {
                    [newData addObject:aData];
                }
                [aData release];
            }
            
            if (![resultArray count] || self.totalPage == 0)
            {
                [self.activityIndicator setHidden:YES];
                
                NSString *aMsg = [resultsDictionary objectForKey:@"message"];
                
                if([aMsg length] < 1)
                {
                    if (self.selectedCategories.length > 0) {
                        aMsg = @"No data matched.";
                    }
                }
                
                
                self.loadingLabel.text = [NSString stringWithFormat:@"%@",aMsg];
                [self.loadingLabel setTextAlignment:NSTextAlignmentCenter];
                self.loadingLabel.textColor = [UIColor grayColor];
                //                [self.tableView setContentOffset:CGPointMake(0, (([self.tableData count]-kDisplayPerscreen)*kTableCellHeight)+kExtraCellHeight)];
            }
            
            //NSLog(@"page now is %d",self.pageCounter);
            //NSLog(@"totpage %d",self.totalPage);
            
            // if data is less, then hide the loading view
            if (([newData count] > 0 && [newData count] < kListPerpage)) {
                //NSLog(@"here xx");
                [self.activityIndicatorView setHidden:YES];
            }
            
        }
        else
        {
            //NSLog(@"Listing error (probably API error) but we treat as no records to close the (null) message.");
            [self.activityIndicatorView setHidden:NO];
            [self.activityIndicator setHidden:YES];
            self.loadingLabel.text = [NSString stringWithFormat:@"No records. Pull to refresh"];
            [self.loadingLabel setTextAlignment:NSTextAlignmentCenter];
            self.loadingLabel.textColor = [UIColor grayColor];
        }
        
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
    
    
    [resultsDictionary release];
    
    return newData;
}

#pragma mark -
#pragma mark UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [super scrollViewDidScroll:scrollView];
}


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"FeedCell";
    
    JambuCell *cell = (JambuCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"JambuCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
        //        [nib release];
    }
    
    MData *fooData = [self.tableData objectAtIndex:indexPath.row];
    
    cell.providerLabel.text = fooData.contentProvider;
    cell.titleLabel.text = fooData.title;
    cell.thumbsView.image = [UIImage imageNamed:fooData.imageURL];
    cell.dateLabel.text = fooData.date;
    cell.abstractLabel.text = fooData.abstract;
    cell.typeLabel.text = fooData.type;
    //    [aQRcodeType addObject:fooData.type];
    cell.categoryLabel.text = fooData.category;
    cell.labelView.backgroundColor = [UIColor colorWithHex:fooData.labelColor];
    //    cell.thumbsView.image = fooData.thumbImage;
    [cell.thumbsView setImageWithURL:[NSURL URLWithString:fooData.imageURL]
                    placeholderImage:[UIImage imageNamed:@"default_icon"]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                               if (!error) {
                                   
                               }else{
                                   //NSLog(@"error retrieve image: %@",error);
                               }
                               
                           }];
    
    if ([fooData.shareType length] > 0) {
        NSString *imgName = [NSString stringWithFormat:@"pin_share_%@",fooData.shareType];
        cell.shareTypeImageView.image = [UIImage imageNamed:imgName];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Get qrcodeId and push to details view
//    [self performSelectorOnMainThread:@selector(processRowAtIndexPath:) withObject:indexPath waitUntilDone:NO];
    [self processRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableCellHeight;
}

#pragma mark -
#pragma mark didSelectRow extended action
//for moreview to pass to spam (abstract n imageView)
- (void)processRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoreViewController *detailView = [[MoreViewController alloc] init];
    detailView.qrcodeId = [[self.tableData objectAtIndex:indexPath.row] qrcodeId];
    AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [mydelegate.homeNavController pushViewController:detailView animated:YES];
    [detailView release];
}
//end

#pragma mark -
#pragma mark PullRefresh action

- (void)refresh {
    [self performSelector:@selector(addItem) withObject:nil afterDelay:0.0];
}

- (void)addItem { /* add item to top */
    self.pageCounter = 1;
    [self.tableData removeAllObjects];
    //    [aQRcodeType removeAllObjects];
    self.tableData = [[self loadMoreFromServer] mutableCopy];
    [self.tableView reloadData];
    
    [self stopLoading];
}

#pragma mark content filter

- (void) refreshTableItemsWithFilter:(NSString *)str
{
    //NSLog(@"Filtering all list");
    self.selectedCategories = @"";
    self.selectedCategories = str;
    self.pageCounter = 1;
    
    [self.tableData removeAllObjects];
    //    [aQRcodeType removeAllObjects];
    self.tableData = [[self loadMoreFromServer] mutableCopy];
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero animated:YES];
    
}

- (void) refreshTableItemsWithFilter:(NSString *)str andSearchedText:(NSString *)pattern
{
    //    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading ..." width:100];
    
    
    //NSLog(@"Filtering ALL list with searched text %@",str);
    self.selectedCategories = @"";
    self.selectedCategories = str;
    self.searchedText = @"";
    self.searchedText = pattern;
    self.pageCounter = 1;
    [self.tableData removeAllObjects];
    //    [aQRcodeType removeAllObjects];
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
    self.activityIndicator=nil;
    self.activityIndicatorView=nil;
    self.footerActivityIndicator=nil;
    self.tableView=nil;
    self.tableData=nil;
    [super viewDidUnload];
}


- (void)dealloc {
    [[self activityIndicator] release];
    [[self activityIndicatorView] release];
    [[self footerActivityIndicator] release];
    [super dealloc];
}

@end
