//
//  SidebarView.m
//  myjam
//
//  Created by nazri on 11/19/12.
//  Copyright (c) 2012 me-tech. All rights reserved.
//

#import "SidebarView.h"
#import "AppDelegate.h"
#import "CustomAlertView.h"
#import "ContactViewController.h"
#import "CalenderViewController.h"
#import "MapViewController.h"
#import "ShowSocialViewController.h"
#import "FAQViewController.h"
#import "FeedbackViewController.h"
#import "AboutViewController.h"
#import "SettingsViewController.h"

#define kTableCellHeightA 110
@interface SidebarView ()

@end

@implementation SidebarView
@synthesize cartItems;
-(id)init{
    self = [super init];
    if (!self) return nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shoppingCartChange:) name:@"cartChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"reloadImage"
                                               object:nil];
    
    
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self reloadCartList];
    [self retrieveImageFromAPI];
    
    [self setUserInfo];
    
    // To initiate Cart
    
}

- (void)reloadCartList
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"cartChanged"object:self];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 40)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(260/2-240/2, 0, 240, 40)];
    imageView.image = [UIImage imageNamed:@"shopping_cart"];
    [headerView addSubview:imageView];
    self.tableView.tableHeaderView = headerView;
    [imageView release];
    [headerView release];
    
    
    UISwipeGestureRecognizer *swipeRightRecognizer;
    swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight)];
    [swipeRightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self tableView] addGestureRecognizer:swipeRightRecognizer];
    [swipeRightRecognizer release];
    
    self.contactLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapContactRecoginzer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleContact)];
    [self.contactLabel addGestureRecognizer:tapContactRecoginzer];
    [tapContactRecoginzer release];
    
    self.calenderLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapCalendarRecoginzer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCalendar)];
    [self.calenderLabel addGestureRecognizer:tapCalendarRecoginzer];
    [tapCalendarRecoginzer release];
    
    self.mapsLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapMapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleMap)];
    [self.mapsLabel addGestureRecognizer:tapMapRecognizer];
    [tapMapRecognizer release];
    
    self.socialLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapSocialRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSocial)];
    [self.socialLabel addGestureRecognizer:tapSocialRecognizer];
    [tapSocialRecognizer release];
    
    self.faqLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapFAQRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleFAQ)];
    [self.faqLabel addGestureRecognizer:tapFAQRecognizer];
    [tapFAQRecognizer release];
    
    self.settingsLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapSettingsRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSettings)];
    [self.settingsLabel addGestureRecognizer:tapSettingsRecognizer];
    [tapSettingsRecognizer release];
    
    self.feedbackLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapFeedbackRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleFeedback)];
    [self.feedbackLabel addGestureRecognizer:tapFeedbackRecognizer];
    [tapFeedbackRecognizer release];
    
    self.aboutLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapAboutRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleAbout)];
    [self.aboutLabel addGestureRecognizer:tapAboutRecognizer];
    [tapAboutRecognizer release];
    
    self.logoutLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapLogoutRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleLogout)];
    [self.logoutLabel addGestureRecognizer:tapLogoutRecognizer];
    [tapLogoutRecognizer release];
}


- (void)retrieveImageFromAPI
{
    NSString *flag = @"DEFAULT";
    NSString *urlString = [NSString stringWithFormat:@"%@/api/settings_jambulite_profile.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
    NSString *dataContent = [NSString stringWithFormat:@"{\"flag\":\"%@\"}",flag];
    
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
    ////NSLog(@"request %@\n%@\n\nresponse retrieveData: %@", urlString, dataContent, response);
    NSDictionary *resultsDictionary = [[response objectFromJSONString] mutableCopy];
    ////NSLog(@"dict %@",resultsDictionary);
    
    if([resultsDictionary count])
    {
        NSString *status = [resultsDictionary objectForKey:@"status"];
        NSDictionary* resultProfile;
        
        
        if ([status isEqualToString:@"ok"])
        {
            NSUserDefaults *localData = [NSUserDefaults standardUserDefaults];
            resultProfile = [resultsDictionary objectForKey:@"profile"];
            
            NSString *fname = [resultProfile objectForKey:@"first_name"];
            NSString *lname = [resultProfile objectForKey:@"last_name"];
            NSString *email = [resultProfile objectForKey:@"email"];
            NSString *mobile = [resultProfile objectForKey:@"mobileno"];
            
            [localData setObject:fname forKey:@"first_name"];
            [localData setObject:lname forKey:@"last_name"];
            [localData setObject:email forKey:@"email"];
            [localData setObject:mobile forKey:@"mobile"];
            
            NSString *urlImg = [resultProfile objectForKey:@"avatar_url"];
            //NSLog(@"urlImg :%@",urlImg);
            [self.profileImage setImageWithURL:[NSURL URLWithString:urlImg]
                              placeholderImage:[UIImage imageNamed:@"blank_avatar.png"]];
        }
        
    }
    [resultsDictionary release];
}

#pragma mark -
#pragma mark notification Center

- (void) reloadImage
{
    // All instances of TestClass will be notified
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadImage"object:self];
}


- (void) receiveTestNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"reloadImage"]) {
        //NSLog (@"Successfully reload image!");
        [self retrieveImageFromAPI];
        [self setUserInfo]; //just add this code.
    }
}
- (void)setUserInfo
{
    NSString *fname = [[[NSUserDefaults standardUserDefaults] objectForKey:@"first_name"] copy];
    NSString *lname = @"";
    id objLname = [[[NSUserDefaults standardUserDefaults] objectForKey:@"last_name"] copy];
    
    if ( objLname != [NSNull null]) {
        lname = [[[NSUserDefaults standardUserDefaults] objectForKey:@"last_name"] copy];
    }
    //    NSString *lname = [[[NSUserDefaults standardUserDefaults] objectForKey:@"last_name"] copy];
    NSString *email = [[[NSUserDefaults standardUserDefaults] objectForKey:@"email"] copy];
    NSString *mobile = [[[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"] copy];
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",fname,lname];
    self.emailLabel.text = email;
    self.mobileLabel.text = mobile;
    
    //    [fullname release];
    [fname release];
    [lname release];
    [email release];
    [mobile release];
}

- (void)viewDidUnload
{
    [self setContactLabel:nil];
    [self setCalenderLabel:nil];
    [self setMapsLabel:nil];
    [self setSocialLabel:nil];
    [self setLogoutLabel:nil];
    [self setNameLabel:nil];
    [self setEmailLabel:nil];
    [self setTableView:nil];
    [super viewDidUnload];
    self.contentView = nil;
    
}

- (void)showViewControllerWithLoadingView:(UIViewController *)vc
{
    AppDelegate *myDel = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    [DejalBezelActivityView activityViewForView:myDel.window withLabel:@"Please wait..." width:100];
    
    [self performSelector:@selector(pushController:) withObject:vc afterDelay:0.2];
}

- (void)showLoadingView
{
    AppDelegate *myDel = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [DejalBezelActivityView activityViewForView:myDel.window withLabel:@"Please wait..." width:100];
}

- (void)removeDejalLoadingView
{
    [DejalBezelActivityView removeViewAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushController:(UIViewController *)controller
{
    AppDelegate *mydelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //    [DejalBezelActivityView activityViewForView:mydelegate.window withLabel:@"Please wait..." width:100];
//    [mydelegate handleTab5];
    
    [mydelegate.otherNavController popToRootViewControllerAnimated:NO];
    [mydelegate.otherNavController pushViewController:controller animated:NO];
    [mydelegate.tabView activateController:4];
    
    
    // Manually change the selected tabButton
    for (int i = 0; i < [mydelegate.tabView.tabItemsArray count]; i++) {
        if (i == 4) {
            [[mydelegate.tabView.tabItemsArray objectAtIndex:i] toggleOn:YES];
        } else {
            [[mydelegate.tabView.tabItemsArray objectAtIndex:i] toggleOn:NO];
        }
    }
    mydelegate.isMustCloseSidebar = YES;
    [mydelegate closeSidebar];
    
}

- (void)pushProfileViewController
{
    AppDelegate *mydelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [mydelegate.otherNavController popToRootViewControllerAnimated:NO];
    
    SettingsViewController *settings = [[SettingsViewController alloc] init];
    settings.updateProfile = YES;
    [mydelegate.otherNavController pushViewController:settings animated:NO];
    [mydelegate.tabView activateController:4];
    
    
    // Manually change the selected tabButton
    for (int i = 0; i < [mydelegate.tabView.tabItemsArray count]; i++) {
        if (i == 4) {
            [[mydelegate.tabView.tabItemsArray objectAtIndex:i] toggleOn:YES];
        } else {
            [[mydelegate.tabView.tabItemsArray objectAtIndex:i] toggleOn:NO];
        }
    }
    
    [mydelegate closeSidebar];
}

- (void)handleSwipeRight
{
    AppDelegate *mydelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [mydelegate handleTab5];
}

- (void)handleContact
{
    //NSLog(@"handleContact");
    
    ContactViewController *contact = [[ContactViewController alloc] init];
    //    [self pushController:contact];
    [self showViewControllerWithLoadingView:contact];
    [contact release];
}

- (void)handleCalendar
{
    //NSLog(@"handleCalendar");
    
    CalenderViewController *cal = [[CalenderViewController alloc] init];
    [self showViewControllerWithLoadingView:cal];
    [cal release];
}

- (void)handleMap
{
    //NSLog(@"handleMap");
    
    MapViewController *map = [[MapViewController alloc] init];
    [self showViewControllerWithLoadingView:map];
    [map release];
}


- (void)handleSocial
{
    //NSLog(@"handleSocial");
    
    ShowSocialViewController *soc = [[ShowSocialViewController alloc] init];
    [self showViewControllerWithLoadingView:soc];
    [soc release];
}

- (void)handleFAQ
{
    //NSLog(@"handleFAQ");
    
    FAQViewController *faq = [[FAQViewController alloc] init];
    [self showViewControllerWithLoadingView:faq];
    [faq release];
}

- (void)handleFeedback
{
    //NSLog(@"handleFeedback");
    
    FeedbackViewController *feedback = [[FeedbackViewController alloc] init];
    [self showViewControllerWithLoadingView:feedback];
    [feedback release];
}
- (void)handleSettings
{
    //NSLog(@"handleSettings");
    
    SettingsViewController *settings = [[SettingsViewController alloc] init];
    [self showViewControllerWithLoadingView:settings];
    //    [self pushController:settings];
    [settings release];
}

- (void)handleAbout
{
    AboutViewController *about = [[AboutViewController alloc] init];
    [self showViewControllerWithLoadingView:about];
    [about release];
}


- (void)handleLogout
{
    //NSLog(@"handleLogout");
    [self showLoadingView];
    // If OK, go to alertview delegate
    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Logout JAM-BU" message:@"Are you sure to logout?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
    alert.tag= 7;
    [alert show];
    [alert release];
    
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 7){
        [self removeDejalLoadingView];
        if (buttonIndex == 1) {
            AppDelegate *mydelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [mydelegate presentLoginPage];
            NSUserDefaults *localData = [NSUserDefaults standardUserDefaults];
            [localData setObject:@"" forKey:@"tokenString"];
            [localData setObject:@"" forKey:@"fullname"];
            [localData setObject:@"" forKey:@"first_name"];
            [localData setObject:@"" forKey:@"last_name"];
            [localData setObject:@"" forKey:@"email"];
            [localData setObject:@"" forKey:@"mobile"];
            [localData setObject:@"NO" forKey:@"islogin"];
//            [localData setObject:@"YES" forKey:@"isReloadNewsNeeded"];
            [localData synchronize];
            [mydelegate handleTab5];
            [mydelegate.tabView activateController:0];
            [mydelegate.tabView activateTabItem:0];
        }
    }
    else{
        if (buttonIndex == 0)
        {
            [self changeQuantity:@"0" from: alertView.tag];
        }
    }
    
}

- (void)dealloc {
    [_contactLabel release];
    [_calenderLabel release];
    [_mapsLabel release];
    [_socialLabel release];
    [_contentView release];
    [_logoutLabel release];
    [_nameLabel release];
    [_emailLabel release];
    [cartItems release];
    [_tableView release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    if ([cartItems count] > 0 ){
        return [cartItems count];
    }
    else{
        [self.tableView.tableHeaderView setHidden:YES];
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([[[cartItems objectAtIndex:section] valueForKey:@"item_list" ] count] >0 ){
        [self.tableView.tableHeaderView setHidden:NO];
        return ([[[cartItems objectAtIndex:section] valueForKey:@"item_list" ] count] + 2);
    }
    else{
        
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    //if last row
    
    if (indexPath.row == ([[[cartItems objectAtIndex:indexPath.section] valueForKey:@"item_list" ] count]+1 ))
    {
        
        SideBarFooterCell *cell = (SideBarFooterCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SideBarFooterCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
            //     cell.adminFeeLabel.text = [[[[cartItems objectAtIndex:indexPath.section] valueForKey:@"admin_fee" ] componentsSeparatedByString:@":"] objectAtIndex:1] ;
            cell.totalLabel.text = [[[[cartItems objectAtIndex:indexPath.section] valueForKey:@"total" ] componentsSeparatedByString:@":"] objectAtIndex:1];
            cell.shopNameLabel.text =[[cartItems objectAtIndex:indexPath.section] valueForKey:@"shop_name" ] ;
            [cell.checkOutButton setTag:indexPath.section];
            [cell.checkOutButton addTarget:self action:@selector(checkOutTapped:) forControlEvents:UIControlEventTouchUpInside];
        }
        //  [self createCellForIndex:indexPath cell:cell];
        
        return cell;
    }
    //if first row
    else if(indexPath.row == 0 )
        
    {
        SidebarTableHeaderView *cell = (SidebarTableHeaderView*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SidebarTableHeaderView" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
            cell.shopName.text = [[cartItems objectAtIndex:indexPath.section] valueForKey:@"shop_name" ] ;
            [cell.shopLogo setImageWithURL:[[cartItems objectAtIndex:indexPath.section] valueForKey:@"shop_logo" ]  placeholderImage:[UIImage imageNamed:@"default_icon.png"]];
        }
        
        return cell;
    }
    else{
        
        SideBarCartCell *cell = (SideBarCartCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SideBarCartCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
        }
        [self createCellForIndex:indexPath cell:cell];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == ([[[cartItems objectAtIndex:indexPath.section] valueForKey:@"item_list" ] count] + 1 )){
        return 108;
    }
    else if(indexPath.row == 0){
        return 64;
    }
    else{
        return kTableCellHeightA;
    }
    
}
- (void)createCellForIndex:(NSIndexPath *)indexPath cell:(SideBarCartCell *)cell
{
    //NSLog(@"%@", cartItems);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (![[[[[[cartItems objectAtIndex:indexPath.section] valueForKey:@"item_list" ] objectAtIndex:indexPath.row-1]  valueForKey:@"product_name"] class ]isEqual:[NSNull class]]){
        cell.productItem.text = [[[[cartItems objectAtIndex:indexPath.section] valueForKey:@"item_list" ] objectAtIndex:indexPath.row-1]  valueForKey:@"product_name"];
    }
    
    cell.priceLabel.text =  [[[[cartItems objectAtIndex:indexPath.section] valueForKey:@"item_list" ]  objectAtIndex:indexPath.row-1] valueForKey:@"total_price"];
    cell.qtyLabel.text =  [[[[cartItems objectAtIndex:indexPath.section] valueForKey:@"item_list" ] objectAtIndex:indexPath.row-1]valueForKey:@"quantity"];
    
    if ([[[[[cartItems objectAtIndex:indexPath.section] valueForKey:@"item_list" ]   objectAtIndex:indexPath.row-1] valueForKey:@"color_code"] isEqual:@""]){
        cell.colorView.hidden = true;
    }
    else{
        [cell.colorView setBackgroundColor:[UIColor colorWithHex:[[[[cartItems objectAtIndex:indexPath.section] valueForKey:@"item_list"] objectAtIndex:indexPath.row-1] valueForKey:@"color_code"]]];
    }
    if ([[[[[cartItems objectAtIndex:indexPath.section] valueForKey:@"item_list"] objectAtIndex:indexPath.row-1] valueForKey:@"size_name"] isEqual:@""]){
        cell.sizeImageView.hidden=TRUE;
        cell.sizeLabel.hidden = YES;
        CGRect sFrame = cell.sizeLabel.frame;
        
//        cell.addButton.frame = CGRectMake(cell.addButton.frame.origin.x,
//                                          cell.quantityLabel.frame.origin.y,
//                                          cell.addButton.frame.size.width,
//                                          cell.addButton.frame.size.height);
//        cell.minusButton.frame = CGRectMake(cell.minusButton.frame.origin.x,
//                                            cell.quantityLabel.frame.origin.y,
//                                            cell.minusButton.frame.size.width,
//                                            cell.minusButton.frame.size.height);
//        cell.priceLabel.frame = CGRectMake(cell.priceLabel.frame.origin.x,
//                                           cell.quantityLabel.frame.origin.y,
//                                           cell.priceLabel.frame.size.width,
//                                           cell.priceLabel.frame.size.height);
        
        
        cell.quantityLabel.frame = CGRectMake(sFrame.origin.x,
                                              sFrame.origin.y,
                                              cell.quantityLabel.frame.size.width,
                                              cell.quantityLabel.frame.size.height);
        cell.qtyLabel.frame = CGRectMake(cell.qtyLabel.frame.origin.x,
                                         sFrame.origin.y,
                                         cell.qtyLabel.frame.size.width,
                                         cell.qtyLabel.frame.size.height);
    }else{
        cell.sizeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_button.png",[[[[cartItems objectAtIndex:indexPath.section] valueForKey:@"item_list"] objectAtIndex:indexPath.row-1] valueForKey:@"size_name" ]]];
    }
    
    if (![[[[[cartItems objectAtIndex:indexPath.section] valueForKey:@"item_list"] objectAtIndex:indexPath.row-1] valueForKey:@"product_image"]isKindOfClass: [NSNull class]])
    {
        [cell.productImage setImageWithURL:[NSURL URLWithString:[[[[cartItems objectAtIndex:indexPath.section] valueForKey:@"item_list"] objectAtIndex:indexPath.row-1] valueForKey:@"product_image"] ] placeholderImage:[UIImage imageNamed:@"default_icon.png"]] ;
    }
    else{
        cell.productImage.image = [UIImage imageNamed:@"default_icon.png"];
    }
    cell.minusButton.tag = indexPath.section*1000 + indexPath.row*100 +1;
    cell.addButton.tag = indexPath.section*1000 + indexPath.row*100 ;
    [cell.addButton addTarget:self action:@selector(changeQty:) forControlEvents:UIControlEventTouchUpInside];
    [cell.minusButton addTarget:self action:@selector(changeQty:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)changeQty:(id)sender{
    NSString *newQty ;
    //For add item
    //NSLog(@"%d", [sender tag]);
    if (([sender tag] % 2) == 0){
        //NSLog(@"%d",(([sender tag]/100)-1));
        //NSLog(@"%@",cartItems);
        newQty = [NSString stringWithFormat:@"%d",([[[[[cartItems objectAtIndex:([sender tag]/1000)] valueForKey:@"item_list"]  objectAtIndex:((([sender tag]%1000)/100)-1)]  valueForKey:@"quantity" ] intValue] +1)  ];
        
    }
    //For minus item
    else{
        newQty = [NSString stringWithFormat:@"%d",([[[[[cartItems objectAtIndex:([sender tag]/1000)] valueForKey:@"item_list"]  objectAtIndex:((([sender tag]%1000)/100)-1)]   valueForKey:@"quantity" ] intValue] -1)  ];;
        
    }
    if ([newQty isEqualToString:@"-1"])
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Unsuccessful"
                              message: @"Insufficient stock"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return ;
    }else if([newQty isEqualToString:@"0"]){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Are you sure?"
                              message: @"Are you sure to remove the item?"
                              delegate: self
                              cancelButtonTitle:@"Yes"
                              otherButtonTitles:@"No",nil];
        alert.tag = [sender tag];
        [alert show];
        [alert release];
        
    }
    
    else{
        [self changeQuantity:newQty from:[sender tag]];
    }
    
    //TODO if cart empty
    
    
    //  [self updatePage];
    
}

-(void)changeQuantity:(NSString*)qty from:(NSInteger*)tag
{
    self.cartItems = [[NSMutableArray alloc] initWithArray:[[MJModel sharedInstance] updateProduct:[[[[cartItems objectAtIndex:((int)tag/1000)] valueForKey:@"item_list"]  objectAtIndex:((((int)tag%1000)/100)-1)] valueForKey:@"cart_item_id"] forCart:[[cartItems objectAtIndex:((int)tag/1000)]valueForKey:@"cart_id"]  forQuantity:qty]];
    
    [self.tableView reloadData];
    [self updateTabBar];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"cartChangedFromView" object:self];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadCartViewNotif" object:self];
}

- (void)updateTabBar {
    int counter = 0;
    AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    for (id row in cartItems ){
        for (id items in [row valueForKey:@"item_list"]){
            
            counter = counter + [[items valueForKey:@"quantity"] intValue];
            
        }
    }
    //  [mydelegate tabView]
    if (counter == 0){
        [mydelegate removeCustomBadge];
    }
    else{
        [mydelegate setCustomBadgeWithText:[NSString stringWithFormat:@"%d",counter]];
    }
}

-(void)shoppingCartChange:(NSNotification *)notification{
    self.cartItems = [[MJModel sharedInstance] getCartList];
    
    [self updateTabBar];
    
    [self.tableView reloadData];
    
    
    // [[[[[self tabBarController] tabBar] items] objectAtIndex:4] setBadgeValue:@"1"];
}
-(void)checkOutTapped:(id)sender{
    AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [DejalBezelActivityView activityViewForView:mydelegate.window withLabel:@"Loading ..." width:100];
    [self performSelector:@selector(processCheckOut:) withObject:sender afterDelay:0.1];
}

- (void)processCheckOut:(id)sender
{
    CheckoutViewController *detailViewController = [[CheckoutViewController alloc] initWithNibName:@"CheckoutViewController" bundle:nil];
    detailViewController.cartList = [[NSMutableArray alloc] initWithArray:[[MJModel sharedInstance] getCartListForRow:[NSNumber numberWithInteger:[sender tag]]] ];
    detailViewController.footerView = [[[NSBundle mainBundle] loadNibNamed:@"checkOutFooterView" owner:self options:nil]objectAtIndex:0];
    detailViewController.footerType = @"0";
    
    
    AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    mydelegate.isCheckoutFromSideBar = YES;
    [mydelegate.shopNavController pushViewController:detailViewController animated:NO];
    
    
    [mydelegate.tabView activateController:1];
    
    
    // Manually change the selected tabButton
    for (int i = 0; i < [mydelegate.tabView.tabItemsArray count]; i++) {
        if (i == 1) {
            [[mydelegate.tabView.tabItemsArray objectAtIndex:i] toggleOn:YES];
        } else {
            [[mydelegate.tabView.tabItemsArray objectAtIndex:i] toggleOn:NO];
        }
    }
    
    [mydelegate handleTab5];
    [detailViewController release];
    
    [DejalBezelActivityView removeViewAnimated:YES];
}
@end
