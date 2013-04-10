//
//  DeliveryDayChoiceViewController.m
//  myjam
//
//  Created by Azad Johari on 2/3/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "DeliveryDayChoiceViewController.h"

@interface DeliveryDayChoiceViewController ()

@end

@implementation DeliveryDayChoiceViewController

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
    }
    return self;
}

- (void)viewDidLoad
{
    self.priceLabel.text = [[[_deliveryInfo valueForKey:@"delivery_option_list"] objectAtIndex:0 ] valueForKey:@"price"];
    if ([[_deliveryInfo valueForKey:@"selected_option_id"] isEqual:@"1"]){
        [self.button1 setBackgroundImage:[UIImage imageNamed:@"greenbtn_bg.png"] forState:UIControlStateNormal];
    }
    else if ([[_deliveryInfo valueForKey:@"selected_option_id"] isEqual:@"2"]){
        [self.button2 setBackgroundImage:[UIImage imageNamed:@"greenbtn_bg.png"] forState:UIControlStateNormal];
    }
    self.deliverChoice = [_deliveryInfo valueForKey:@"selected_option_id"];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_button1 release];
    [_button2 release];
    [_priceLabel release];
    [_nextButton release];
   
    [super dealloc];
}
- (void)viewDidUnload {
    [self setButton1:nil];
    [self setButton2:nil];
    [self setPriceLabel:nil];
    [self setNextButton:nil];
   
    [super viewDidUnload];
}
- (IBAction)nextButtonTapped:(id)sender {
    NSDictionary *status = [NSDictionary dictionaryWithDictionary:[[MJModel sharedInstance]submitDeliveryOptionFor:_cartId withOption:self.deliverChoice]];
         if ([[status valueForKey:@"status" ] isEqual:@"ok"]){
             CheckoutViewController *detailViewController = [[CheckoutViewController alloc] initWithNibName:@"CheckoutViewController" bundle:nil];
             detailViewController.cartList = [[NSMutableArray alloc] initWithArray:[[MJModel sharedInstance] getCartListForCartId:_cartId]];
             detailViewController.footerView = [[[NSBundle mainBundle] loadNibNamed:@"ConfirmFooterView" owner:self options:nil]objectAtIndex:0];
             detailViewController.footerType=@"1";
             AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
             [mydelegate.shopNavController pushViewController:detailViewController animated:YES];

         }
    
}

- (IBAction)choiceTapped:(id)sender {
    if (![[NSString stringWithFormat:@"%d",[sender tag] ] isEqual:[_deliveryInfo valueForKey:@"delivery_option_list"]]){
        self.deliverChoice = [NSString stringWithFormat:@"%d",[sender tag] ];
        if ([sender tag] == 1){
            [self.button1 setBackgroundImage:[UIImage imageNamed:@"greenbtn_bg.png"] forState:UIControlStateNormal];
            [self.button2 setBackgroundImage:[UIImage imageNamed:@"redbtn_bg.png"] forState:UIControlStateNormal];
        }else{
            [self.button2 setBackgroundImage:[UIImage imageNamed:@"greenbtn_bg.png"] forState:UIControlStateNormal];
            [self.button1 setBackgroundImage:[UIImage imageNamed:@"redbtn_bg.png"] forState:UIControlStateNormal];
            
        }
    }

}
@end
