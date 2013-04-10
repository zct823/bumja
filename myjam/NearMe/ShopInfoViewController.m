//
//  ShopInfoViewController.m
//  myjam
//
//  Created by Mohd Zulhilmi on 5/04/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "ShopInfoViewController.h"
#import "DejalActivityView.h"

#define degreesToRadians(x) (M_PI * x / 180.0)
#define radiandsToDegrees(x) (x * 180.0 / M_PI)

@interface ShopInfoViewController ()

@end

@implementation ShopInfoViewController

@synthesize shopDistance, shopCoordLat, shopCoordLong, shopID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        FontLabel *titleViewUsingFL = [[FontLabel alloc] initWithFrame:CGRectZero fontName:@"jambu-font.otf" pointSize:22];
        titleViewUsingFL.text = @"Near Me";
        titleViewUsingFL.textAlignment = NSTextAlignmentCenter;
        titleViewUsingFL.backgroundColor = [UIColor clearColor];
        titleViewUsingFL.textColor = [UIColor whiteColor];
        [titleViewUsingFL sizeToFit];
        self.navigationItem.titleView = titleViewUsingFL;
        [titleViewUsingFL release];
        
        self.navigationItem.backBarButtonItem =
        [[[UIBarButtonItem alloc] initWithTitle:@"Back"
                                          style:UIBarButtonItemStyleBordered
                                         target:nil
                                         action:nil] autorelease];
        
        self.scrollView = (UIScrollView *)self.view;
        
        [self.scrollView setContentSize:self.contentView.frame.size];
        [self.scrollView addSubview:self.contentView];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [DejalBezelActivityView activityViewForView:self.contentView withLabel:@"Loading..." width:100];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    if (screenBounds.size.height == 568) {
        // code for 4-inch screen
        self.view.frame = CGRectMake(0,0,self.view.bounds.size.width, 568);
        self.headerImg.frame = CGRectMake(20, 20, 95, 135);
    }
    else
    {
        // code for 3.5-inch screen
        self.view.frame = CGRectMake(0,0,self.view.bounds.size.width, 480);
        self.headerImg.frame = CGRectMake(20, 20, 95, 160);
    }
    
    //-Setup Buttons-//
    UIGestureRecognizer *gestTapper = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(prevMapHyperAct)];
    [self.prevMapLbl addGestureRecognizer:gestTapper];
    [self.prevMapLbl setUserInteractionEnabled:YES];
    [gestTapper release];
    
    gestTapper = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(visitJSHyperAct)];
    [self.visitJSLbl addGestureRecognizer:gestTapper];
    [self.visitJSLbl setUserInteractionEnabled:YES];
    [gestTapper release];
    
    gestTapper = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareFBHyperAct)];
    [self.shareFBBtn addGestureRecognizer:gestTapper];
    [self.shareFBBtn setUserInteractionEnabled:YES];
    [gestTapper release];
    
    gestTapper = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareTWHyperAct)];
    [self.shareTWBtn addGestureRecognizer:gestTapper];
    [self.shareTWBtn setUserInteractionEnabled:YES];
    [gestTapper release];
    
    gestTapper = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareEMHyperAct)];
    [self.shareEMBtn addGestureRecognizer:gestTapper];
    [self.shareEMBtn setUserInteractionEnabled:YES];
    [gestTapper release];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"ShopID: %d",shopID);
    
    [self getShopCoordNDistFromAPI];
    [self getShopInfo];
    
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSInteger degreeDecimals = [self degreeCalculatorWithLat:self.shopCoordLat andLong:self.shopCoordLong] + appDel.currentDecDegree;
    
    UIImage *imagePointer = [[UIImage imageNamed:@"arrowNaviHR.png"]imageRotatedByDegrees:degreeDecimals];
    UIImageView *pointing = [[UIImageView alloc]initWithImage:imagePointer];
    
    pointing.frame = CGRectMake(70, 115, 50, 45);
    [self.contentView addSubview:pointing];
    [pointing release];
    
    self.distanceLabel.text = [self distanceConverter:shopDistance];
    
    NSLog(@"CalculatedDist: %@",[self distanceConverter:shopDistance]);
    
}

- (void)getShopCoordNDistFromAPI
{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/api/nearme_map.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
    NSString *dataContent = [NSString stringWithFormat:@"{\"lat\":\"%f\",\"lng\":\"%f\",\"radius\":\"%d\"}",appDel.currentLat,appDel.currentLong,appDel.withRadius];
    
    NSLog(@"UrlString %@ and datacontent %@",urlString,dataContent);
    
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
    NSLog(@"request %@\n%@\n\nresponse retrieveData: %@", urlString, dataContent, response);
    NSDictionary *resultsDictionary = [[response objectFromJSONString] mutableCopy];
    
    NSLog(@"dict %@",resultsDictionary);
    
    if([resultsDictionary count])
    {
        NSString *status = [resultsDictionary objectForKey:@"status"];
        
        if ([status isEqualToString:@"ok"])
        {
            for (id row in [resultsDictionary objectForKey:@"list"])
            {
                NSLog(@"row shopID: %@",[row objectForKey:@"shop_id"]);
                NSInteger shopIDStr = [[row objectForKey:@"shop_id"]intValue];
                NSInteger shopIDStrCurrent = self.shopID;
                
                if (shopIDStr == shopIDStrCurrent)
                {
                    NSLog(@"row shopID detected: %d",shopIDStr);
                    self.shopCoordLat = [[row objectForKey:@"shop_lat"]doubleValue];
                    self.shopCoordLong = [[row objectForKey:@"shop_lng"]doubleValue];
                    self.shopDistance = [[row objectForKey:@"distance_in_meter"]doubleValue];
                }
            }
        }
    }
    else
    {
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Near Me" message:@"Connection error. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        [self.navigationController popViewControllerAnimated:YES];
    }

}

- (void)getShopInfo
{
    NSString *urlString = [NSString stringWithFormat:@"%@/api/shop_details.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
    NSString *dataContent = [NSString stringWithFormat:@"{\"shop_id\":\"%d\"}",self.shopID];
    
    NSLog(@"UrlString %@ and datacontent %@",urlString,dataContent);
    
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
    NSLog(@"request %@\n%@\n\nresponse retrieveData: %@", urlString, dataContent, response);
    NSDictionary *resultsDictionary = [[response objectFromJSONString] mutableCopy];
    
    NSLog(@"dict %@",resultsDictionary);
    
    if([resultsDictionary count])
    {
        NSString *status = [resultsDictionary objectForKey:@"status"];
        
        if ([status isEqualToString:@"ok"])
        {            
            self.headerImg.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[resultsDictionary objectForKey:@"shop_logo"]]]];
            
            NSString *setContent = [NSString stringWithFormat:@"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"><html xmlns=\"http://www.w3.org/1999/xhtml\"><head><title></title></head><body style='font-family:Verdana; font-size:12px; text-align:justify;'>%@</body></html>",[resultsDictionary objectForKey:@"shop_info"]];
            
            [self.addressView loadHTMLString:setContent baseURL:nil];
            
            [DejalBezelActivityView removeViewAnimated:YES];
        }
    }
    else
    {
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Near Me" message:@"Connection error. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
}

- (void)prevMapHyperAct
{
    NSLog(@"Preview Map Action Voided!");
    
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    PrevMapNMViewController *prevMapNMVC = [[PrevMapNMViewController alloc]init];
    prevMapNMVC.shopID = shopID;
    
    [myDelegate.otherNavController pushViewController:prevMapNMVC animated:YES];
}

- (void)visitJSHyperAct
{
    NSLog(@"Visit JAM-BU Shop Action Voided!");
}

- (void)shareFBHyperAct
{
    NSLog(@"Share FB Action Voided!");
}

- (void)shareTWHyperAct
{
    NSLog(@"Share Twitter Shop Action Voided!");
}

- (void)shareEMHyperAct
{
    NSLog(@"Share Email Shop Action Voided!");
}

- (NSInteger)degreeCalculatorWithLat:(double)latitude andLong:(double)longitude
{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSLog(@"Curr Lat: %f",appDel.currentLat);
    NSLog(@"Curr Long: %f",appDel.currentLong);
    NSLog(@"Curr DecDegree: %d",appDel.currentDecDegree);
    
    float fromLat = degreesToRadians(appDel.currentLat);
    float fromLong = degreesToRadians(appDel.currentLong);
    float toLat = degreesToRadians(latitude);
    float toLong = degreesToRadians(longitude);
    
    float getDegree = radiandsToDegrees(atan2(sin(toLong-fromLong)*cos(toLat), cos(fromLat)*sin(toLat)-sin(fromLat)*cos(toLat)*cos(toLong-fromLong)));
    
    if (getDegree >= 0) { return getDegree; }
    else { return 360+getDegree; }
    
    NSLog(@"Degree: %f",getDegree);
    
    return getDegree;
}

- (NSString *)distanceConverter:(NSInteger)distanceInMeter
{
    NSString *distance = @"";
    
    float distanceInMeter2 = (float)distanceInMeter;
    float convertToKM = distanceInMeter2 / 1000;
    NSString *floatItToKMInString = [NSString stringWithFormat:@"%.1f",(float)convertToKM];
    float floatItToKM = [floatItToKMInString floatValue];
    
    NSLog(@"Convert To KM: %f",convertToKM);
    NSLog(@"Float It To KM: %f",floatItToKM);
    NSLog(@"Float It To Meter: %d",distanceInMeter);
    
    if (floatItToKM < 1.0)
    {
        NSLog(@"Less than 1.0: %@",floatItToKMInString);
        distance = [NSString stringWithFormat:@"%d m",distanceInMeter];
    }
    else
    {
        NSLog(@"More than 1.0 : %@",floatItToKMInString);
        distance = [NSString stringWithFormat:@"%.1f km",(float)convertToKM];
    }
    
    return distance;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
}

@end
