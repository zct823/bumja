//
//  FavFolderViewController.m
//  myjam
//
//  Created by Mohd Zulhilmi on 25/02/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "FavFolderViewController.h"

@interface FavFolderViewController ()

@end

@implementation FavFolderViewController

@synthesize tableData = _tableData, tableView = _tableView, favHead = _favHead, purrFav = _purrFav;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // setup title
        self.title = @"Select Fav Folder";
        FontLabel *titleView = [[FontLabel alloc] initWithFrame:CGRectZero fontName:@"jambu-font.otf" pointSize:22];
        titleView.text = self.title;
        titleView.textAlignment = NSTextAlignmentCenter;
        titleView.backgroundColor = [UIColor clearColor];
        titleView.textColor = [UIColor whiteColor];
        [titleView sizeToFit];
        self.navigationItem.titleView = titleView;
        [titleView release];
        
        self.navigationItem.leftBarButtonItem =
        [[[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                          style:UIBarButtonSystemItemCancel
                                         target:self
                                         action:@selector(disappearModal)] autorelease];
        
        ////NSLog(@"QRCODE ID PASSED WITH VALUE: %@",qrCodeId);
        
        //self.qrcodeId = qrCodeId;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.frame = CGRectMake(0,0,260,350);
    self.tableView.frame = CGRectMake(0,0,260,280);
    
    FontLabel *instructLabel = [[FontLabel alloc] initWithFrame:CGRectMake(6, 244, 260, 50) fontName:@"jambu-font.otf" pointSize:13];
    
    instructLabel.text = @"Swipe list up or down to see more folders.";
    instructLabel.textAlignment = NSTextAlignmentCenter;
    instructLabel.textColor = [UIColor whiteColor];
    instructLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:instructLabel];
    
    instructLabel = [[FontLabel alloc] initWithFrame:CGRectMake(30, 258, 260, 50) fontName:@"jambu-font.otf" pointSize:13];
    instructLabel.text = @"Tap outside box will close this box.";
    instructLabel.textAlignment = NSTextAlignmentCenter;
    instructLabel.textColor = [UIColor whiteColor];
    instructLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:instructLabel];
    
    instructLabel = [[FontLabel alloc] initWithFrame:CGRectMake(30, 0, 260, 50) fontName:@"jambu-font.otf" pointSize:22];
    instructLabel.text = @"Select your Fav Box";
    instructLabel.textAlignment = NSTextAlignmentCenter;
    instructLabel.textColor = [UIColor whiteColor];
    instructLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:instructLabel];
    
    [instructLabel release];
    [self loadDataToTable];
    
}

# pragma mark -
# pragma mark Dialog Box trigger (CustomAlertView)

- (void)setMessageForSuccess
{
    NSString *setMessage = [NSString stringWithFormat:@"The feed has been favourited into selected folder."];
    
    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Favourite" message:setMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)setMessageForNoSelectError
{
    NSString *setMessage = [NSString stringWithFormat:@"Please select folder first."];
    
    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Favourite" message:setMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)setMessageForConnError
{
    NSString *setMessage = [NSString stringWithFormat:@"Connection error. Please try again."];
    
    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Favourite" message:setMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

# pragma mark - Load Data Table and Save to Server trigger

-(void)loadDataToTable
{
    NSArray *list = nil;
    
    list = [self generateDataFromServer:nil andCurrentFav:nil];
    
    [self.tableData addObjectsFromArray:list];
    self.tableData = [list mutableCopy];
    [self.tableView clearsContextBeforeDrawing];
    [self.tableView reloadData];
    
}

-(void)saveDataToServer:(id)cellTag withCurrentFav:(NSString *)currentFav
{
    [self performSelector:@selector(generateDataFromServer:andCurrentFav:) withObject:cellTag withObject:currentFav];
}

# pragma mark - Continue button goes here

- (IBAction)continueBtn:(id)sender
{
    if(self.oldIndexPath == nil)
    {
        //NSLog(@"Continue button will trigger no select alert");
        [self performSelector:@selector(setMessageForNoSelectError) withObject:self afterDelay:0.0f];
    }
    else
    {
        [self saveDataToServer:currentCellTag withCurrentFav:self.purrFav];
        //NSLog(@"Continue button will trigger NSNotificationCenter");
        [self performSelector:@selector(setMessageForSuccess) withObject:self afterDelay:0.0f];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notifyClose" object:self];
    }
}

# pragma mark - Load the data from server processor

- (NSString *)urlAPIString
{
    //NSLog(@"Token String: %@",[[[NSUserDefaults standardUserDefaults]objectForKey:@"tokenString"]mutableCopy]);
    
    return [NSString stringWithFormat:@"%@/api/fav_folder.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
}

-(NSMutableArray *)generateDataFromServer:(id)cellTag andCurrentFav:(NSString *)currentFav
{
    NSString *urlString = [self urlAPIString];
    NSString *dataContentForDefaults = nil;
    
    if (cellTag == nil)
    {
        dataContentForDefaults = [NSString stringWithFormat:@"{\"flag\":\"FAVOURITE_LIST\",\"qrcode_id\":\"%@\"}",self.qrcodeId];
    }
    else if(cellTag != nil && currentFav == nil)
    {
        dataContentForDefaults = [NSString stringWithFormat:@"{\"flag\":\"ADD\",\"qrcode_id\":\"%@\",\"fav_folder_id\":\"%@\"}",self.qrcodeId,cellTag];
    }
    else if(cellTag != nil && currentFav != nil)
    {
        dataContentForDefaults = [NSString stringWithFormat:@"{\"flag\":\"REPLACE\",\"qrcode_id\":\"%@\",\"fav_folder_id\":\"%@\"}",self.qrcodeId,cellTag];
    }
    
    //NSLog(@"Data Content: %@",dataContentForDefaults);
    
    //=== WRAPPING DATA IN NSSTRING ===//
    NSString *wrappedDefaultDataFromServer = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContentForDefaults];
    
    //NSLog(@"Check response for DEFAULT2 param: %@",wrappedDefaultDataFromServer);
    
    NSMutableArray *newData = [[NSMutableArray alloc] init];
    NSDictionary* wrappedDefaultDataToDictionary = [[wrappedDefaultDataFromServer objectFromJSONString] copy];
    
    NSString *currentStatus = nil;
    //NSString *currentFav = nil;
    NSDictionary* resultArray;
    
    if([wrappedDefaultDataToDictionary count])
    {
        
        currentStatus = [wrappedDefaultDataToDictionary objectForKey:@"status"];
        currentFav = [wrappedDefaultDataToDictionary objectForKey:@"current_fav"];
        
        if (currentFav != nil)
        {
            self.purrFav = [NSString stringWithFormat:@"%@",currentFav];
            self.favHead = [NSString stringWithFormat:@"Current Folder: %@",self.purrFav];
        }
        else if (currentFav == nil)
        {
            self.favHead = [NSString stringWithFormat:@"Add to your Favourite Folder."];
        }
        
        if ([currentStatus isEqual: @"ok"])
        {
            if (cellTag == nil)
            {
                if ([wrappedDefaultDataToDictionary objectForKey:@"list"] != [NSNull null])
                {
                    resultArray = [wrappedDefaultDataToDictionary objectForKey:@"list"];

            
                    for (id row in resultArray)
                    {
                        MData *favVar = [[MData alloc]init];
                
                        favVar.favFolderID = [row objectForKey:@"fav_folder_id"];
                        favVar.favFolderName = [row objectForKey:@"fav_folder_name"];
                
                        [newData addObject:favVar];
                        [favVar release];
                    }
                }
                else
                {
                    //NSLog(@"List is null/not available");
                    [self tableViewHide];
                }
            }
            else if(cellTag != nil)
            {
                //This is space for action after fav folder is selected.
                
                //[self performSelector:@selector(setMessageForSuccess)];
            }
        }
        else
        {
            [self setMessageForConnError];
        }

    }
    
    return newData;
}



# pragma mark - Error Handler
- (void)tableViewHide
{
    CGRect frame = CGRectMake(0, -70, self.view.bounds.size.width, self.view.bounds.size.height);
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    
    label.text = @"You haven't create Favourite Folder yet.";
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    label.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:label];
    [self.tableView setHidden:YES];
}


# pragma mark -
# pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Add to your favourite";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,50)];
    tempView.backgroundColor=[UIColor whiteColor];
    
    UILabel *tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,-3,self.view.frame.size.width,25)];
    tempLabel.backgroundColor = [UIColor colorWithHex:@"#17aa9d"];
    tempLabel.shadowOffset = CGSizeMake(0,2);
    tempLabel.textColor = [UIColor whiteColor];
    tempLabel.font = [UIFont fontWithName:@"Verdana" size:13];
    //tempLabel.font = [UIFont boldSystemFontOfSize:15];
    tempLabel.text = [NSString stringWithFormat:@"   %@",self.favHead];
    
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
    
    MData *favData = [self.tableData objectAtIndex:indexPath.row];
    
    //CGRect radioFrame = CGRectMake(0, 0, 24, 24);
    
    //UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //UIButton *uncheckBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //UIImage *radioCheck = [UIImage imageNamed:@"radio_check.png"];
    //UIImage *radioUncheck = [UIImage imageNamed:@"radio_uncheck.png"];
    
    //checkBtn.frame = radioFrame;
    //uncheckBtn.frame = radioFrame;
    
    //[checkBtn setBackgroundImage:radioUncheck forState:UIControlStateNormal];
    //[checkBtn setBackgroundImage:radioCheck forState:UIControlStateSelected];
    
    tableView.backgroundColor = [UIColor darkGrayColor];
    
    tableView.separatorColor = [UIColor clearColor];
    cell.tag = favData.favFolderID;
    cell.textLabel.text = favData.favFolderName;
    cell.textLabel.font = [UIFont fontWithName:@"Verdana" size:14];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if(self.oldIndexPath == nil)
    {
        self.oldIndexPath = indexPath;
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else
    {
        UITableViewCell *oldIndexCell = [tableView cellForRowAtIndexPath:self.oldIndexPath];
        [oldIndexCell setAccessoryType:UITableViewCellAccessoryNone];
        
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        
        self.oldIndexPath=indexPath;
        
    }
    
    currentCellTag = (id)cell.tag;

    //NSLog(@"Cell Tag: %@ & Current Fav: %@",(id)cell.tag,self.purrFav);
    
//    [self saveDataToServer:(id)cell.tag withCurrentFav:self.purrFav];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    [super dealloc];
    [_tableData release];
    [_tableView release];
    [_favHead release];
    [_purrFav release];
}


@end
