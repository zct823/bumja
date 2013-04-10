//
//  ScanViewController.m
//  myjam
//
//  Created by nazri on 11/7/12.
//  Copyright (c) 2012 me-tech. All rights reserved.
//

#import "ScanQRViewController.h"
#import <QRCodeReader.h>
#import <UniversalResultParser.h>
#import <BusinessCardParsedResult.h>
#import <GeoParsedResult.h>
#import <URIParsedResult.h>
#import <ParsedResult.h>
#import <ResultAction.h>
//#import "ScanViewController.h"
#import "AppDelegate.h"
#import "ASIWrapper.h"
#import "MoreViewController.h"
#import "MEvent.h"
#import "ErrorViewController.h"
#import "ConnectionClass.h"

@interface ScanQRViewController ()

@end

@implementation ScanQRViewController

@synthesize widController;
@synthesize actions;
@synthesize result;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        FontLabel *titleView = [[FontLabel alloc] initWithFrame:CGRectZero fontName:@"jambu-font.otf" pointSize:22];
        titleView.text = @"JAM-BU Scan";
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
    // Setup screen for retina 4
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    if (screenBounds.size.height == 568) {
        // code for 4-inch screen
        self.view.frame = CGRectMake(0,0,self.view.bounds.size.width, 568);
    } else {
        // code for 3.5-inch screen
        self.view.frame = CGRectMake(0,0,self.view.bounds.size.width, 480);
    }
    
    [self.loadingActivityView startAnimating];
    // Do any additional setup after loading the view from its nib.
    [self openScanner];
}

- (void)openScanner
{
    //NSLog(@"openScanner");
    
    widController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:NO OneDMode:NO];
    QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
    NSSet *readers = [[NSSet alloc ] initWithObjects:qrcodeReader,nil];
    [qrcodeReader release];
    widController.readers = readers;
    [readers release];
    NSBundle *mainBundle = [NSBundle mainBundle];
    widController.soundToPlay =
    [NSURL fileURLWithPath:[mainBundle pathForResource:@"beep-beep" ofType:@"mp3"] isDirectory:NO];
    scanNavController = [[UINavigationController alloc] initWithRootViewController:widController];
    
    [scanNavController setNavigationBarHidden:YES];
    [self.view addSubview:scanNavController.view];
    
    [widController release];
    
}

//- (IBAction)scanButton:(id)sender {
//    [self openScanner];
//}

- (void)viewDidAppear:(BOOL)animated
{
    AppDelegate *mydelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [mydelegate.bannerView animateFunction];
    mydelegate.pageIndex = kScannerTab;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    //NSLog(@"viewWillAppearScan");
    [self.loadingActivityView startAnimating];
    //    [self openScanner];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //NSLog(@"viewWillDisappearScan");
    [self.loadingActivityView stopAnimating];
    [DejalBezelActivityView removeViewAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)performAction:(ResultAction *)action {
    [action performActionWithController:self shouldConfirm:NO];
}

- (void)modalViewControllerWantsToBeDismissed:(UIViewController *)controller {
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)addScanToServer:(NSString *)qrcodeId
{
    NSString *urlString = [NSString stringWithFormat:@"%@/api/qrcode_scan.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
    
    NSString *dataContent = [NSString stringWithFormat:@"{\"qrcode_id\":%@}",qrcodeId];
    
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
    //NSLog(@"abc: %@, def:%@",dataContent, response);
    NSDictionary *resultsDictionary = [[response objectFromJSONString] mutableCopy];
    
    if([resultsDictionary count])
    {
        NSString *status = [resultsDictionary objectForKey:@"status"];
        
        if ([status isEqualToString:@"ok"])
        {
            //NSLog(@"Success submit scan");
            return YES;
        }
        else{
            //NSLog(@"Submit scan error!");
        }
    }
    
    return NO;
    
}

- (NSString *)getQRCodeIdFromScanString:(NSString *)str
{
    NSString *urlString = [NSString stringWithFormat:@"%@/api/qrcode_scan.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]copy]];
    
    NSString *dataContent = [NSString stringWithFormat:@"{\"qrcode_data\":\"%@\"}",str];
    
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
    //NSLog(@"abc: %@, def:%@",dataContent, response);
    NSDictionary *resultsDictionary = [[response objectFromJSONString] copy];
    
    if([resultsDictionary count])
    {
        NSString *status = [resultsDictionary objectForKey:@"status"];
        
        if ([status isEqualToString:@"ok"])
        {
            //NSLog(@"Get qrcode id success");
            return [resultsDictionary objectForKey:@"qrcode_id"];
        }
        else{
            //NSLog(@"Get qrcode id error!");
        }
    }
    
    return @"error";
}

- (NSString *)checkQRCodeType:(NSString *)qrcodeid
{
    NSString *urlString = [NSString stringWithFormat:@"%@/api/qrcode_type.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
    NSString *dataContent = [NSString stringWithFormat:@"{\"qrcode_id\":%@}",qrcodeid];
    
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
    //NSLog(@"request %@\n%@\n\nresponse data: %@", urlString, dataContent, response);
    NSDictionary *resultsDictionary = [[response objectFromJSONString] copy];
    //NSLog(@"dict %@",resultsDictionary);
    
    if([resultsDictionary count])
    {
        NSString *status = [resultsDictionary objectForKey:@"status"];
        if ([status isEqualToString:@"ok"])
        {
            NSString *type = [resultsDictionary objectForKey:@"qrcode_type"];
            
            if ([type isEqualToString:@"Product"]) {
                NSString *productid = [resultsDictionary objectForKey:@"product_id"];
                return productid;
            }
            
        }
    }
    
    return @"0"; // normal qrcode, other than product
}


//- (void)processRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *productId = [self checkQRCodeType:[[self.tableData objectAtIndex:indexPath.row] qrcodeId]];
//    
//    if ([productId intValue] > 0)
//    {
//        // type of product
//        DetailProductViewController *detailViewController = [[DetailProductViewController alloc] initWithNibName:@"DetailProductViewController" bundle:nil];
//        //        NSString *prodId = productId;
//        detailViewController.productInfo = [[MJModel sharedInstance] getProductInfoFor:productId];
//        detailViewController.buyButton =  [[NSString alloc] initWithString:@"ok"];
//        detailViewController.productId = [productId mutableCopy];
//        AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        [mydelegate.boxNavController pushViewController:detailViewController animated:YES];
//    }
//    else{
//        MoreViewController *detailView = [[MoreViewController alloc] init];
//        detailView.qrcodeId = [[self.tableData objectAtIndex:indexPath.row] qrcodeId];
//        AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        [mydelegate.boxNavController pushViewController:detailView animated:YES];
//        [detailView release];
//    }
//}

#pragma mark -
#pragma mark ZXingDelegateMethods
- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)resultString
{
    //    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading ..." width:100];
    //    [self.view bringSubviewToFront:self.loadingActivityView];
    //    [self.view bringSubviewToFront:self.waitLabel];
    
    MoreViewController *more = [[MoreViewController alloc] init];
    AppDelegate *mydelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    mydelegate.isFromScannerTab = YES;
    if (![ConnectionClass connected]) {
        more.noInternetConnection = YES;
        [mydelegate.scanNavController pushViewController:more animated:YES];
        [more release];
        
        return;
    }
    
    //NSLog(@"str %@",resultString);
    //    NSString *qrcodeId = @"0";
    
    //    qrcodeId = [self getQRCodeIdFromScanString:resultString];
    
    //NSLog(@"str %@",resultString);
    NSString *qrcodeId;
    BOOL isInternalQR = NO;
    
    // Process if preview jambu qrcode http://jambu/preview
    if ([resultString isEqualToString:[NSString stringWithFormat: @"%@/preview",APP_API_URL]])
    {
        ErrorViewController *errorPage = [[ErrorViewController alloc] init];
        errorPage.errorOption = kERROR_NOT_SAVED;
        [mydelegate.scanNavController pushViewController:errorPage animated:YES];
        [errorPage release];
        
        return;
    }
    
    // Process if jam-bu qrcode
    NSArray *splittedURL = [resultString componentsSeparatedByString:@"/"];
    if ([splittedURL count] >= 5) { // Is URL with "/" seperated
        // Check if jam-bu link
        if ([[splittedURL objectAtIndex:2] isEqualToString:SCAN_URL] && [[splittedURL objectAtIndex:3] isEqualToString:@"scan"])
        {
            isInternalQR = YES;
            qrcodeId = [splittedURL lastObject];
        }
    }
    
    // Process alien qrcode
    if (!isInternalQR) {
        //NSLog(@"External QR code");
        
        qrcodeId = [self performResultAction:resultString];
        if ([qrcodeId isEqualToString:@"0000"]) { // 0000 indicates calendar qrcode
            
            // skip for map since it is processed directly in MKReverse delegate
            return;
        }
        else if ([qrcodeId isEqualToString:@"error"])
        {
            // Redirect to error page
            ErrorViewController *errorPage = [[ErrorViewController alloc] init];
            errorPage.errorOption = kERROR_QR_NOT_COMPATIBLE;
            [mydelegate.scanNavController pushViewController:errorPage animated:YES];
            [errorPage release];
            
            return;
        }
        
    }
    
    if ([qrcodeId integerValue]) {
        // Store qrcode in server / scan list
        if ([self addScanToServer:qrcodeId])
        {
            
            NSString *productId = [self checkQRCodeType:qrcodeId];
            
            if ([productId intValue] > 0)
            {
                // type of product
                DetailProductViewController *detailViewController = [[DetailProductViewController alloc] initWithNibName:@"DetailProductViewController" bundle:nil];
                //        NSString *prodId = productId;
                detailViewController.productInfo = [[MJModel sharedInstance] getProductInfoFor:productId];
                detailViewController.buyButton =  [[NSString alloc] initWithString:@"ok"];
                detailViewController.productId = [productId mutableCopy];
                [mydelegate.boxNavController pushViewController:detailViewController animated:YES];
            }
            else{
            
                more.qrcodeId = qrcodeId;
                [mydelegate.boxNavController pushViewController:more animated:YES];
                [more release];
            }
            [mydelegate.tabView activateController:3];
            // Manually change the selected tabButton
            for (int i = 0; i < [mydelegate.tabView.tabItemsArray count]; i++) {
                if (i == 3) {
                    [[mydelegate.tabView.tabItemsArray objectAtIndex:i] toggleOn:YES];
                } else {
                    [[mydelegate.tabView.tabItemsArray objectAtIndex:i] toggleOn:NO];
                }
            }
        }
    }else{
        //NSLog(@"Error occured.");
    }
    
    //NSLog(@"qrcodeid : %@",qrcodeId);
}

- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller {
    [self dismissModalViewControllerAnimated:YES];
}


- (NSString *)performResultAction:(NSString *)resultString
{
    ParsedResult *parsedResult = [UniversalResultParser parsedResultForString:resultString];
    self.result = [parsedResult retain];
    self.actions = [self.result.actions retain];
    
    NSString *qrcodeId;
    
    if (self.result == nil) {
        //NSLog(@"no result to perform an action on!");
        return @"error";
    }
    
    if (self.actions == nil || self.actions.count == 0) {
        //NSLog(@"Plain text detected!");
        
        if (resultString == nil || [resultString length] < 1) {
            return @"error";
        }else if ([resultString hasPrefix:@"BEGIN:VEVENT"]){
            // process calendar
            return [self processScanEvent:resultString];
            
        }else{
            // Others scan result treat as plain text
            return [self processPlainText:resultString];
        }
        
    }
    
    if (self.actions.count == 1) {
        ResultAction *action = [self.actions lastObject];
        
        if ([[action title] isEqualToString:@"Add Contact"]) {
            qrcodeId = [self processAddContact:self.result];
        }
        else if ([[action title] isEqualToString:@"Show on Map"]) {
            qrcodeId = [self processShowMap:self.result];
        }
        else if ([[action title] isEqualToString:@"Open URL"]) {
            qrcodeId = [self processOpenURL:self.result];
        }else{
            return @"error";
        }
        
    }else{
        return @"error";
    }
    
    return qrcodeId;
}

- (NSString *)processPlainText:(NSString *)text
{
    NSString *qrcodeId = nil;
    NSString *urlString = [NSString stringWithFormat:@"%@/api/qrcode_text.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"] copy]];
    
    NSString *dataContent = [NSString stringWithFormat:@"{\"text_text\":\"%@\",\"external\":\"1\"}",text];
    
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
    //NSLog(@"abc: %@, def:%@",dataContent, response);
    NSDictionary *resultsDictionary = [[response objectFromJSONString] copy];
    
    if([resultsDictionary count])
    {
        NSString *status = [resultsDictionary objectForKey:@"status"];
        
        if ([status isEqualToString:@"ok"])
        {
            qrcodeId = [resultsDictionary objectForKey:@"qrcode_id"];
            //NSLog(@"Submit text ok!");
        }
        else{
            //NSLog(@"Submit text error! %@",[resultsDictionary objectForKey:@"message"]);
            
        }
    }
    return qrcodeId;
    
}

- (NSString *)processScanEvent:(NSString *)text
{
    //NSLog(@"processScanEvent");
    
    NSString *qrcodeId = nil;
    NSArray *rawKeyValue = [text componentsSeparatedByString:@"\n"];
    MEvent *event = [[MEvent alloc] init];
    
    //NSLog(@"%@",rawKeyValue);
    for (NSString *line in rawKeyValue)
    {
        NSArray *keyVal = [line componentsSeparatedByString:@":"];
        NSString *key = [keyVal objectAtIndex:0];
        NSString *value = [keyVal objectAtIndex:1];
        value = [value stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        if ([key isEqualToString:@"SUMMARY"]) {
            [event setName:value];
        }
        else if ([key isEqualToString:@"LOCATION"]) {
            [event setLocation:value];
        }
        else if ([key isEqualToString:@"DESCRIPTION"]) {
            [event setDescription:value];
        }
        else if ([key isEqualToString:@"DTSTART"]) {
            
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyyMMdd'T'HHmmss'Z'"];
            NSDate *aDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",value]];
            
            event.startDate = [self dateToString:aDate];
            event.startTime = [self timeToString:aDate];
            
        }else if ([key isEqualToString:@"DTEND"]) {
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyyMMdd'T'HHmmss'Z'"];
            NSDate *aDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",value]];
            event.endDate = [self dateToString:aDate];
            event.endTime = [self timeToString:aDate];
            
        }
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/api/qrcode_calendar.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
    
    NSString *dataContent = [NSString stringWithFormat:@"{\"app_title\":\"Alien\",\"calendar_event_name\":\"%@\",\"calendar_event_description\":\"%@\",\"calendar_start_date\":\"%@\",\"calendar_start_time\":\"%@\",\"calendar_end_date\":\"%@\",\"calendar_end_time\":\"%@\",\"calendar_location\":\"%@\",\"external\":\"1\"}",
                             event.name,
                             event.description,
                             event.startDate,
                             event.startTime,
                             event.endDate,
                             event.endTime,
                             event.location];
    
    
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
    //NSLog(@"abc: %@, def:%@",dataContent, response);
    NSDictionary *resultsDictionary = [[response objectFromJSONString] mutableCopy];
    
    if([resultsDictionary count])
    {
        NSString *status = [resultsDictionary objectForKey:@"status"];
        
        if ([status isEqualToString:@"ok"])
        {
            qrcodeId = [resultsDictionary objectForKey:@"qrcode_id"];
            //NSLog(@"Submit event ok!");
        }
        else{
            //NSLog(@"Submit event error! %@",[resultsDictionary objectForKey:@"message"]);
            
        }
    }
    return qrcodeId;
    
}

- (NSString *)timeToString:(NSDate *)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *newTime = [dateFormatter stringFromDate:time];
    [dateFormatter release];
    
    return newTime;
}

- (NSString *)dateToString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *newDate = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    
    return newDate;
}

- (NSString *)processAddContact:(ParsedResult *)parsed
{
    //NSLog(@"processAddContact");
    
    BusinessCardParsedResult *vcard = (BusinessCardParsedResult *)parsed;
    
    NSString *qrcodeId = nil;
    
    NSString *urlString = [NSString stringWithFormat:@"%@/api/qrcode_contact.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
    
    NSString *address = [[NSString stringWithFormat:@"%@",[vcard.addresses objectAtIndex:0]]
                         stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    
    NSString *dataContent = [NSString stringWithFormat:@"{\"app_title\":\"Alien\",\"contact_name\":\"%@\",\"contact_mobile_phone_number\":\"%@\",\"contact_address\":\"%@\",\"external\":\"1\"}",
                             [NSString stringWithFormat:@"%@",[vcard.names objectAtIndex:0]],
                             [NSString stringWithFormat:@"%@",[vcard.phoneNumbers objectAtIndex:0]],
                             address];
    
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
    //NSLog(@"abc: %@, def:%@",dataContent, response);
    NSDictionary *resultsDictionary = [[response objectFromJSONString] mutableCopy];
    
    if([resultsDictionary count])
    {
        NSString *status = [resultsDictionary objectForKey:@"status"];
        
        if ([status isEqualToString:@"ok"])
        {
            qrcodeId = [resultsDictionary objectForKey:@"qrcode_id"];
            //NSLog(@"Submit contact ok!");
        }
        else{
            //NSLog(@"Submit contact error! %@",[resultsDictionary objectForKey:@"message"]);
            
        }
    }
    
    return qrcodeId;
}

- (NSString *)processShowMap:(ParsedResult *)parsed
{
    //NSLog(@"processShowMap");
    
    GeoParsedResult *geo = (GeoParsedResult *)parsed;
    
    NSArray *coords = [geo.location componentsSeparatedByString:@","];
    //NSLog(@"coords: %@", geo.location);
    mapCoords = geo.location;
    CLLocationCoordinate2D cc2d = CLLocationCoordinate2DMake([[coords objectAtIndex:0] doubleValue], [[coords objectAtIndex:1] doubleValue]);
    MKReverseGeocoder *geoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:cc2d];
    geoCoder.delegate = self;
    [geoCoder start]; // find the address of location
    
    [geoCoder release];
    return @"0000";
}

- (NSString *)processOpenURL:(ParsedResult *)parsed
{
    //NSLog(@"processOpenURL");
    
    NSString *qrcodeId = nil;
    URIParsedResult *urlqr = (URIParsedResult *)parsed;
    
    NSString *urlString = [NSString stringWithFormat:@"%@/api/qrcode_url.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
    
    NSString *aURL = urlqr.urlString;
    
    NSString *dataContent = [NSString stringWithFormat:@"{\"app_title\":\"Alien\",\"url_name\":\"\",\"url_url\":\"%@\",\"external\":\"1\"}",aURL];
    
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
    //NSLog(@"abc: %@, def:%@",dataContent, response);
    NSDictionary *resultsDictionary = [[response objectFromJSONString] mutableCopy];
    
    if([resultsDictionary count])
    {
        NSString *status = [resultsDictionary objectForKey:@"status"];
        
        if ([status isEqualToString:@"ok"])
        {
            qrcodeId = [resultsDictionary objectForKey:@"qrcode_id"];
            //NSLog(@"Submit url ok!");
        }
        else{
            //NSLog(@"Submit url error! %@",[resultsDictionary objectForKey:@"message"]);
            
        }
    }
    return qrcodeId;
}

#pragma mark -
#pragma mark MKReverseGeocoder delegate

// this delegate is called when the reverseGeocoder finds a placemark
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
    NSString *qrcodeId = nil;
    MoreViewController *more = [[MoreViewController alloc] init];
    MKPlacemark * myPlacemark = placemark;
    
    NSString *aAddress = [NSString stringWithFormat:@"%@, %@, %@, %@ %@",
                          [myPlacemark.addressDictionary objectForKey:(NSString *)kABPersonAddressStreetKey],
                          [myPlacemark.addressDictionary objectForKey:(NSString *)kABPersonAddressCityKey],
                          [myPlacemark.addressDictionary objectForKey:(NSString *)kABPersonAddressStateKey],
                          [myPlacemark.addressDictionary objectForKey:(NSString *)kABPersonAddressZIPKey],
                          [myPlacemark.addressDictionary objectForKey:(NSString *)kABPersonAddressCountryKey]];
    
    //NSLog(@"result address %@", aAddress);
    
    NSString *urlString = [NSString stringWithFormat:@"%@/api/qrcode_map.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
    
    NSString *dataContent = [NSString stringWithFormat:@"{\"app_title\":\"Alien\",\"category_id\":\"\",\"map_name\":\"Alien QR Code\",\"map_description\":\"%@\",\"map_address\":\"%@\",\"external\":\"1\"}", mapCoords , aAddress];
    
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
    //NSLog(@"abc: %@, def:%@",dataContent, response);
    NSDictionary *resultsDictionary = [[response objectFromJSONString] mutableCopy];
    
    if([resultsDictionary count])
    {
        NSString *status = [resultsDictionary objectForKey:@"status"];
        
        if ([status isEqualToString:@"ok"])
        {
            qrcodeId = [resultsDictionary objectForKey:@"qrcode_id"];
            //NSLog(@"Submit map ok!");
        }
        else{
            //NSLog(@"Submit map error! %@",[resultsDictionary objectForKey:@"message"]);
            
        }
    }
    
    
    if ([qrcodeId integerValue]) {
        // Store qrcode in server / scan list
        if ([self addScanToServer:qrcodeId])
        {
            more.qrcodeId = qrcodeId;
            AppDelegate *mydelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [mydelegate.boxNavController pushViewController:more animated:YES];
            [mydelegate.tabView activateController:3];
            [more release];
        }
    }else{
        //NSLog(@"Error occured.");
    }
}

// this delegate is called when the reversegeocoder fails to find a placemark
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    //NSLog(@"reverseGeocoder:%@ didFailWithError:%@", geocoder, error);
}


- (void)dealloc {
    [_loadingActivityView release];
    [_waitLabel release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setLoadingActivityView:nil];
    [self setWaitLabel:nil];
    [super viewDidUnload];
}
@end
