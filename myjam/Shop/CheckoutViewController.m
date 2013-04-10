//
//  CheckoutViewController.m
//  myjam
//
//  Created by Azad Johari on 2/2/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "CheckoutViewController.h"
#define kTableCellHeightB 150
@interface CheckoutViewController ()

@end

@implementation CheckoutViewController
@synthesize tableView, footerView, paymentStatus;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Checkout";
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
        
        // Custom initialization
    }
    return self;
}
- (void)updatePage
{
    // All instances of TestClass will be notified
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"cartChanged"
     object:self];
    if ([_cartList count] >0){
        footerView.totalPrice.text =[[[[_cartList objectAtIndex:0]valueForKey:@"total"] componentsSeparatedByString:@":"] objectAtIndex:1];
        // footerView.adminFeeLabel.text = [[[[_cartList objectAtIndex:0] valueForKey:@"admin_fee"]componentsSeparatedByString:@":"] objectAtIndex:1];
        if ([self.footerType isEqual:@"1"]){
            footerView.shopNameLabel.text = [[_cartList objectAtIndex:0] valueForKey:@"shop_name"];
            footerView.deliveryLabel.text = [[_cartList objectAtIndex:0] valueForKey:@"delivery_fee"];
            footerView.gTotalLabel.text
            = [[[[_cartList objectAtIndex:0] valueForKey:@"grand_total"] componentsSeparatedByString:@":"] objectAtIndex:1];
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Cart is empty. Please add an item." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        [alert release];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //NSLog(@"vdl checkout");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shoppingCartChange:) name:@"cartChangedFromView" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PurchaseVerification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(PurchaseVerification:)
                                                 name:@"PurchaseVerification"
                                               object:nil];

    
    self.shopName.text = [[_cartList objectAtIndex:0] valueForKey:@"shop_name"];
    if ([self.footerType isEqual:@"1"]){
        [footerView.checkOutButton addTarget:self action:@selector(checkOutPressed:) forControlEvents:UIControlEventTouchUpInside];
        footerView.jambuFeePrice.text = [[_cartList objectAtIndex:0] valueForKey:@"admin_fee"];
    }
    self.tableView.tableFooterView=footerView;
    [self.shopLogo setImageWithURL:[NSURL URLWithString:[[_cartList objectAtIndex:0] valueForKey:@"shop_logo"]]
                  placeholderImage:[UIImage imageNamed:@"default_icon.png"]];
    [self updatePage];
    [footerView.deliveryButton addTarget:self action:@selector(deliveryOptions:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return [_cartList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[_cartList objectAtIndex:section] valueForKey:@"item_list"] count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    CartItemViewCell *cell = (CartItemViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CartItemViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    [self createCellForIndex:indexPath cell:cell];
    
    return cell;
}
- (void)createCellForIndex:(NSIndexPath *)indexPath cell:(CartItemViewCell *)cell
{
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.productName.text = [[[[_cartList objectAtIndex:indexPath.section] valueForKey:@"item_list"] objectAtIndex:indexPath.row] valueForKey:@"product_name"];
    cell.priceLabel.text = [[[[_cartList objectAtIndex:indexPath.section] valueForKey:@"item_list"] objectAtIndex:indexPath.row] valueForKey:@"total_price"];
    cell.qtyLabel.text = [[[[_cartList objectAtIndex:indexPath.section] valueForKey:@"item_list"] objectAtIndex:indexPath.row] valueForKey:@"quantity"];
    if ([[[[[_cartList objectAtIndex:indexPath.section] valueForKey:@"item_list"] objectAtIndex:indexPath.row] valueForKey:@"color_code"] isEqual:@""]){
        cell.colorView.hidden = true;
    }
    else{
        [cell.colorView setBackgroundColor:[UIColor colorWithHex:[[[[_cartList objectAtIndex:indexPath.section] valueForKey:@"item_list"] objectAtIndex:indexPath.row] valueForKey:@"color_code"]]];
        [cell.colorView.layer setBorderColor:[[UIColor grayColor]CGColor]];
        [cell.colorView.layer setBorderWidth:1.0];
    }
    if ([[[[[_cartList objectAtIndex:indexPath.section] valueForKey:@"item_list"] objectAtIndex:indexPath.row] valueForKey:@"size_name"] isEqual:@""]){
        cell.sizeLabel.hidden=TRUE;
        [cell.aSizeLabel setHidden:YES];
    }else{
        cell.sizeLabel.text = [[[[_cartList objectAtIndex:indexPath.section] valueForKey:@"item_list"] objectAtIndex:indexPath.row] valueForKey:@"size_name" ];
        
    }
    
    if (![[[[[_cartList objectAtIndex:indexPath.section] valueForKey:@"item_list"] objectAtIndex:indexPath.row] valueForKey:@"product_image"]isKindOfClass: [NSNull class]])
    {[cell.productImage setImageWithURL:[NSURL URLWithString:[[[[_cartList objectAtIndex:indexPath.section] valueForKey:@"item_list"] objectAtIndex:indexPath.row] valueForKey:@"product_image"] ] placeholderImage:[UIImage imageNamed:@"default_icon.png"]] ;
    }
    else{
        cell.productImage.image = [UIImage imageNamed:@"default_icon.png"];
    }
    cell.buttonMinus.tag = 2*indexPath.row+ 1;
    cell.buttonPlus.tag = 2*indexPath.row;
    [cell.buttonPlus addTarget:self action:@selector(changeQty:) forControlEvents:UIControlEventTouchUpInside];
    [cell.buttonMinus addTarget:self action:@selector(changeQty:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableCellHeightB;
}

#pragma mark - Table view delegate

-(void)changeQty:(id)sender{
    NSString *newQty ;
    if (([sender tag] % 2) == 0){
        newQty = [NSString stringWithFormat:@"%d",([[[[[_cartList objectAtIndex:0] valueForKey:@"item_list"] objectAtIndex:([sender tag]/2)]  valueForKey:@"quantity" ]intValue] + 1) ];
        
    }
    else{
        if (![[[[[_cartList objectAtIndex:0] valueForKey:@"item_list"] objectAtIndex:([sender tag] / 2)] valueForKey:@"product_name"] isEqual:@"0"]){
            
            newQty = [NSString stringWithFormat:@"%d",([[[[[_cartList objectAtIndex:0] valueForKey:@"item_list"] objectAtIndex:([sender tag]/2)]  valueForKey:@"quantity" ]intValue] - 1) ];
            
        } else{
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Unsuccessful"
                                  message: @"Insufficient stock"
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            return ;
        }
    }
    //TODO if cart empty
    if ([newQty isEqualToString:@"0"]){
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
        [self changeQuantity:newQty fromId:[sender tag]];
    }
    
    
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{ if (buttonIndex == 0)
{
    
    [self changeQuantity:@"0" fromId: alertView.tag];
}}

-(void)changeQuantity:(NSString*)qty fromId:(NSInteger)tag{
    NSMutableArray *arrayTemp;
    arrayTemp = [[NSMutableArray alloc] initWithArray:[[MJModel sharedInstance] updateProduct:[[[[_cartList objectAtIndex:0] valueForKey:@"item_list"] objectAtIndex:(tag/2)] valueForKey:@"cart_item_id"] forCart:[[_cartList objectAtIndex:0] valueForKey:@"cart_id"]  forQuantity:qty]];
    if ([qty isEqualToString:@"0"]){
        AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [mydelegate.shopNavController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"cartChanged"
         object:self];
    }else{
        for (id row in arrayTemp){
            if ([[row valueForKey:@"cart_id"] isEqualToString:[[self.cartList objectAtIndex:0] valueForKey:@"cart_id"]]){
                self.cartList = [[NSMutableArray alloc] initWithObjects:row, nil];
            }
        }
        
        //NSLog(@"%@", _cartList);
        [self.tableView reloadData];
        [self updatePage];
    }
}
-(void)deliveryOptions:(id)sender{
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading ..." width:100];
    [self performSelector:@selector(processToDeliveryAddressPage) withObject:nil afterDelay:0.1];
}

- (void)processToDeliveryAddressPage
{
    AddressEditViewController *detailViewController = [[AddressEditViewController alloc] initWithNibName:@"AddressEditViewController" bundle:nil];
    detailViewController.addressInfo = [[MJModel sharedInstance] getDeliveryDetailforCart:[[_cartList objectAtIndex:0] valueForKey:@"cart_id"]];
    detailViewController.cartId = [[_cartList objectAtIndex:0] valueForKey:@"cart_id"];
    AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [mydelegate.shopNavController pushViewController:detailViewController animated:YES];
    [DejalBezelActivityView removeViewAnimated:YES];
    [detailViewController release];
}

- (void)dealloc {
    [tableView release];
    [_shopLogo release];
    [_shopName release];
    [paymentStatus release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setShopLogo:nil];
    [self setShopName:nil];
    
    [self setShopLogo:nil];
    [super viewDidUnload];
}
-(void)shoppingCartChange:(NSNotification *)notification{
    
    self.cartList = [[MJModel sharedInstance] getCartListForCartId:[[_cartList objectAtIndex:0] valueForKey:@"cart_id"]];
    //[NSString stringWithFormat:@"%d",[[[cartItems objectAtIndex:0] valueForKey:@"item_list" ] count] ]
    [self.tableView reloadData];
    [self updatePage];
    // [[[[[self tabBarController] tabBar] items] objectAtIndex:4] setBadgeValue:@"1"];
}
-(void)checkOutPressed:(id)sender{
    NSDictionary *respond = [[MJModel sharedInstance]getCheckoutUrlForId:[[_cartList objectAtIndex:0]valueForKey:@"cart_id"]];
    if ([[respond valueForKey:@"status" ] isEqual:@"ok"]){
        self.paymentStatus = @"processing";
        if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:[respond valueForKey:@"url"] ]]){
            
        }
    }
    
}

-(void)PurchaseVerification:(NSNotification *) notification{
    
    
    AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (mydelegate.isReturnFromPayment == NO) {
        return;
    }
    
    mydelegate.isReturnFromPayment = NO;
    NSDictionary *purchaseStatus = [[MJModel sharedInstance] getPurchaseStatus:[[_cartList objectAtIndex:0] valueForKey:@"cart_id"]];
    //NSLog(@"PurchaseVerification get called!");
    if ([[purchaseStatus valueForKey:@"status"] isEqualToString:@"Paid"]){
        ShopViewController *sv1 =[[mydelegate.shopNavController viewControllers] objectAtIndex:0];
        [[NSNotificationCenter defaultCenter ] postNotificationName:@"cartChanged" object:self];
        [[NSNotificationCenter defaultCenter ] postNotificationName:@"refreshPurchaseHistory" object:self];
        mydelegate.isShowPurchaseHistory = YES;
        //        [sv1 switchViewController:sv1.vc3];
        [mydelegate.shopNavController popToRootViewControllerAnimated:YES];
        [sv1.tabBar showViewControllerAtIndex:1];
        
//        [mydelegate.shopNavController popToRootViewControllerAnimated:YES];
    }
    else{
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"Failure" message:@"Purchase failed. Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
        [alertView release];
    }
    
    
}
@end
