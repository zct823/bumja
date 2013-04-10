//
//  NewsPreferenceViewController.m
//  myjam
//
//  Created by Mohd Zulhilmi on 14/02/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "NewsPreferenceViewController.h"
#import "AppDelegate.h"
#import "CustomAlertView.h"
#import "CPViewController.h"

@interface NewsPreferenceViewController ()

@end

@implementation NewsPreferenceViewController

@synthesize uiTableView, tableData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

# pragma mark -
# pragma mark Main category refresh receiver (NSNotificationCenter)


//- (id) init
//{
//    self = [super init];
//    
//    if(!self)return nil;
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataNotify:) name:@"notifyTableReload" object:nil];
//    
//    return self;
//}

- (void) loadDataNotify:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"notifyTableReload"])
    {
        [self animateDBAV:@"Loading ..."];
        
        [self.uiTableView setHidden:YES];
        
        [self performSelector:@selector(loadData:) withObject:nil];
        
        [self performSelector:@selector(deAnimateDBAV) withObject:nil afterDelay:1.0];
    }
}

# pragma mark -
# pragma mark DejalBezelActivityView On and Off trigger

- (void)animateDBAV:(NSString *)label
{
    //AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [DejalBezelActivityView activityViewForView:self.view withLabel:label width:100];
}

- (void)deAnimateDBAV
{
    [DejalBezelActivityView removeViewAnimated:YES];
}

# pragma mark -
# pragma mark Dialog Box trigger (CustomAlertView)

- (void)setMessageForSuccess
{
    NSString *setMessage = [NSString stringWithFormat:@"Subscription is successfully saved."];
    
    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"JAM-BU Settings" message:setMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
    
    [setMessage release];
}

# pragma mark -
# pragma mark View action trigger

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [self animateDBAV:@"Loading ..."];
    
    [self.uiTableView setHidden:YES];
    [self loadData:nil];
//    [self performSelector:@selector(loadData:) withObject:nil afterDelay:0.0];
    
//    [self performSelector:@selector(deAnimateDBAV) withObject:nil afterDelay:1.0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self animateDBAV:@"Loading ..."];
    
    [self.uiTableView setHidden:YES];
    
    [self performSelector:@selector(loadData:) withObject:nil afterDelay:0.2];
    
    [self performSelector:@selector(deAnimateDBAV) withObject:nil afterDelay:1.0];
}

# pragma mark -
# pragma mark Trigger for load the data

- (void)loadAfterSaved
{
    //Trigger to display the data after tapping button subscribe/unsubscribe
    
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
    //NSLog(@"Check response for DEFAULT2 param: %@",wrappedDefaultDataFromServer);
    
    NSMutableArray *newData = [[NSMutableArray alloc] init];
    NSDictionary *wrappedDefaultDataToDictionary = [[wrappedDefaultDataFromServer objectFromJSONString] copy];
    
    NSString *currentStatus = nil;
    NSDictionary* resultArray;
    
    if([wrappedDefaultDataToDictionary count])
    {
        
        currentStatus = [wrappedDefaultDataToDictionary objectForKey:@"status"];
        
        if ([currentStatus isEqual: @"ok"])
        {
            [self.uiTableView setHidden:NO];
            
            resultArray = [wrappedDefaultDataToDictionary objectForKey:@"preferences"];
            
                for (id row in resultArray)
                {
                    if([row objectForKey:@"cp"] == [NSNull null])
                    {
                        //if array is null
                        self.cpStatus = @"notAvailable";
                    }
                    else
                    {
                        self.cpStatus = @"available";
                        
                    }
                    
                    MData *settingsVar = [[MData alloc]init];
                    
                    settingsVar.defaultCategoryID = [row objectForKey:@"category_id"];
                    settingsVar.defaultCategoryName = [row objectForKey:@"category_name"];
                    NSString *subscriptionStr = [NSString stringWithFormat:@"%@",[row objectForKey:@"subscription"]];
                    settingsVar.subscriptionStatus = subscriptionStr;
                    
                    [newData addObject:settingsVar];
                    [settingsVar release];
                }

        }
        else
        {
            [self displayRequestProblemError];
        }
    
    }

    
    
    return newData;
}

# pragma mark -
# pragma mark Error handle trigger

- (void)displayRequestProblemError
{
    CGRect frame = CGRectMake(0, -70, self.view.bounds.size.width, self.view.bounds.size.height);
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    
    label.text = @"Connection error. Please try again.";
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:label];
    [self.uiTableView setHidden:YES];
}

# pragma mark -
# pragma mark Table view data source

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
    tempLabel.text = @"JAM-BU News";
    
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
    UIImage *bulkCT = [UIImage imageNamed:@"settings_news_semi.png"];

    //NSLog(@"Subscription STATUS GET: %@",setData.subscriptionStatus);

    if ([setData.subscriptionStatus isEqual:@"2"])
    {
        //NSLog(@"SubscriptionStatus isEqual to TWO should be passed...");
        CGRect setFrameCT = CGRectMake(0, 0, bulkCT.size.width-20, bulkCT.size.height-10);
        customTicker.frame = setFrameCT;
        [customTicker setBackgroundImage:bulkCT forState:UIControlStateNormal];
        cell.accessoryView = customTicker;
        [customTicker addTarget:self action:@selector(subscribeBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if ([setData.subscriptionStatus isEqual:@"1"])
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
    
    [customTicker setTag:setData.defaultCategoryID];
    
    cell.textLabel.text = setData.defaultCategoryName;
    cell.textLabel.font = [UIFont fontWithName:@"Verdana" size:18];
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = setData.defaultCategoryID;
    
    //NSLog(@"Showing hidden data TEST: %ld",(long)indexPath.row);
    
    //NSLog(@"getbuttonid: %ld",(long)customTicker.tag);
    
    return cell;
}

# pragma mark -
# pragma mark Subscription action trigger

-(void)subscribeBtn:(id)btnTagID
{
    
    //NSLog(@"Subscribe button is voided!");
    //NSLog(@"ID TAG: %@",(id)[btnTagID tag]);
    
    NSString *namaRumahApi = [self urlAPIString];
    NSString *dataContent = nil;
    
    dataContent = [NSString stringWithFormat:@"{\"flag\":\"SUBSCRIBE_BULK\",\"category_id\":\"%@\"}",(id)[btnTagID tag]];
    
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
    NSString *dataContent = nil;
    
    dataContent = [NSString stringWithFormat:@"{\"flag\":\"UNSUBSCRIBE_BULK\",\"category_id\":\"%@\"}",(id)[btnTagID tag]];
    
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

# pragma mark -
# pragma mark Tapped row tableView trigger

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self animateDBAV:@"Please wait..."];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    //NSLog(@"cell TAG: %@",(id)cell.tag);
    
    CPViewController *cpVC = [[CPViewController alloc] initWithTagID:cell.tag];
    
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    [appDel.otherNavController pushViewController:cpVC animated:YES];
    [cpVC release];
    
    [self performSelector:@selector(deAnimateDBAV) withObject:self afterDelay:0.2];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

# pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end
