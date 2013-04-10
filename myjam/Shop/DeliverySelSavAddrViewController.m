//
//  DeliverySelSavAddrViewController.m
//  myjam
//
//  Created by Mohd Zulhilmi on 21/03/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "DeliverySelSavAddrViewController.h"

#define kickStartAddressY 40.0f

@interface DeliverySelSavAddrViewController ()

@end

@implementation DeliverySelSavAddrViewController {
    int addrIdSetPrime;
}

@synthesize getCartID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        // TITLE
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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.scrollView = (UIScrollView *)self.view;
    
    
    //NSLog(@"Get cartID: %@",getCartID);
    
    [self retAddrFrmAPI];
}

- (void)retAddrFrmAPI
{
    NSString *urlString = [NSString stringWithFormat:@"%@/api/settings_jambulite_profile.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
    
    NSString *dataContent = [NSString stringWithFormat:@"{\"flag\":\"DEFAULT\"}"];
    
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
    
    NSDictionary *resultsDictionary = [[response objectFromJSONString] mutableCopy];
    
    NSInteger count = nil;
    NSInteger kickStartAddrY = nil;
    
    if([resultsDictionary count])
    {
        NSString *status = [resultsDictionary objectForKey:@"status"];
        
        if ([status isEqualToString:@"ok"])
        {
            if (![[resultsDictionary objectForKey:@"address"]isKindOfClass:[NSString class]])
            {
                for (id row in [resultsDictionary objectForKey:@"address"])
                {
                    self.addressList = [resultsDictionary objectForKey:@"address"];
                    
                    //NSLog(@"ROW: %@",row);
                    
                    if (count == 0)
                    {
                        count++;
                        kickStartAddrY = kickStartAddressY;
                    }
                    else if (count != 0)
                    {
                        count++;
                        kickStartAddrY = kickStartAddrY+110;
                    }
                    
                    //NSLog(@"row street: %@",[row objectForKey:@"address"]);
                    //NSLog(@"row city: %@",[row objectForKey:@"city"]);
                    //NSLog(@"row state: %@",[row objectForKey:@"state"]);
                    //NSLog(@"row country: %@",[row objectForKey:@"country"]);
                    
                    DeliverySelSavAddresses *dssaUIV = [[DeliverySelSavAddresses alloc] initWithFrame: CGRectMake(0, kickStartAddrY, 320, 106)];
                    
                    dssaUIV.stringAddr = [NSString stringWithFormat:@"%@",[row objectForKey:@"address"]];
                    
                    dssaUIV.addressStreet.text = [row objectForKey:@"address"];
                    
                    dssaUIV.addressLabelNo.text = [NSString stringWithFormat:@"Address %d",count];
                    dssaUIV.addressCity.text = [row objectForKey:@"city"];
                    dssaUIV.addressState.text = [row objectForKey:@"state"];
                    dssaUIV.addressCountry.text = [row objectForKey:@"country"];
                    [dssaUIV.setAsPrimary setHidden:YES];
                    
                    [dssaUIV setTag:[[row objectForKey:@"addressId"] intValue]];
                    UITapGestureRecognizer *tapOnAddress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedAddress:)];
                    [dssaUIV addGestureRecognizer:tapOnAddress];
                    
                    //[dssaUIV.selectedBtn setUserInteractionEnabled:YES];
                    //[dssaUIV.selectedBtn setTag:[[row objectForKey:@"addressId"] intValue]];
                    //UITapGestureRecognizer *setPrimary = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setPrime:)];
                    //[dssaUIV.selectedBtn addGestureRecognizer:setPrimary];
                    dssaUIV.selectedBtn.tag = [[row objectForKey:@"addressId"] intValue];
                    [dssaUIV.selectedBtn addTarget:self action:@selector(setPrime:) forControlEvents:UIControlEventTouchUpInside];
                    
                    if ([[row objectForKey:@"addressIsPrimary"] isEqual:@"Y"])
                    {
                        [dssaUIV.selectedBtn setImage:[UIImage imageNamed:@"checkbox_active"] forState:UIControlStateNormal];
                        [dssaUIV.bgColor setBackgroundColor:[UIColor colorWithHex:@"#aab44e"]];
                        [dssaUIV.setAsPrimary setHidden:NO];
                        self.tagID = [[row objectForKey:@"addressId"] intValue];
                    }
                    
                    [self.mainContentView addSubview:dssaUIV];
                    
                    [self.mainContentView addSubview:self.nextBtnView];
                    [dssaUIV release];
                    [tapOnAddress release];
                    
                }
                
                
                
                [self.nextBtnView setFrame:CGRectMake(0, kickStartAddrY+110, self.nextBtnView.bounds.size.width, self.nextBtnView.bounds.size.height)];
                [self.nextBtnView setUserInteractionEnabled:YES];
                UITapGestureRecognizer *tapOnNext = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToNextView)];
                [self.nextBtnView addGestureRecognizer:tapOnNext];
                
                [self.mainContentView addSubview:self.nextBtnView];
                
                [self.scrollView setContentSize:CGSizeMake(self.mainContentView.frame.size.width, self.mainContentView.frame.size.height+kickStartAddrY-200)];
                [self.mainContentView setFrame:CGRectMake(0, 0, self.mainContentView.frame.size.width, self.mainContentView.frame.size.height+kickStartAddrY-200+self.nextBtnView.bounds.size.height)];
                
                [self.scrollView addSubview:self.mainContentView];
                [tapOnNext release];
            }
        }
    }
}

- (void)setPrime:(id)sender
{
    UIButton* aid = (UIButton*) sender;
    //NSLog(@"tag=%d",aid.tag);
    NSString *flag = @"SET_PRIMARY_ADDRESS";
    addrIdSetPrime = aid.tag;
    NSString *urlString = [NSString stringWithFormat:@"%@/api/settings_jambulite_profile.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
    NSString *dataContent = [NSString stringWithFormat:@"{\"flag\":\"%@\",\"addressId\":\"%ld\"}",
                             flag,
                             (long)aid.tag];
    
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
    //NSLog(@"request %@\n%@\n\nresponse dataSetPrime: %@", urlString, dataContent, response);
    NSDictionary *resultsDictionary = [[response objectFromJSONString] mutableCopy];
    //NSLog(@"dict %@",resultsDictionary);
    
    if([resultsDictionary count])
    {
        NSString *status = [resultsDictionary objectForKey:@"status"];
        NSString *msg = [resultsDictionary objectForKey:@"message"];
        
        if ([status isEqualToString:@"ok"]) {
            //NSLog(@"Successfully set primary address!");
            [DejalBezelActivityView activityViewForView:self.view withLabel:@"Saving ..." width:100];
            [self performSelector:@selector(setViewPrime) withObject:nil afterDelay:0.2];
        }
        else {
            CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Jambulite Profile" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }
    //NSLog(@"end saved");
}

- (void)setViewPrime
{
    for (UIView *aView in [self.mainContentView subviews]) {
        if ([aView isKindOfClass:[DeliverySelSavAddresses class]]) {
            
            DeliverySelSavAddresses *kView = (DeliverySelSavAddresses *) aView;
            
            if (kView.tag == addrIdSetPrime ) {
                //[kView.bgColor setBackgroundColor:[UIColor colorWithHex:@"#aab44e"]];
                [kView.selectedBtn setImage:[UIImage imageNamed:@"checkbox_active"] forState:UIControlStateNormal];
                [kView.setAsPrimary setHidden:NO];
            }else{
                //[kView.bgColor setBackgroundColor:[UIColor colorWithHex:@"#e40045"]];
                [kView.selectedBtn setImage:[UIImage imageNamed:@"checkbox_inactive"] forState:UIControlStateNormal];
                [kView.setAsPrimary setHidden:YES];
            }
            
        }
    }
    [DejalBezelActivityView removeViewAnimated:YES];
}

- (void)selectedAddress:(id)sender
{
    //NSLog(@"Button Voided!");
    //NSLog(@"tapped on label %d",[(UITapGestureRecognizer *)sender view].tag);
    self.tagID = [(UITapGestureRecognizer *)sender view].tag;
    
    int clickedTag = [(UITapGestureRecognizer *)sender view].tag;
    
    for (UIView *aView in [self.mainContentView subviews]) {
        if ([aView isKindOfClass:[DeliverySelSavAddresses class]]) {
            
            DeliverySelSavAddresses *kView = (DeliverySelSavAddresses *) aView;
            
            if (kView.tag == clickedTag ) {
                [kView.bgColor setBackgroundColor:[UIColor colorWithHex:@"#aab44e"]];
                //[kView.selectedBtn setImage:[UIImage imageNamed:@"checkbox_active"] forState:UIControlStateNormal];
                //[kView.setAsPrimary setHidden:NO];
            }else{
                [kView.bgColor setBackgroundColor:[UIColor colorWithHex:@"#e40045"]];
                //[kView.selectedBtn setImage:[UIImage imageNamed:@"checkbox_inactive"] forState:UIControlStateNormal];
                //[kView.setAsPrimary setHidden:YES];
            }
            
        }
    }
    
}

- (void)goToNextView
{
    //NSLog(@"gotonextview addID:%d",self.tagID);
    
    NSString *urlString = [NSString stringWithFormat:@"%@/api/shop_cart_delivery_address_submit.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
    
    NSString *dataContent = [NSString stringWithFormat:@"{\"cart_id\":\"%@\",\"address_id\":\"%d\"}",getCartID,self.tagID];
    
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
    
    NSDictionary *resultsDictionary = [[response objectFromJSONString] mutableCopy];
    
    if([resultsDictionary count])
    {
        NSString *status = [resultsDictionary objectForKey:@"status"];
        
        if ([status isEqualToString:@"ok"])
        {
            //NSLog(@"OK");
            
            NSDictionary *dictTemp = [[MJModel sharedInstance] getDeliveryInfoFor:getCartID];
            
            if ([[dictTemp valueForKey:@"delivery_option_list"] count] ==1){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"An error has occured. Please try again later." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alertView show];
                [alertView release];
                
            }
            else{
                DeliveryChoiceViewController *detailViewController = [[DeliveryChoiceViewController alloc] initWithNibName:@"DeliveryChoiceViewController" bundle:nil andCartId:getCartID];
                
                
                AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [mydelegate.shopNavController pushViewController:detailViewController animated:YES];}
        }
        else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"An error has occured. Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alertView show];
            [alertView release];
        }

        
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
