//
//  CPViewController.m
//  myjam
//
//  Created by Mohd Zulhilmi on 21/02/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

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
    
    NSLog(@"tagID = %@",tagID);
    self.tagID = tagID;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadSubCatData];

}

- (void)loadSubCatData
{
    
    NSArray *list = nil;
    
    list = [self loadFromServer];
    
    [self.tableData addObjectsFromArray:list];
    
    self.tableData = [list mutableCopy];
    [self.uiTableView clearsContextBeforeDrawing];
    [self.uiTableView reloadData];
}

- (NSString *)urlAPIString
{
    return [NSString stringWithFormat:@"%@/api/settings_news_preference.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
}

- (NSMutableArray *)loadFromServer
{
    NSString *urlString = [self urlAPIString];
    
    NSString *dataContentForDefaults = [NSString stringWithFormat:@"{\"flag\":\"DEFAULT2\"}"];
    
    //=== WRAPPING DATA IN NSSTRING ===//
    NSString *wrappedDefaultDataFromServer = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContentForDefaults];
    NSLog(@"Check response for DEFAULT2 in CPVIEWController param: %@",wrappedDefaultDataFromServer);
    
    NSMutableArray *newData = [[NSMutableArray alloc] init];
    NSDictionary *wrappedDefaultDataToDictionary = [[wrappedDefaultDataFromServer objectFromJSONString] copy];
    
    NSString *currentStatus = nil;
    id tagID;
    NSDictionary* resultArray;
    NSMutableArray* secondArray = nil;
    
    if([wrappedDefaultDataToDictionary count])
    {
        currentStatus = [wrappedDefaultDataToDictionary objectForKey:@"status"];
        if ([currentStatus isEqualToString:@"ok"])
        {
            resultArray = [wrappedDefaultDataToDictionary objectForKey:@"preferences"];
            
            for(id row in resultArray)
            {
                tagID = [row objectForKey:@"category_id"];
                NSLog(@"tagID: %@",tagID);
                NSLog(@"self.tagID: %@",self.tagID);
                if([tagID isEqual:self.tagID])
                {
                    secondArray = [row objectForKey:@"cp"];
                    NSLog(@"SecondArray: %@",secondArray);
                    
                    for (id row2 in secondArray)
                    {
                        NSLog(@"CategoryIDIn SA: %@",[row2 objectForKey:@"category_id"]);
                        NSLog(@"cpID in SA: %@",[row2 objectForKey:@"cp_id"]);
                        
                        MData *settingsVar = [[MData alloc]init];
                        
                        settingsVar.defaultCategoryID = [row2 objectForKey:@"category_id"];
                        settingsVar.defaultCPID = [row2 objectForKey:@"cp_id"];
                        settingsVar.defaultCategoryName = [row2 objectForKey:@"cp_name"];
                        NSString *subscriptionStr = [NSString stringWithFormat:@"%@",[row2 objectForKey:@"subscription"]];
                        settingsVar.subscriptionStatus = subscriptionStr;
                        
                        [newData addObject:settingsVar];
                        [settingsVar release];
                    }
                }
                
            }
        }
    }
    
    return newData;
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
    
    NSLog(@"Subscription STATUS GET: %@",setData.subscriptionStatus);
    
    if ([setData.subscriptionStatus isEqual:@"2"])
    {
        NSLog(@"SubscriptionStatus isEqual to TWO should be passed...");
        CGRect setFrameCT = CGRectMake(0, 0, bulkCT.size.width-20, bulkCT.size.height-10);
        customTicker.frame = setFrameCT;
        [customTicker setBackgroundImage:bulkCT forState:UIControlStateNormal];
        cell.accessoryView = customTicker;
        [customTicker addTarget:self action:@selector(unsubscribeBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if ([setData.subscriptionStatus isEqual:@"1"])
    {
        NSLog(@"SubscriptionStatus isEqual to ONE should be passed...");
        CGRect setFrameCT = CGRectMake(0, 0, tickedCT.size.width-20, tickedCT.size.height-10);
        customTicker.frame = setFrameCT;
        [customTicker setBackgroundImage:tickedCT forState:UIControlStateNormal];
        cell.accessoryView = customTicker;
        [customTicker addTarget:self action:@selector(unsubscribeBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if([setData.subscriptionStatus isEqual:@"0"])
    {
        NSLog(@"SubscriptionStatus isEqual to ZERO should be passed...");
        CGRect setFrameCT = CGRectMake(0, 0, unTickedCT.size.width-20, unTickedCT.size.height-10);
        customTicker.frame = setFrameCT;
        [customTicker setBackgroundImage:unTickedCT forState:UIControlStateNormal];
        cell.accessoryView = customTicker;
        [customTicker addTarget:self action:@selector(subscribeBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [customTicker setTag:setData.defaultCPID];
    
    cell.textLabel.text = setData.defaultCategoryName;
    cell.textLabel.font = [UIFont fontWithName:@"Verdana" size:18];
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //cell.tag = setData.defaultCategoryID;
    
    NSLog(@"Showing hidden data TEST: %ld",(long)indexPath.row);
    
    NSLog(@"getbuttonid: %ld",(long)customTicker.tag);
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
