//
//  NewsPreferenceViewController.m
//  myjam
//
//  Created by Mohd Zulhilmi on 14/02/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "CPViewController.h"
#import "AppDelegate.h"
#import "CustomAlertView.h"
#import "CPViewController.h"

@interface CPViewController ()

@end

@implementation CPViewController

@synthesize uiTableView, tableData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithTagID:(id)tagID
{
    [self init];
    self.title = @"Content Provider";
    FontLabel *titleView = [[FontLabel alloc] initWithFrame:CGRectZero fontName:@"jambu-font.otf" pointSize:22];
    titleView.text = self.title;
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.backgroundColor = [UIColor clearColor];
    titleView.textColor = [UIColor whiteColor];
    [titleView sizeToFit];
    self.navigationItem.titleView = titleView;
    [titleView release];
    
    self.navigationItem.backBarButtonItem =
    [[[UIBarButtonItem alloc] initWithTitle:@"Back"
                                      style:UIBarButtonItemStyleBordered
                                     target:nil
                                     action:nil] autorelease];
    
    self.tagID = tagID;
    //NSLog(@"tagID: %@",tagID);
    
    return self;
}

- (void)animateDBAV:(NSString *)label
{
    //AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [DejalBezelActivityView activityViewForView:self.view withLabel:label width:100];
}

- (void)deAnimateDBAV
{
    [DejalBezelActivityView removeViewAnimated:YES];
}

- (void)setMessageForSuccess
{
    NSString *setMessage = [NSString stringWithFormat:@"Subscription is successfully saved."];
    
    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"JAM-BU Settings" message:setMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
    
    [setMessage release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    if (screenBounds.size.height == 568) {
        // code for 4-inch screen
        self.view.frame = CGRectMake(0,0,self.view.bounds.size.width, 568);
    } else {
        // code for 3.5-inch screen
        self.view.frame = CGRectMake(0,0,self.view.bounds.size.width, 480);
    }
    
    self.uiTableView.frame = CGRectMake(0,0,self.view.bounds.size.width, self.view.bounds.size.height-84);
    
    // Do any additional setup after loading the view from its nib.
    
    [self viewWillAppear:NO];
    [self viewWillDisappear:NO];

    [self animateDBAV:@"Loading ..."];
    
    [self performSelector:@selector(loadData:) withObject:nil];
    
    [self performSelector:@selector(deAnimateDBAV) withObject:nil afterDelay:1.0];
}

- (void)loadAfterSaved
{
    [self animateDBAV:@"Saving ..."];
    
    [self performSelector:@selector(loadData:) withObject:nil afterDelay:0.2];
    
}

- (void)loadData:(id)subCatTag
{
    
    NSArray *list = nil;
    
    list = [self loadFromServer:nil];
    
    [self.tableData addObjectsFromArray:list];
    
    self.tableData = [list mutableCopy];
    
    [self.uiTableView clearsContextBeforeDrawing];
    [self.uiTableView reloadData];
    
}

- (NSString *)urlAPIString
{
    //NSLog(@"Token String: %@",[[[NSUserDefaults standardUserDefaults]objectForKey:@"tokenString"]mutableCopy]);
    
    return [NSString stringWithFormat:@"%@/api/settings_news_preference.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
}

- (NSMutableArray *)loadFromServer:(id)subCatTag
{
    NSString *urlString = [self urlAPIString];
    
    NSString *dataContentForDefaults = [NSString stringWithFormat:@"{\"flag\":\"DEFAULT2\"}"];
    
    //=== WRAPPING DATA IN NSSTRING ===//
    NSString *wrappedDefaultDataFromServer = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContentForDefaults];
    //NSLog(@"Check response for DEFAULT2 param CPVC: %@",wrappedDefaultDataFromServer);
    
    NSMutableArray *newData = [[NSMutableArray alloc] init];
    NSDictionary *wrappedDefaultDataToDictionary = [[wrappedDefaultDataFromServer objectFromJSONString] copy];
    
    id tagID;
    NSString *currentStatus = nil;
    NSDictionary* resultArray;
    NSDictionary* secondArray;

    
    if([wrappedDefaultDataToDictionary count])
    {
        
        currentStatus = [wrappedDefaultDataToDictionary objectForKey:@"status"];
        
        if ([currentStatus isEqual: @"ok"])
        {
            [self.uiTableView setHidden:NO];
            
            resultArray = [wrappedDefaultDataToDictionary objectForKey:@"preferences"];
            
            for (id row in resultArray)
            {
                tagID = [row objectForKey:@"category_id"];
                
                self.catHead = [row objectForKey:@"category_name"];
                
                if([tagID isEqual:self.tagID])
                {
                    secondArray = [row objectForKey:@"cp"];
                    
                    if([row objectForKey:@"cp"] == [NSNull null])
                    {
                        //if array is null
                        self.cpStatus = @"notAvailable";
                    }
                    else
                    {
                        self.cpStatus = @"available";
                        
                    }
                    
                    if([self.cpStatus isEqual: @"available"])
                    {
                        for(id row2 in secondArray)
                        {
                            //NSLog(@"Second Array: %@",secondArray);
                        
                            MData *settingsVar = [[MData alloc]init];
                        
                            settingsVar.defaultCategoryID = [row2 objectForKey:@"category_id"];
                            settingsVar.defaultCPID = [row2 objectForKey:@"cp_id"];
                            settingsVar.defaultCPName = [row2 objectForKey:@"cp_name"];
                            NSString *subscriptionStr = [NSString stringWithFormat:@"%@",[row2 objectForKey:@"subscription"]];
                            settingsVar.subscriptionStatus = subscriptionStr;
                        
                            [newData addObject:settingsVar];
                            [settingsVar release];
                        }
                        break;
                    }
                    else if([self.cpStatus isEqual: @"notAvailable"])
                    {
                        [self tableViewHide];
                    }
                }
                
            }
        }
    
    }
    
    
    return newData;
}

- (void)tableViewHide
{
    CGRect frame = CGRectMake(0, -70, self.view.bounds.size.width, self.view.bounds.size.height);
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    
    label.text = @"No Content Provider Available Yet";
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:label];
    [self.uiTableView setHidden:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"JAM-BU News";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,50)];
    tempView.backgroundColor=[UIColor whiteColor];
    
    UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,8,self.view.frame.size.width,20)];
    tempLabel.backgroundColor=[UIColor clearColor];
    //tempLabel.shadowColor = [UIColor blackColor];
    tempLabel.shadowOffset = CGSizeMake(0,2);
    tempLabel.textColor = [UIColor blackColor]; //here you can change the text color of header.
    tempLabel.font = [UIFont fontWithName:@"Verdana" size:11];
    tempLabel.font = [UIFont boldSystemFontOfSize:11];
    tempLabel.text = [NSString stringWithFormat:@"JAM-BU News > %@",self.catHead];
    
    [tempView addSubview:tempLabel];
    
    [tempLabel release];
    return tempView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    // Usually the number of items in your array (the one that holds your list)
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Where we configure the cell in each row
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell... setting the text of our cell's label
    
    MData *setData = [self.tableData objectAtIndex:indexPath.row];
    
    UIButton *customTicker = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *tickedCT = [UIImage imageNamed:@"settings_news_active.png"];
    UIImage *unTickedCT = [UIImage imageNamed:@"settings_news_inactive.png"];

    //NSLog(@"Subscription STATUS GET: %@",setData.subscriptionStatus);

    if ([setData.subscriptionStatus isEqual:@"1"])
    {
        //NSLog(@"SubscriptionStatus isEqual to ONE should be passed...");
        CGRect setFrameCT = CGRectMake(0, 0, tickedCT.size.width-20, tickedCT.size.height-10);
        customTicker.frame = setFrameCT;
        [customTicker setBackgroundImage:tickedCT forState:UIControlStateNormal];
        cell.accessoryView = customTicker;
        [customTicker addTarget:self action:@selector(unsubscribeBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if([setData.subscriptionStatus isEqual:@"0"])
    {
        //NSLog(@"SubscriptionStatus isEqual to ZERO should be passed...");
        CGRect setFrameCT = CGRectMake(0, 0, unTickedCT.size.width-20, unTickedCT.size.height-10);
        customTicker.frame = setFrameCT;
        [customTicker setBackgroundImage:unTickedCT forState:UIControlStateNormal];
        cell.accessoryView = customTicker;
        [customTicker addTarget:self action:@selector(subscribeBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [customTicker setTag:setData.defaultCPID];
    
    cell.textLabel.text = setData.defaultCPName;
    cell.textLabel.font = [UIFont fontWithName:@"Verdana" size:18];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //cell.tag = setData.defaultCategoryID;
    
    //NSLog(@"Showing hidden data TEST: %ld",(long)indexPath.row);
    
    //NSLog(@"getbuttonid: %ld",(long)customTicker.tag);
    
    return cell;
}



-(void)subscribeBtn:(id)btnTagID
{
    
    //NSLog(@"Subscribe button is voided!");
    //NSLog(@"ID TAG: %@",(id)[btnTagID tag]);
    
    NSString *namaRumahApi = [self urlAPIString];
    
    NSString *dataContent = [NSString stringWithFormat:@"{\"flag\":\"SUBSCRIBE2\",\"category_id\":\"%@\",\"cp_id\":\"%@\"}",self.tagID,(id)[btnTagID tag]];
    
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:namaRumahApi andDataContent:dataContent];
    //NSLog(@"abc: %@, def:%@",dataContent, response);
    NSDictionary *resultsDictionary = [[response objectFromJSONString] mutableCopy];

    if([resultsDictionary count])
    {
        NSString *status = [resultsDictionary objectForKey:@"status"];
        NSString *msg = [resultsDictionary objectForKey:@"message"];
        
        if ([status isEqualToString:@"ok"])
        {
            //NSLog(@"Success change");
            [self loadAfterSaved];
            [self performSelector:@selector(deAnimateDBAV) withObject:nil afterDelay:0.2];

            [self performSelector:@selector(notifyMainCatToRefresh) withObject:self afterDelay:1.0];
        }
        else if([msg isEqualToString:@"Request timed out."])
        {
            CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Request Timed Out" message:@"Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            
            [self performSelector:@selector(deAnimateDBAV) withObject:nil afterDelay:0.2];
        }
    }
    
}

-(void)unsubscribeBtn:(id)btnTagID
{
    
    //NSLog(@"Unsubscribe button is voided!");
    //NSLog(@"ID TAG: %@",(id)[btnTagID tag]);

    NSString *namaRumahApi = [self urlAPIString];
    
    NSString *dataContent = [NSString stringWithFormat:@"{\"flag\":\"UNSUBSCRIBE2\",\"category_id\":\"%@\",\"cp_id\":\"%@\"}",self.tagID,(id)[btnTagID tag]];
    
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:namaRumahApi andDataContent:dataContent];
    //NSLog(@"abc: %@, def:%@",dataContent, response);
    NSDictionary *resultsDictionary = [[response objectFromJSONString] mutableCopy];
    
    if([resultsDictionary count])
    {
        NSString *status = [resultsDictionary objectForKey:@"status"];
        NSString *msg = [resultsDictionary objectForKey:@"message"];
        
        if ([status isEqualToString:@"ok"])
        {
            //NSLog(@"Success change");
            [self loadAfterSaved];
            [self performSelector:@selector(deAnimateDBAV) withObject:nil afterDelay:0.2];
            
            [self performSelector:@selector(notifyMainCatToRefresh) withObject:self afterDelay:1.0];
        }
        else if([msg isEqualToString:@"Request timed out."])
        {
            CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Request Timed Out" message:@"Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];

            [self performSelector:@selector(deAnimateDBAV) withObject:nil afterDelay:0.2];
        }
    }
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)notifyMainCatToRefresh
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notifyTableReload" object:self];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
