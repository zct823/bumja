//
//  NearMeViewController.m
//  myjam
//
//  Created by Mohd Zulhilmi on 27/03/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "NearMeViewController.h"
#import "NMTabViewController.h"
#import "ShopInfoViewController.h"

@interface NearMeViewController ()

@end

@implementation NearMeViewController
@synthesize clLocationMgr, mkMapView, clGeoCoder, currentLong, currentLat, userHeadingBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        FontLabel *titleView = [[[FontLabel alloc] initWithFrame:CGRectZero fontName:@"jambu-font.otf" pointSize:22]autorelease];
        titleView.text = @"Near Me";
        titleView.textAlignment = NSTextAlignmentCenter;
        titleView.backgroundColor = [UIColor clearColor];
        titleView.textColor = [UIColor whiteColor];
        [titleView sizeToFit];
        self.navigationItem.titleView = titleView;
        
        NSLog(@"Initiating CLGeoCoder...");
        if (!self.clGeoCoder)
        {
            self.clGeoCoder = [[CLGeocoder alloc]init];
        }
        
        self.mkMapView.delegate = self;
        
        clLocationMgr = [[CLLocationManager alloc]init];
        [clLocationMgr setDelegate:self];
        
        [clLocationMgr setDistanceFilter:kCLDistanceFilterNone];
        [clLocationMgr setDesiredAccuracy:kCLLocationAccuracyBest];
        
        [self.mkMapView setShowsUserLocation:YES];
        [clLocationMgr startUpdatingLocation];
        [clLocationMgr startUpdatingHeading];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
    
    self.withRad = 10000;
    
    [self.mkMapView setShowsUserLocation:YES];

    UIImage *buttonImage = [UIImage imageNamed:@"greyButtonHighlight.png"];
    UIImage *buttonImageHighlight = [UIImage imageNamed:@"greyButton.png"];
    UIImage *buttonArrow = [UIImage imageNamed:@"LocationGrey.png"];
    
    //Configure the button
    userHeadingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [userHeadingBtn addTarget:self action:@selector(startShowingUserHeading:) forControlEvents:UIControlEventTouchUpInside];
    //Add state images
    [userHeadingBtn setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [userHeadingBtn setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [userHeadingBtn setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [userHeadingBtn setImage:buttonArrow forState:UIControlStateNormal];
    
    //Position and Shadow
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    if (screenBounds.size.height == 568) {
        // code for 4-inch screen
        userHeadingBtn.frame = CGRectMake(5,screenBounds.origin.y+370,39,30);
    } else {
        // code for 3.5-inch screen
        userHeadingBtn.frame = CGRectMake(5,screenBounds.origin.y+280,39,30);
    }
    
    //userHeadingBtn.frame = CGRectMake(5,30,39,30);
    userHeadingBtn.layer.cornerRadius = 8.0f;
    userHeadingBtn.layer.masksToBounds = NO;
    userHeadingBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    userHeadingBtn.layer.shadowOpacity = 0.8;
    userHeadingBtn.layer.shadowRadius = 1;
    userHeadingBtn.layer.shadowOffset = CGSizeMake(0, 1.0f);
    
    [self.mkMapView addSubview:userHeadingBtn];
    
    [DejalBezelActivityView activityViewForView:self.mkMapView withLabel:@"Preparing Map..." width:100];

}

- (void)viewDidAppear:(BOOL)animated
{
    //[self performSelectorInBackground:@selector(retrieveMapDataFromAPI) withObject:self];
}

#pragma mark - User Heading
- (IBAction) startShowingUserHeading:(id)sender{
    
    if(self.mkMapView.userTrackingMode == 0){
        [self.mkMapView setUserTrackingMode: MKUserTrackingModeFollow animated: YES];
        
        //Turn on the position arrow
        UIImage *buttonArrow = [UIImage imageNamed:@"LocationBlue.png"];
        [userHeadingBtn setImage:buttonArrow forState:UIControlStateNormal];
        
    }
    else if(self.mkMapView.userTrackingMode == 1){
        [self.mkMapView setUserTrackingMode: MKUserTrackingModeFollowWithHeading animated: YES];
        
        //Change it to heading angle
        UIImage *buttonArrow = [UIImage imageNamed:@"LocationHeadingBlue"];
        [userHeadingBtn setImage:buttonArrow forState:UIControlStateNormal];
    }
    else if(self.mkMapView.userTrackingMode == 2){
        [self.mkMapView setUserTrackingMode: MKUserTrackingModeNone animated: YES];
        
        //Put it back again
        UIImage *buttonArrow = [UIImage imageNamed:@"LocationGrey.png"];
        [userHeadingBtn setImage:buttonArrow forState:UIControlStateNormal];
    }
}

- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated
{
    if(self.mkMapView.userTrackingMode == 0){
        [self.mkMapView setUserTrackingMode: MKUserTrackingModeNone animated: YES];
        
        //Put it back again
        UIImage *buttonArrow = [UIImage imageNamed:@"LocationGrey.png"];
        [userHeadingBtn setImage:buttonArrow forState:UIControlStateNormal];
    }
    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    // To get current Lat/Long (current user position)
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    
    [self.mkMapView setRegion:[self.mkMapView regionThatFits:region] animated:YES];
    
    // Get Current Position
    self.currentLat = (float)self.mkMapView.userLocation.coordinate.latitude;
    self.currentLong = (float)self.mkMapView.userLocation.coordinate.longitude;
    NSLog(@"Current Lat/Long: %f:%f",self.currentLat,self.currentLong);
    
    if (SYSTEM_VERSION_EQUAL_TO(@"5.0") || SYSTEM_VERSION_EQUAL_TO(@"5.1"))
    {
        [self performSelector:@selector(retrieveMapDataFromAPI) withObject:self afterDelay:2.0f];
    }
    
    //Trigger to identify current user degrees.
    
    CLLocation *location = [self.clLocationMgr location];
    CLLocationCoordinate2D user = [location coordinate];
    
    [self calculateUserAngle:user];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //identify old location to put on new location
    
    CLLocationCoordinate2D here =  newLocation.coordinate;
    [self calculateUserAngle:here];
    
}

-(void) calculateUserAngle:(CLLocationCoordinate2D)user {

    //counting user location degrees.
    self.degrees = 0;
    
    NSLog(@"%f ; %f", currentLat, currentLong);
    
    float pLat = 0;
    float pLon = 0;
    
    if(self.currentLat > user.latitude && self.currentLong > user.longitude) {
        // north east
        
        pLat = user.latitude;
        pLon = self.currentLong;
        
        self.degrees = 0;
    }
    else if(self.currentLat > user.latitude && self.currentLong < user.longitude) {
        // south east
        
        pLat = self.currentLat;
        pLon = user.longitude;
        
        self.degrees = 45;
    }
    else if(self.currentLat < user.latitude && self.currentLong < user.longitude) {
        // south west
        
        pLat = self.currentLat;
        pLon = user.latitude;
        
        self.degrees = 180;
    }
    else if(self.currentLat < user.latitude && self.currentLong > user.longitude) {
        // north west
        
        pLat = self.currentLat;
        pLon = user.longitude;
        
        self.degrees = 225;
    }
    
    // Vector QP (from user to point)
    float vQPlat = pLat - user.latitude;
    float vQPlon = pLon - user.longitude;
    
    // Vector QL (from user to location)
    float vQLlat = self.currentLat - user.latitude;
    float vQLlon = self.currentLong - user.longitude;
    
    // degrees between QP and QL
    float cosDegrees = (vQPlat * vQLlat + vQPlon * vQLlon) / sqrt((vQPlat*vQPlat + vQPlon*vQPlon) * (vQLlat*vQLlat + vQLlon*vQLlon));
    self.degrees = self.degrees + acos(cosDegrees);
    
    NSLog(@"Self.degrees: %d",self.degrees);
    
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    myDelegate.currentDecDegree = self.degrees;
}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
    //[self performSelectorInBackground:@selector(retrieveMapDataFromAPI) withObject:self];
    [DejalBezelActivityView activityViewForView:self.mkMapView withLabel:@"Preparing Map..." width:100];
    [self performSelector:@selector(retrieveMapDataFromAPI) withObject:self];
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    NSLog(@"DidFinishLoadingMap");
    
    //MKMapRect zoomedIn = MKMapRectNull;
    
    for (id <MKAnnotation> currentAnnotation in mapView.annotations)
    {
        //MKMapPoint annotationPoints = MKMapPointForCoordinate(currentAnnotation.coordinate);
        //MKMapRect pointRect = MKMapRectMake(annotationPoints.x, annotationPoints.y, 0.1, 0.1);
        //zoomedIn = MKMapRectUnion(zoomedIn, pointRect);
        [mapView selectAnnotation:currentAnnotation animated:FALSE];
    }
    
    //[mapView setVisibleMapRect:zoomedIn animated:YES];
    
    //Turn off auto go to current location.
    //[self.mkMapView setShowsUserLocation:NO];
    //[self performSelector:@selector(retrieveMapDataFromAPI) withObject:self];
}

- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView
{
    NSLog(@"Start Locating User");
    //[self performSelectorInBackground:@selector(retrieveMapDataFromAPI) withObject:self];
}

-(void)mapViewDidStopLocatingUser:(MKMapView *)mapView
{
    NSLog(@"Stop Locating User");
    //[self performSelectorInBackground:@selector(retrieveMapDataFromAPI) withObject:self];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{    
    if ([annotation isKindOfClass:[MKUserLocation class]]) return nil;

    static NSString *identifier = @"NearMeViewController";
    
    MKAnnotationView *mkAnnotationView = (MKAnnotationView *)[self.mkMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
   
    if (mkAnnotationView == nil)
    {
        mkAnnotationView = [[[MKAnnotationView alloc]
                             initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
    }
    
    //image changes/resizes goes here
    UIImage *setAnnotationImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageURL]]];
    UIImage *thumbAnnotateImage = nil;
    CGSize setSize = CGSizeMake(70,70);
    
    UIGraphicsBeginImageContext(setSize);
    
    CGRect thumbCGRect = CGRectZero;
    thumbCGRect.origin = CGPointZero;
    thumbCGRect.size.width  = setSize.width;
    thumbCGRect.size.height = setSize.height;
    [setAnnotationImage drawInRect:thumbCGRect];
    thumbAnnotateImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    mkAnnotationView.image = thumbAnnotateImage;
    
    //UIImageView *imageForCallOut = [[UIImageView alloc]initWithImage:thumbAnnotateImage];
    
    //The part of map callOut
    UIButton *moreInformationButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [moreInformationButton addTarget:self action:@selector(clicked:)
                    forControlEvents:UIControlEventTouchUpInside];
    //mkAnnotationView.leftCalloutAccessoryView = imageForCallOut;
    mkAnnotationView.rightCalloutAccessoryView = moreInformationButton;
    moreInformationButton.frame = CGRectMake(0, 0, 30, 30);
    moreInformationButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    moreInformationButton.contentHorizontalAlignment =
    UIControlContentHorizontalAlignmentCenter;
    moreInformationButton.tag = self.setBtnTag;
    
    mkAnnotationView.canShowCallout = TRUE;
    
    [self.clGeoCoder reverseGeocodeLocation: clLocationMgr.location completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         
         //Get nearby address
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         NSLog(@"PlaceMarks: %@",placemarks);
         NSLog(@"PlaceMark: %@",placemark);
         NSLog(@"Error: %@",error);
         
         //String to hold address
         NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
         NSLog(@"LocatedAt: %@",locatedAt);
         
         //Print the location to console
         mapView.userLocation.title = @"I am Here!";
         mapView.userLocation.subtitle = [NSString stringWithFormat:@"%@",locatedAt];
         
     }];
    
    return mkAnnotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"Tapped on Annotation");
}

- (void)clicked:(id)sender
{
    NSLog(@"clicked sender: %d",[sender tag]);
    
    AppDelegate *mydelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    ShopInfoViewController *shopInfoVC = [[ShopInfoViewController alloc]init];
    shopInfoVC.shopID = [sender tag];
    
    [mydelegate.otherNavController pushViewController:shopInfoVC animated:YES];
    [shopInfoVC release];
}


#pragma mark - API Data Retrieval

- (void)retrieveMapDataFromAPI
{
    NSString *urlString = [NSString stringWithFormat:@"%@/api/nearme_map.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
    NSString *dataContent = [NSString stringWithFormat:@"{\"lat\":\"%f\",\"lng\":\"%f\",\"radius\":\"%d\"}",self.currentLat,self.currentLong,self.withRad];
    
    NSLog(@"UrlString %@ and datacontent %@",urlString,dataContent);
    
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
    NSLog(@"request %@\n%@\n\nresponse retrieveData: %@", urlString, dataContent, response);
    NSDictionary *resultsDictionary = [[response objectFromJSONString] mutableCopy];
    
    NSLog(@"dict %@",resultsDictionary);
    
    if([resultsDictionary count])
    {
        NSString *status = [resultsDictionary objectForKey:@"status"];
        //NSDictionary* resultProfile;
        
        if ([status isEqualToString:@"ok"])
        {
            MKPointAnnotation *mkPointAnnotation = nil;
            CLLocationCoordinate2D ctrpoint;
            
            for (id row in [resultsDictionary objectForKey:@"list"])
            {
                ctrpoint.latitude = [[row objectForKey:@"shop_lat"] doubleValue];
                ctrpoint.longitude = [[row objectForKey:@"shop_lng"]doubleValue];
                self.shopDistance = [[row objectForKey:@"distance_in_meter"]intValue];
                mkPointAnnotation = [[MKPointAnnotation alloc]init];
                [mkPointAnnotation setCoordinate:ctrpoint];
                [mkPointAnnotation setTitle:[row objectForKey:@"shop_name"]];
                //[mkPointAnnotation setSubtitle:@"Jalan Ni"];
                self.imageURL = [row objectForKey:@"shop_logo"];
                self.setBtnTag = [[row objectForKey:@"shop_id"]intValue];
                [self.mkMapView addAnnotation:mkPointAnnotation];
                [mkPointAnnotation release];
            }
        }
    }
    else
    {
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Near Me" message:@"Connection error. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    [DejalBezelActivityView removeViewAnimated:YES];
    //[self.mkMapView setShowsUserLocation:NO];
    [self sentDataToNearMeListing];
}

- (void)sentDataToNearMeListing
{
    AppDelegate *setDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    setDelegate.currentLat = self.currentLat;
    setDelegate.currentLong = self.currentLong;
    setDelegate.withRadius = 10000;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
    [self.mkMapView dealloc];
    [self.mkMapView release];
    [clLocationMgr dealloc];
    [clLocationMgr release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

@end
