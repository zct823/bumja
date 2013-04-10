//
//  ShopAddressViewController.m
//  myjam
//
//  Created by Azad Johari on 2/28/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "ShopAddressViewController.h"

@interface ShopAddressViewController ()

@end

@implementation ShopAddressViewController
@synthesize shopAddInfo,shopId, shopLogo, shopAddress, scroller;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Store Location";
        FontLabel *titleView = [[FontLabel alloc] initWithFrame:CGRectZero fontName:@"jambu-font.otf" pointSize:22];
        titleView.text = self.title;
        titleView.textAlignment = NSTextAlignmentCenter;
        titleView.backgroundColor = [UIColor clearColor];
        titleView.textColor = [UIColor whiteColor];
        [titleView sizeToFit];
        self.navigationItem.titleView = titleView;
        [titleView release];
    }
    return self;
}

- (void)refreshScroller
{
    self.scroller.contentSize = self.scroller.frame.size;
    self.scroller.frame = self.view.frame;
    if (self.scroller.frame.size.height > 350){
        [ scroller setContentSize:CGSizeMake(320, self.shopAddress.frame.size.height+300) ];
        
    }
    [self.view addSubview:self.scroller];
}

- (void)viewDidLoad
{
    self.shopAddInfo = [[NSDictionary alloc] initWithDictionary:[[MJModel sharedInstance]getAddressForStore:shopId]];
    [self refreshScroller];
    [self.shopLogo setImageWithURL:[NSURL URLWithString:[shopAddInfo valueForKey:@"shop_logo"]] placeholderImage:[UIImage imageNamed:@"default_icon.png"]];
    
    [[self.shopAddress scrollView] setBounces:NO];
    //modification to add font
    
    NSString *setContent = [NSString stringWithFormat:@"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"><html xmlns=\"http://www.w3.org/1999/xhtml\"><head><title></title></head><body style='font-family:Arial; font-size:12px; text-align:justify;'>%@</body></html>",[shopAddInfo valueForKey:@"shop_info"]];
    
    [shopAddress loadHTMLString:setContent baseURL:nil];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
    CGRect frame = aWebView.frame;
    frame.size.height = 1;
    aWebView.frame = frame;
    CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    aWebView.frame = frame;
    self.visitButton.frame = CGRectMake(0,MAX(125,25+fittingSize.height),self.visitButton.frame.size.width,self.visitButton.frame.size.height);
    self.socialView.frame = CGRectMake(0, self.visitButton.frame.origin.y+55, self.socialView.frame.size.width, self.socialView.frame.size.height);
    if (self.visitButton.frame.origin.y+55+self.socialView.frame.size.height < 400){
        self.scroller.scrollEnabled = NO;
    }
    [self refreshScroller];
    //NSLog(@"size: %f, %f", fittingSize.width, fittingSize.height);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [shopLogo release];
    [shopAddress release];
    [scroller release];
    [_visitButton release];
    [_socialView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setShopLogo:nil];
    [self setShopAddress:nil];
    [self setVisitButton:nil];
    [self setSocialView:nil];
    [super viewDidUnload];
}
- (IBAction)visitShop:(id)sender {
    
    
    AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    for (int i=0 ; i< [mydelegate.shopNavController.viewControllers count]; i++){
        //NSLog(@"%@",[[mydelegate.shopNavController.viewControllers objectAtIndex:i] class] );
        
        if( [[[mydelegate.shopNavController.viewControllers objectAtIndex:i] class] isEqual:[ShopDetailListingViewController class]])
        {
            //NSLog(@"ok");
            
            [mydelegate.shopNavController popToViewController:[mydelegate.shopNavController.viewControllers objectAtIndex:i] animated:YES];
            break;
            
        }
        
        
    }
    
    
    
}

- (IBAction)facebookPressed:(id)sender {
    [self shareImageOnFBwith:[self.shopAddInfo  valueForKey:@"qrcode_id"] andImage:self.shopLogo.image];
}

- (IBAction)twitterPressed:(id)sender {
    [self shareImageOnTwitterFor:[self.shopAddInfo  valueForKey:@"qrcode_id"] andImage:self.shopLogo.image];
}

- (IBAction)emailPressed:(id)sender {
    [self shareImageOnEmailWithId:[self.shopAddInfo  valueForKey:@"qrcode_id"] withImage:self.shopLogo.image];
}
@end