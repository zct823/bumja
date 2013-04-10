//
//  DeliveryOptionViewController.m
//  myjam
//
//  Created by Azad Johari on 2/3/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "DeliveryOptionViewController.h"

@interface DeliveryOptionViewController ()

@end

@implementation DeliveryOptionViewController


@synthesize addressInfo;
@synthesize cartId;
@synthesize selectedRow;

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
        // Custom initialization
        
        self.navigationItem.backBarButtonItem =
        [[[UIBarButtonItem alloc] initWithTitle:@"Back"
                                          style:UIBarButtonItemStyleBordered
                                         target:nil
                                         action:nil] autorelease];
    }
    return self;
}

- (void)viewDidLoad
{
    
    self.scrollView.contentSize = self.scrollView.frame.size;
    self.scrollView.frame = self.view.frame;
    [self.view addSubview:self.scrollView];
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        // code for 4-inch screen
        [self.view setBounds:CGRectMake(0, 90, self.view.bounds.size.width, self.view.bounds.size.height)];
    }

    addressInfo = [[NSMutableDictionary alloc] initWithDictionary:[[MJModel sharedInstance] getSavedAddressFor:cartId]];

        self.addressView1.hidden = YES;
        self.addressView3.hidden = YES;
        self.adressView2.hidden= YES;

     if([[addressInfo valueForKey:@"delivery_address_list"] count] == 1 ||[[addressInfo valueForKey:@"delivery_address_list"] count] == 2 || [[addressInfo valueForKey:@"delivery_address_list"] count] == 3){
            self.address1.text = [[[addressInfo valueForKey:@"delivery_address_list"] objectAtIndex:0] valueForKey:@"delivery_address"];
            self.adressCity.text = [[[addressInfo valueForKey:@"delivery_address_list"] objectAtIndex:0] valueForKey:@"delivery_city"];
            self.addressState.text = [[[[[[addressInfo valueForKey:@"delivery_address_list"] objectAtIndex:0] valueForKey:@"delivery_address_full"] componentsSeparatedByString:@"<br/>"] objectAtIndex:3] stringByStrippingHTML];
            self.addressCountry.text = [[[[[[addressInfo valueForKey:@"delivery_address_list"] objectAtIndex:0] valueForKey:@"delivery_address_full"] componentsSeparatedByString:@"<br/>"] objectAtIndex:4] stringByStrippingHTML];
         self.addressView1.hidden = NO;
         if ([[[[addressInfo valueForKey:@"delivery_address_list"] objectAtIndex:0] valueForKey:@"is_primary"] isEqualToString:@"Y"]){
             self.addressView1.backgroundColor = [UIColor colorWithRed:161.0/255.0 green:183.0/255.0 blue:58.0/255 alpha:1.0];
             self.checkBox1.image = [UIImage imageNamed:@"checkbox_active.png"];
         }
         
            
        }
     if ([[addressInfo valueForKey:@"delivery_address_list"] count] == 2 || [[addressInfo valueForKey:@"delivery_address_list"] count] == 3){
        self.address2.text = [[[addressInfo valueForKey:@"delivery_address_list"] objectAtIndex:1] valueForKey:@"delivery_address"];
        self.addressCity2.text = [[[addressInfo valueForKey:@"delivery_address_list"] objectAtIndex:1] valueForKey:@"delivery_city"];
        self.addressState2.text = [[[[[[addressInfo valueForKey:@"delivery_address_list"] objectAtIndex:1] valueForKey:@"delivery_address_full"] componentsSeparatedByString:@"<br/>"] objectAtIndex:3] stringByStrippingHTML];
        self.addressCountry2.text = [[[[[[addressInfo valueForKey:@"delivery_address_list"] objectAtIndex:1] valueForKey:@"delivery_address_full"] componentsSeparatedByString:@"<br/>"] objectAtIndex:4] stringByStrippingHTML];
        self.adressView2.hidden = NO;
         if ([[[[addressInfo valueForKey:@"delivery_address_list"] objectAtIndex:1] valueForKey:@"is_primary"] isEqualToString:@"Y"]){
             self.adressView2.backgroundColor = [UIColor colorWithRed:161.0/255.0 green:183.0/255.0 blue:58.0/255 alpha:1.0];
             self.checkBox2.image = [UIImage imageNamed:@"checkbox_active.png"];
         }
    }
     if( [[addressInfo valueForKey:@"delivery_address_list"] count] == 3){
        self.address3.text = [[[addressInfo valueForKey:@"delivery_address_list"] objectAtIndex:2] valueForKey:@"delivery_address"];
        self.addressCity3.text = [[[addressInfo valueForKey:@"delivery_address_list"] objectAtIndex:2] valueForKey:@"delivery_city"];
        self.addressState3.text = [[[[[[addressInfo valueForKey:@"delivery_address_list"] objectAtIndex:2] valueForKey:@"delivery_address_full"] componentsSeparatedByString:@"<br/>"] objectAtIndex:3] stringByStrippingHTML];
        self.addressCountry3.text = [[[[[[addressInfo valueForKey:@"delivery_address_list"] objectAtIndex:2] valueForKey:@"delivery_address_full"] componentsSeparatedByString:@"<br/>"] objectAtIndex:4] stringByStrippingHTML];
        self.addressView3.hidden = NO;
         if ([[[[addressInfo valueForKey:@"delivery_address_list"] objectAtIndex:2] valueForKey:@"is_primary"] isEqualToString:@"Y"]){
              self.addressView3.backgroundColor = [UIColor colorWithRed:161.0/255.0 green:183.0/255.0 blue:58.0/255 alpha:1.0];
             self.checkBox3.image = [UIImage imageNamed:@"checkbox_active.png"];
         }
    
    }
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)choiceTapped:(id)sender {

        if ([sender tag] == 1){
            self.addressView1.backgroundColor = [UIColor colorWithRed:161.0/255.0 green:183.0/255.0 blue:58.0/255 alpha:1.0];
                self.adressView2.backgroundColor = [UIColor colorWithRed:211.0/255.0 green:54.0/255.0 blue:88.0/255 alpha:1.0];
                    self.addressView3.backgroundColor = [UIColor colorWithRed:211.0/255.0 green:54.0/255.0 blue:88.0/255 alpha:1.0];
            self.selectedRow = [NSNumber numberWithInt:0];
            self.checkBox1.image = [UIImage imageNamed:@"checkbox_active.png"];
            self.checkBox2.image = [UIImage imageNamed:@"checkbox_inactive.png"];
            self.checkBox3.image = [UIImage imageNamed:@"checkbox_inactive.png"];
        }else if ([sender tag] ==2){
           self.adressView2.backgroundColor = [UIColor colorWithRed:161.0/255.0 green:183.0/255.0 blue:58.0/255 alpha:1.0];
            self.addressView1.backgroundColor = [UIColor colorWithRed:211.0/255.0 green:54.0/255.0 blue:88.0/255 alpha:1.0];
            self.addressView3.backgroundColor = [UIColor colorWithRed:211.0/255.0 green:54.0/255.0 blue:88.0/255 alpha:1.0];
            self.selectedRow = [NSNumber numberWithInt:1];
            self.checkBox1.image = [UIImage imageNamed:@"checkbox_inactive.png"];
            self.checkBox2.image = [UIImage imageNamed:@"checkbox_active.png"];
            self.checkBox3.image = [UIImage imageNamed:@"checkbox_inactive.png"];
        
    }else
    {
       self.addressView3.backgroundColor = [UIColor colorWithRed:161.0/255.0 green:183.0/255.0 blue:58.0/255 alpha:1.0];
        self.addressView1.backgroundColor = [UIColor colorWithRed:211.0/255.0 green:54.0/255.0 blue:88.0/255 alpha:1.0];
        self.adressView2.backgroundColor = [UIColor colorWithRed:211.0/255.0 green:54.0/255.0 blue:88.0/255 alpha:1.0];
        self.selectedRow = [NSNumber numberWithInt:2];
        self.checkBox1.image = [UIImage imageNamed:@"checkbox_inactive.png"];
        self.checkBox2.image = [UIImage imageNamed:@"checkbox_inactive.png"];
        self.checkBox3.image = [UIImage imageNamed:@"checkbox_active.png"];
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_addressView1 release];
    [_address1 release];
    [_adressCity release];
    [_addressCountry release];
    [_addressState release];
    [_address2 release];
    [_addressCity2 release];
    [_addressState2 release];
    [_addressCountry2 release];
    [_adressView2 release];
    [_addressView3 release];
    [_address3 release];
    [_addressState3 release];
    [_addressCity2 release];
    [_addressCountry3 release];
    [_button1 release];
    [_button2 release];
    [_button3 release];
    [addressInfo release];
    [_checkBox1 release];
    [_checkBox2 release];
    [_checkBox3 release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setAddressView1:nil];
    [self setAddress1:nil];
    [self setAdressCity:nil];
    [self setAddressCountry:nil];
    [self setAddressState:nil];
    [self setAddress2:nil];
    [self setAddressCity2:nil];
    [self setAddressState2:nil];
    [self setAddressCountry2:nil];
    [self setAdressView2:nil];
    [self setAddressView3:nil];
    [self setAddress3:nil];
    [self setAddressState3:nil];
    [self setAddressCity2:nil];
    [self setAddressCountry3:nil];
    [self setButton1:nil];
    [self setButton2:nil];
    [self setButton3:nil];
    [self setCheckBox1:nil];
    [self setCheckBox2:nil];
    [self setCheckBox3:nil];
    [super viewDidUnload];
}
- (IBAction)selectAddress:(id)sender {
   
    NSDictionary *status = [[MJModel sharedInstance] sendAddressSaved:cartId withAddress:[[[addressInfo valueForKey:@"delivery_address_list"] objectAtIndex:[selectedRow intValue] ] valueForKey:@"address_id"]];
    
    if ([[status valueForKey:@"status" ] isEqual:@"ok"]){
        NSDictionary *dictTemp = [[MJModel sharedInstance] getDeliveryInfoFor:cartId];
        
        if ([[dictTemp valueForKey:@"delivery_option_list"] count] ==1){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"An error has occured. Please try again later." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alertView show];
            [alertView release];
            
        }
        else{
        DeliveryChoiceViewController *detailViewController = [[DeliveryChoiceViewController alloc] initWithNibName:@"DeliveryChoiceViewController" bundle:nil andCartId:cartId];
   
        
        AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [mydelegate.shopNavController pushViewController:detailViewController animated:YES];}
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"An error has occured. Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
        [alertView release];
    }

}
@end
